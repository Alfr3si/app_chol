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
        opaque: false,
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
  final int _selectedIndex = 0; 
  final ScrollController _scrollController = ScrollController();

  late double _volume;
  late double _brightness;

  // Paleta de colores consistente con ExploraScreen y ProfileScreen
  static const Color _bgBlack = Color(0xFF121212);
  static const Color _cardBlack = Color(0xFF1E1E1E);
  static const Color _orangePrimary = Color(0xFFFF7A00);
  static const Color _pureWhite = Color(0xFFFFFFFF);
  static const Color _grayText = Color(0xFFB3B3B3);

  @override
  void initState() {
    super.initState();
    _volume = widget.initialVolume;
    _brightness = widget.initialBrightness;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo estático idéntico al de las demás pantallas principales
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/background/fondo2.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Capa superior con la barra de navegación lateral y el contenido estructurado
          SafeArea(
            child: Row(
              children: [
                // Panel Izquierdo: NavigationRail solo con Ajustes
                Container(
                  width: 110,
                  color: _bgBlack.withOpacity(0.85),
                  child: NavigationRail(
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (int index) {},
                    labelType: NavigationRailLabelType.all,
                    backgroundColor: Colors.transparent,
                    selectedIconTheme: const IconThemeData(color: _orangePrimary, size: 26),
                    unselectedIconTheme: const IconThemeData(color: _grayText, size: 20),
                    selectedLabelTextStyle: const TextStyle(
                      color: _orangePrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                    unselectedLabelTextStyle: const TextStyle(
                      color: _grayText,
                      fontSize: 10,
                    ),
                    indicatorColor: _orangePrimary.withOpacity(0.2),
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.settings_outlined),
                        selectedIcon: Icon(Icons.settings),
                        label: Text('Ajustes'),
                      ),
                    ],
                  ),
                ),

                const VerticalDivider(thickness: 2, width: 2, color: Color(0xFF2C2C2C)),

                // Panel Derecho optimizado y más compacto
                Expanded(
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      title: const Text(
                        "Configuración",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: _pureWhite,
                          letterSpacing: 0.5,
                          shadows: [Shadow(color: Colors.black, blurRadius: 3)],
                        ),
                      ),
                      backgroundColor: _bgBlack.withOpacity(0.8),
                      elevation: 4,
                      toolbarHeight: 48,
                      iconTheme: const IconThemeData(color: _orangePrimary),
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    body: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      radius: const Radius.circular(8),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14), // Reducido para mayor compacidad
                              decoration: BoxDecoration(
                                color: _cardBlack.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: _orangePrimary.withOpacity(0.5), width: 1),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.tune, color: _orangePrimary, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'Preferencias del Sistema',
                                        style: TextStyle(
                                          color: _pureWhite,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // 🔊 CONTROL DE VOLUMEN
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
                                      widget.onVolumeChanged(newValue);
                                    },
                                  ),
                                  const SizedBox(height: 12),

                                  // ☀️ CONTROL DE BRILLO
                                  _buildSliderSection(
                                    title: 'Brillo',
                                    icon: Icons.brightness_6,
                                    value: _brightness,
                                    min: 0.2,
                                    max: 1.0,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _brightness = newValue;
                                      });
                                      widget.onBrightnessChanged(newValue);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // 🔙 BOTÓN DE GUARDAR Y VOLVER MÁS COMPACTO
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _orangePrimary,
                                  foregroundColor: _pureWhite,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 3,
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'Guardar y Volver',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar compacto para los sliders
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
            Icon(icon, color: _orangePrimary, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: _pureWhite,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              '${(value * 100).toInt()}%',
              style: const TextStyle(
                color: _orangePrimary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        SizedBox(
          height: 28, // Altura reducida para ahorrar espacio vertical
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: _orangePrimary,
              inactiveTrackColor: _bgBlack,
              thumbColor: _orangePrimary,
              overlayColor: _orangePrimary.withOpacity(0.2),
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
