import 'package:flutter/material.dart';

/// Temas claro y oscuro de Monwaste.
///
/// Colores definidos en AGENTS.md:
///   - Principal: #2563EB
///   - Éxito:     #10B981
///   - Error:     #EF4444
class AppTheme {
  static const Color primaryColor = Color(0xFF2563EB);
  static const Color successColor = Color(0xFF10B981);
  static const Color errorColor = Color(0xFFEF4444);

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: primaryColor,
      brightness: Brightness.light,
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: primaryColor,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF000000),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
