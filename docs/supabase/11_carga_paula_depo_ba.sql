-- Primer pedido de Paula Berenguer, del stock que había en Depo BA (proforma también numerada 00021, 17/09/2026).
-- 18 pares · subtotal $ 4.440.800 + IVA $ 932.568 = $ 5.373.368. Fuente: docs/datos/proforma-00021-depo-ba.pdf
-- RS300 "Verde agua" = Turquesa (RS300T) · M4 PRO "Lila" = Morado (M4PROM).
-- No mueve stock: el stock de Depo BA (primer pedido) no está cargado. Sin número de proforma porque el 21 ya lo usa la del 28/10.
do $$
declare cli bigint; venta bigint;
begin
  select id into cli from public.clientes where razon_social = 'Paula Berenguer';
  if cli is null then raise exception 'No encuentro a Paula Berenguer'; end if;
  insert into public.operaciones (tipo, fecha, cliente_id, modo, canal, total, estado, origen, notas)
  values ('venta', '2026-09-17', cli, 'ya', 'Ferro Carga', 5373368, 'entregada', 'manual',
          'Primer pedido, del stock en Depo BA. Proforma N° 00021 (el mismo número que la del pedido que llega el 28/10). Subtotal $ 4.440.800 + IVA $ 932.568. Confirmar pago.')
  returning id into venta;
  insert into public.operacion_items (operacion_id, sku, cantidad, precio_unitario, modo) values
    (venta,'RS600B38/39',2,195900,'ya'),(venta,'RS600B40/41',2,195900,'ya'),
    (venta,'RS300T38/39',2,160300,'ya'),(venta,'RS300T40/41',2,160300,'ya'),
    (venta,'M4PRON38/39',2,291850,'ya'),(venta,'M4PRON40/41',2,291850,'ya'),
    (venta,'M4PROM36/37',2,308100,'ya'),(venta,'M4PROM38/39',2,308100,'ya'),(venta,'M4PROM40/41',2,308100,'ya');
end $$;
