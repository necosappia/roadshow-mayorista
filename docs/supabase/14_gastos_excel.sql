-- Gastos del Excel de movimientos (docs/datos/movimientos-excel.csv). El medio de pago va en "canal".
-- Falta el monotributo de octubre (el Excel no tiene el monto).
insert into public.operaciones (tipo, fecha, contraparte, canal, total, origen, notas) values
  ('gasto', '2026-09-18', 'Papelera Scalabrini Ortiz', 'Mercado Pago', 49300, 'manual', 'Embalaje: gastos para embalar pedidos'),
  ('gasto', '2026-09-29', 'Contador', 'Mercado Pago', 120000, 'manual', 'Contador: Excel y primeros pasos'),
  ('gasto', '2026-09-29', 'Contador', 'Mercado Pago', 70000, 'manual', 'Contador: pago mes de octubre');
