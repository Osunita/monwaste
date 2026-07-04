import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database.dart';
import '../../core/database/tables.dart';
import '../../shared/providers.dart';

// ---------------------------------------------------------------------------
// List providers
// ---------------------------------------------------------------------------

/// Provider that watches ALL gastos (active and inactive).
final gastoListProvider = StreamProvider<List<Gasto>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllGastos();
});

/// Provider that watches only ACTIVE gastos.
final activeGastoListProvider = StreamProvider<List<Gasto>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchActiveGastos();
});

// ---------------------------------------------------------------------------
// Form state
// ---------------------------------------------------------------------------

/// Immutable state for the expense form.
@immutable
class ExpenseFormState {
  final String nombre;
  final String importe;
  final Periodicidad periodicidad;
  final DateTime? fechaCobro;
  final Color color;
  final String? nombreError;
  final String? importeError;
  final bool isSaving;
  final bool isEditMode;

  const ExpenseFormState({
    required this.nombre,
    required this.importe,
    required this.periodicidad,
    this.fechaCobro,
    required this.color,
    this.nombreError,
    this.importeError,
    this.isSaving = false,
    this.isEditMode = false,
  });

  factory ExpenseFormState.initial() => ExpenseFormState(
        nombre: '',
        importe: '',
        periodicidad: Periodicidad.mensual,
        color: const Color(0xFF2563EB),
      );

  ExpenseFormState copyWith({
    String? nombre,
    String? importe,
    Periodicidad? periodicidad,
    Object? fechaCobro = _sentinel,
    Color? color,
    Object? nombreError = _sentinel,
    Object? importeError = _sentinel,
    bool? isSaving,
    bool? isEditMode,
  }) {
    return ExpenseFormState(
      nombre: nombre ?? this.nombre,
      importe: importe ?? this.importe,
      periodicidad: periodicidad ?? this.periodicidad,
      fechaCobro:
          fechaCobro == _sentinel ? this.fechaCobro : fechaCobro as DateTime?,
      color: color ?? this.color,
      nombreError: nombreError == _sentinel
          ? this.nombreError
          : nombreError as String?,
      importeError: importeError == _sentinel
          ? this.importeError
          : importeError as String?,
      isSaving: isSaving ?? this.isSaving,
      isEditMode: isEditMode ?? this.isEditMode,
    );
  }
}

/// Sentinel used by [ExpenseFormState.copyWith] to distinguish
/// "not passed" from "explicitly set to null".
const _sentinel = Object();

// ---------------------------------------------------------------------------
// Form notifier
// ---------------------------------------------------------------------------

/// [StateNotifier] that drives the expense create/edit form.
class ExpenseFormNotifier extends StateNotifier<ExpenseFormState> {
  final MonwasteDatabase _db;
  final int? _editId;

  ExpenseFormNotifier(this._db, [this._editId])
      : super(ExpenseFormState.initial()) {
    final editId = _editId;
    if (editId != null) {
      _loadExisting(editId);
    }
  }

  void setNombre(String value) =>
      state = state.copyWith(nombre: value, nombreError: null);

  void setImporte(String value) =>
      state = state.copyWith(importe: value, importeError: null);

  void setPeriodicidad(Periodicidad value) =>
      state = state.copyWith(periodicidad: value);

  void setFechaCobro(DateTime? value) =>
      state = state.copyWith(fechaCobro: value);

  void setColor(Color value) => state = state.copyWith(color: value);

  /// Validates form fields and returns true if valid.
  bool validate() {
    var valid = true;
    String? nombreErr;
    String? importeErr;

    if (state.nombre.trim().isEmpty) {
      nombreErr = 'nombre_required';
      valid = false;
    }

    // Normalize comma decimal separator (4,50 → 4.50) for locale support.
    final normalized = state.importe.trim().replaceAll(',', '.');
    final parsed = double.tryParse(normalized);
    if (parsed == null || parsed <= 0) {
      importeErr = 'importe_positive';
      valid = false;
    }

    state = state.copyWith(
      nombreError: nombreErr,
      importeError: importeErr,
    );
    return valid;
  }

  /// Saves (insert or update) and returns the id.
  Future<int> save() async {
    if (!validate()) return -1;

    state = state.copyWith(isSaving: true);

    final importe = double.parse(state.importe.replaceAll(',', '.'));
    final colorHex =
        '#${state.color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';

    // Si el usuario no eligió fecha, se asume el día 1 del mes actual
    // (ver AGENTS.md: "fecha de cobro opcional, por defecto día 1 del mes
    // de creación").
    final now = DateTime.now();
    final fechaCobro = state.fechaCobro ?? DateTime(now.year, now.month, 1);

    final companion = GastosCompanion.insert(
      nombre: state.nombre.trim(),
      importe: importe,
      periodicidad: state.periodicidad.name,
      fechaCobro: Value(fechaCobro),
      color: colorHex,
    );

    try {
      final editId = _editId;
      if (editId != null) {
        await _db.updateGasto(
          editId,
          GastosCompanion(
            nombre: Value(companion.nombre.value),
            importe: Value(companion.importe.value),
            periodicidad: Value(companion.periodicidad.value),
            fechaCobro: companion.fechaCobro,
            color: Value(companion.color.value),
          ),
        );
        state = state.copyWith(isSaving: false);
        return editId;
      } else {
        final id = await _db.insertGasto(companion);
        state = state.copyWith(isSaving: false);
        return id;
      }
    } catch (e) {
      state = state.copyWith(isSaving: false);
      rethrow;
    }
  }

  Future<void> _loadExisting(int id) async {
    final gasto = await _db.getGastoById(id);
    if (gasto == null) return;

    state = ExpenseFormState(
      nombre: gasto.nombre,
      importe: gasto.importe.toString(),
      periodicidad: Periodicidad.values.firstWhere(
        (p) => p.name == gasto.periodicidad,
      ),
      fechaCobro: gasto.fechaCobro,
      color: Color(
        int.parse(gasto.color.substring(1), radix: 16) | 0xFF000000,
      ),
      isEditMode: true,
    );
  }
}

/// Provider that creates a form notifier for a given edit id (null = new).
final expenseFormProvider =
    StateNotifierProvider.autoDispose.family<ExpenseFormNotifier, ExpenseFormState, int?>(
  (ref, editId) {
    final db = ref.watch(databaseProvider);
    return ExpenseFormNotifier(db, editId);
  },
);
