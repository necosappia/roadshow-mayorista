# Instrucciones para trabajar en este proyecto

**Universo Sobre Ruedas** (mayorista de rollers Roadshow). Dueño: Nico Sappia.
Nico no es programador: hablale en español rioplatense, frases cortas, paso a paso y con capturas cuando tenga que tocar algo en una web (Vercel, Hostinger, Supabase). Cuando cambies la página, mandale el `index.html` y una captura.

> ⚠️ Este repo **no** es el sistema de ventas de Fly Free (`fly-free-sistema`). Si un pedido parece de ese otro sistema (Rama, Fruti, Valen, Despacho, Planes NM…), **preguntá antes de tocar nada**. Ya pasó una vez.

Leé primero **`docs/PLAN.md`**: ahí está todo lo que se decidió (cuenta corriente, listas de precios, clientes, base de datos y pendientes).

---

## Qué hay hoy

- `index.html`: la página para clientes mayoristas. Un solo archivo, sin build. Fotos, logo y portada van adentro en base64 (por eso pesa ~1,3 MB).
- **Publicada en Vercel** → https://roadshow.universosobreruedas.com (y https://roadshow-mayorista.vercel.app). Cada push a `main` se publica solo.
- También hay una copia en Cloudflare (`roadshow-mayorista.necosappia.workers.dev`, `wrangler.jsonc`). Nico va a borrarla; no la uses como referencia.
- `admin/index.html`: **panel de administración** (`/admin`), mismo estilo Roadshow. Solo entra quien está en la tabla `admins` de Supabase. Solapas: Inicio · Clientes (aprobar y elegir lista) · Precios (costo, listas y margen) · Pedidos / Stock / Finanzas (próximamente). No lleva datos escritos: todo sale de Supabase.
- **Versiones:** el panel va por **BETA 0.7** (constante `VERSION` y la etiqueta del encabezado). Subí el número en cada cambio que publiques (0.2, 0.3…).
- `docs/datos/`: el Excel de movimientos, la lista de precios y la proforma 00021 tal como los pasó Nico.

## Lo que NO se publica

`.vercelignore` y `.assetsignore` dejan afuera `docs/`, `*.md`, `*.csv` y la configuración. **Nunca** pongas datos financieros fuera de `docs/`: todo lo que está en la raíz queda público en internet.

## Dónde se cambia la página (`<script>` de `index.html`)

| Constante | Qué es |
|---|---|
| `MODOS` | las 3 solapas: `ya` ⚡ Entrega inmediata, `via` 🚚 Llega 28/10, `enc` 📦 Encargo |
| `RS` | productos: `ya`/`via` stock por talle, `tl` talles, `caja` pares por caja (encargo, un solo talle por caja), `fab` mínimo de fabricación compartido, `info` ficha. **Sin precios**: no escribir precios en la página (quedan públicos en el código) |
| `REF` | qué fila de `productos` de Supabase (`MODELO|COLOR`) le da el precio a cada producto de la página |
| cuenta (`cargarCuenta`, `precio()`, `minimo()`) | Registrarse / Ingresar arriba. Los precios llegan de la función `precios_cliente()` de Supabase solo si el cliente está aprobado, según su **perfil**: **Mayorista** ve BA en ⚡ y China en 🚚/📦 (+ IVA), mínimo 6 pares por pedido salvo si todo es ⚡; **Emprendedor** ve China + 30 % (+ IVA), mínimo 3 pares; **Fly Free** ve FF **sin IVA**, sin mínimo. Cada producto muestra la venta sugerida con IVA, cuánto gana el cliente ($ y %) y cuánto gana vendiendo en Mercado Libre (`ML_COMISION` = 25 % del precio de venta). "Mi cuenta" muestra su historial (pares y $ de sus ventas no canceladas). El admin aprueba clientes desde "Mi cuenta" o `/admin` |
| `EDADES` | etiqueta Niños / Niños-Adolescentes-Adultos (el resto: Adolescentes · Adultos) |
| `INFO` | fichas del botón Info |
| `VIDEOS` | YouTube: se abre afuera (en la página no se puede incrustar) |
| `PRUEBAS` / `GRUPOS` | sección "Probados al límite": fotos del equipo, agrupadas por modelo |
| `FOTOS`, `PORTADA`, `LOGO` | imágenes en base64 (webp 900px) |
| `WA` | WhatsApp de Nico — **todavía vacío, pedírselo** |

La página arranca **sin solapa elegida** (catálogo con fotos). Los talles aparecen al tocar una solapa. Sin cuenta aprobada no se ven precios.

SQL de la base en `docs/supabase/` (se aplica con el conector de Supabase).

## Antes de subir un cambio

Probalo con Playwright (Chromium en `/opt/pw-browsers/chromium`) en 390px y 1280px: sin errores de JS, sin scroll horizontal (`scrollWidth` igual al ancho), y que la proforma PDF se genere. jsPDF viene de cdnjs; en las pruebas servilo desde un `node_modules` local.

## Errores que no hay que repetir

1. **Errores que se tragan en silencio:** todo lo que guarda tiene que avisar si falla (cartel rojo + "🔄 Reintentar") y conservar lo que el usuario cargó.
2. **No inventes datos:** si falta un precio, un stock o un nombre, preguntá. Lo que se muestra a clientes son precios reales.
3. **Emojis que no se ven en Windows:** no usar 🛼 🪖 🏫 🪪 ♾️ (usar ⛸️ ⛑️ 🎓 🆔 ∞).
