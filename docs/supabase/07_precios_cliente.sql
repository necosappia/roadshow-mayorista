-- Reemplaza a mis_precios() (queda sin uso: borrarla cuando se pueda). Precios sin IVA según perfil y solapa:
--   mayorista: ya = BA, via/enc = China · emprendedor: China + 30 % en todo · ff: FF en todo
--   admin sin ficha aprobada: como mayorista. Sin aprobación no devuelve nada. Nunca devuelve el costo.
--   publico / publico_iva: precio de venta sugerido, para que el cliente vea cuánto gana.
create or replace function public.precios_cliente()
returns table (modelo text, color text, talle text, ya numeric, via numeric, enc numeric, publico numeric, publico_iva numeric, perfil text)
language sql stable security definer set search_path = ''
as $$
  with cat as (
    select coalesce(
      (select c.categoria from public.clientes c
        where c.user_id = auth.uid() and c.estado = 'aprobado' and c.categoria is not null),
      case when privado.es_admin() then 'mayorista' end) as k
  )
  select p.modelo, p.color, p.talle,
         case cat.k when 'ff' then p.precio_ff when 'emprendedor' then round(p.precio_china * 1.3) else p.precio_ba end,
         case cat.k when 'ff' then p.precio_ff when 'emprendedor' then round(p.precio_china * 1.3) else p.precio_china end,
         case cat.k when 'ff' then p.precio_ff when 'emprendedor' then round(p.precio_china * 1.3) else p.precio_china end,
         p.precio_publico, p.precio_publico_iva, cat.k
  from public.productos p, cat
  where cat.k is not null and p.activo
$$;
revoke execute on function public.precios_cliente() from public, anon;
grant execute on function public.precios_cliente() to authenticated;
