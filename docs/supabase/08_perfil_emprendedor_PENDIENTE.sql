-- PENDIENTE: lo corre Nico en Supabase → SQL Editor (el conector no puede confirmar borrados).
-- Deja aprobar clientes con perfil "emprendedor". Después, se puede borrar la función vieja.
alter table public.clientes drop constraint if exists clientes_categoria_check;
alter table public.clientes add constraint clientes_categoria_check check (categoria in ('mayorista','emprendedor','ff'));
drop function if exists public.mis_precios();
