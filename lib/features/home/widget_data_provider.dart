import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/currency_utils.dart';
import '../../shared/providers.dart';
import 'providers.dart';

/// Resolves the effective dark mode state, accounting for [ThemeMode.system].
final isDarkModeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  if (themeMode == ThemeMode.dark) return true;
  if (themeMode == ThemeMode.light) return false;
  return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
      Brightness.dark;
});

/// Data payload pushed to the glance home-screen widget.
///
/// All strings are pre-formatted and locale-aware so the widget (which runs
/// in a separate process) doesn't need Flutter localization access.
class HomeWidgetData {
  /// The widget title string (locale-aware: "Next month" / "Mes siguiente").
  final String title;

  /// The formatted total amount (e.g. "€123,45").
  final String total;

  /// Optional subtitle describing the count (locale-aware).
  final String? subtitle;

  /// Whether the widget should use dark theme colors.
  final bool isDark;

  const HomeWidgetData({
    required this.title,
    required this.total,
    this.subtitle,
    required this.isDark,
  });
}

/// Provider that composes [nextMonthSummaryProvider], [currencyCodeProvider],
/// [themeModeProvider] and [localeProvider] into a [HomeWidgetData] used to
/// drive the glance widget update.
///
/// All locale-sensitive strings are resolved here so the native widget
/// process receives already-localized text.
final widgetDataProvider = Provider<HomeWidgetData>((ref) {
  final summary = ref.watch(nextMonthSummaryProvider);
  final formatter = ref.watch(currencyFormatterProvider);
  final isDark = ref.watch(isDarkModeProvider);

  // Resolve locale-aware strings from providers or detect locale.
  final locale = ref.watch(localeProvider);
  final title = locale.languageCode == 'es'
      ? 'El próximo mes pagarás'
      : 'Next month you\'ll pay';
  final total = formatter.format(summary.total);
  final subtitle = summary.count > 0
      ? locale.languageCode == 'es'
          ? '${summary.count} ${summary.count == 1 ? 'gasto' : 'gastos'}'
          : '${summary.count} ${summary.count == 1 ? 'expense' : 'expenses'}'
      : locale.languageCode == 'es' ? 'Sin gastos' : 'No expenses';

  return HomeWidgetData(
    title: title,
    total: total,
    subtitle: subtitle,
    isDark: isDark,
  );
});
