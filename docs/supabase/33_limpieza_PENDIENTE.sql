-- PENDIENTE: lo corre Nico en Supabase → SQL Editor (el conector no puede confirmar borrados).
-- Antes se guardó una copia de todo en el esquema "respaldo" (tablas *_20261007).
-- 1) Borra el pedido #4 de Paula (anulado: estaba mal) con sus líneas.
-- 2) Borra el par de Yine de la compra de Fly Free (no es de la Impo 1, sin cargo, no cambia ningún total).
-- 3) Deja aprobar clientes con perfil Emprendedor (lo de 08_perfil_emprendedor) y borra una función vieja.
delete from public.operacion_items where operacion_id = 3 and id = 47 and fuera_impo1 and precio_unitario = 0;
delete from public.operaciones where id = 4 and estado = 'cancelada' and total = 5373368;
alter table public.clientes drop constraint if exists clientes_categoria_check;
alter table public.clientes add constraint clientes_categoria_check check (categoria in ('mayorista','emprendedor','ff'));
drop function if exists public.mis_precios();
select 'Listo: limpieza hecha' as resultado;
