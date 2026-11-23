// lib/ui/screens/perfil/profile_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/progreso_providers.dart';
import '../../../domain/entities/user_profile_entity.dart';

class ProfileState {
  final UserProfileEntity profile;
  final bool isLoading;

  const ProfileState({
    required this.profile,
    this.isLoading = false,
  });

  ProfileState copyWith({
    UserProfileEntity? profile,
    bool? isLoading,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    _cargarPerfilDesdeDb();

    return const ProfileState(
      profile: UserProfileEntity(
        alias: 'Invitado',
        ageRange: '8-10 años',
        avatarPath: 'assets/image/learning/grupo.webp',
        rankTitle: 'Aprendiz',
        completedThemes: 0,
        unlockedInsignias: ['Familia'],
      ),
    );
  }

  Future<void> _cargarPerfilDesdeDb() async {
    try {
      final repo = ref.read(progresoRepositoryProvider);
      final perfilDb = await repo.obtenerPerfilActivo();
      final nombreGuardado = perfilDb.nombre.trim();
      final rangoGuardado = perfilDb.rangoEdad.trim();

      state = state.copyWith(
        profile: state.profile.copyWith(
          alias: nombreGuardado.isNotEmpty ? nombreGuardado : 'Invitado',
          ageRange: rangoGuardado.isNotEmpty ? rangoGuardado : '8-10 años',
        ),
      );
    } catch (e) {
      debugPrint('Error cargando perfil desde Drift: $e');
    }
  }

  /// Actualiza datos locales en memoria antes de guardar en Drift
  void updateProfile({
    String? alias,
    String? ageRange,
    String? avatarPath,
  }) {
    state = state.copyWith(
      profile: state.profile.copyWith(
        alias: alias,
        ageRange: ageRange,
        avatarPath: avatarPath,
      ),
    );
  }

  /// Persiste el alias/nombre y el rango de edad en la tabla PerfilUsuario de Drift
  Future<void> saveChanges() async {
    state = state.copyWith(isLoading: true);
    try {
      final repo = ref.read(progresoRepositoryProvider);
      final nombreLimpio = state.profile.alias.trim();
      if (nombreLimpio.isNotEmpty) {
        await repo.actualizarPerfilLocal(
          nombre: nombreLimpio,
          rangoEdad: state.profile.ageRange,
        );
      }
    } catch (e) {
      debugPrint('Error guardando perfil en Drift: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Reinicia el progreso visual del perfil
  void resetProgress() {
    state = state.copyWith(
      profile: state.profile.copyWith(
        completedThemes: 0,
        unlockedInsignias: const ['Familia'],
      ),
    );
  }
}

final profileProvider =
    NotifierProvider<ProfileNotifier, ProfileState>(ProfileNotifier.new);
