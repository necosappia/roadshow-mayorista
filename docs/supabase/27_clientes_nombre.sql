-- Nombre que se muestra (nombre de fantasía). razon_social queda para facturación.
alter table public.clientes add column nombre text;
update public.clientes set nombre = 'Fly Free Urban' where razon_social = 'PISAPPCO SRL';
