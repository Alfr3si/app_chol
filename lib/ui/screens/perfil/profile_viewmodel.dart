import 'package:flutter/foundation.dart';
import '../../../domain/entities/user_profile_entity.dart'; // Ajusta tu ruta de importación

class ProfileViewModel extends ChangeNotifier {
  // Estado inicial simulado (mientras conectamos la base de datos)
  UserProfileEntity _profile = const UserProfileEntity(
    alias: 'Luis',
    ageRange: '8-10 años',
    avatarPath: 'assets/image/learning/grupo.webp',
    rankTitle: 'Aprendiz',
    completedThemes: 0,
    unlockedInsignias: ['Familia'],
  );

  UserProfileEntity get profile => _profile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Método para actualizar datos locales temporalmente
  void updateProfile({String? alias, String? ageRange}) {
    _profile = _profile.copyWith(
      alias: alias,
      ageRange: ageRange,
    );
    notifyListeners();
  }

  // Simulación de guardado (aquí después meteremos la llamada a la DB)
  Future<void> saveChanges() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600)); // Simula red/DB

    _isLoading = false;
    notifyListeners();
    debugPrint('Perfil guardado exitosamente en el ViewModel.');
  }

  // Método para reiniciar progreso
  void resetProgress() {
    _profile = _profile.copyWith(completedThemes: 0, unlockedInsignias: ['Familia']);
    notifyListeners();
  }
}
