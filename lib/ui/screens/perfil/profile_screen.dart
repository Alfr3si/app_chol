//lib\ui\screens\perfil\profile_screen.dart
import 'package:flutter/material.dart';

import 'widgets/cuenta_sincronizacion_tab.dart';
import 'widgets/perfil_general_tab.dart';
import 'widgets/progreso_estadisticas_tab.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 0;

  static const Color _bgBlack = Color(0xFF121212);
  static const Color _cardBlack = Color(0xFF1E1E1E);
  static const Color _orangePrimary = Color(0xFFFF7A00);
  static const Color _pureWhite = Color(0xFFFFFFFF);
  static const Color _grayText = Color(0xFFB3B3B3);

  @override
  Widget build(BuildContext context) {
    final List<Widget> profileViews = [
      const PerfilGeneralTab(
        cardColor: _cardBlack,
        accentColor: _orangePrimary,
        textPrimary: _pureWhite,
        textSecondary: _grayText,
      ),
      const ProgresoEstadisticasTab(
        backgroundColor: _bgBlack,
        cardColor: _cardBlack,
        accentColor: _orangePrimary,
        textPrimary: _pureWhite,
        textSecondary: _grayText,
      ),
      const CuentaSincronizacionTab(
        cardColor: _cardBlack,
        accentColor: _orangePrimary,
        textPrimary: _pureWhite,
        textSecondary: _grayText,
      ),
    ];

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/background/fondo2.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Row(
              children: [
                Container(
                  width: 110,
                  color: _bgBlack.withValues(alpha: 0.85),
                  child: NavigationRail(
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (int index) {
                      setState(() => _selectedIndex = index);
                    },
                    labelType: NavigationRailLabelType.all,
                    backgroundColor: Colors.transparent,
                    selectedIconTheme: const IconThemeData(
                      color: _orangePrimary,
                      size: 28,
                    ),
                    unselectedIconTheme: const IconThemeData(
                      color: _grayText,
                      size: 22,
                    ),
                    selectedLabelTextStyle: const TextStyle(
                      color: _orangePrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    unselectedLabelTextStyle: const TextStyle(
                      color: _grayText,
                      fontSize: 11,
                    ),
                    indicatorColor: _orangePrimary.withValues(alpha: 0.2),
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.person_outline),
                        selectedIcon: Icon(Icons.person),
                        label: Text('Perfil'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.bar_chart_outlined),
                        selectedIcon: Icon(Icons.bar_chart),
                        label: Text('Progreso'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.cloud_sync_outlined),
                        selectedIcon: Icon(Icons.cloud_sync),
                        label: Text('Cuenta'),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(
                  thickness: 2,
                  width: 2,
                  color: Color(0xFF2C2C2C),
                ),
                Expanded(
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      title: Text(
                        _selectedIndex == 0
                            ? "Mi Perfil"
                            : _selectedIndex == 1
                                ? "Estadísticas y Progreso"
                                : "Administración de Cuenta",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: _pureWhite,
                          letterSpacing: 0.5,
                          shadows: [Shadow(color: Colors.black, blurRadius: 3)],
                        ),
                      ),
                      backgroundColor: _bgBlack.withValues(alpha: 0.8),
                      elevation: 4,
                      iconTheme: const IconThemeData(color: _orangePrimary),
                    ),
                    body: IndexedStack(
                      index: _selectedIndex,
                      children: profileViews,
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
