-- Fly Free (PISAPPCO SRL), del Excel de movimientos (captura del 07/10):
-- 1) Venta del 06/10: RSK S x1 + RSK M x2 a $ 133.250 = $ 399.750. Sale de FF Palermo (Stock -1 y -2 en el Excel).
--    Con esto la Impo 1 queda: 184 vendidos + 14 en stock = 198.
-- 2) Pagos de los 153 pares ($ 21.373.680): lo que figura cobrado en el Excel (05/09 a 17/09) = $ 15.637.840.
--    Lo que falta ($ 4.750.000 del 07/09 + $ 985.840 del 10/09 = $ 5.735.840) figura "Pendiente de Cobro, debe Nico".
do $$
declare cli bigint; venta bigint;
begin
  select id into cli from public.clientes where razon_social = 'PISAPPCO SRL';
  insert into public.operaciones (tipo, fecha, cliente_id, modo, canal, total, estado, origen, notas)
  values ('venta', '2026-10-06', cli, 'ya', 'Fly Free', 399750, 'entregada', 'manual', 'Ventas del 06/10 (Excel). Lo debe Nico.')
  returning id into venta;
  insert into public.operacion_items (operacion_id, sku, cantidad, precio_unitario, modo) values
    (venta,'RSKTS',1,133250,'ya'),(venta,'RSKTM',2,133250,'ya');
  insert into public.stock_movimientos (fecha, sku, cantidad, lugar, operacion_id, notas) values
    ('2026-10-06','RSKTS',-1,'FF',venta,'Venta Fly Free 06/10'),
    ('2026-10-06','RSKTM',-2,'FF',venta,'Venta Fly Free 06/10');
  insert into public.pagos (fecha, monto, medio, cuenta, cliente_id, operacion_id, notas) values
    ('2026-09-05',6537840,'efectivo','Nico',cli,3,'Pago de deuda Nico en efectivo (Excel)'),
    ('2026-09-15',3000000,'mp','NM',cli,3,'Transfirió Nico desde NM'),
    ('2026-09-15',3000000,'mp','NM',cli,3,'Transfirió Nico desde NM'),
    ('2026-09-16',1500000,'mp','NM',cli,3,'Transfirió Nico desde NM'),
    ('2026-09-17', 600000,'mp','PISAPPCO SRL',cli,3,'Transfirió Nico desde PISAPPCO SRL'),
    ('2026-09-17', 500000,'mp','FLY',cli,3,'Transfirió Nico desde FLY'),
    ('2026-09-17', 500000,'mp','FLY',cli,3,'Transfirió Nico desde FLY');
end $$;
