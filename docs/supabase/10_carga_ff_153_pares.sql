-- Compras de PISAPPCO SRL (Fly Free) a Sobre Ruedas, del 20/04 al 27/06/2026: 153 pares, $ 21.373.680 (sin IVA).
-- Fuente: docs/datos/ff-153-pares.csv. Cargadas como UNA sola venta, como pidió Nico.
-- RX6D = Negro · RSK 28-32/S = S, 32-35/M = M · RSJ BLUE = Azul, MORA = Violeta · RSJ 32/32-35 = M, 36/36-39/39/L = L.
-- 8 pares van sin cargo ($ 0: Valen, Fruti, Choy, Karen, Yine, sorteo, Martu, Melli Nico). No mueve stock: el primer pedido no está cargado.
do $$
declare cli bigint; venta bigint;
begin
  select id into cli from public.clientes where razon_social = 'PISAPPCO SRL' and categoria = 'ff';
  if cli is null then raise exception 'No encuentro a PISAPPCO SRL como Fly Free'; end if;
  insert into public.operaciones (tipo, fecha, cliente_id, canal, total, estado, origen, notas)
  values ('venta', '2026-06-27', cli, 'Fly Free', 21373680, 'entregada', 'manual',
          'Compras de Fly Free del 20/04 al 27/06/2026 (153 pares), cargadas como una sola. 8 pares sin cargo.')
  returning id into venta;
  insert into public.operacion_items (operacion_id, sku, cantidad, precio_unitario, modo) values
    (venta,'RS600B36/37',7,159000,null),
    (venta,'RS600B36/37',1,176310,null),
    (venta,'RS600B38/39',3,0,null),
    (venta,'RS600B38/39',10,159000,null),
    (venta,'RS600B40/41',1,0,null),
    (venta,'RS600B40/41',11,159000,null),
    (venta,'RS600B40/41',1,176310,null),
    (venta,'RS600B42/43',6,159000,null),
    (venta,'RS600B44/45',3,159000,null),
    (venta,'RSJAL',1,0,null),
    (venta,'RSJAL',6,159000,null),
    (venta,'RSJAM',3,159000,null),
    (venta,'RSJRL',1,0,null),
    (venta,'RSJRL',2,159000,null),
    (venta,'RSJRM',5,159000,null),
    (venta,'RSJRM',2,189000,null),
    (venta,'RSJVL',3,159000,null),
    (venta,'RSJVL',2,189000,null),
    (venta,'RSKTM',5,120540,null),
    (venta,'RSKTM',1,133250,null),
    (venta,'RSKTS',4,120540,null),
    (venta,'RX6DN36/37',6,137800,null),
    (venta,'RX6DN36/37',3,165650,null),
    (venta,'RX6DN38/39',1,0,null),
    (venta,'RX6DN38/39',22,137800,null),
    (venta,'RX6DN40/41',1,0,null),
    (venta,'RX6DN40/41',22,137800,null),
    (venta,'RX6DN42/43',13,137800,null),
    (venta,'RX6DN44/45',7,137800,null);
end $$;
-- RS600B36/37 159000 7
-- RS600B36/37 176310 1
-- RS600B38/39 0 3
-- RS600B38/39 159000 10
-- RS600B40/41 0 1
-- RS600B40/41 159000 11
-- RS600B40/41 176310 1
-- RS600B42/43 159000 6
-- RS600B44/45 159000 3
-- RSJAL 0 1
-- RSJAL 159000 6
-- RSJAM 159000 3
-- RSJRL 0 1
-- RSJRL 159000 2
-- RSJRM 159000 5
-- RSJRM 189000 2
-- RSJVL 159000 3
-- RSJVL 189000 2
-- RSKTM 120540 5
-- RSKTM 133250 1
-- RSKTS 120540 4
-- RX6DN36/37 137800 6
-- RX6DN36/37 165650 3
-- RX6DN38/39 0 1
-- RX6DN38/39 137800 22
-- RX6DN40/41 0 1
-- RX6DN40/41 137800 22
-- RX6DN42/43 137800 13
-- RX6DN44/45 137800 7
