-- Costo real de la Impo 1 (abril 2026), de la planilla "COSTO 05.2026" que pasó Nico (07/10).
-- La lista de precios actual (columna costo) es la de la Impo 2; para lo de la Impo 1 se usa costo_impo1.
-- Faltan M4 PRO y RS300: mientras tanto el panel usa el costo de lista.
alter table public.productos add column costo_impo1 numeric(12,2) check (costo_impo1 >= 0);
update public.productos set costo_impo1 = 106000 where modelo in ('RS600','RX6D');
update public.productos set costo_impo1 = 132500 where modelo = 'RSJ';
update public.productos set costo_impo1 = 86100  where modelo = 'RSK';
