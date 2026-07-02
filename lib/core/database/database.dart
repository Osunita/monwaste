import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'database.g.dart';

/// Base de datos local de Monwaste.
///
/// Usar [MonwasteDatabase()] para producción (archivo en directorio de documentos)
/// o [MonwasteDatabase.fromExecutor] para pruebas (ej. en memoria).
@DriftDatabase(tables: [Gastos, Settings])
class MonwasteDatabase extends _$MonwasteDatabase {
  /// Crea la base de datos en el directorio de documentos (producción).
  MonwasteDatabase() : super(_openConnection());

  /// Crea la base de datos con un [QueryExecutor] personalizado (pruebas).
  MonwasteDatabase.fromExecutor(super.e);

  /// Watch all gastos, ordered by id descending (newest first).
  Stream<List<Gasto>> watchAllGastos() =>
      (select(gastos)..orderBy([(g) => OrderingTerm.desc(g.id)])).watch();

  /// Watch only active gastos.
  Stream<List<Gasto>> watchActiveGastos() =>
      (select(gastos)..where((g) => g.activo.equals(true)))
          .watch();

  /// Get active gastos once (synchronous-style query for fire-and-forget
  /// use cases like notification rescheduling).
  Future<List<Gasto>> getActiveGastos() =>
      (select(gastos)..where((g) => g.activo.equals(true))).get();

  /// Get a single gasto by id.
  Future<Gasto?> getGastoById(int id) =>
      (select(gastos)..where((g) => g.id.equals(id))).getSingleOrNull();

  /// Insert a new gasto.
  Future<int> insertGasto(GastosCompanion companion) =>
      into(gastos).insert(companion);

  /// Update an existing gasto.
  Future<void> updateGasto(int id, GastosCompanion companion) =>
      (update(gastos)..where((g) => g.id.equals(id))).write(companion);

  /// Delete a gasto.
  Future<void> deleteGasto(int id) =>
      (delete(gastos)..where((g) => g.id.equals(id))).go();

  /// Toggle the activo status of a gasto.
  Future<void> toggleGastoActivo(int id) async {
    final gasto = await getGastoById(id);
    if (gasto != null) {
      await updateGasto(
        id,
        GastosCompanion(activo: Value(!gasto.activo)),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Settings DAO
  // ---------------------------------------------------------------------------

  /// Watch settings as a stream (reacts to DB changes).
  Stream<Setting> watchSettings() =>
      select(settings).watch().map((list) => list.first);

  /// Get the current settings once.
  Future<Setting> getSettings() =>
      (select(settings)..where((s) => s.id.equals(1))).getSingle();

  /// Update settings fields (only non-absent values are written).
  Future<void> updateSettings(SettingsCompanion companion) =>
      (update(settings)..where((s) => s.id.equals(1))).write(companion);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
        // Insertar fila por defecto de Settings (singleton id=1).
        await into(settings).insert(const SettingsCompanion(
          moneda: Value('EUR'),
          idioma: Value('es'),
          tema: Value('system'),
        ));
      },
      onUpgrade: (m, from, to) async {
        if (from == 1) {
          await m.addColumn(settings, settings.tema);
          // Ensure defaults exist for existing settings row
          final existing =
              await (select(settings)..where((s) => s.id.equals(1)))
                  .getSingleOrNull();
          if (existing == null) {
            await into(settings).insert(const SettingsCompanion(
              moneda: Value('EUR'),
              idioma: Value('es'),
              tema: Value('system'),
            ));
          }
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      await Directory(dir.path).create(recursive: true);
      final file = File(p.join(dir.path, 'monwaste.db'));
      return NativeDatabase(file);
    });
  }
}
