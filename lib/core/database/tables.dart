import 'package:drift/drift.dart';

/// Periodicidad de un gasto recurrente.
///
/// Se almacena como texto usando el valor `.name` del enum.
enum Periodicidad {
  mensual,
  trimestral,
  semestral,
  anual,
}

/// Tabla de gastos recurrentes.
class Gastos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  RealColumn get importe => real()();
  TextColumn get periodicidad => text()();
  DateTimeColumn get fechaCobro => dateTime().nullable()();
  TextColumn get color => text()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
}

/// Tabla de configuración global (singleton de una sola fila).
class Settings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get moneda => text().withDefault(const Constant("EUR"))();
  TextColumn get idioma => text().withDefault(const Constant("es"))();
  TextColumn get tema => text().withDefault(const Constant("system"))();

  @override
  Set<Column> get primaryKey => {id};
}
