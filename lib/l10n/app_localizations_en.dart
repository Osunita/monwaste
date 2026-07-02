// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homeNextMonthLabel => 'Next month';

  @override
  String get homeTotalLabel => 'Total to pay';

  @override
  String get homeNextMonthEmpty => 'No expenses next month';

  @override
  String homeActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active expenses',
      one: '$count active expense',
    );
    return '$_temp0';
  }

  @override
  String get homeNoExpenses => 'Add your first expense';

  @override
  String get homeTapToSeeDetails => 'Tap to see details';

  @override
  String get expensesTitle => 'Expenses';

  @override
  String get expenseFormTitle => 'New expense';

  @override
  String get expenseFormNameHint => 'Expense name';

  @override
  String get expenseFormAmountHint => 'Amount';

  @override
  String get expenseFormPeriodicityLabel => 'Frequency';

  @override
  String get expenseFormDateLabel => 'Charge date';

  @override
  String get expenseFormColorLabel => 'Color';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsCurrencyLabel => 'Currency';

  @override
  String get settingsLanguageLabel => 'Language';

  @override
  String get settingsThemeLabel => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get commonSave => 'Save';

  @override
  String get expenseFormNameRequired => 'Name is required';

  @override
  String get expenseFormAmountPositive => 'Amount must be greater than zero';

  @override
  String get expenseFormAmountInvalid => 'Invalid amount';

  @override
  String get expenseFormDateNotSet => 'Not set';

  @override
  String get expenseFormSelectDate => 'Select date';

  @override
  String get expenseFormEditTitle => 'Edit expense';

  @override
  String get expensesEmpty => 'No expenses yet';

  @override
  String get expensesDeleteConfirm => 'Delete this expense?';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonEdit => 'Edit';

  @override
  String get periodicidadMensual => 'Monthly';

  @override
  String get periodicidadTrimestral => 'Quarterly';

  @override
  String get periodicidadSemestral => 'Semi-annual';

  @override
  String get periodicidadAnual => 'Annual';
}
