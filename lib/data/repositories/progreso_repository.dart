import 'package:drift/drift.dart';
import '../local/app_database.dart';

class ResumenModulo {
  final int moduloId;
  final int completadas;
  final int total;

  const ResumenModulo({
    required this.moduloId,
    required this.completadas,
    this.total = 5,
  });

  double get porcentaje => total == 0 ? 0.0 : completadas / total;
}

class ProgresoRepository {
  final AppDatabase _db;

  ProgresoRepository(this._db);

  Future<PerfilUsuarioData> obtenerPerfilActivo() {
    return _db.obtenerOCrearPerfilInvitado();
  }

  Future<void> completarActividad({
    required int moduloId,
    required int actividadNumero,
  }) async {
    final perfil = await _db.obtenerOCrearPerfilInvitado();
    await _db.registrarActividadCompletada(
      usuarioLocalUuid: perfil.localUuid,
      moduloId: moduloId,
      actividadNumero: actividadNumero,
    );
  }

  Stream<ResumenModulo> watchResumenModulo(int moduloId) async* {
    final perfil = await _db.obtenerOCrearPerfilInvitado();
    yield* _db
        .watchCompletadasPorModulo(
          usuarioLocalUuid: perfil.localUuid,
          moduloId: moduloId,
        )
        .map(
          (completadas) => ResumenModulo(
            moduloId: moduloId,
            completadas: completadas,
            total: 5,
          ),
        );
  }

  Stream<int> watchPuntajeTotal() async* {
    final perfil = await _db.obtenerOCrearPerfilInvitado();
    final countExp = _db.progresoActividades.id.count();
    final query = _db.selectOnly(_db.progresoActividades)
      ..addColumns([countExp])
      ..where(
        _db.progresoActividades.usuarioLocalUuid.equals(perfil.localUuid) &
            _db.progresoActividades.completada.equals(true),
      );

    yield* query.watchSingle().map(
          (row) => row.read(countExp) ?? 0,
        );
  }

  Future<List<ProgresoActividade>> obtenerPendientesSync() async {
    final perfil = await _db.obtenerOCrearPerfilInvitado();
    return _db.obtenerPendientesSincronizacion(perfil.localUuid);
  }

  Future<void> vincularCuentaRemota({required String remoteUserId}) async {
    final perfil = await _db.obtenerOCrearPerfilInvitado();
    await (_db.update(_db.perfilUsuario)
          ..where((tbl) => tbl.localUuid.equals(perfil.localUuid)))
        .write(
      PerfilUsuarioCompanion(
        remoteUserId: Value(remoteUserId),
        estaVinculado: const Value(true),
      ),
    );
  }

  Future<void> marcarComoSincronizados(List<int> ids) async {
    if (ids.isEmpty) return;
    final ahora = DateTime.now().toUtc();

    await (_db.update(_db.progresoActividades)
          ..where((tbl) => tbl.id.isIn(ids)))
        .write(
      const ProgresoActividadesCompanion(
        sincronizado: Value(true),
      ),
    );

    final perfil = await _db.obtenerOCrearPerfilInvitado();
    await (_db.update(_db.perfilUsuario)
          ..where((tbl) => tbl.localUuid.equals(perfil.localUuid)))
        .write(
      PerfilUsuarioCompanion(
        ultimaSincronizacion: Value(ahora),
      ),
    );
  }
}
