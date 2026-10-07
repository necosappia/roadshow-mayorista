-- 07/10 (Nico): Paula transfiere $ 7.947.703,50 cuando llega el pedido (28/10), antes de enviarlo. Pedido confirmado con vencimiento 28/10.
update operaciones set estado='confirmada', vencimiento='2026-10-28',
  notas='Proforma 00021. Subtotal $ 6.568.350 + IVA $ 1.379.353,50. Paula transfiere el total cuando llega el pedido (28/10), antes de enviarlo.'
where id=2 and total=7947703.50;
