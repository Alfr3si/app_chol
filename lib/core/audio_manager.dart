import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';

class AudioManager with WidgetsBindingObserver {
  static final AudioManager instance = AudioManager._internal();
  AudioManager._internal();

  bool _isInitialized = false;
  String? _currentTrack;
  
  // 🔊 NUEVO: Control de volumen global (rango de 0.0 a 1.0)
  double _globalVolume = 0.5;
  double get globalVolume => _globalVolume;

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

  ///  Método para cambiar el volumen en tiempo real
  void setVolume(double newVolume) {
    _globalVolume = newVolume.clamp(0.0, 1.0);
    
    // Si hay una pista sonando, actualizamos el volumen de FlameAudio inmediatamente
    if (_currentTrack != null) {
      FlameAudio.bgm.audioPlayer.setVolume(_globalVolume);
    }
    debugPrint('Volumen global actualizado a: ${(_globalVolume * 100).toInt()}%');
  }

  /// Reproduce cualquier pista de audio usando el volumen global
  Future<void> playTrack(String fileName, {double? volume}) async {
    try {
      // Usamos el volumen global si no se especifica uno local
      final targetVolume = volume ?? _globalVolume;

      if (_currentTrack == fileName) return;

      if (_currentTrack != null) {
        FlameAudio.bgm.stop();
      }

      await FlameAudio.bgm.play(fileName, volume: targetVolume);
      _currentTrack = fileName;
      debugPrint('Reproduciendo pista: $fileName con volumen: $targetVolume');
    } catch (e) {
      debugPrint('Error al reproducir la pista $fileName: $e');
    }
  }

  // Pausar
  void pauseMusic() {
    FlameAudio.bgm.pause();
  }

  // Reanudar
  void resumeMusic() {
    FlameAudio.bgm.resume();
  }

  // Detener
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
