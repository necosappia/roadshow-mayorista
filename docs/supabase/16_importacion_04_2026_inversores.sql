-- Importación de 04/2026 (primer pedido, 198 rollers) por USD 15.654 y los aportes de los inversores.
-- Pablo USD 6.900 · Nico USD 5.855 · Martu USD 2.500 = USD 15.255 → faltan USD 399 sin asignar (Nico tiene que aclarar).
-- Día exacto de la compra a confirmar (se cargó 01/04/2026).
insert into public.operaciones (tipo, fecha, contraparte, total, moneda, origen, notas) values
  ('compra', '2026-04-01', 'Proveedor Roadshow (China)', 15654, 'USD', 'manual', 'Importación 04/2026: primer pedido, 198 rollers. Día exacto a confirmar.'),
  ('aporte_capital', '2026-04-01', 'Pablo', 6900, 'USD', 'manual', 'Aporte para la importación 04/2026'),
  ('aporte_capital', '2026-04-01', 'Nico', 5855, 'USD', 'manual', 'Aporte para la importación 04/2026'),
  ('aporte_capital', '2026-04-01', 'Martu', 2500, 'USD', 'manual', 'Aporte para la importación 04/2026');
