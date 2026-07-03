// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get homeNextMonthLabel => 'Mes siguiente';

  @override
  String get homeNextMonthPagaras => 'El próximo mes pagarás';

  @override
  String get homeTotalLabel => 'Total a pagar';

  @override
  String get homeNextMonthEmpty => 'No hay gastos el mes que viene';

  @override
  String homeActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gastos activos',
      one: '$count gasto activo',
    );
    return '$_temp0';
  }

  @override
  String get homeNoExpenses => 'Añade tu primer gasto';

  @override
  String get homeTapToSeeDetails => 'Toca para ver detalles';

  @override
  String get expensesTitle => 'Gastos';

  @override
  String get expenseFormTitle => 'Nuevo gasto';

  @override
  String get expenseFormNameHint => 'Nombre del gasto';

  @override
  String get expenseFormAmountHint => 'Importe';

  @override
  String get expenseFormPeriodicityLabel => 'Periodicidad';

  @override
  String get expenseFormDateLabel => 'Fecha de cobro';

  @override
  String get expenseFormColorLabel => 'Color';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsCurrencyLabel => 'Moneda';

  @override
  String get settingsLanguageLabel => 'Idioma';

  @override
  String get settingsThemeLabel => 'Tema';

  @override
  String get settingsThemeSystem => 'Sistema';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get commonSave => 'Guardar';

  @override
  String get expenseFormNameRequired => 'El nombre es obligatorio';

  @override
  String get expenseFormAmountPositive => 'El importe debe ser mayor que cero';

  @override
  String get expenseFormAmountInvalid => 'Importe inválido';

  @override
  String get expenseFormDateNotSet => 'Sin asignar';

  @override
  String get expenseFormSelectDate => 'Seleccionar fecha';

  @override
  String get expenseFormEditTitle => 'Editar gasto';

  @override
  String get expensesEmpty => 'No hay gastos aún';

  @override
  String get expensesDeleteConfirm => '¿Eliminar este gasto?';

  @override
  String get commonDelete => 'Eliminar';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonEdit => 'Editar';

  @override
  String get periodicidadMensual => 'Mensual';

  @override
  String get periodicidadTrimestral => 'Trimestral';

  @override
  String get periodicidadSemestral => 'Semestral';

  @override
  String get periodicidadAnual => 'Anual';
}
