-- Al registrarse (auth.users), si mandó razón social, se crea su ficha en clientes como 'pendiente'.
-- Así funciona aunque tenga que confirmar el mail antes de poder entrar.
create or replace function privado.crear_cliente()
returns trigger language plpgsql security definer set search_path = ''
as $$
declare d jsonb := coalesce(new.raw_user_meta_data, '{}'::jsonb);
begin
  if nullif(trim(d->>'razon_social'), '') is not null then
    insert into public.clientes (user_id, razon_social, cuit, zona, contacto, telefono, email, direccion)
    values (new.id, trim(d->>'razon_social'), nullif(trim(d->>'cuit'),''), nullif(trim(d->>'zona'),''),
            nullif(trim(d->>'contacto'),''), nullif(trim(d->>'telefono'),''), new.email,
            nullif(trim(d->>'direccion'),''));
  end if;
  return new;
end $$;
revoke execute on function privado.crear_cliente() from public, anon, authenticated;

create trigger crear_cliente after insert on auth.users
  for each row execute function privado.crear_cliente();
