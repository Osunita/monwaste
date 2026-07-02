# AGENTS.md — Monwaste

Instrucciones para cualquier agente de código (Opencode) que trabaje en este repositorio.

## Qué es Monwaste

App móvil (Flutter, Android + iOS) para saber en menos de 1 segundo cuánto dinero se va a pagar en gastos recurrentes el mes que viene. No es una app de finanzas personales. No registra gastos diarios. No se conecta al banco. No requiere cuenta. No usa servidores. No almacena nada en la nube. Todo vive en el dispositivo.

> "Nunca olvides cuánto dinero se va cada mes."

## Filosofía — léela antes de añadir cualquier función

Cuatro principios innegociables:

- Simplicidad por encima de todo.
- Privacidad absoluta.
- Velocidad de uso.
- Cero funcionalidades innecesarias.

Antes de implementar algo que no esté ya descrito en este documento, pregúntate: **¿hace que el usuario sepa cuánto va a pagar el mes que viene de forma más rápida o sencilla?** Si la respuesta es no, no se implementa. Si tienes dudas, pregunta al usuario en vez de asumir.

## Lo que esta app NUNCA debe tener

- Conexión a bancos o APIs financieras.
- Cuentas de usuario, login o registro.
- Backend, servidor propio o sincronización en la nube.
- Backup automático (decisión consciente — ver sección Decisiones).
- Publicidad.
- Registro de gastos diarios o funciones de presupuesto/finanzas personales.
- La app NUNCA debe afirmar que un gasto "ha sido cobrado" — no tiene acceso a ninguna cuenta bancaria, solo puede avisar de lo previsto.

## Stack técnico (fijado, no cambiar sin aprobación explícita)

| Área | Elección | Motivo |
|---|---|---|
| Framework | Flutter (última estable) | Una base de código, Android + iOS |
| Lenguaje | Dart | — |
| Base de datos | **Drift** | SQL, type-safe, mantenido activamente. **No usar Isar** (paquete original sin mantenimiento activo desde 2024) |
| Estado | Riverpod | Testeable, providers sobreescribibles |
| Navegación | GoRouter | Incluye ruta `/home/next-month` |
| Notificaciones | flutter_local_notifications con `androidScheduleMode: inexactAllowWhileIdle` | Evita el permiso `SCHEDULE_EXACT_ALARM` de Android 12+ |
| Selector de color | flutter_colorpicker, **solo** modo barra de gradiente horizontal | Sin inputs RGB/HEX manuales |
| Fechas y moneda | intl | `NumberFormat.currency` para moneda multi-divisa |
| i18n | `flutter gen-l10n` (oficial), archivos `.arb` | ES + EN desde v1.0, escalable a más idiomas sin tocar código |
| Widget home screen | home_widget (puente Dart) + código nativo | Ver sección Widget nativo |
| Iconos | Material Symbols | — |

## Arquitectura de carpetas

```
lib/
 ├── core/
 ├── features/
 │      ├── home/
 │      ├── expenses/
 │      └── settings/
 ├── shared/
 ├── l10n/
 │      ├── app_es.arb
 │      └── app_en.arb
 └── main.dart
```

Sin Clean Architecture compleja. El proyecto es intencionadamente pequeño — no sobre-ingenierices la estructura.

## Modelo de datos

```dart
Gasto {
  nombre: String
  importe: Decimal
  periodicidad: Mensual | Trimestral | Semestral | Anual
  fechaCobro: Date   // fecha ANCLA completa (día+mes+año), no solo un número de día
  color: String      // hex interno, nunca editable como texto por el usuario
  activo: Boolean
}
```

Configuración global (Settings, no por gasto):
```dart
moneda: String  // código ISO 4217, ej. "EUR", "USD"
idioma: String  // "es" | "en", puede derivarse del locale del dispositivo
```

### Regla del campo `fechaCobro`

- Es un **selector de fecha completa** (día + mes), no un simple número 1–31. Esto es intencional: permite calcular con precisión periodicidades no mensuales sin añadir un campo "mes" separado.
- Es **opcional** en el formulario. Si el usuario no la rellena, se asume el **día 1 del mes de creación**.
- Edge case fijado: si el día elegido no existe en un mes (ej. 31 en febrero), la ocurrencia cae en el **último día disponible de ese mes**.

## El motor de cálculo — la pieza más importante del proyecto

Función central: `nextOccurrence(gasto, mesDeReferencia)`.

A partir de `fechaCobro` + `periodicidad`, calcula si (y cuándo) ese gasto se cobra en un mes dado:

- Mensual → se repite cada mes en ese día.
- Trimestral → cada 3 meses desde la fecha ancla.
- Semestral → cada 6 meses.
- Anual → cada 12 meses.

Esta única función alimenta:
1. El importe mostrado en la pantalla principal ("lo que pagarás el mes que viene").
2. La lista filtrada al hacer tap en esa burbuja.
3. Los recordatorios de cobro (notificaciones).

**Regla obligatoria de testing:** toda función que calcule fechas o importes debe llevar tests unitarios cubriendo explícitamente:
- Día 31 en meses cortos (regla: cae en el último día del mes).
- 29 de febrero en años no bisiestos.
- Un gasto trimestral/semestral/anual cuya fecha ancla NO cae en el mes de referencia (no debe contarse ese mes).
- Un gasto creado a mitad de mes: **no requiere lógica especial**. `fechaCobro` es la fecha real del próximo cobro (no una fecha de alta), así que `nextOccurrence()` simplemente comprueba si esa fecha, o su recurrencia calculada a partir de la periodicidad, cae dentro del mes de referencia. Si el usuario indica que el próximo cobro es en agosto, cuenta para agosto sin importar cuándo se creó el registro.

No mergees código que toque `nextOccurrence()` sin tests que cubran estos casos.

## Pantallas

### Inicio (pestaña principal)
- Elemento más grande de la app: importe que se pagará **el mes que viene** (NO la suma total de todos los gastos, NO un promedio prorrateado).
- Número de gastos activos.
- Botón flotante para añadir gasto.
- Tap en el importe → navega a `/home/next-month`, una lista filtrada (mismo componente de tarjeta que la lista general) mostrando solo los gastos cuya próxima ocurrencia cae el mes siguiente.

### Gastos (segunda pestaña)
Lista vertical sin filtrar, todos los gastos (activos e inactivos). Cada tarjeta: indicador de color, nombre, importe, periodicidad, fecha de cobro, interruptor ON/OFF.

### Crear / Editar gasto
Formulario: nombre (obligatorio), importe (obligatorio), periodicidad (obligatorio, lista fija de 4 opciones), fecha de cobro (opcional, ver regla arriba), color (selector de gradiente, valor por defecto asignado).

## Diseño visual

- Minimalista, mucho espacio en blanco, sin publicidad, sin elementos decorativos.
- Inspiración: Google Tasks, Google Calendar, Apple Wallet.
- Tarjetas con esquinas redondeadas, sombra muy ligera. El color del gasto **nunca** tiñe toda la tarjeta — solo una barra izquierda o un círculo pequeño.
- Tipografía nativa: Roboto (Android) / SF Pro (iOS). No usar fuentes custom.
- Animaciones discretas, solo en: añadir, eliminar, activar/desactivar, transiciones entre pantallas.
- Colores: principal `#2563EB`, éxito `#10B981`, error `#EF4444`, fondo claro blanco, fondo oscuro negro casi absoluto.

## Notificaciones

Todas locales, cero dependencia de internet.

- **Resumen mensual**: el día 1 de cada mes, con el importe total previsto ese mes.
- **Recordatorio de cobro**: el día configurado de cada gasto activo.
- Usar siempre `inexactAllowWhileIdle` — nunca alarmas exactas.
- Redacción siempre en condicional/previsión ("previsto", "está previsto"), nunca afirmando que un cobro ya ha ocurrido.

## Widget de pantalla de inicio

Un único widget, sin listas ni gráficos, solo el importe y "Gasto mensual". Al pulsar, abre la app.

**Importante:** `home_widget` es solo el puente desde Dart. El widget real requiere código nativo dedicado: Swift/WidgetKit en iOS, Kotlin/Glance o RemoteViews en Android. No está en el alcance de v1.0 — es tarea de v1.1.

## Testing — prioridades

1. **Máxima prioridad**: tests unitarios de `nextOccurrence()` y de cualquier lógica de fechas/importes (ver reglas arriba). Es el código que más puede engañar al usuario si falla.
2. **Media**: widget tests — validación de formulario (nombre vacío, importe ≤ 0), el toggle activar/desactivar reflejado en el total, pantalla principal actualizándose tras añadir/editar/eliminar.
3. **Baja / opcional para v1.0**: integration tests end-to-end.

Riverpod permite sobreescribir providers en tests — mockea el repositorio Drift para aislar la lógica de negocio.

## Internacionalización

- `flutter gen-l10n` con `lib/l10n/app_es.arb` y `lib/l10n/app_en.arb`.
- Toda cadena de texto visible al usuario va en una clave `.arb`, nunca hardcodeada en el widget.
- Convención de nombres de claves: `pantalla + descripción` (ej. `homeNextMonthLabel`, `expenseFormNameHint`).
- Añadir un idioma nuevo en el futuro = crear `app_XX.arb` con las mismas claves — no debe requerir cambios en el código Dart.

## Moneda

Una única moneda **global**, configurada en Ajustes (no por gasto — mezclar monedas complicaría la suma sin beneficio real). Se guarda como código ISO 4217 y se formatea siempre con `NumberFormat.currency` de `intl`.

## Distribución

- Android: Google Play Store + APK firmado en GitHub Releases.
- iOS: Apple App Store.

## Roadmap

**v1.0**: pantalla principal (mes que viene), lista filtrada al tap, lista de gastos completa, añadir/editar/eliminar, activar/desactivar, motor de cálculo `nextOccurrence()` + tests, modelo de datos con Drift, selector de color, notificaciones locales, modo claro/oscuro, i18n ES+EN, moneda global configurable.

**v1.1**: widget nativo Android (Kotlin/Glance) y iOS (Swift/WidgetKit), integración opcional con el calendario del dispositivo, mejoras de rendimiento, refinamiento de animaciones.

## Decisiones ya resueltas (no reabrir sin motivo)

- Pantalla principal muestra "el mes que viene", no un total prorrateado.
- Fecha de cobro completa (día+mes) en vez de solo un número de día.
- Sin backup en la nube — riesgo aceptado conscientemente.
- Drift en vez de Isar.
- Widget nativo movido a v1.1, no v1.0.
- Notificaciones inexactas en vez de exactas.
- i18n con `gen-l10n`, ES+EN desde el inicio.
- Moneda global en Ajustes, no por gasto.
- Día de cobro opcional, por defecto día 1 del mes de creación.
- Un gasto cuenta para "el mes que viene" si `nextOccurrence()` calcula que su próximo cobro cae en ese mes — no depende de cuándo se creó el registro, solo de `fechaCobro` + `periodicidad`.
