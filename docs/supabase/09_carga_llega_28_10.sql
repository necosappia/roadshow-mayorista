-- Pedido en tránsito que llega el 28/10 (88 pares) y la proforma 00021 de Paula (27 pares reservados).
-- Importado = lo que muestra la página en "Llega 28/10" (RS.via, ya sin Paula) + la proforma 00021.
-- PENDIENTE con Nico: fecha y total real de la compra (¿es el pedido del 17/09 por $ 17.015.100?) y estado/seña de Paula.
do $$
declare compra bigint; paula bigint; venta bigint;
begin
  -- 1) Compra al proveedor: total a costo de lista (a confirmar)
  insert into public.operaciones (tipo, fecha, contraparte, modo, total, estado, origen, notas)
  values ('compra', '2026-09-17', 'Proveedor Roadshow (China)', 'via', 15399100, null, 'manual',
          'Pedido en tránsito, llega 28/10. 88 pares. Total calculado a costo de lista: confirmar fecha y monto real (¿pedido del 17/09 por $ 17.015.100?).')
  returning id into compra;
  insert into public.operacion_items (operacion_id, sku, cantidad, precio_unitario, modo)
  select compra, v.sku, v.q, p.costo, 'via' from (values
    ('RS600B36/37',4),('RS600B38/39',11),('RS600B40/41',8),('RS600B42/43',4),('RS600B44/45',4),
    ('M4PRON36/37',5),('M4PRON38/39',4),('M4PRON40/41',4),('M4PRON42/43',3),('M4PRON44/45',5),
    ('M4PROM36/37',5),('M4PROM38/39',5),('M4PROM40/41',5),('M4PROM42/43',5),
    ('RS300T38/39',4),('RS300T40/41',4),('RS300T42/43',4),
    ('RX6DB40/41',4)) as v(sku,q) join public.productos p on p.sku = v.sku;
  insert into public.stock_movimientos (fecha, sku, cantidad, lugar, operacion_id, notas)
  select '2026-09-17', sku, cantidad, 'CAMINO', compra, 'Pedido en tránsito (llega 28/10)' from public.operacion_items where operacion_id = compra;

  -- 2) Paula (sin usuario en la página todavía)
  insert into public.clientes (razon_social, zona, contacto, estado, categoria, notas)
  values ('Paula Berenguer', 'Neuquén - Río Negro', 'Paula Berenguer', 'aprobado', 'mayorista',
          'Distribución exclusiva de zona Neuquén - Río Negro. Envío Ferro Carga, pago transferencia.')
  returning id into paula;

  -- 3) Proforma 00021: reserva 27 pares del pedido en tránsito
  insert into public.operaciones (tipo, fecha, cliente_id, modo, canal, total, estado, origen, numero_proforma, notas)
  values ('venta', '2026-09-17', paula, 'via', 'Ferro Carga', 7947703.50, 'a_confirmar', 'manual', 21,
          'Proforma 00021. Subtotal $ 6.568.350 + IVA $ 1.379.353,50. Confirmar estado y seña (¿$ 4.499.566,50 del 11/09?).')
  returning id into venta;
  insert into public.operacion_items (operacion_id, sku, cantidad, precio_unitario, modo) values
    (venta,'RS600B36/37',1,195900,'via'),(venta,'RS600B38/39',3,195900,'via'),(venta,'RS600B40/41',3,195900,'via'),(venta,'RS600B42/43',1,195900,'via'),
    (venta,'RS300T38/39',2,160300,'via'),(venta,'RS300T40/41',2,160300,'via'),(venta,'RS300T42/43',1,160300,'via'),
    (venta,'M4PRON36/37',1,291850,'via'),(venta,'M4PRON38/39',2,291850,'via'),(venta,'M4PRON40/41',2,291850,'via'),(venta,'M4PRON42/43',1,291850,'via'),(venta,'M4PRON44/45',1,291850,'via'),
    (venta,'M4PROM36/37',2,308100,'via'),(venta,'M4PROM38/39',2,308100,'via'),(venta,'M4PROM40/41',2,308100,'via'),(venta,'M4PROM42/43',1,308100,'via');
  insert into public.stock_movimientos (fecha, sku, cantidad, lugar, operacion_id, notas)
  select '2026-09-17', sku, -cantidad, 'CAMINO', venta, 'Reservado para la proforma 00021 (Paula)' from public.operacion_items where operacion_id = venta;
end $$;
