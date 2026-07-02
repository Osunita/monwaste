// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $GastosTable extends Gastos with TableInfo<$GastosTable, Gasto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GastosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _importeMeta = const VerificationMeta(
    'importe',
  );
  @override
  late final GeneratedColumn<double> importe = GeneratedColumn<double>(
    'importe',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodicidadMeta = const VerificationMeta(
    'periodicidad',
  );
  @override
  late final GeneratedColumn<String> periodicidad = GeneratedColumn<String>(
    'periodicidad',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaCobroMeta = const VerificationMeta(
    'fechaCobro',
  );
  @override
  late final GeneratedColumn<DateTime> fechaCobro = GeneratedColumn<DateTime>(
    'fecha_cobro',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    importe,
    periodicidad,
    fechaCobro,
    color,
    activo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gastos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Gasto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('importe')) {
      context.handle(
        _importeMeta,
        importe.isAcceptableOrUnknown(data['importe']!, _importeMeta),
      );
    } else if (isInserting) {
      context.missing(_importeMeta);
    }
    if (data.containsKey('periodicidad')) {
      context.handle(
        _periodicidadMeta,
        periodicidad.isAcceptableOrUnknown(
          data['periodicidad']!,
          _periodicidadMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_periodicidadMeta);
    }
    if (data.containsKey('fecha_cobro')) {
      context.handle(
        _fechaCobroMeta,
        fechaCobro.isAcceptableOrUnknown(data['fecha_cobro']!, _fechaCobroMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Gasto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Gasto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      importe: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}importe'],
      )!,
      periodicidad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}periodicidad'],
      )!,
      fechaCobro: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_cobro'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
    );
  }

  @override
  $GastosTable createAlias(String alias) {
    return $GastosTable(attachedDatabase, alias);
  }
}

class Gasto extends DataClass implements Insertable<Gasto> {
  final int id;
  final String nombre;
  final double importe;
  final String periodicidad;
  final DateTime? fechaCobro;
  final String color;
  final bool activo;
  const Gasto({
    required this.id,
    required this.nombre,
    required this.importe,
    required this.periodicidad,
    this.fechaCobro,
    required this.color,
    required this.activo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['importe'] = Variable<double>(importe);
    map['periodicidad'] = Variable<String>(periodicidad);
    if (!nullToAbsent || fechaCobro != null) {
      map['fecha_cobro'] = Variable<DateTime>(fechaCobro);
    }
    map['color'] = Variable<String>(color);
    map['activo'] = Variable<bool>(activo);
    return map;
  }

  GastosCompanion toCompanion(bool nullToAbsent) {
    return GastosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      importe: Value(importe),
      periodicidad: Value(periodicidad),
      fechaCobro: fechaCobro == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaCobro),
      color: Value(color),
      activo: Value(activo),
    );
  }

  factory Gasto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Gasto(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      importe: serializer.fromJson<double>(json['importe']),
      periodicidad: serializer.fromJson<String>(json['periodicidad']),
      fechaCobro: serializer.fromJson<DateTime?>(json['fechaCobro']),
      color: serializer.fromJson<String>(json['color']),
      activo: serializer.fromJson<bool>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'importe': serializer.toJson<double>(importe),
      'periodicidad': serializer.toJson<String>(periodicidad),
      'fechaCobro': serializer.toJson<DateTime?>(fechaCobro),
      'color': serializer.toJson<String>(color),
      'activo': serializer.toJson<bool>(activo),
    };
  }

  Gasto copyWith({
    int? id,
    String? nombre,
    double? importe,
    String? periodicidad,
    Value<DateTime?> fechaCobro = const Value.absent(),
    String? color,
    bool? activo,
  }) => Gasto(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    importe: importe ?? this.importe,
    periodicidad: periodicidad ?? this.periodicidad,
    fechaCobro: fechaCobro.present ? fechaCobro.value : this.fechaCobro,
    color: color ?? this.color,
    activo: activo ?? this.activo,
  );
  Gasto copyWithCompanion(GastosCompanion data) {
    return Gasto(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      importe: data.importe.present ? data.importe.value : this.importe,
      periodicidad: data.periodicidad.present
          ? data.periodicidad.value
          : this.periodicidad,
      fechaCobro: data.fechaCobro.present
          ? data.fechaCobro.value
          : this.fechaCobro,
      color: data.color.present ? data.color.value : this.color,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Gasto(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('importe: $importe, ')
          ..write('periodicidad: $periodicidad, ')
          ..write('fechaCobro: $fechaCobro, ')
          ..write('color: $color, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nombre, importe, periodicidad, fechaCobro, color, activo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Gasto &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.importe == this.importe &&
          other.periodicidad == this.periodicidad &&
          other.fechaCobro == this.fechaCobro &&
          other.color == this.color &&
          other.activo == this.activo);
}

class GastosCompanion extends UpdateCompanion<Gasto> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<double> importe;
  final Value<String> periodicidad;
  final Value<DateTime?> fechaCobro;
  final Value<String> color;
  final Value<bool> activo;
  const GastosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.importe = const Value.absent(),
    this.periodicidad = const Value.absent(),
    this.fechaCobro = const Value.absent(),
    this.color = const Value.absent(),
    this.activo = const Value.absent(),
  });
  GastosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required double importe,
    required String periodicidad,
    this.fechaCobro = const Value.absent(),
    required String color,
    this.activo = const Value.absent(),
  }) : nombre = Value(nombre),
       importe = Value(importe),
       periodicidad = Value(periodicidad),
       color = Value(color);
  static Insertable<Gasto> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<double>? importe,
    Expression<String>? periodicidad,
    Expression<DateTime>? fechaCobro,
    Expression<String>? color,
    Expression<bool>? activo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (importe != null) 'importe': importe,
      if (periodicidad != null) 'periodicidad': periodicidad,
      if (fechaCobro != null) 'fecha_cobro': fechaCobro,
      if (color != null) 'color': color,
      if (activo != null) 'activo': activo,
    });
  }

  GastosCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<double>? importe,
    Value<String>? periodicidad,
    Value<DateTime?>? fechaCobro,
    Value<String>? color,
    Value<bool>? activo,
  }) {
    return GastosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      importe: importe ?? this.importe,
      periodicidad: periodicidad ?? this.periodicidad,
      fechaCobro: fechaCobro ?? this.fechaCobro,
      color: color ?? this.color,
      activo: activo ?? this.activo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (importe.present) {
      map['importe'] = Variable<double>(importe.value);
    }
    if (periodicidad.present) {
      map['periodicidad'] = Variable<String>(periodicidad.value);
    }
    if (fechaCobro.present) {
      map['fecha_cobro'] = Variable<DateTime>(fechaCobro.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GastosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('importe: $importe, ')
          ..write('periodicidad: $periodicidad, ')
          ..write('fechaCobro: $fechaCobro, ')
          ..write('color: $color, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _monedaMeta = const VerificationMeta('moneda');
  @override
  late final GeneratedColumn<String> moneda = GeneratedColumn<String>(
    'moneda',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant("EUR"),
  );
  static const VerificationMeta _idiomaMeta = const VerificationMeta('idioma');
  @override
  late final GeneratedColumn<String> idioma = GeneratedColumn<String>(
    'idioma',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant("es"),
  );
  static const VerificationMeta _temaMeta = const VerificationMeta('tema');
  @override
  late final GeneratedColumn<String> tema = GeneratedColumn<String>(
    'tema',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant("system"),
  );
  @override
  List<GeneratedColumn> get $columns => [id, moneda, idioma, tema];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('moneda')) {
      context.handle(
        _monedaMeta,
        moneda.isAcceptableOrUnknown(data['moneda']!, _monedaMeta),
      );
    }
    if (data.containsKey('idioma')) {
      context.handle(
        _idiomaMeta,
        idioma.isAcceptableOrUnknown(data['idioma']!, _idiomaMeta),
      );
    }
    if (data.containsKey('tema')) {
      context.handle(
        _temaMeta,
        tema.isAcceptableOrUnknown(data['tema']!, _temaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      moneda: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}moneda'],
      )!,
      idioma: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idioma'],
      )!,
      tema: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tema'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final int id;
  final String moneda;
  final String idioma;
  final String tema;
  const Setting({
    required this.id,
    required this.moneda,
    required this.idioma,
    required this.tema,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['moneda'] = Variable<String>(moneda);
    map['idioma'] = Variable<String>(idioma);
    map['tema'] = Variable<String>(tema);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      moneda: Value(moneda),
      idioma: Value(idioma),
      tema: Value(tema),
    );
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      id: serializer.fromJson<int>(json['id']),
      moneda: serializer.fromJson<String>(json['moneda']),
      idioma: serializer.fromJson<String>(json['idioma']),
      tema: serializer.fromJson<String>(json['tema']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'moneda': serializer.toJson<String>(moneda),
      'idioma': serializer.toJson<String>(idioma),
      'tema': serializer.toJson<String>(tema),
    };
  }

  Setting copyWith({int? id, String? moneda, String? idioma, String? tema}) =>
      Setting(
        id: id ?? this.id,
        moneda: moneda ?? this.moneda,
        idioma: idioma ?? this.idioma,
        tema: tema ?? this.tema,
      );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      id: data.id.present ? data.id.value : this.id,
      moneda: data.moneda.present ? data.moneda.value : this.moneda,
      idioma: data.idioma.present ? data.idioma.value : this.idioma,
      tema: data.tema.present ? data.tema.value : this.tema,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('id: $id, ')
          ..write('moneda: $moneda, ')
          ..write('idioma: $idioma, ')
          ..write('tema: $tema')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, moneda, idioma, tema);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.id == this.id &&
          other.moneda == this.moneda &&
          other.idioma == this.idioma &&
          other.tema == this.tema);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<int> id;
  final Value<String> moneda;
  final Value<String> idioma;
  final Value<String> tema;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.moneda = const Value.absent(),
    this.idioma = const Value.absent(),
    this.tema = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    this.moneda = const Value.absent(),
    this.idioma = const Value.absent(),
    this.tema = const Value.absent(),
  });
  static Insertable<Setting> custom({
    Expression<int>? id,
    Expression<String>? moneda,
    Expression<String>? idioma,
    Expression<String>? tema,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (moneda != null) 'moneda': moneda,
      if (idioma != null) 'idioma': idioma,
      if (tema != null) 'tema': tema,
    });
  }

  SettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? moneda,
    Value<String>? idioma,
    Value<String>? tema,
  }) {
    return SettingsCompanion(
      id: id ?? this.id,
      moneda: moneda ?? this.moneda,
      idioma: idioma ?? this.idioma,
      tema: tema ?? this.tema,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (moneda.present) {
      map['moneda'] = Variable<String>(moneda.value);
    }
    if (idioma.present) {
      map['idioma'] = Variable<String>(idioma.value);
    }
    if (tema.present) {
      map['tema'] = Variable<String>(tema.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('moneda: $moneda, ')
          ..write('idioma: $idioma, ')
          ..write('tema: $tema')
          ..write(')'))
        .toString();
  }
}

abstract class _$MonwasteDatabase extends GeneratedDatabase {
  _$MonwasteDatabase(QueryExecutor e) : super(e);
  $MonwasteDatabaseManager get managers => $MonwasteDatabaseManager(this);
  late final $GastosTable gastos = $GastosTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [gastos, settings];
}

typedef $$GastosTableCreateCompanionBuilder =
    GastosCompanion Function({
      Value<int> id,
      required String nombre,
      required double importe,
      required String periodicidad,
      Value<DateTime?> fechaCobro,
      required String color,
      Value<bool> activo,
    });
typedef $$GastosTableUpdateCompanionBuilder =
    GastosCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<double> importe,
      Value<String> periodicidad,
      Value<DateTime?> fechaCobro,
      Value<String> color,
      Value<bool> activo,
    });

class $$GastosTableFilterComposer
    extends Composer<_$MonwasteDatabase, $GastosTable> {
  $$GastosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get importe => $composableBuilder(
    column: $table.importe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get periodicidad => $composableBuilder(
    column: $table.periodicidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaCobro => $composableBuilder(
    column: $table.fechaCobro,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GastosTableOrderingComposer
    extends Composer<_$MonwasteDatabase, $GastosTable> {
  $$GastosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get importe => $composableBuilder(
    column: $table.importe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get periodicidad => $composableBuilder(
    column: $table.periodicidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCobro => $composableBuilder(
    column: $table.fechaCobro,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GastosTableAnnotationComposer
    extends Composer<_$MonwasteDatabase, $GastosTable> {
  $$GastosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<double> get importe =>
      $composableBuilder(column: $table.importe, builder: (column) => column);

  GeneratedColumn<String> get periodicidad => $composableBuilder(
    column: $table.periodicidad,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaCobro => $composableBuilder(
    column: $table.fechaCobro,
    builder: (column) => column,
  );

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);
}

class $$GastosTableTableManager
    extends
        RootTableManager<
          _$MonwasteDatabase,
          $GastosTable,
          Gasto,
          $$GastosTableFilterComposer,
          $$GastosTableOrderingComposer,
          $$GastosTableAnnotationComposer,
          $$GastosTableCreateCompanionBuilder,
          $$GastosTableUpdateCompanionBuilder,
          (Gasto, BaseReferences<_$MonwasteDatabase, $GastosTable, Gasto>),
          Gasto,
          PrefetchHooks Function()
        > {
  $$GastosTableTableManager(_$MonwasteDatabase db, $GastosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GastosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GastosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GastosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<double> importe = const Value.absent(),
                Value<String> periodicidad = const Value.absent(),
                Value<DateTime?> fechaCobro = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<bool> activo = const Value.absent(),
              }) => GastosCompanion(
                id: id,
                nombre: nombre,
                importe: importe,
                periodicidad: periodicidad,
                fechaCobro: fechaCobro,
                color: color,
                activo: activo,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required double importe,
                required String periodicidad,
                Value<DateTime?> fechaCobro = const Value.absent(),
                required String color,
                Value<bool> activo = const Value.absent(),
              }) => GastosCompanion.insert(
                id: id,
                nombre: nombre,
                importe: importe,
                periodicidad: periodicidad,
                fechaCobro: fechaCobro,
                color: color,
                activo: activo,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GastosTableProcessedTableManager =
    ProcessedTableManager<
      _$MonwasteDatabase,
      $GastosTable,
      Gasto,
      $$GastosTableFilterComposer,
      $$GastosTableOrderingComposer,
      $$GastosTableAnnotationComposer,
      $$GastosTableCreateCompanionBuilder,
      $$GastosTableUpdateCompanionBuilder,
      (Gasto, BaseReferences<_$MonwasteDatabase, $GastosTable, Gasto>),
      Gasto,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      Value<int> id,
      Value<String> moneda,
      Value<String> idioma,
      Value<String> tema,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<int> id,
      Value<String> moneda,
      Value<String> idioma,
      Value<String> tema,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$MonwasteDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moneda => $composableBuilder(
    column: $table.moneda,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idioma => $composableBuilder(
    column: $table.idioma,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tema => $composableBuilder(
    column: $table.tema,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$MonwasteDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moneda => $composableBuilder(
    column: $table.moneda,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idioma => $composableBuilder(
    column: $table.idioma,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tema => $composableBuilder(
    column: $table.tema,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$MonwasteDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get moneda =>
      $composableBuilder(column: $table.moneda, builder: (column) => column);

  GeneratedColumn<String> get idioma =>
      $composableBuilder(column: $table.idioma, builder: (column) => column);

  GeneratedColumn<String> get tema =>
      $composableBuilder(column: $table.tema, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$MonwasteDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (
            Setting,
            BaseReferences<_$MonwasteDatabase, $SettingsTable, Setting>,
          ),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$MonwasteDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> moneda = const Value.absent(),
                Value<String> idioma = const Value.absent(),
                Value<String> tema = const Value.absent(),
              }) => SettingsCompanion(
                id: id,
                moneda: moneda,
                idioma: idioma,
                tema: tema,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> moneda = const Value.absent(),
                Value<String> idioma = const Value.absent(),
                Value<String> tema = const Value.absent(),
              }) => SettingsCompanion.insert(
                id: id,
                moneda: moneda,
                idioma: idioma,
                tema: tema,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$MonwasteDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$MonwasteDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;

class $MonwasteDatabaseManager {
  final _$MonwasteDatabase _db;
  $MonwasteDatabaseManager(this._db);
  $$GastosTableTableManager get gastos =>
      $$GastosTableTableManager(_db, _db.gastos);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
