import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database.dart';
import '../../l10n/l10n.dart';
import '../../shared/providers.dart';

/// Pantalla de Ajustes.
///
/// Permite cambiar moneda, idioma y tema de la aplicación.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settingsAsync = ref.watch(settingsProvider);
    final db = ref.read(databaseProvider);

    return settingsAsync.when(
      data: (settings) => Scaffold(
        appBar: AppBar(title: Text(l10n.settingsTitle)),
        body: ListView(
          children: [
            const SizedBox(height: 8),
            // ── Currency ──────────────────────────────────────────
            _SectionHeader(l10n.settingsCurrencyLabel),
            ListTile(
              title: Text(settings.moneda),
              trailing: DropdownButton<String>(
                value: settings.moneda,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'EUR', child: Text('€ EUR')),
                  DropdownMenuItem(value: 'USD', child: Text(r'$ USD')),
                  DropdownMenuItem(value: 'GBP', child: Text('£ GBP')),
                  DropdownMenuItem(value: 'JPY', child: Text('¥ JPY')),
                  DropdownMenuItem(value: 'CAD', child: Text('CA\$ CAD')),
                  DropdownMenuItem(value: 'BRL', child: Text('R\$ BRL')),
                  DropdownMenuItem(value: 'ARS', child: Text('AR\$ ARS')),
                  DropdownMenuItem(value: 'MXN', child: Text('MX\$ MXN')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    db.updateSettings(
                      SettingsCompanion(moneda: Value(value)),
                    );
                  }
                },
              ),
            ),
            const Divider(height: 1),

            // ── Language ──────────────────────────────────────────
            _SectionHeader(l10n.settingsLanguageLabel),
            ListTile(
              title: SegmentedButton<String>(
                segments: [
                  const ButtonSegment(value: 'es', label: Text('ES')),
                  const ButtonSegment(value: 'en', label: Text('EN')),
                ],
                selected: {settings.idioma},
                onSelectionChanged: (value) {
                  db.updateSettings(
                    SettingsCompanion(idioma: Value(value.first)),
                  );
                },
              ),
            ),
            const Divider(height: 1),

            // ── Theme ─────────────────────────────────────────────
            _SectionHeader(l10n.settingsThemeLabel),
            ListTile(
              title: SegmentedButton<String>(
                segments: [
                  ButtonSegment(
                    value: 'system',
                    label: Text(l10n.settingsThemeSystem),
                  ),
                  ButtonSegment(
                    value: 'light',
                    label: Text(l10n.settingsThemeLight),
                  ),
                  ButtonSegment(
                    value: 'dark',
                    label: Text(l10n.settingsThemeDark),
                  ),
                ],
                selected: {settings.tema},
                onSelectionChanged: (value) {
                  db.updateSettings(
                    SettingsCompanion(tema: Value(value.first)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      loading: () => Scaffold(
        appBar: AppBar(title: Text(l10n.settingsTitle)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: Text(l10n.settingsTitle)),
        body: Center(child: Text('Error: $e')),
      ),
    );
  }
}

/// Simple section header used inside the settings ListView.
class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
