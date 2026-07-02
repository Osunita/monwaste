import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monwaste/core/database/database.dart';
import 'package:monwaste/core/database/tables.dart';

void main() {
  group('MonwasteDatabase', () {
    late MonwasteDatabase db;

    setUp(() {
      db = MonwasteDatabase.fromExecutor(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    test('Insert Gasto with all fields — read back matches', () async {
      final companion = GastosCompanion.insert(
        nombre: 'Netflix',
        importe: 15.99,
        periodicidad: Periodicidad.mensual.name,
        fechaCobro: Value(DateTime(2026, 7, 15)),
        color: '#E50914',
      );
      final id = await db.into(db.gastos).insert(companion);
      final gastos = await db.select(db.gastos).get();

      expect(gastos.length, 1);
      final g = gastos.first;
      expect(g.id, id);
      expect(g.nombre, 'Netflix');
      expect(g.importe, 15.99);
      expect(g.periodicidad, Periodicidad.mensual.name);
      expect(g.fechaCobro, DateTime(2026, 7, 15));
      expect(g.color, '#E50914');
      expect(g.activo, isTrue);
    });

    test('Insert Gasto with null fechaCobro — stored as null', () async {
      final companion = GastosCompanion.insert(
        nombre: 'Seguro',
        importe: 120.0,
        periodicidad: Periodicidad.anual.name,
        color: '#2563EB',
      );
      await db.into(db.gastos).insert(companion);
      final gastos = await db.select(db.gastos).get();

      expect(gastos.length, 1);
      final g = gastos.first;
      expect(g.nombre, 'Seguro');
      expect(g.fechaCobro, isNull);
    });

    test('Settings defaults on first read', () async {
      final settings = await db.select(db.settings).get();

      expect(settings.length, 1);
      final s = settings.first;
      expect(s.id, 1);
      expect(s.moneda, 'EUR');
      expect(s.idioma, 'es');
      expect(s.tema, 'system');
    });

    test('Settings DAO — updateSettings updates tema', () async {
      await db.updateSettings(
        const SettingsCompanion(tema: Value('dark')),
      );
      final settings = await db.getSettings();
      expect(settings.tema, 'dark');
      expect(settings.moneda, 'EUR'); // unchanged
      expect(settings.idioma, 'es'); // unchanged
    });

    test('Settings DAO — watchSettings emits updates', () async {
      final emitted = <Setting>[];
      final sub = db.watchSettings().listen(emitted.add);

      // Wait for the initial emission.
      await Future.delayed(const Duration(milliseconds: 50));
      expect(emitted.length, 1);
      expect(emitted.first.tema, 'system');

      await db.updateSettings(
        const SettingsCompanion(moneda: Value('USD')),
      );
      await Future.delayed(const Duration(milliseconds: 50));
      expect(emitted.length, 2);
      expect(emitted.last.moneda, 'USD');

      await sub.cancel();
    });

    test('getActiveGastos returns only active gastos', () async {
      await db.into(db.gastos).insert(GastosCompanion.insert(
            nombre: 'Activo',
            importe: 10,
            periodicidad: 'mensual',
            color: '#000',
            activo: Value(true),
          ));
      await db.into(db.gastos).insert(GastosCompanion.insert(
            nombre: 'Inactivo',
            importe: 20,
            periodicidad: 'mensual',
            color: '#000',
            activo: Value(false),
          ));

      final activos = await db.getActiveGastos();
      expect(activos.length, 1);
      expect(activos.first.nombre, 'Activo');
    });
  });
}
