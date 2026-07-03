import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @homeNextMonthLabel.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get homeNextMonthLabel;

  /// No description provided for @homeNextMonthPagaras.
  ///
  /// In en, this message translates to:
  /// **'Next month you\'ll pay'**
  String get homeNextMonthPagaras;

  /// No description provided for @homeTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total to pay'**
  String get homeTotalLabel;

  /// No description provided for @homeNextMonthEmpty.
  ///
  /// In en, this message translates to:
  /// **'No expenses next month'**
  String get homeNextMonthEmpty;

  /// No description provided for @homeActiveCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} active expense} other{{count} active expenses}}'**
  String homeActiveCount(int count);

  /// No description provided for @homeNoExpenses.
  ///
  /// In en, this message translates to:
  /// **'Add your first expense'**
  String get homeNoExpenses;

  /// No description provided for @homeTapToSeeDetails.
  ///
  /// In en, this message translates to:
  /// **'Tap to see details'**
  String get homeTapToSeeDetails;

  /// No description provided for @expensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expensesTitle;

  /// No description provided for @expenseFormTitle.
  ///
  /// In en, this message translates to:
  /// **'New expense'**
  String get expenseFormTitle;

  /// No description provided for @expenseFormNameHint.
  ///
  /// In en, this message translates to:
  /// **'Expense name'**
  String get expenseFormNameHint;

  /// No description provided for @expenseFormAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get expenseFormAmountHint;

  /// No description provided for @expenseFormPeriodicityLabel.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get expenseFormPeriodicityLabel;

  /// No description provided for @expenseFormDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Charge date'**
  String get expenseFormDateLabel;

  /// No description provided for @expenseFormColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get expenseFormColorLabel;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsCurrencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get settingsCurrencyLabel;

  /// No description provided for @settingsLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageLabel;

  /// No description provided for @settingsThemeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeLabel;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @expenseFormNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get expenseFormNameRequired;

  /// No description provided for @expenseFormAmountPositive.
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than zero'**
  String get expenseFormAmountPositive;

  /// No description provided for @expenseFormAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid amount'**
  String get expenseFormAmountInvalid;

  /// No description provided for @expenseFormDateNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get expenseFormDateNotSet;

  /// No description provided for @expenseFormSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get expenseFormSelectDate;

  /// No description provided for @expenseFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit expense'**
  String get expenseFormEditTitle;

  /// No description provided for @expensesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No expenses yet'**
  String get expensesEmpty;

  /// No description provided for @expensesDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this expense?'**
  String get expensesDeleteConfirm;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @periodicidadMensual.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get periodicidadMensual;

  /// No description provided for @periodicidadTrimestral.
  ///
  /// In en, this message translates to:
  /// **'Quarterly'**
  String get periodicidadTrimestral;

  /// No description provided for @periodicidadSemestral.
  ///
  /// In en, this message translates to:
  /// **'Semi-annual'**
  String get periodicidadSemestral;

  /// No description provided for @periodicidadAnual.
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get periodicidadAnual;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
