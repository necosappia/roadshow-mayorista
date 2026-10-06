-- Precios que ve quien está logueado, según su categoría y la solapa:
--   mayorista: ya = BA, via/enc = China · ff: todo FF · admin sin ficha: como mayorista.
-- Sin aprobación no devuelve nada. Nunca devuelve el costo.
create or replace function public.mis_precios()
returns table (modelo text, color text, talle text, ya numeric, via numeric, enc numeric)
language sql stable security definer set search_path = ''
as $$
  with cat as (
    select coalesce(
      (select c.categoria from public.clientes c
        where c.user_id = auth.uid() and c.estado = 'aprobado' and c.categoria is not null),
      case when privado.es_admin() then 'mayorista' end) as k
  )
  select p.modelo, p.color, p.talle,
         case when cat.k = 'ff' then p.precio_ff else p.precio_ba end,
         case when cat.k = 'ff' then p.precio_ff else p.precio_china end,
         case when cat.k = 'ff' then p.precio_ff else p.precio_china end
  from public.productos p, cat
  where cat.k is not null and p.activo
$$;
revoke execute on function public.mis_precios() from public, anon;
grant execute on function public.mis_precios() to authenticated;
