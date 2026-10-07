-- Tucumán pagó en efectivo a Nico: su pedido queda pagado y la deuda pasa a la cuenta de Fly Free / Nico
-- (en la planilla de Nico: "DEUDA NICO POR OP. TUCUMAN (EFECTIVO)" dentro del total que debe Fly Free).
do $$
declare ff bigint; tuc bigint;
begin
  select id into ff from public.clientes where razon_social = 'PISAPPCO SRL';
  select cliente_id into tuc from public.operaciones where id = 5 and total = 778135;
  insert into public.pagos (fecha, monto, medio, cuenta, cliente_id, operacion_id, notas)
  values ('2026-09-09', 778135, 'efectivo', 'Nico', tuc, 5, 'Lo cobró Nico en efectivo. La deuda pasa a la cuenta de Fly Free / Nico.');
  insert into public.operaciones (tipo, fecha, cliente_id, total, origen, notas)
  values ('ajuste', '2026-09-09', ff, 778135, 'manual', 'Cobro de Tucumán que tiene Nico (efectivo)');
end $$;
update public.operaciones set notas = 'Pagó en efectivo a Nico. Precios del pedido por WhatsApp (en el Excel: $ 778.000).' where id = 5;
