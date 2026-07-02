import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monwaste/core/database/database.dart';
import 'package:monwaste/features/expenses/expense_form_screen.dart';
import 'package:monwaste/l10n/l10n.dart';
import 'package:monwaste/shared/providers.dart';

/// Helper that creates a [ProviderScope] with an in-memory database
/// wrapping the given [child].  Locale is forced to en-US.
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

void main() {
  group('ExpenseFormScreen', () {
    late MonwasteDatabase db;

    setUp(() {
      db = MonwasteDatabase.fromExecutor(NativeDatabase.memory());
    });

    tearDown(() async {
      try {
        await db.close();
      } catch (_) {}
    });

    /// Pumps the form screen and waits for it to render.
    Future<void> pumpForm(WidgetTester tester, {int? editId}) async {
      await tester.pumpWidget(
        createTestApp(ExpenseFormScreen(editId: editId), db),
      );
      await tester.pumpAndSettle();
    }

    /// Scroll down in the ListView until we find the save button,
    /// then return the [FilledButton] finder.
    Future<Finder> findSaveButton(WidgetTester tester) async {
      final saveText = find.text('Save');
      if (saveText.evaluate().isEmpty) {
        // Scroll the ListView down.
        await tester.drag(find.byType(ListView), const Offset(0, -600));
        await tester.pumpAndSettle();
      }
      return find.text('Save');
    }

    testWidgets('empty name shows error', (tester) async {
      await pumpForm(tester);

      // Find and tap Save — scroll first if needed.
      final saveFinder = await findSaveButton(tester);
      expect(saveFinder, findsOneWidget);

      await tester.tap(saveFinder);
      await tester.pumpAndSettle();

      // Scroll back to top to see the validation error.
      final listFinder = find.byType(ListView);
      await tester.drag(listFinder, const Offset(0, 600));
      await tester.pumpAndSettle();

      expect(find.text('Name is required'), findsOneWidget);
    });

    testWidgets('zero amount shows error', (tester) async {
      await pumpForm(tester);

      // Fill in name.
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Expense name'),
        'Netflix',
      );
      await tester.pumpAndSettle();

      // Tap save — amount is empty so it should show error.
      final saveFinder = await findSaveButton(tester);
      await tester.tap(saveFinder);
      await tester.pumpAndSettle();

      expect(find.text('Amount must be greater than zero'), findsOneWidget);
    });

    testWidgets('negative amount shows error', (tester) async {
      await pumpForm(tester);

      // Fill name.
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Expense name'),
        'Netflix',
      );
      await tester.pumpAndSettle();

      // Enter negative amount.
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Amount'),
        '-10',
      );
      await tester.pumpAndSettle();

      // Tap save.
      final saveFinder = await findSaveButton(tester);
      await tester.tap(saveFinder);
      await tester.pumpAndSettle();

      expect(find.text('Amount must be greater than zero'), findsOneWidget);
    });

    testWidgets('valid form saves expense to database', (tester) async {
      await pumpForm(tester);

      // Fill valid form.
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Expense name'),
        'Netflix',
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Amount'),
        '15.99',
      );
      await tester.pumpAndSettle();

      // Tap save — should succeed and pop the screen.
      final saveFinder = await findSaveButton(tester);
      await tester.tap(saveFinder);
      await tester.pumpAndSettle();

      // The form should be popped; verify the expense was actually inserted.
      final saved = await db.select(db.gastos).get();
      expect(saved.length, 1);
      expect(saved.first.nombre, 'Netflix');
      expect(saved.first.importe, 15.99);

      await db.close();
    });
  });
}
