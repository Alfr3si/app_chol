import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';

class AudioManager with WidgetsBindingObserver {
  static final AudioManager instance = AudioManager._internal();
  AudioManager._internal();

  bool _isInitialized = false;
  String? _currentTrack; // Para llevar el registro de qué canción está sonando

  void init() {
    if (_isInitialized) return;
    WidgetsBinding.instance.addObserver(this);
    _isInitialized = true;
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    FlameAudio.bgm.stop();
    _isInitialized = false;
  }

  ///Reproduce cualquier pista de audio
  Future<void> playTrack(String fileName, {double volume = 0.5}) async {
    try {
      // Si la misma pista ya está sonando, no la reiniciamos
      if (_currentTrack == fileName) return;

      // Si hay otra pista sonando, la detenemos primero
      if (_currentTrack != null) {
        FlameAudio.bgm.stop();
      }

      await FlameAudio.bgm.play(fileName, volume: volume);
      _currentTrack = fileName;
      debugPrint('Reproduciendo pista: $fileName');
    } catch (e) {
      debugPrint('Error al reproducir la pista $fileName: $e');
    }
  }

  // Pausar (útil al bloquear el teléfono)
  void pauseMusic() {
    FlameAudio.bgm.pause();
  }

  // Reanudar la última pista activa
  void resumeMusic() {
    FlameAudio.bgm.resume();
  }

  // Detener por completo y limpiar el registro de pista actual
  void stopMusic() {
    FlameAudio.bgm.stop();
    _currentTrack = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      pauseMusic();
    } else if (state == AppLifecycleState.resumed) {
      resumeMusic();
    }
  }
}
