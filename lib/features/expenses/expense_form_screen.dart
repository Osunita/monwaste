import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/tables.dart';
import '../../l10n/l10n.dart';
import '../../shared/notifications.dart';
import '../../shared/providers.dart';
import 'providers.dart';

/// Default color palette for new expenses.
const _defaultColors = [
  Color(0xFF2563EB), // blue
  Color(0xFF10B981), // green
  Color(0xFFEF4444), // red
  Color(0xFFF59E0B), // amber
  Color(0xFF8B5CF6), // purple
  Color(0xFFEC4899), // pink
  Color(0xFF06B6D4), // cyan
  Color(0xFFF97316), // orange
];

class ExpenseFormScreen extends ConsumerStatefulWidget {
  final int? editId;

  const ExpenseFormScreen({super.key, this.editId});

  @override
  ConsumerState<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends ConsumerState<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // If creating a new expense, cycle the default color based on count.
    if (widget.editId == null) {
      _initDefaultColor();
    }
  }

  Future<void> _initDefaultColor() async {
    final db = ref.read(databaseProvider);
    final count = await db.select(db.gastos).get().then((list) => list.length);
    final color = _defaultColors[count % _defaultColors.length];
    // Small delay to ensure the provider is initialized.
    Future.microtask(() {
      ref.read(expenseFormProvider(null).notifier).setColor(color);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formState = ref.watch(expenseFormProvider(widget.editId));
    final formNotifier = ref.read(expenseFormProvider(widget.editId).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          formState.isEditMode
              ? l10n.expenseFormEditTitle
              : l10n.expenseFormTitle,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // --- Name field ---
            TextFormField(
              initialValue: formState.nombre,
              decoration: InputDecoration(
                labelText: l10n.expenseFormNameHint,
                errorText: formState.nombreError != null
                    ? l10n.expenseFormNameRequired
                    : null,
              ),
              textInputAction: TextInputAction.next,
              onChanged: formNotifier.setNombre,
            ),
            const SizedBox(height: 16),

            // --- Amount field ---
            TextFormField(
              initialValue: formState.importe,
              decoration: InputDecoration(
                labelText: l10n.expenseFormAmountHint,
                errorText: _amountError(l10n, formState.importeError),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              onChanged: formNotifier.setImporte,
            ),
            const SizedBox(height: 16),

            // --- Periodicity dropdown ---
            DropdownButtonFormField<Periodicidad>(
              initialValue: formState.periodicidad,
              decoration: InputDecoration(
                labelText: l10n.expenseFormPeriodicityLabel,
              ),
              items: Periodicidad.values.map((p) {
                return DropdownMenuItem(
                  value: p,
                  child: Text(_periodicidadLabel(l10n, p)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) formNotifier.setPeriodicidad(value);
              },
            ),
            const SizedBox(height: 16),

            // --- Date picker ---
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.expenseFormDateLabel),
              subtitle: Text(
                formState.fechaCobro != null
                    ? '${formState.fechaCobro!.day}/${formState.fechaCobro!.month}/${formState.fechaCobro!.year}'
                    : l10n.expenseFormDateNotSet,
              ),
              trailing: TextButton(
                onPressed: () => _pickDate(context, formNotifier, formState),
                child: Text(l10n.expenseFormSelectDate),
              ),
            ),
            const SizedBox(height: 16),

            // --- Color picker ---
            Text(l10n.expenseFormColorLabel,
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            ColorPicker(
              pickerColor: formState.color,
              onColorChanged: (color) => formNotifier.setColor(color),
              enableAlpha: false,
              pickerAreaHeightPercent: 0.7,
              labelTypes: const [], // gradient bar only — no labels
            ),
            const SizedBox(height: 24),

            // --- Save button ---
            FilledButton(
              onPressed: formState.isSaving
                  ? null
                  : () => _save(context, formNotifier),
              child: formState.isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.commonSave),
            ),
          ],
        ),
      ),
    );
  }

  String? _amountError(AppLocalizations l10n, String? error) {
    if (error == null) return null;
    return error == 'importe_positive'
        ? l10n.expenseFormAmountPositive
        : l10n.expenseFormAmountInvalid;
  }

  String _periodicidadLabel(AppLocalizations l10n, Periodicidad p) {
    return switch (p) {
      Periodicidad.mensual => l10n.periodicidadMensual,
      Periodicidad.trimestral => l10n.periodicidadTrimestral,
      Periodicidad.semestral => l10n.periodicidadSemestral,
      Periodicidad.anual => l10n.periodicidadAnual,
    };
  }

  Future<void> _pickDate(
    BuildContext context,
    ExpenseFormNotifier notifier,
    ExpenseFormState formState,
  ) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: formState.fechaCobro ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      notifier.setFechaCobro(picked);
    }
  }

  Future<void> _save(
    BuildContext context,
    ExpenseFormNotifier notifier,
  ) async {
    final id = await notifier.save();
    if (id < 0) return; // validation failed, errors are shown
    // Fire-and-forget reschedule so widget tests don't hang on stream
    // .first() in environments without a running event loop.
    rescheduleNotifications(ref);
    if (context.mounted) Navigator.of(context).pop();
  }
}
