-- El pedido #4 (Paula, "Depo BA", 18 pares, $ 5.373.368, de proforma-00021-depo-ba.pdf) estaba mal: la primera compra de Paula es la proforma 00020 (21_...).
-- Se marcó cancelado (no cuenta en Finanzas, Stock ni historial). Borrarlo del todo necesita confirmación en Supabase:
update public.operaciones set estado = 'cancelada',
  notas = 'CARGADA POR ERROR: la primera compra de Paula es la proforma 00020 del 10/09. No cuenta en nada (Nico, 07/10).'
where id = 4 and total = 5373368;
-- Para borrarlo del todo (SQL Editor de Supabase):  delete from public.operaciones where id = 4 and total = 5373368;
