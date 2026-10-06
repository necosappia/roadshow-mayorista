# Roadshow mayorista · Universo Sobre Ruedas

Página para clientes mayoristas: fotos, precios, stock y pedido con proforma en PDF.

**Link para clientes:** https://roadshow.universosobreruedas.com (Vercel)

Todo está en `index.html` (fotos y logo van adentro). No hay build: se edita y se sube.

## Qué tiene
- **⚡ Entrega inmediata**: stock actual.
- **🚚 Llega 28/10**: pedido en tránsito (lista Roadshow menos la proforma 00021).
- **📦 Encargo** (5 al 10 de octubre): todos los modelos, por caja de un solo talle.
- Ficha **Info** por modelo, videos y proforma en PDF.

## Dónde se cambia
Al principio del `<script>`:
- `RS`: productos, precios (`p`, sin IVA), stock (`ya`, `via`), talles (`tl`), caja (`caja`).
- `INFO`: fichas de cada modelo.
- `VIDEOS`: videos de YouTube.
- `WA`: número de WhatsApp.

## Publicar
Vercel está conectado a este repositorio y publica solo cada vez que se sube un cambio a `main`. `docs/` (datos del negocio y el plan) no se publica.

## Próximo paso
Tablero financiero + pedidos con cuenta corriente en Supabase: ver `docs/PLAN.md`.
