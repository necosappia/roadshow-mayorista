-- Proforma N° 00020 del 10/09/2026 a Paula Berenguer (Neuquén - Río Negro): 20 pares, subtotal $ 3.718.650 + IVA $ 780.916,50 = $ 4.499.566,50.
-- Fuente: docs/datos/proforma-00020-paula.pdf. Pago: Excel 11/09, Mercado Pago, "Venta de 20 rollers a Paula de Neuquén/Río Negro".
-- No mueve stock: el conteo del 06/10 ya es posterior a esta venta.
do $$
declare cli bigint; venta bigint;
begin
  select id into cli from public.clientes where razon_social = 'Paula Berenguer';
  insert into public.operaciones (tipo, fecha, cliente_id, modo, canal, total, estado, origen, numero_proforma, notas)
  values ('venta', '2026-09-10', cli, 'ya', 'Mayorista', 4499566.50, 'entregada', 'manual', 20,
          'Proforma 00020. Subtotal $ 3.718.650 + IVA $ 780.916,50.')
  returning id into venta;
  insert into public.operacion_items (operacion_id, sku, cantidad, precio_unitario, modo) values
    (venta,'RS600B44/45',1,195900,'ya'),
    (venta,'RSJRM',1,204750,'ya'),(venta,'RSJRL',5,204750,'ya'),(venta,'RSJVL',5,204750,'ya'),(venta,'RSJAM',2,204750,'ya'),
    (venta,'RSKTS',3,143500,'ya'),(venta,'RSKTM',3,143500,'ya');
  insert into public.pagos (fecha, monto, medio, cliente_id, operacion_id, notas)
  values ('2026-09-11', 4499566.50, 'mp', cli, venta, 'Excel 11/09: venta de 20 rollers a Paula');
end $$;
