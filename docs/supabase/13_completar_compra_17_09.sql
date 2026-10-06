-- La compra del 17/09 (llega 28/10) también trae GF500C, cascos, protecciones y soportes (Excel de movimientos).
-- Con esto el total da $ 17.015.100, igual al "Pendiente de Pago" del Excel. Costos tal cual el Excel (casco M a $ 27.000).
do $$
declare compra bigint;
begin
  select id into compra from public.operaciones where tipo = 'compra' and fecha = '2026-09-17' and contraparte = 'Proveedor Roadshow (China)';
  if compra is null then raise exception 'No encuentro la compra del 17/09'; end if;
  insert into public.operacion_items (operacion_id, sku, cantidad, precio_unitario, modo) values
    (compra,'GF500CNC40/41',8,120000,'via'),(compra,'GF500CNC42/43',4,120000,'via'),
    (compra,'CELIGHTNM',1,27000,'via'),(compra,'CELIGHTNL',2,27000,'via'),
    (compra,'PROTECCIONRSM',1,29000,'via'),(compra,'PROTECCIONRSXL',1,29000,'via'),
    (compra,'SOPORTERS',10,3700,'via');
  insert into public.stock_movimientos (fecha, sku, cantidad, lugar, operacion_id, notas)
  select '2026-09-17', sku, cantidad, 'CAMINO', compra, 'Pedido en tránsito (llega 28/10)'
  from public.operacion_items where operacion_id = compra and sku in ('GF500CNC40/41','GF500CNC42/43','CELIGHTNM','CELIGHTNL','PROTECCIONRSM','PROTECCIONRSXL','SOPORTERS');
  update public.operaciones set total = 17015100,
    notas = 'Pedido 09.2026 en tránsito, llega 28/10: 88 rollers + 12 GF500C + 3 cascos + 2 protecciones + 10 soportes. Total $ 17.015.100 (pendiente de pago según el Excel).'
  where id = compra;
end $$;
