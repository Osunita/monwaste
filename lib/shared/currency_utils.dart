import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'providers.dart';

/// Shared currency symbol lookup by ISO 4217 code.
///
/// Extracted from duplicate _currencySymbol methods in home_screen.dart and
/// expense_card.dart.
String currencySymbol(String code) {
  switch (code) {
    case 'EUR':
      return '€';
    case 'USD':
      return r'$';
    case 'GBP':
      return '£';
    case 'JPY':
      return '¥';
    case 'CAD':
      return 'CA\$';
    case 'BRL':
      return 'R\$';
    case 'ARS':
      return 'AR\$';
    case 'MXN':
      return 'MX\$';
    default:
      return code;
  }
}

/// Cached [NumberFormat] provider that rebuilds only when the currency code
/// changes.
///
/// Replaces inline `NumberFormat.currency(...)` calls in HomeScreen and
/// ExpenseCard to avoid re-instantiating the formatter on every build.
final currencyFormatterProvider = Provider<NumberFormat>((ref) {
  final code = ref.watch(currencyCodeProvider);
  return NumberFormat.currency(
    symbol: currencySymbol(code),
    decimalDigits: 2,
  );
});
