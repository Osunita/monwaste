import '../core/database/tables.dart';

/// Calcula la próxima ocurrencia de cobro para un gasto dado.
///
/// [periodicidad] define la frecuencia del gasto.
/// [fechaCobro] es la fecha ancla del cobro (puede ser nula).
/// [referenceMonth] es el mes de referencia para la consulta (se usa solo
/// el año y mes del [DateTime]).
///
/// Devuelve la fecha de la próxima ocurrencia si cae dentro del mes de
/// referencia, o `null` si no hay ocurrencia en ese mes.
///
/// ## Reglas de clamping
///
/// Si el día ancla (ej. 31) no existe en el mes de destino, la fecha se
/// ajusta al último día disponible de ese mes.  Esto incluye el caso
/// especial del 29 de febrero en años no bisiestos → 28 de febrero.
///
/// ## Pureza
///
/// Esta función es **pura** — no tiene efectos secundarios, no lee
/// bases de datos ni estados globales.  Dada la misma entrada, siempre
/// devuelve la misma salida.
DateTime? nextOccurrence(
  Periodicidad periodicidad,
  DateTime? fechaCobro,
  DateTime referenceMonth,
) {
  // R5: Null anchor → null
  if (fechaCobro == null) return null;

  final anchorYear = fechaCobro.year;
  final anchorMonth = fechaCobro.month;
  final anchorDay = fechaCobro.day;

  final refYear = referenceMonth.year;
  final refMonth = referenceMonth.month;

  // Diferencia total en meses entre el mes ancla y el mes de referencia
  final totalMonths =
      (refYear - anchorYear) * 12 + (refMonth - anchorMonth);

  // Si el mes de referencia es anterior al ancla, no hay ocurrencia
  if (totalMonths < 0) return null;

  // Comprobar si la periodicidad se alinea con el mes de referencia
  final bool aligns = switch (periodicidad) {
    Periodicidad.mensual => true,
    Periodicidad.trimestral => totalMonths % 3 == 0,
    Periodicidad.semestral => totalMonths % 6 == 0,
    Periodicidad.anual => totalMonths % 12 == 0,
  };

  if (!aligns) return null;

  // Clamping: si el día ancla no existe en el mes de destino, se usa el
  // último día disponible.
  final lastDay = _daysInMonth(refYear, refMonth);
  final clampedDay = anchorDay > lastDay ? lastDay : anchorDay;

  return DateTime(refYear, refMonth, clampedDay);
}

/// Devuelve el número de días que tiene un mes dado.
///
/// Ejemplos:
///   - `_daysInMonth(2026, 2)` → 28 (febrero no bisiesto)
///   - `_daysInMonth(2024, 2)` → 29 (febrero bisiesto)
///   - `_daysInMonth(2026, 4)` → 30
///   - `_daysInMonth(2026, 1)` → 31
int _daysInMonth(int year, int month) {
  // El día 0 del mes siguiente = último día del mes actual.
  return DateTime(year, month + 1, 0).day;
}
