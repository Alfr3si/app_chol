import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final double initialVolume;
  final double initialBrightness;
  final ValueChanged<double> onVolumeChanged;
  final ValueChanged<double> onBrightnessChanged;

  const SettingsScreen({
    super.key,
    required this.initialVolume,
    required this.initialBrightness,
    required this.onVolumeChanged,
    required this.onBrightnessChanged,
  });

  /// 🚀 Método estático para abrir la pantalla de configuración limpiamente
  static void show({
    required BuildContext context,
    required double initialVolume,
    required double initialBrightness,
    required ValueChanged<double> onVolumeChanged,
    required ValueChanged<double> onBrightnessChanged,
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false, // Fondo semitransparente para ver el mapa detrás
        pageBuilder: (BuildContext context, _, __) {
          return SettingsScreen(
            initialVolume: initialVolume,
            initialBrightness: initialBrightness,
            onVolumeChanged: onVolumeChanged,
            onBrightnessChanged: onBrightnessChanged,
          );
        },
      ),
    );
  }

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late double _volume;
  late double _brightness;

  @override
  void initState() {
    super.initState();
    _volume = widget.initialVolume;
    _brightness = widget.initialBrightness;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      body: Center(
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.brown.shade900.withOpacity(0.95),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.orange, width: 3),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ⚙️ TÍTULO
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.settings, color: Colors.orangeAccent, size: 32),
                  SizedBox(width: 10),
                  Text(
                    'Configuración',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 🔊 CONTROL DE VOLUMEN (Conectado a AudioManager)
              _buildSliderSection(
                title: 'Volumen',
                icon: _volume == 0 ? Icons.volume_off : Icons.volume_up,
                value: _volume,
                min: 0.0,
                max: 1.0,
                onChanged: (newValue) {
                  setState(() {
                    _volume = newValue;
                  });
                  // Actualiza el manager de audio en tiempo real
                  widget.onVolumeChanged(newValue);
                },
              ),
              const SizedBox(height: 20),

              // ☀️ CONTROL DE BRILLO (Conectado a BrightnessManager)
              _buildSliderSection(
                title: 'Brillo',
                icon: Icons.brightness_6,
                value: _brightness,
                min: 0.2, // Evita brillo en 0 para no dejar la pantalla totalmente negra
                max: 1.0,
                onChanged: (newValue) {
                  setState(() {
                    _brightness = newValue;
                  });
                  // Actualiza el manager de brillo en tiempo real
                  widget.onBrightnessChanged(newValue);
                },
              ),
              const SizedBox(height: 30),

              // 🔙 BOTÓN DE CERRAR / VOLVER
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Guardar y Volver',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para mantener un diseño limpio y reutilizable en los sliders
  Widget _buildSliderSection({
    required String title,
    required IconData icon,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white70, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const Spacer(),
            Text(
              '${(value * 100).toInt()}%',
              style: const TextStyle(
                color: Colors.orangeAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: Colors.orange,
            inactiveTrackColor: Colors.brown.shade700,
            thumbColor: Colors.orangeAccent,
            overlayColor: Colors.orange.withOpacity(0.2),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
