import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database.dart';
import '../../core/database/tables.dart';
import '../../shared/next_occurrence.dart';
import '../expenses/providers.dart';

/// Summary of expenses whose next occurrence falls in the next month.
class NextMonthSummary {
  final double total;
  final int count;
  final List<Gasto> matchingGastos;

  const NextMonthSummary({
    required this.total,
    required this.count,
    required this.matchingGastos,
  });
}

/// Provider that watches active expenses and calculates what falls due
/// next month (the month following [DateTime.now]).
final nextMonthSummaryProvider = Provider<NextMonthSummary>((ref) {
  final activeGastos = ref.watch(activeGastoListProvider).valueOrNull ?? [];

  final now = DateTime.now();
  // Dart handles month overflow: month 13 → January of next year.
  final nextMonth = DateTime(now.year, now.month + 1, 1);

  double total = 0;
  final matching = <Gasto>[];

  for (final gasto in activeGastos) {
    final periodicidad = Periodicidad.values.firstWhere(
      (p) => p.name == gasto.periodicidad,
    );
    final occurrence = nextOccurrence(periodicidad, gasto.fechaCobro, nextMonth);
    if (occurrence != null) {
      total += gasto.importe;
      matching.add(gasto);
    }
  }

  return NextMonthSummary(total: total, count: matching.length, matchingGastos: matching);
});
