-- Pedido confirmado desde la página por un cliente aprobado.
-- Los precios los calcula la base según el perfil del cliente (no se confía en lo que manda la página),
-- controla el stock (🚚 en camino / ⚡ SR Palermo), lo reserva, numera la proforma y deja el pedido "nueva" para el admin.
create or replace function public.crear_pedido(items jsonb, datos jsonb default '{}'::jsonb)
returns table(id bigint, numero int, total numeric)
language plpgsql security definer set search_path = ''
as $$
declare
  cli public.clientes%rowtype; it jsonb; p public.productos%rowtype;
  q int; m text; pu numeric; sub numeric := 0; disp int; modos text[] := '{}';
  venta bigint; nro int; tot numeric; lug text;
begin
  select * into cli from public.clientes c where c.user_id = auth.uid() and c.estado = 'aprobado' and c.categoria is not null;
  if not found then raise exception 'Tu cuenta no está aprobada para hacer pedidos.'; end if;
  if jsonb_typeof(items) <> 'array' or jsonb_array_length(items) = 0 then raise exception 'El pedido está vacío.'; end if;
  perform pg_advisory_xact_lock(4242);   -- dos pedidos a la vez no se pisan el stock
  nro := nextval('public.proforma_seq');
  insert into public.operaciones (tipo, fecha, cliente_id, canal, total, estado, origen, numero_proforma, notas)
  values ('venta', current_date, cli.id, 'Página', 0, 'nueva', 'pagina', nro,
          nullif(concat_ws(' · ', nullif(datos->>'envio',''), nullif(datos->>'pago',''), nullif(datos->>'zona','')), ''))
  returning operaciones.id into venta;
  for it in select * from jsonb_array_elements(items) loop
    q := (it->>'cantidad')::int; m := it->>'modo';
    if q is null or q <= 0 or m not in ('ya','via','enc') then raise exception 'Hay una línea del pedido que no es válida.'; end if;
    select * into p from public.productos x where x.modelo = it->>'modelo' and x.color = it->>'color'
      and coalesce(x.talle,'') = coalesce(it->>'talle','') and x.activo;
    if not found then raise exception 'No encuentro % % talle % en la lista.', it->>'modelo', it->>'color', it->>'talle'; end if;
    if m <> 'enc' then
      lug := case m when 'via' then 'CAMINO' else 'SR' end;
      select coalesce(sum(s.cantidad),0) into disp from public.stock_movimientos s where s.sku = p.sku and s.lugar = lug;
      if disp < q then raise exception 'Ya no alcanza el stock de % % talle %: quedan %.', p.modelo, p.color, coalesce(p.talle,''), greatest(disp,0); end if;
      insert into public.stock_movimientos (fecha, sku, cantidad, lugar, operacion_id, notas) values (current_date, p.sku, -q, lug, venta, 'Reserva pedido de la página');
    end if;
    pu := case cli.categoria when 'ff' then p.precio_ff when 'emprendedor' then round(p.precio_china * 1.3)
            else case m when 'ya' then p.precio_ba else p.precio_china end end;
    insert into public.operacion_items (operacion_id, sku, cantidad, precio_unitario, modo) values (venta, p.sku, q, pu, m);
    sub := sub + q * pu; modos := array_append(modos, m);
  end loop;
  tot := round(sub * case when cli.categoria = 'ff' then 1 else 1.21 end, 2);
  update public.operaciones o set total = tot,
    modo = case when (select count(distinct x) from unnest(modos) x) = 1 then modos[1] end
  where o.id = venta;
  return query select venta, nro, tot;
end $$;
revoke execute on function public.crear_pedido(jsonb, jsonb) from public, anon;
grant execute on function public.crear_pedido(jsonb, jsonb) to authenticated;
