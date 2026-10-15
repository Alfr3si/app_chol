import 'package:flutter/material.dart';

// Importa tu pantalla de Módulos real
import '../../../ui/screens/modulos/screens/game_modules_screen.dart';

class MenuButtonsWidget extends StatelessWidget {
  const MenuButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 1. Botón Módulos (Conectado a tu pantalla modular de tarjetas gigantes)
          _buildMenuButton(
            context,
            icon: Icons.grid_view_rounded,
            label: 'Módulos',
            color: Colors.orangeAccent,
            onTap: () => _navigateTo(context, const GameModulesScreen()),
          ),

          // 2. Botón Explora (Temporal para evitar errores)
          _buildMenuButton(
            context,
            icon: Icons.explore_rounded,
            label: 'Explora',
            color: Colors.greenAccent,
            onTap: () => _showTemporaryScreen(context, 'Explora'),
          ),

          // 3. Botón Chat IA (Temporal para evitar errores)
          _buildMenuButton(
            context,
            icon: Icons.smart_toy_rounded,
            label: 'Chat IA',
            color: Colors.purpleAccent,
            onTap: () => _showTemporaryScreen(context, 'Chat IA'),
          ),

          // 4. Botón Ajustes (Temporal para evitar errores)
          _buildMenuButton(
            context,
            icon: Icons.settings_rounded,
            label: 'Ajustes',
            color: Colors.blueAccent,
            onTap: () => _showTemporaryScreen(context, 'Ajustes'),
          ),

          // 5. Botón Perfil (Temporal para evitar errores)
          _buildMenuButton(
            context,
            icon: Icons.person_rounded,
            label: 'Perfil',
            color: Colors.pinkAccent,
            onTap: () => _showTemporaryScreen(context, 'Perfil'),
          ),
        ],
      ),
    );
  }

  /// Método auxiliar privado para manejar la transición suave de pantalla
  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  /// Muestra una pantalla temporal de "En construcción" para las secciones faltantes
  void _showTemporaryScreen(BuildContext context, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: const Color(0xFF1A1A2E),
          appBar: AppBar(
            title: Text(title, style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: Text(
              'Próximamente: Sección de $title',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  // Método auxiliar para construir cada botón
  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 4,
                  color: Colors.black,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
