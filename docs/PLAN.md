# Plan: tablero financiero + pedidos con cuenta corriente (Supabase)

Estado al 06/10/2026. Lo definió Nico en la sesión anterior; acá está todo lo acordado y lo que falta preguntar.

---

## 1. El negocio

- **Universo Sobre Ruedas (SR):** mayorista de rollers Roadshow. Importa (pedido a China) y vende a otros comercios.
- **Fly Free (FF):** el local de Nico. Es el **principal cliente** de SR: vendió casi todo el primer pedido. También financia a SR.
- **Nico:** socio. Paga desde varias cuentas: NM (MART MP), PISAPPCO SRL y FLY.
- **Otros clientes:** Paula (Neuquén / Río Negro, proforma 00021), Empresa C (Tucumán) y "Cliente".
- **Lugares de stock:** SR (Sobre Ruedas), FF (Fly Free), LP (La Plata).
- Antes de que llegara la mercadería se aportaron **~$ 22.000.000 de capital** para traerla (falta el monto exacto, la fecha y quiénes aportaron).

## 2. La cuenta corriente de Nico / Fly Free con SR (conciliada con Nico)

| Concepto | Debe | Haber | Saldo |
|---|---|---|---|
| Fly Free compró/vendió **153 pares** | 21.373.680 | | 21.373.680 |
| Pagó pedido nuevo al proveedor (USD 4.256) | | 6.537.840 | 14.835.840 |
| 2 transferencias desde NM | | 6.000.000 | 8.835.840 |
| Desde NM (MART MP) | | 1.500.000 | 7.335.840 |
| Desde SRL (MP) | | 600.000 | 6.735.840 |
| Desde FF (MP) | | 500.000 | 6.235.840 |
| Desde FF (MP) | | 500.000 | **5.735.840** |

- **Saldo 5.735.840** = 4.750.000 + 985.840 ("DEUDA NICO", efectivo). ✅
- **En efectivo debe:** 5.735.840 + 778.000 (operación Tucumán) = **6.513.840**. Nico lo cuenta como 6.490.000 + 23.840 de diferencia. ✅
- **Aparte:** 331.250 (mitad del costo de 6 rollers) + 833.500 (ventas del 04/10: RSKTS 2 × 133.250, RSJRL 1 × 189.000, RSJRM 2 × 189.000).
- **Total que Nico/FF le debe a SR: $ 7.678.590.** Coincide con el "Pendiente de Cobro" del Excel. ✅

## 3. Problemas del Excel (`docs/datos/movimientos-excel.csv`)

1. **Signo invertido** en el stock inicial del 01/09: 7 compras pagadas en efectivo figuran con Cash **+** 3.080.000 (debería ser −). Diferencia de 6.160.000 en el efectivo.
2. Las filas **"Venta · SKU = Capital Inicial"** no son ventas: son **pagos de la cuenta corriente** de Nico. La venta real (153 pares por 21.373.680) **no está cargada** con sus productos.
3. **05/09:** "Venta" +6.537.840 y "Gasto" −6.537.840 se cancelan (deuda de Nico usada para pagar el pedido 09.2026 por financiera). Si ese pago es del pedido del 17/09, la compra queda contada dos veces (gasto + 17.015.100 "Pendiente de Pago"). **Preguntar.**
4. **Neuquén 11/09:** 4.499.566,50 "20 rollers", pero la proforma 00021 es de 27 pares por 7.947.703,50 con IVA (6.568.350 sin IVA). ¿Seña? **Preguntar.** Además, esa venta no descontó stock.
5. **Stock según las notas vs. según las cuentas:** RSKTS da 2 pero la nota dice 3; RSJRL da 7, pero la nota dice "7 en FF y 1 en LP" y "Restar 2"; RSJRM da 0 pero la nota dice "2 en FF".
6. **El stock "Entrega inmediata" de la página** (RSJ V/R/A L: 1/2/2; RSK S/M: 1/1) **no coincide** con el Excel (RSJVL 2, RSJRL 7, RSJAL 2, RSKTS 2, RSKTM 3). Confirmar cuál es el real.
7. **Estructura:** fechas sin año y filas sin fecha. "Método de Pago" mezcla medio y estado. "Concepto" mezcla canal y COSTO. La ubicación del stock solo está en el texto de las observaciones. Montos como texto ("$  1.260.000 ").
8. **IVA:** las proformas dicen "+ IVA 21%", pero SR paga **monotributo** (no puede discriminar IVA). Nico tiene que confirmarlo con el contador **antes** de que los clientes pidan por la web.

## 4. Listas de precios (`docs/datos/lista-precios.csv`)

| Lista | Quién | Cuándo | Ej. RS600 |
|---|---|---|---|
| COSTO | interno | lo que paga SR | 130.600 |
| **FF** | solo Fly Free / Nico | su precio como cliente principal | 176.310 |
| **MAYORISTA CHINA** | clientes mayoristas | 🚚 **Llega 28/10 (en tránsito)** y 📦 **Encargo**: es el mismo precio | 195.900 + IVA |
| **MAYORISTA BA** | clientes mayoristas | ⚡ **Entrega inmediata** | 212.552 + IVA |
| P.P | público (referencia) | precio de venta sugerido; las últimas columnas son el % que gana el revendedor (China/BA) | 382.593 |

- Hoy la página usa el precio **China** para todo. Falta: Entrega inmediata con precio **BA**.
- **Revisar en la lista:** CELIGHTNM tiene costo 29.000 y precio 37.700 (igual que las protecciones), mientras los otros talles del casco tienen 27.000 y 35.100. ¿Error de copiado?
- **Colores, distintos en la lista y en la página:** RS600 "B" (página: Camuflado), M3 "G" (página: Blanco), RSJ PRO "M" (página: Violeta), RSK "T". Unificar con Nico.

## 5. Cómo va a funcionar

### Clientes
1. Se **registran** en la página con sus datos: razón social, CUIT, zona, teléfono, mail y dirección.
2. Quedan **pendientes de aprobación**. Mientras tanto ven **los modelos con fotos, sin precios**.
3. Nico los aprueba en el tablero y les asigna una **categoría** (Mayorista, Fly Free, más adelante otras).
4. Ya aprobados, ven el precio según la solapa: **BA** en Entrega inmediata, **China** en Llega 28/10 y en Encargo. Fly Free ve los precios **FF**.

### Pedido desde la página
- Elige productos y toca "Hacer pedido". Se genera **la orden** (número correlativo, sigue la proforma 00021) + **la proforma PDF** + **un cargo en su cuenta corriente** + **la reserva del stock**.
- **Pago, por ahora: el total de la compra.** Dejarlo preparado para después: pago diferido 30/60, cheques, o "pagás cuando llega la mercadería".
- Recomendado: el primer pedido de un cliente, o uno que supere su límite, queda **"a confirmar"** hasta que Nico lo apruebe.

### Tablero (`/admin`, solo Nico)
- **Caja:** efectivo, Mercado Pago y USD.
- **Cuentas corrientes:** saldo de cada cliente (Nico/FF con su detalle), vencimientos y vencidos en rojo; deuda con el proveedor.
- **Resultado** por mes: ventas, costo de lo vendido, gastos y ganancia real.
- **Capital** aportado y su rendimiento.
- **Stock valorizado** por modelo, talle y lugar.
- Aprobar clientes, cargar pagos, cambiar precios (se actualiza solo en la página).

## 6. Base de datos (Supabase)

- **Proyecto:** `sobre-ruedas` (org "NM 2026 PRO", plan Free, región Canada Central).
- **URL:** `https://tqmqlvlbfkjekxwccsty.supabase.co`
- **Publishable key:** `sb_publishable_UdVpZD6Xem9M1wADl-X5JA_TyZkkx_q` (es pública; va en la página).
- Al crear el proyecto se dejó **"Enable automatic RLS" activado** y **"Automatically expose new tables" desactivado**: cada tabla nace cerrada y hay que darle permisos explícitos.
- La secret key y la contraseña de la base las tiene Nico. **Nunca pedirlas por chat.**
- El plan Free pausa el proyecto tras 7 días sin uso (se reanuda con un clic).

### Tablas propuestas

| Tabla | Campos clave |
|---|---|
| `productos` | sku, modelo, color, talle, costo, precio_ff, precio_china, precio_ba, precio_publico, caja, fab_minimo, activo |
| `clientes` | user_id (auth), razón social, CUIT, zona, contacto, categoría, estado (pendiente/aprobado), plazo, límite de crédito |
| `operaciones` | tipo (compra · venta · gasto · aporte de capital · pago de cuenta corriente), fecha, contraparte, canal/modo, total, estado, vencimiento, origen (página / manual), n° de proforma |
| `operacion_items` | operación, sku, cantidad, precio unitario, modo (ya/via/enc) |
| `pagos` | fecha, monto, moneda, medio (efectivo / MP / transferencia / USD / cheque), operación |
| `stock_movimientos` | fecha, sku, cantidad ±, lugar (SR/FF/LP), operación |

**Permisos (RLS):** el cliente aprobado lee productos con **solo su lista de precios** y lee y crea **sus** pedidos. El pedido se crea con una función (RPC) que valida el stock y calcula el precio en el servidor, nunca con el precio que manda el navegador. Nico (admin) ve todo. Los no aprobados solo ven modelos y fotos.

## 7. Pendientes

**Datos que tiene que pasar Nico:**
1. El detalle de los **153 pares** (modelos, talles y precios). Si no lo tiene, se carga como una venta total.
2. El **aporte de capital** (~22M): monto, fecha y quiénes.
3. El **pedido del 17/09 por 17.015.100**: ¿pagado o pendiente? ¿Los USD 4.256 fueron para ese pedido?
4. **Neuquén 4.499.566,50:** ¿seña de la proforma 00021?
5. Cuál es el **stock real** (punto 3.6) y los **nombres de colores** (punto 4).
6. **WhatsApp** para la página.
7. **IVA / monotributo** con el contador.

**Infra:**
- Borrar el proyecto de Cloudflare `roadshow-mayorista` (Vercel queda como el único).
- Hostinger DNS de universosobreruedas.com: el registro **A `@` 76.76.21.21 está duplicado**, y hay un **AAAA `@`** de Hostinger que apunta el dominio principal a otro lado. El dominio principal lo usa **otro proyecto de Vercel de Nico**: revisar con él antes de tocar. Para `roadshow` se agregaron el CNAME `roadshow → 9000f6aa383ae333.vercel-dns-017.com` y el TXT `_vercel` de verificación.
- Faltan 3 fotos del M4 PRO Morado para "Probados al límite" (llegaron en el chat pero no como archivo).

## 8. Orden de trabajo sugerido

1. Crear las tablas y los permisos en Supabase (con el conector). Cargar `productos` desde `lista-precios.csv`.
2. Cargar el historial: capital, compras, la cuenta corriente de Nico/FF (sección 2), Neuquén, Tucumán y gastos. Verificar que el saldo de Nico dé **7.678.590**.
3. Tablero `/admin` (login de Nico).
4. Página: registro de clientes, precios por solapa y pedido → cuenta corriente.
