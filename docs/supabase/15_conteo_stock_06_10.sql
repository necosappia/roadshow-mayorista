-- Conteo de stock del 06/10/2026 que pasó Nico (17 pares): SR Palermo 6, Fly Free Palermo 8, La Plata 3.
-- PINK = Rosa, PURPLE = Violeta, BLUE = Azul · RSJ 36 = L, 32 = M.
do $$
declare op bigint;
begin
  insert into public.operaciones (tipo, fecha, total, origen, notas)
  values ('ajuste', '2026-10-06', 0, 'manual', 'Conteo de stock del 06/10: 14 rollers en Palermo (SR y Fly Free) + 3 en La Plata.')
  returning id into op;
  insert into public.stock_movimientos (fecha, sku, cantidad, lugar, operacion_id, notas) values
    ('2026-10-06','RSJRL',1,'LP',op,'Conteo 06/10'),('2026-10-06','RSJVL',1,'LP',op,'Conteo 06/10'),('2026-10-06','RSJAM',1,'LP',op,'Conteo 06/10'),
    ('2026-10-06','RSJRL',2,'FF',op,'Conteo 06/10'),('2026-10-06','RSJVL',1,'FF',op,'Conteo 06/10'),('2026-10-06','RSKTS',2,'FF',op,'Conteo 06/10'),('2026-10-06','RSKTM',3,'FF',op,'Conteo 06/10'),
    ('2026-10-06','RSJAL',2,'SR',op,'Conteo 06/10'),('2026-10-06','RSJRL',4,'SR',op,'Conteo 06/10');
end $$;
