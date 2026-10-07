-- Regalos a sponsors (Valen, Fruti, Choy, Sorteo, Martu, Melli Nico): se marcan para que en Finanzas
-- la mitad que pone Sobre Ruedas ($ 331.250) figure como GASTO "Regalos a sponsors" y no escondida en el costo.
alter table public.operacion_items add column regalo boolean not null default false;
update public.operacion_items set regalo = true where operacion_id = 3 and id in (37,39,44,58,60) and precio_unitario in (53000,66250);
