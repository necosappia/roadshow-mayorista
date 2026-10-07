-- Los 8 pares sin cargo de Fly Free (07/10, Nico):
-- * Yine (RSJ Rosa L) no es de la Impo 1: ese par lo había traído Nico antes. Se marca fuera_impo1 y sigue sin cargo.
-- * Los otros 7 se dividen en 2 entre Sobre Ruedas y Fly Free al costo de abril: Fly Free paga la mitad.
--   RS600 y RX6D: 106.000 / 2 = 53.000 · RSJ: 132.500 / 2 = 66.250.
--   4 RS600 (Valen, Fruti, Choy, Karen) + 2 RX6D (Martu, Melli Nico) = 6 × 53.000 = 318.000; RSJ Azul (Sorteo) = 66.250. Total 384.250.
alter table public.operacion_items add column fuera_impo1 boolean not null default false;
update public.operacion_items set fuera_impo1 = true where id = 47 and operacion_id = 3 and sku = 'RSJRL' and precio_unitario = 0;
update public.operacion_items set precio_unitario = 53000 where operacion_id = 3 and precio_unitario = 0 and sku in ('RS600B38/39','RS600B40/41','RX6DN38/39','RX6DN40/41');
update public.operacion_items set precio_unitario = 66250 where operacion_id = 3 and precio_unitario = 0 and sku = 'RSJAL';
update public.operaciones set total = total + 384250,
  notas = 'Compras de Fly Free del 20/04 al 27/06/2026 (153 pares). 7 pares de regalo (Valen, Fruti, Choy, Karen, Sorteo, Martu, Melli Nico) a mitad del costo de abril: $ 384.250. El de Yine no es de la Impo 1 (lo trajo Nico) y va sin cargo.',
  historial = (select jsonb_agg(case when (x->>'precio')::int = 0 and x->>'quien' <> 'Yine'
                 then jsonb_set(x, '{precio}', to_jsonb(case when x->>'sku' like 'RSJ%' then 66250 else 53000 end)) else x end order by n)
               from jsonb_array_elements(historial) with ordinality t(x, n))
where id = 3 and total = 21373680;
