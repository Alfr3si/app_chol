import 'package:flutter/material.dart';
import 'cuentos_view.dart';
import 'cultura_view.dart';
import 'comunidades_view.dart';
import 'gastronomia_view.dart';

class ExploraScreen extends StatefulWidget {
  const ExploraScreen({super.key});

  @override
  State<ExploraScreen> createState() => _ExploraScreenState();
}

class _ExploraScreenState extends State<ExploraScreen> {
  int _selectedIndex = 0;
  bool _isCholLanguage = true;

  static const Color _bgBlack = Color(0xFF121212);
  static const Color _cardBlack = Color(0xFF1E1E1E);
  static const Color _orangePrimary = Color(0xFFFF7A00);
  static const Color _pureWhite = Color(0xFFFFFFFF);
  static const Color _grayText = Color(0xFFB3B3B3);

  @override
  Widget build(BuildContext context) {
    // Lista de las vistas modulares según el índice seleccionado
    final List<Widget> views = [
      CuentosView(isCholLanguage: _isCholLanguage),
      CulturaView(isCholLanguage: _isCholLanguage),
      ComunidadesView(isCholLanguage: _isCholLanguage),
      GastronomiaView(isCholLanguage: _isCholLanguage),
    ];

    // Ocultamos el botón de traducción si estamos en Cuentos (0) o Gastronomía (3).
    final bool showTranslateButton = _selectedIndex != 0 && _selectedIndex != 3;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo estático
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/background/fondo2.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Capa superior con la barra de navegación lateral y el contenido activo
          SafeArea(
            child: Row(
              children: [
                // Panel Izquierdo: NavigationRail
                Container(
                  width: 110,
                  color: _bgBlack.withOpacity(0.85),
                  child: NavigationRail(
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (int index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    labelType: NavigationRailLabelType.all,
                    backgroundColor: Colors.transparent,
                    selectedIconTheme: const IconThemeData(color: _orangePrimary, size: 28),
                    unselectedIconTheme: const IconThemeData(color: _grayText, size: 22),
                    selectedLabelTextStyle: const TextStyle(
                      color: _orangePrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    unselectedLabelTextStyle: const TextStyle(
                      color: _grayText,
                      fontSize: 11,
                    ),
                    indicatorColor: _orangePrimary.withOpacity(0.2),
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.auto_stories_outlined),
                        selectedIcon: Icon(Icons.auto_stories),
                        label: Text('Cuentos'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.groups_outlined),
                        selectedIcon: Icon(Icons.groups),
                        label: Text('Cultura'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.map_outlined),
                        selectedIcon: Icon(Icons.map),
                        label: Text('Comunidades'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.restaurant_outlined),
                        selectedIcon: Icon(Icons.restaurant),
                        label: Text('Gastronomía'),
                      ),
                    ],
                  ),
                ),

                const VerticalDivider(thickness: 2, width: 2, color: Color(0xFF2C2C2C)),

                // Panel Derecho: Renderiza la vista del componente seleccionado
                Expanded(
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      title: const Text(
                        "Explora",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: _pureWhite,
                          letterSpacing: 0.5,
                          shadows: [Shadow(color: Colors.black, blurRadius: 3)],
                        ),
                      ),
                      backgroundColor: _bgBlack.withOpacity(0.8),
                      elevation: 4,
                      iconTheme: const IconThemeData(color: _orangePrimary),
                      actions: [
                        // Muestra el botón de traducción únicamente si NO estamos en Cuentos ni en Gastronomía
                        if (showTranslateButton)
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color: _cardBlack,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: _orangePrimary, width: 1.2),
                            ),
                            child: TextButton.icon(
                              style: TextButton.styleFrom(
                                foregroundColor: _pureWhite,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isCholLanguage = !_isCholLanguage;
                                });
                              },
                              icon: const Icon(Icons.translate, size: 16, color: _orangePrimary),
                              label: Text(
                                _isCholLanguage ? "Ch'ol" : "Español",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: _pureWhite),
                              ),
                            ),
                          ),
                      ],
                    ),
                    body: IndexedStack(
                      index: _selectedIndex,
                      children: views,
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
}
