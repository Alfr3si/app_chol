import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../local/app_database.dart';
import '../repositories/progreso_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final progresoRepositoryProvider = Provider<ProgresoRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ProgresoRepository(db);
});

final resumenModuloProvider =
    StreamProvider.family<ResumenModulo, int>((ref, moduloId) {
  final repo = ref.watch(progresoRepositoryProvider);
  return repo.watchResumenModulo(moduloId);
});

final puntajeTotalProvider = StreamProvider<int>((ref) {
  final repo = ref.watch(progresoRepositoryProvider);
  return repo.watchPuntajeTotal();
});
