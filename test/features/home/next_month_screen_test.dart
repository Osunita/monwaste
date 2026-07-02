import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monwaste/core/database/database.dart';
import 'package:monwaste/features/home/next_month_screen.dart';
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
  group('NextMonthScreen', () {
    late MonwasteDatabase db;

    setUp(() {
      db = MonwasteDatabase.fromExecutor(NativeDatabase.memory());
    });

    tearDown(() async {
      try {
        await db.close();
      } catch (_) {}
    });

    Future<void> pumpScreen(WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const NextMonthScreen(), db));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
    }

    testWidgets('empty filtered list shows empty state', (tester) async {
      await pumpScreen(tester);
      // With no expenses at all, the next-month list should be empty.
      expect(find.text('No expenses next month'), findsOneWidget);
      await db.close();
    });

    testWidgets('expenses with next-month occurrence are shown',
        (tester) async {
      final now = DateTime.now();
      // An expense charged on the 15th of this month will have its next
      // monthly occurrence on the 15th of next month.
      await insertSampleGasto(
        db,
        nombre: 'Netflix',
        importe: 15.99,
        fechaCobro: DateTime(now.year, now.month, 15),
        activo: true,
      );
      await pumpScreen(tester);

      // The card should be visible in the filtered list.
      expect(find.text('Netflix'), findsOneWidget);
      await db.close();
    });

    testWidgets('expenses not aligned to next month are hidden',
        (tester) async {
      final now = DateTime.now();
      // Create a quarterly expense whose anchor does NOT align with the
      // next month.  For example, if anchor is Jan 2026 and the next
      // month is Aug 2026, a quarterly recurrence on Jan 2026 aligns with
      // Apr, Jul, Oct — NOT August.
      //
      // To guarantee it doesn't appear in next month, pick a quarterly
      // anchor whose next occurrence skips the next month.
      // Easiest approach: use the current month for the anchor and
      // set periodicidad to something that only sometimes aligns.
      // If current month is, say, January, a quarterly expense anchored
      // in January aligns with April, July, October, January — so it
      // would align with February only if (Feb - Jan) % 3 == 0 → 1 % 3
      // = 1 → no.
      await insertSampleGasto(
        db,
        nombre: 'Spotify',
        importe: 9.99,
        periodicidad: 'trimestral',
        fechaCobro: DateTime(now.year, now.month, 10),
        activo: true,
      );
      await pumpScreen(tester);

      // A trimestral expense anchored in the current month will only
      // align with months whose offset from anchor is divisible by 3.
      // TotalMonths = (nextMonth - anchor) = 1 month from now.
      // 1 % 3 != 0 → does NOT align → should NOT be shown.
      final spotify = find.text('Spotify');
      expect(spotify, findsNothing);
      await db.close();
    });

    testWidgets('inactive expenses do not appear', (tester) async {
      final now = DateTime.now();
      await insertSampleGasto(
        db,
        nombre: 'Inactive',
        importe: 5.00,
        fechaCobro: DateTime(now.year, now.month, 1),
        activo: false,
      );
      await pumpScreen(tester);

      // Inactive expenses are filtered out by activeGastoListProvider.
      expect(find.text('Inactive'), findsNothing);
      await db.close();
    });
  });
}
