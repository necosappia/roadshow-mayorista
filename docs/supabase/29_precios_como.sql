-- Para el botón Admin / Cliente de la página: el admin puede ver los precios como un perfil (mayorista, emprendedor o ff).
-- Si quien llama no es admin, devuelve lo mismo que precios_cliente() (su propio perfil): no abre precios a nadie.
create or replace function public.precios_como(perfil_ver text)
returns table(modelo text, color text, talle text, ya numeric, via numeric, enc numeric, publico numeric, publico_iva numeric, perfil text)
language sql stable security definer set search_path = ''
as $$
  with cat as (
    select case when privado.es_admin() and perfil_ver in ('mayorista','emprendedor','ff') then perfil_ver
      else coalesce(
        (select c.categoria from public.clientes c where c.user_id = auth.uid() and c.estado = 'aprobado' and c.categoria is not null),
        case when privado.es_admin() then 'mayorista' end) end as k
  )
  select p.modelo, p.color, p.talle,
         case cat.k when 'ff' then p.precio_ff when 'emprendedor' then round(p.precio_china * 1.3) else p.precio_ba end,
         case cat.k when 'ff' then p.precio_ff when 'emprendedor' then round(p.precio_china * 1.3) else p.precio_china end,
         case cat.k when 'ff' then p.precio_ff when 'emprendedor' then round(p.precio_china * 1.3) else p.precio_china end,
         p.precio_publico, p.precio_publico_iva, cat.k
  from public.productos p, cat
  where cat.k is not null and p.activo
$$;
revoke execute on function public.precios_como(text) from public, anon;
grant execute on function public.precios_como(text) to authenticated;
