# Instrucciones para trabajar en este proyecto

**Universo Sobre Ruedas** (mayorista de rollers Roadshow). Dueño: Nico Sappia.
Nico no es programador: hablale en español rioplatense, frases cortas, paso a paso y con capturas cuando tenga que tocar algo en una web (Vercel, Hostinger, Supabase). Cuando cambies la página, mandale el `index.html` y una captura. **Al terminar cada respuesta, pasale siempre los dos links para ver:** Usuario https://roadshow-mayorista-git-claude-vibrant-ride-pgnbfy-necooo.vercel.app y Admin https://roadshow-mayorista-git-claude-vibrant-ride-pgnbfy-necooo.vercel.app/admin (cuando se publique en `main`: https://roadshow.universosobreruedas.com y /admin).

> ⚠️ Este repo **no** es el sistema de ventas de Fly Free (`fly-free-sistema`). Si un pedido parece de ese otro sistema (Rama, Fruti, Valen, Despacho, Planes NM…), **preguntá antes de tocar nada**. Ya pasó una vez.

Leé primero **`docs/PLAN.md`**: ahí está todo lo que se decidió (cuenta corriente, listas de precios, clientes, base de datos y pendientes).

---

## Qué hay hoy

- `index.html`: la página para clientes mayoristas. Un solo archivo, sin build. Fotos, logo y portada van adentro en base64 (por eso pesa ~1,3 MB).
- **Publicada en Vercel** → https://roadshow.universosobreruedas.com (y https://roadshow-mayorista.vercel.app). Cada push a `main` se publica solo.
- También hay una copia en Cloudflare (`roadshow-mayorista.necosappia.workers.dev`, `wrangler.jsonc`). Nico va a borrarla; no la uses como referencia.
- `admin/index.html`: **panel de administración** (`/admin`), mismo estilo Roadshow. Solo entra quien está en la tabla `admins` de Supabase. Solapas: Inicio · Clientes (aprobar y elegir lista) · Precios (costo, listas, nuestro margen y nuestra ganancia vendiendo al por menor en Mercado Libre: público con IVA − 25 % − costo) · Pedidos (ventas con estado; "Ver pedido" abre el desglose por modelo y talle, cambia el estado y registra pagos en `pagos` (pagado / debe); desde cada cliente, "Ver sus pedidos") · Stock con botones **Impo 1 · Abril** (vendidos y lo que queda por lugar SR/FF/LP, del conteo) e **Impo 2 · Llega 28/10** (importado, reservado y libre) · Finanzas (resultado: vendido, costo, ganancia bruta, gastos y ganancia neta; inversión: importación 04/2026 en USD, % recuperado (contra el costo de la planilla COSTO 05.2026) e inversores Pablo, Nico y Martu con su aporte; gastos con formulario para cargar nuevos, como `operaciones` tipo `gasto`). No lleva datos escritos: todo sale de Supabase.
- **Versiones:** el panel va por **BETA 4.5** (constante `VERSION` y la etiqueta del encabezado). Subí el número en cada cambio que publiques (0.2, 0.3…).
- `docs/datos/`: el Excel de movimientos, la lista de precios y la proforma 00021 tal como los pasó Nico.

## Lo que NO se publica

`.vercelignore` y `.assetsignore` dejan afuera `docs/`, `*.md`, `*.csv` y la configuración. **Nunca** pongas datos financieros fuera de `docs/`: todo lo que está en la raíz queda público en internet.

## Dónde se cambia la página (`<script>` de `index.html`)

| Constante | Qué es |
|---|---|
| `MODOS` | las 3 solapas: `ya` ⚡ Entrega inmediata, `via` 🚚 Llega 28/10, `enc` 📦 Encargo |
| `RS` | productos: `ya`/`via` stock por talle, `tl` talles, `caja` pares por caja (encargo, un solo talle por caja), `fab` mínimo de fabricación compartido, `info` ficha. **Sin precios**: no escribir precios en la página (quedan públicos en el código) |
| `REF` | qué fila de `productos` de Supabase (`MODELO|COLOR`) le da el precio a cada producto de la página |
| cuenta (`cargarCuenta`, `precio()`, `minimo()`) | Registrarse / Ingresar arriba. Los precios llegan de la función `precios_cliente()` de Supabase solo si el cliente está aprobado, según su **perfil**: **Mayorista** ve BA en ⚡ y China en 🚚/📦 (+ IVA), mínimo 6 unidades en lo de ⚡ Depo BA (China: por caja cerrada con curva completa, **regla pendiente de detalle**); **Emprendedor** ve China + 30 % (+ IVA), mínimo 3 pares; **Fly Free** ve FF, no se le suma IVA y **no se menciona el IVA** en su página ni en su proforma; sin mínimo. Cada producto muestra la venta sugerida con IVA, cuánto gana el cliente ($ y %). "Mi cuenta" muestra su historial (pares y $ de sus ventas no canceladas). El admin aprueba clientes desde "Mi cuenta" o `/admin`. Si el admin también es un cliente aprobado (Nico = Fly Free Urban), arriba aparece el botón **👑 Admin / 👤 Cliente** (`modoVista` en localStorage; en Admin los precios salen de `precios_como('mayorista')`) |
| menú del cliente (`#cnav`, `seccion`) | El cliente aprobado ve arriba **🏠 Inicio** (saludo, resumen y cómo comprar, `inicioHTML()`) · **🛍️ Productos** (el catálogo) · **🧾 Pedidos** (`misHTML()`) · **📚 Recursos** (fotos para bajar, fichas y videos, `recursosHTML()`). En Productos, Inicio y Recursos va el recuadro "¿Te gustaría un color en especial? Escribinos" (`escribinos()`, mail y WhatsApp si `WA` está cargado). Sin cuenta aprobada: solo el catálogo |
| 🧾 Pedidos (`misHTML()`) | Para el cliente aprobado: lo que compró, lo que ya tiene (entregado), lo que le llega el 28/10 y lo en preparación, con fotos por modelo y talle, saldo a pagar y la lista de pedidos |
| pedido (`#gen`, `crear_pedido()`) | Cliente aprobado (no en modo Admin): "✅ Confirmar pedido y bajar proforma" guarda el pedido con la función `crear_pedido()` de Supabase (precios calculados en la base según su perfil, controla y reserva stock 🚚 CAMINO / ⚡ SR, numera con `proforma_seq`), baja la proforma con ese número y vacía el carrito. Queda en `/admin` → Pedidos como "Nueva". Si falla: cartel rojo + Reintentar y el carrito queda. El admin en modo Admin solo arma proformas sin guardar |
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
