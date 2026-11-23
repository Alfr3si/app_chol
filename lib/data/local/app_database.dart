// lib/data/local/app_database.dart
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

part 'app_database.g.dart';

class PerfilUsuario extends Table {
  TextColumn get localUuid => text()();
  TextColumn get remoteUserId => text().nullable()();
  TextColumn get nombre => text().withDefault(const Constant('Invitado'))();
  BoolColumn get estaVinculado =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get creadoEn => dateTime()();
  DateTimeColumn get ultimaSincronizacion => dateTime().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {localUuid};
}

class ProgresoActividades extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get usuarioLocalUuid =>
      text().references(PerfilUsuario, #localUuid)();
  IntColumn get moduloId => integer()();
  IntColumn get actividadNumero => integer()();
  TextColumn get actividadClave => text()();
  BoolColumn get completada => boolean().withDefault(const Constant(true))();
  IntColumn get intentos => integer().withDefault(const Constant(1))();
  DateTimeColumn get fechaCompletado => dateTime()();
  DateTimeColumn get actualizadoEn => dateTime()();
  BoolColumn get sincronizado => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {usuarioLocalUuid, moduloId, actividadNumero},
      ];
}

@DriftDatabase(tables: [PerfilUsuario, ProgresoActividades])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  Future<PerfilUsuarioData>? _perfilEnCurso;

  @override
  int get schemaVersion => 1;

  /// Obtiene el perfil local activo o crea uno en modo invitado de forma segura ante llamadas concurrentes.
  Future<PerfilUsuarioData> obtenerOCrearPerfilInvitado() {
    final enCurso = _perfilEnCurso;
    if (enCurso != null) return enCurso;

    final future = _obtenerOCrearPerfilInvitadoInterno().whenComplete(() {
      _perfilEnCurso = null;
    });
    _perfilEnCurso = future;
    return future;
  }

  Future<PerfilUsuarioData> _obtenerOCrearPerfilInvitadoInterno() async {
    final existentes = await (select(perfilUsuario)..limit(1)).get();
    if (existentes.isNotEmpty) {
      return existentes.first;
    }

    final nuevoUuid = const Uuid().v4();
    final ahora = DateTime.now().toUtc();
    final companion = PerfilUsuarioCompanion.insert(
      localUuid: nuevoUuid,
      nombre: const Value('Invitado'),
      estaVinculado: const Value(false),
      creadoEn: ahora,
    );

    await into(perfilUsuario).insert(companion, mode: InsertMode.insertOrIgnore);

    final lista = await (select(perfilUsuario)..limit(1)).get();
    return lista.first;
  }

  /// Registra o actualiza una actividad completada (1 punto por actividad completada).
  Future<void> registrarActividadCompletada({
    required String usuarioLocalUuid,
    required int moduloId,
    required int actividadNumero,
  }) async {
    final ahora = DateTime.now().toUtc();
    final clave = 'mod${moduloId}_act$actividadNumero';

    final existente = await (select(progresoActividades)
          ..where(
            (tbl) =>
                tbl.usuarioLocalUuid.equals(usuarioLocalUuid) &
                tbl.moduloId.equals(moduloId) &
                tbl.actividadNumero.equals(actividadNumero),
          ))
        .getSingleOrNull();

    if (existente == null) {
      await into(progresoActividades).insert(
        ProgresoActividadesCompanion.insert(
          usuarioLocalUuid: usuarioLocalUuid,
          moduloId: moduloId,
          actividadNumero: actividadNumero,
          actividadClave: clave,
          completada: const Value(true),
          intentos: const Value(1),
          fechaCompletado: ahora,
          actualizadoEn: ahora,
          sincronizado: const Value(false),
        ),
      );
    } else {
      await (update(progresoActividades)
            ..where((tbl) => tbl.id.equals(existente.id)))
          .write(
        ProgresoActividadesCompanion(
          completada: const Value(true),
          intentos: Value(existente.intentos + 1),
          actualizadoEn: Value(ahora),
          sincronizado: const Value(false),
        ),
      );
    }
  }

  /// Conteo de actividades completadas (0 a 5) para un módulo específico.
  Future<int> contarCompletadasPorModulo({
    required String usuarioLocalUuid,
    required int moduloId,
  }) async {
    final countExp = progresoActividades.id.count();
    final query = selectOnly(progresoActividades)
      ..addColumns([countExp])
      ..where(
        progresoActividades.usuarioLocalUuid.equals(usuarioLocalUuid) &
            progresoActividades.moduloId.equals(moduloId) &
            progresoActividades.completada.equals(true),
      );

    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  /// Stream reactivo del conteo de actividades completadas por módulo (0 a 5).
  Stream<int> watchCompletadasPorModulo({
    required String usuarioLocalUuid,
    required int moduloId,
  }) {
    final countExp = progresoActividades.id.count();
    final query = selectOnly(progresoActividades)
      ..addColumns([countExp])
      ..where(
        progresoActividades.usuarioLocalUuid.equals(usuarioLocalUuid) &
            progresoActividades.moduloId.equals(moduloId) &
            progresoActividades.completada.equals(true),
      );

    return query.watchSingle().map((row) => row.read(countExp) ?? 0);
  }

  /// Stream reactivo con los números de actividad completados (1..5) de un módulo.
  Stream<Set<int>> watchActividadesCompletadasNumeros({
    required String usuarioLocalUuid,
    required int moduloId,
  }) {
    final query = select(progresoActividades)
      ..where(
        (tbl) =>
            tbl.usuarioLocalUuid.equals(usuarioLocalUuid) &
            tbl.moduloId.equals(moduloId) &
            tbl.completada.equals(true),
      );

    return query.watch().map(
          (filas) => filas.map((f) => f.actividadNumero).toSet(),
        );
  }

  /// Registros locales pendientes de subir a la nube.
  Future<List<ProgresoActividade>> obtenerPendientesSincronizacion(
    String usuarioLocalUuid,
  ) {
    return (select(progresoActividades)
          ..where(
            (tbl) =>
                tbl.usuarioLocalUuid.equals(usuarioLocalUuid) &
                tbl.sincronizado.equals(false),
          ))
        .get();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    Directory dbFolder;
    try {
      dbFolder = await getApplicationDocumentsDirectory();
    } catch (_) {
      dbFolder = Directory.systemTemp;
    }
    final file = File('${dbFolder.path}/app_chol_progreso.sqlite');
    return NativeDatabase.createInBackground(file);
  });
}
