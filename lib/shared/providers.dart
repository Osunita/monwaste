import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database/database.dart';

/// Provider singleton de la base de datos.
///
/// Se cierra automáticamente al descartar el provider.
final databaseProvider = Provider<MonwasteDatabase>((ref) {
  final db = MonwasteDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// ---------------------------------------------------------------------------
// Settings-derived providers
// ---------------------------------------------------------------------------

/// Stream provider que expone la configuración global desde la base de datos.
final settingsProvider = StreamProvider<Setting>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchSettings();
});

/// Código de moneda ISO 4217 actual (ej. "EUR", "USD").
final currencyCodeProvider = Provider<String>((ref) {
  return ref.watch(settingsProvider).valueOrNull?.moneda ?? 'EUR';
});

/// Modo de tema (system / light / dark) derivado de la config.
final themeModeProvider = Provider<ThemeMode>((ref) {
  final tema = ref.watch(settingsProvider).valueOrNull?.tema ?? 'system';
  switch (tema) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
});

/// Locale activo derivado de la configuración de idioma.
final localeProvider = Provider<Locale>((ref) {
  final idioma = ref.watch(settingsProvider).valueOrNull?.idioma ?? 'en';
  return Locale(idioma);
});
