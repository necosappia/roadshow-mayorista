-- 07/10 (Nico): de los regalos de Fly Free, Karen no va (no existe ese par: era el que sobraba en la Impo 1) y Yine tampoco (lo trajo Nico antes).
-- Quedan 6 regalos a mitad del costo de abril = $ 331.250 (lo que Nico tenía anotado como "deuda Nico por costo repartido con SR").
-- Total de la compra de Fly Free: $ 21.373.680 (vendido) + $ 331.250 = $ 21.704.930. Impo 1 = 198 pares.
update operacion_items set cantidad = 2 where id = 37 and operacion_id = 3 and sku = 'RS600B38/39' and cantidad = 3 and precio_unitario = 53000;
update operaciones set total = 21704930,
  notas = 'Compras de Fly Free del 20/04 al 27/06/2026: 145 pares vendidos ($ 21.373.680) + 6 de regalo (Valen, Fruti, Choy, Sorteo, Martu, Melli Nico) a mitad del costo de abril ($ 331.250). Karen y Yine no van (Nico, 07/10).',
  historial = (select jsonb_agg(x order by n) from jsonb_array_elements(historial) with ordinality t(x, n) where coalesce(x->>'quien','') not in ('Karen','Yine'))
where id = 3 and total = 21757930;
-- El item de Yine (id 47, sin cargo) queda marcado fuera_impo1: no cuenta en la Impo 1 ni en el costo. Para borrarlo del todo (SQL Editor):
-- delete from public.operacion_items where id = 47 and operacion_id = 3;
