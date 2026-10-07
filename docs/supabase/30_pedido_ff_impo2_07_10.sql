-- Pedido #18 · Fly Free Urban · 07/10/2026 · Impo 2 (llega 28/10), a precio FF. Reserva el stock en camino.
-- M4 PRO Lila (Morado) 38 ×2, 40 ×1, 42 ×3 (uno para Nico) + M4 PRO Negro 38 ×1 = 7 pares · $ 1.975.800.
-- Nico dice que está pago: falta registrar cómo y cuándo. Se van a sumar más rollers.
do $$
declare cli bigint; venta bigint;
begin
  select id into cli from public.clientes where razon_social = 'PISAPPCO SRL';
  insert into public.operaciones (tipo, fecha, cliente_id, modo, canal, total, estado, origen, notas)
  values ('venta', '2026-10-07', cli, 'via', 'Fly Free', 1975800, 'confirmada', 'manual',
    'Pedido Fly Free de la Impo 2 (llega 28/10). Nico dice que está pago: falta registrar cómo y cuándo. Se van a sumar más rollers.')
  returning id into venta;
  insert into public.operacion_items (operacion_id, sku, cantidad, precio_unitario, modo) values
    (venta,'M4PROM38/39',2,284400,'via'),(venta,'M4PRON38/39',1,269400,'via'),(venta,'M4PROM40/41',1,284400,'via'),(venta,'M4PROM42/43',3,284400,'via');
  insert into public.stock_movimientos (fecha, sku, cantidad, lugar, operacion_id, notas) values
    ('2026-10-07','M4PROM38/39',-2,'CAMINO',venta,'Reserva pedido Fly Free'),('2026-10-07','M4PRON38/39',-1,'CAMINO',venta,'Reserva pedido Fly Free'),
    ('2026-10-07','M4PROM40/41',-1,'CAMINO',venta,'Reserva pedido Fly Free'),('2026-10-07','M4PROM42/43',-3,'CAMINO',venta,'Reserva pedido Fly Free');
end $$;
-- (el historial línea por línea, con el par de Nico, va en operaciones.historial)
