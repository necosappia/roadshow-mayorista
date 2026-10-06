-- Universo Sobre Ruedas · tablas y permisos (etapa 1 del plan)
-- Aplicada en el proyecto sobre-ruedas (tqmqlvlbfkjekxwccsty).
-- Por ahora SOLO el admin (Nico) lee y escribe. Los clientes solo pueden
-- registrarse y ver lo suyo; el catálogo con precios y el pedido van por RPC (etapa 4).

-- ===== Admin =====
create table public.admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  creado  timestamptz not null default now()
);

create or replace function public.es_admin()
returns boolean language sql stable security definer set search_path = ''
as $$ select exists (select 1 from public.admins a where a.user_id = auth.uid()) $$;

-- ===== Productos (lista de precios) =====
create table public.productos (
  sku            text primary key,
  modelo         text not null,
  color          text not null,          -- código de la lista (B, N, R…). Nombres a unificar con Nico.
  talle          text,                   -- null = talle único (SOPORTE)
  costo          numeric(12,2) not null check (costo >= 0),
  precio_ff      numeric(12,2) not null check (precio_ff >= 0),
  precio_china   numeric(12,2) not null check (precio_china >= 0),  -- Llega 28/10 y Encargo (sin IVA)
  precio_ba      numeric(12,2) not null check (precio_ba >= 0),     -- Entrega inmediata (sin IVA)
  precio_publico numeric(12,2) check (precio_publico >= 0),         -- P.P sugerido (sin IVA)
  caja           int check (caja > 0),   -- pares por caja (encargo)
  fab_minimo     int check (fab_minimo > 0),
  activo         boolean not null default true,
  actualizado    timestamptz not null default now()
);

create or replace function public.tocar_actualizado()
returns trigger language plpgsql set search_path = ''
as $$ begin new.actualizado := now(); return new; end $$;

create trigger productos_actualizado before update on public.productos
  for each row execute function public.tocar_actualizado();

-- ===== Clientes =====
create table public.clientes (
  id             bigint generated always as identity primary key,
  user_id        uuid unique references auth.users(id) on delete set null,  -- null = cargado a mano (ej. Fly Free)
  razon_social   text not null,
  cuit           text,
  zona           text,
  contacto       text,
  telefono       text,
  email          text,
  direccion      text,
  categoria      text check (categoria in ('mayorista','ff')),  -- la asigna Nico al aprobar
  estado         text not null default 'pendiente' check (estado in ('pendiente','aprobado','rechazado')),
  plazo_dias     int not null default 0 check (plazo_dias >= 0),
  limite_credito numeric(14,2) check (limite_credito >= 0),
  notas          text,
  creado         timestamptz not null default now()
);

-- ===== Operaciones (órdenes, compras, gastos, aportes, pagos de cuenta corriente) =====
create sequence public.proforma_seq start 22;  -- la última proforma fue la 00021

create table public.operaciones (
  id              bigint generated always as identity primary key,
  tipo            text not null check (tipo in ('venta','compra','gasto','aporte_capital','pago_cc','ajuste')),
  fecha           date not null default current_date,
  cliente_id      bigint references public.clientes(id),
  contraparte     text,                  -- proveedor, socio, etc. cuando no es un cliente
  modo            text check (modo in ('ya','via','enc')),
  canal           text,
  total           numeric(14,2) not null check (total >= 0),
  moneda          text not null default 'ARS' check (moneda in ('ARS','USD')),
  estado          text check (estado in ('nueva','a_confirmar','confirmada','preparada','entregada','cancelada')),
  vencimiento     date,
  origen          text not null default 'manual' check (origen in ('pagina','manual')),
  numero_proforma int unique,
  notas           text,
  creado          timestamptz not null default now()
);
create index on public.operaciones (cliente_id);
create index on public.operaciones (fecha);

create table public.operacion_items (
  id              bigint generated always as identity primary key,
  operacion_id    bigint not null references public.operaciones(id) on delete cascade,
  sku             text not null references public.productos(sku),
  cantidad        int not null check (cantidad > 0),
  precio_unitario numeric(12,2) not null check (precio_unitario >= 0),
  modo            text check (modo in ('ya','via','enc'))
);
create index on public.operacion_items (operacion_id);
create index on public.operacion_items (sku);

-- ===== Pagos =====
create table public.pagos (
  id           bigint generated always as identity primary key,
  fecha        date not null default current_date,
  monto        numeric(14,2) not null check (monto > 0),
  moneda       text not null default 'ARS' check (moneda in ('ARS','USD')),
  medio        text not null check (medio in ('efectivo','mp','transferencia','usd','cheque')),
  cuenta       text,                     -- desde dónde: NM, SRL, FF…
  cliente_id   bigint references public.clientes(id),
  operacion_id bigint references public.operaciones(id),
  notas        text,
  creado       timestamptz not null default now()
);
create index on public.pagos (cliente_id);
create index on public.pagos (operacion_id);

-- ===== Stock =====
create table public.stock_movimientos (
  id           bigint generated always as identity primary key,
  fecha        date not null default current_date,
  sku          text not null references public.productos(sku),
  cantidad     int not null check (cantidad <> 0),  -- + entra, − sale
  lugar        text not null check (lugar in ('SR','FF','LP','CAMINO')),  -- CAMINO = pedido en tránsito
  operacion_id bigint references public.operaciones(id),
  notas        text,
  creado       timestamptz not null default now()
);
create index on public.stock_movimientos (sku);
create index on public.stock_movimientos (operacion_id);

-- ===== Permisos =====
-- Las tablas nacen cerradas (RLS automático, sin exponer). Nadie anónimo entra.
revoke all on public.admins, public.productos, public.clientes, public.operaciones,
  public.operacion_items, public.pagos, public.stock_movimientos from anon;
grant select, insert, update, delete on public.productos, public.clientes, public.operaciones,
  public.operacion_items, public.pagos, public.stock_movimientos to authenticated;
grant select on public.admins to authenticated;
grant usage on sequence public.proforma_seq to authenticated;

alter table public.admins            enable row level security;
alter table public.productos         enable row level security;
alter table public.clientes          enable row level security;
alter table public.operaciones       enable row level security;
alter table public.operacion_items   enable row level security;
alter table public.pagos             enable row level security;
alter table public.stock_movimientos enable row level security;

-- admins: cada uno solo ve si él mismo es admin. Se cargan a mano desde Supabase.
create policy admins_propio on public.admins for select to authenticated
  using (user_id = (select auth.uid()));

-- Nico (admin) ve y cambia todo
create policy admin_todo on public.productos         for all to authenticated using ((select public.es_admin())) with check ((select public.es_admin()));
create policy admin_todo on public.clientes          for all to authenticated using ((select public.es_admin())) with check ((select public.es_admin()));
create policy admin_todo on public.operaciones       for all to authenticated using ((select public.es_admin())) with check ((select public.es_admin()));
create policy admin_todo on public.operacion_items   for all to authenticated using ((select public.es_admin())) with check ((select public.es_admin()));
create policy admin_todo on public.pagos             for all to authenticated using ((select public.es_admin())) with check ((select public.es_admin()));
create policy admin_todo on public.stock_movimientos for all to authenticated using ((select public.es_admin())) with check ((select public.es_admin()));

-- Cliente: se registra (queda pendiente, sin categoría) y ve solo lo suyo
create policy cliente_registro on public.clientes for insert to authenticated
  with check (user_id = (select auth.uid()) and estado = 'pendiente' and categoria is null
              and plazo_dias = 0 and limite_credito is null);
create policy cliente_ve_lo_suyo on public.clientes for select to authenticated
  using (user_id = (select auth.uid()));
create policy cliente_sus_pedidos on public.operaciones for select to authenticated
  using (cliente_id in (select c.id from public.clientes c where c.user_id = (select auth.uid())));
create policy cliente_sus_items on public.operacion_items for select to authenticated
  using (operacion_id in (select o.id from public.operaciones o
         join public.clientes c on c.id = o.cliente_id where c.user_id = (select auth.uid())));
create policy cliente_sus_pagos on public.pagos for select to authenticated
  using (cliente_id in (select c.id from public.clientes c where c.user_id = (select auth.uid())));
-- productos: los clientes NO leen la tabla (tiene costo y todas las listas).
-- El catálogo con su lista de precios llega por una función en la etapa 4.

revoke execute on function public.es_admin() from public, anon;
grant execute on function public.es_admin() to authenticated;
