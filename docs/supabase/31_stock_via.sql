-- Lo libre de lo que llega el 28/10 (importado − reservado por pedidos), por modelo/color/talle.
-- Lo lee la página (también sin cuenta) para mostrar "X disponibles" en 🚚 Llega 28/10. Solo cantidades, sin precios ni clientes.
create or replace function public.stock_via()
returns table(modelo text, color text, talle text, libres int)
language sql stable security definer set search_path = ''
as $$
  select p.modelo, p.color, p.talle, greatest(sum(m.cantidad),0)::int
  from public.stock_movimientos m join public.productos p on p.sku = m.sku
  where m.lugar = 'CAMINO' group by p.modelo, p.color, p.talle
$$;
revoke execute on function public.stock_via() from public;
grant execute on function public.stock_via() to anon, authenticated;
