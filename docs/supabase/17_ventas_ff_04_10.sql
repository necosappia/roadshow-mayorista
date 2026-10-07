-- Ventas a Fly Free (PISAPPCO SRL) del 04/10/2026, del Excel de movimientos: RSK S x2, RSJ Rosa L x1, RSJ Rosa M x2 = $ 833.500.
-- Son aparte de los 153 pares (validado: 181 vendidos + 17 en stock = 198 de la Impo 1). Lo debe Nico.
do $$
declare cli bigint; venta bigint;
begin
  select id into cli from public.clientes where razon_social = 'PISAPPCO SRL';
  insert into public.operaciones (tipo, fecha, cliente_id, modo, canal, total, estado, origen, notas)
  values ('venta', '2026-10-04', cli, 'ya', 'Fly Free', 833500, 'entregada', 'manual', 'Ventas del 04/10 (Excel). Lo debe Nico.')
  returning id into venta;
  insert into public.operacion_items (operacion_id, sku, cantidad, precio_unitario, modo) values
    (venta,'RSKTS',2,133250,'ya'),(venta,'RSJRL',1,189000,'ya'),(venta,'RSJRM',2,189000,'ya');
end $$;
