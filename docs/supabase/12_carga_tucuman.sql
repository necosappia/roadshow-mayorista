-- Cliente de Tucumán ("Empresa C" en el Excel) y su pedido del 09/09/2026 (Depo BA).
-- Fuente: WhatsApp de Nico (5 pares, $ 778.135) y docs/datos/movimientos-excel.csv (09/09, $ 778.000, "Debe Nico en efectivo por compra de Tucuman").
-- Falta: razón social, CUIT y contacto. Perfil a confirmar (se cargó Mayorista).
do $$
declare cli bigint; venta bigint;
begin
  insert into public.clientes (razon_social, zona, estado, categoria, notas)
  values ('Cliente Tucumán', 'Tucumán', 'aprobado', 'mayorista',
          'En el Excel figura como "Empresa C". Faltan razón social, CUIT y contacto. Perfil a confirmar.')
  returning id into cli;
  insert into public.operaciones (tipo, fecha, cliente_id, modo, total, estado, origen, notas)
  values ('venta', '2026-09-09', cli, 'ya', 778135, 'entregada', 'manual',
          'Lo cobró Nico en efectivo y lo debe a Sobre Ruedas (en el Excel: $ 778.000). Precios del pedido por WhatsApp.')
  returning id into venta;
  insert into public.operacion_items (operacion_id, sku, cantidad, precio_unitario, modo) values
    (venta,'RS600B42/43',1,169000,'ya'),
    (venta,'RX6DN42/43',1,148400,'ya'),
    (venta,'RSJRL',1,172250,'ya'),
    (venta,'RSJAL',1,172250,'ya'),
    (venta,'RSKTM',1,116235,'ya');
end $$;
