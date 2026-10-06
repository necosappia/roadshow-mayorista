-- es_admin() pasa a un esquema que no se publica en la API (aviso del asesor de seguridad).
-- Las políticas siguen funcionando: apuntan a la función, no al nombre.
create schema if not exists privado;
revoke all on schema privado from public, anon;
grant usage on schema privado to authenticated;
alter function public.es_admin() set schema privado;
-- Función que crea Supabase para el "RLS automático": nadie de afuera la tiene que poder llamar.
revoke execute on function public.rls_auto_enable() from public, anon, authenticated;
