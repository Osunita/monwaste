import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monwaste/core/database/database.dart';
import 'package:monwaste/features/home/home_screen.dart';
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
  group('HomeScreen', () {
    late MonwasteDatabase db;

    setUp(() {
      db = MonwasteDatabase.fromExecutor(NativeDatabase.memory());
    });

    tearDown(() async {
      try {
        await db.close();
      } catch (_) {}
    });

    Future<void> pumpHome(WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const HomeScreen(), db));
      // Use pump() instead of pumpAndSettle() because Drift stream
      // queries create periodic timers that never settle.
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
    }

    testWidgets('empty state shows appropriate message', (tester) async {
      await pumpHome(tester);
      // When there are no active expenses, the empty state message appears.
      expect(find.text('Add your first expense'), findsOneWidget);
      await db.close();
    });

    testWidgets('dashboard total is not shown when no expenses', (tester) async {
      await pumpHome(tester);
      // When there are no expenses, the empty state is shown instead of
      // the total dashboard.  The "€0.00" text should not be present.
      expect(find.textContaining('€0.00'), findsNothing);
      await db.close();
    });

    testWidgets('FAB is present on the screen', (tester) async {
      await pumpHome(tester);
      final fab = find.byType(FloatingActionButton);
      expect(fab, findsOneWidget);
      await db.close();
    });

    testWidgets('dashboard shows total and active count with expenses',
        (tester) async {
      // Insert an active expense with a monthly charge date.
      final now = DateTime.now();
      await insertSampleGasto(
        db,
        nombre: 'Netflix',
        importe: 15.99,
        fechaCobro: DateTime(now.year, now.month, 15),
        activo: true,
      );
      await pumpHome(tester);

      // The dashboard should show the total (15.99) and active count (1).
      expect(find.textContaining('15.99'), findsOneWidget);
      expect(find.textContaining('1 active expense'), findsOneWidget);
      await db.close();
    });

    testWidgets('inactive expenses do not appear in summary', (tester) async {
      // Insert an INACTIVE expense — it should NOT contribute to the total.
      final now = DateTime.now();
      await insertSampleGasto(
        db,
        nombre: 'Old Spotify',
        importe: 9.99,
        fechaCobro: DateTime(now.year, now.month, 10),
        activo: false,
      );
      await pumpHome(tester);

      // The empty state should show since there are no active expenses.
      expect(find.text('Add your first expense'), findsOneWidget);
      await db.close();
    });
  });
}
