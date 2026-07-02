import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monwaste/core/database/database.dart';
import 'package:monwaste/features/settings/settings_screen.dart';
import 'package:monwaste/l10n/l10n.dart';
import 'package:monwaste/shared/providers.dart';

/// Helper that wraps a widget in a [ProviderScope] with an in-memory database.
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
  group('SettingsScreen', () {
    late MonwasteDatabase db;

    setUp(() {
      db = MonwasteDatabase.fromExecutor(NativeDatabase.memory());
    });

    tearDown(() async {
      try {
        await db.close();
      } catch (_) {}
    });

    Future<void> pumpSettings(WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const SettingsScreen(), db));
      // Use pump() instead of pumpAndSettle() because Drift stream queries
      // create periodic timers that never settle.
      await tester.pump();
      await tester.pump();
    }

    testWidgets('shows currency dropdown and sections', (tester) async {
      await pumpSettings(tester);
      expect(find.text('EUR'), findsOneWidget);
      expect(find.text('ES'), findsOneWidget);
      expect(find.text('EN'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
      await db.close();
    });

    testWidgets('changing currency calls updateSettings', (tester) async {
      await pumpSettings(tester);

      // Open the currency dropdown — tap the DropdownButton itself,
      // not the ListTile title (which also shows "EUR").
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      // Now select USD from the overlay.
      await tester.tap(find.text(r'$ USD').last);
      await tester.pump();
      await tester.pump();

      // Verify the DB was updated.
      final settings = await db.getSettings();
      expect(settings.moneda, 'USD');
      await db.close();
    });

    testWidgets('changing theme mode updates DB', (tester) async {
      await pumpSettings(tester);

      // Tap the "Dark" segment button.
      await tester.tap(find.text('Dark'));
      await tester.pump();

      final settings = await db.getSettings();
      expect(settings.tema, 'dark');
      await db.close();
    });
  });
}
