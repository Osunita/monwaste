import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monwaste/core/database/database.dart';
import 'package:monwaste/features/expenses/expense_list_screen.dart';
import 'package:monwaste/l10n/l10n.dart';
import 'package:monwaste/shared/providers.dart';

/// Helper that creates a [ProviderScope] with an in-memory database.
Widget createTestApp(Widget child, MonwasteDatabase db) {
  return ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(db),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: child,
    ),
  );
}

/// Insert a sample Gasto into the database.
Future<int> insertSampleGasto(
  MonwasteDatabase db, {
  String nombre = 'Netflix',
  double importe = 15.99,
  String periodicidad = 'mensual',
  DateTime? fechaCobro,
  String color = '#E50914',
  bool activo = true,
}) async {
  return db.into(db.gastos).insert(GastosCompanion.insert(
        nombre: nombre,
        importe: importe,
        periodicidad: periodicidad,
        fechaCobro:
            fechaCobro != null ? Value(fechaCobro) : const Value.absent(),
        color: color,
        activo: Value(activo),
      ));
}

void main() {
  group('ExpenseListScreen', () {
    late MonwasteDatabase db;

    setUp(() {
      db = MonwasteDatabase.fromExecutor(NativeDatabase.memory());
    });

    tearDown(() async {
      // The database may already have been closed inside the test body
      // to avoid pending timer assertions.  Try closing but swallow
      // any "already closed" error.
      try {
        await db.close();
      } catch (_) {}
    });

    Future<void> pumpList(WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const ExpenseListScreen(), db));
      // Use pump() instead of pumpAndSettle() because Drift stream
      // queries create periodic timers that never settle.
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
    }

    testWidgets('empty list shows empty state message', (tester) async {
      await pumpList(tester);
      expect(find.text('No expenses yet'), findsOneWidget);
      // Close db to cancel any pending stream timers before test frame ends.
      await db.close();
    });

    testWidgets('expense card shows name and amount', (tester) async {
      await insertSampleGasto(db);
      await pumpList(tester);

      expect(find.text('Netflix'), findsOneWidget);
      expect(find.textContaining('15'), findsOneWidget);

      await db.close();
    });

    testWidgets('toggle changes activo state', (tester) async {
      await insertSampleGasto(db, activo: true);
      await pumpList(tester);

      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);

      final switchWidget = tester.widget<Switch>(switchFinder);
      expect(switchWidget.value, isTrue);

      await tester.tap(switchFinder);
      await tester.pump();
      await tester.pump();

      final switchWidgetAfter = tester.widget<Switch>(switchFinder);
      expect(switchWidgetAfter.value, isFalse);

      await db.close();
    });
  });
}
