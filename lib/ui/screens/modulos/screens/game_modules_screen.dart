import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../../../game_canvas/menu_game.dart'; // <--- Ajusta la ruta de importación hacia tu MenuGame
import '../models/game_module_model.dart';
import '../widgets/giant_module_card.dart';
import 'module_detail_screen.dart';

class GameModulesScreen extends StatelessWidget {
  const GameModulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GameModuleCardData> modules = [
      GameModuleCardData(
        title: 'Saludos',
        chokName: 'Ch\'anob',
        subtitle: 'Aprende a saludar jugando con personajes',
        icon: Icons.waving_hand_rounded,
        gradientColors: [const Color(0xFFFF8008), const Color(0xFFFFC837)],
        onTap: () {
          _navigateToDetail(context, 'Saludos y Cortesía', 'Ch\'anob', const Color(0xFFFF8008));
        },
      ),
      GameModuleCardData(
        title: 'Familia',
        chokName: 'Ch\'ñlel',
        subtitle: 'Descubre los lazos familiares en el pueblo ch\'ol',
        icon: Icons.family_restroom_rounded,
        gradientColors: [const Color(0xFF11998e), const Color(0xFF38ef7d)],
        onTap: () {
          _navigateToDetail(context, 'La Familia', 'Ch\'ñlel', const Color(0xFF11998e));
        },
      ),
      GameModuleCardData(
        title: 'Animales del Entorno',
        chokName: 'Bälum',
        subtitle: 'Explora la selva y atrapa las palabras correctas',
        icon: Icons.pets_rounded,
        gradientColors: [const Color(0xFF8E2DE2), const Color(0xFF4A00E0)],
        onTap: () {
          _navigateToDetail(context, 'Animales del Entorno', 'Bälum', const Color(0xFF8E2DE2));
        },
      ),
      GameModuleCardData(
        title: 'Alimentos y Frutas',
        chokName: 'Jäñlel',
        subtitle: 'Recolecta los frutos tradicionales de la región',
        icon: Icons.fastfood_rounded,
        gradientColors: [const Color(0xFFEB3349), const Color(0xFFF45C43)],
        onTap: () {
          _navigateToDetail(context, 'Alimentos y Frutas', 'Jäñlel', const Color(0xFFEB3349));
        },
      ),
    ];

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. EL MOTOR DE FLAME COMO FONDO ANIMADO
          GameWidget(game: MenuGame()),

          // 2. CAPA OSCURA SEMITRANSPARENTE
          // Da contraste para que los textos blancos y las tarjetas destaquen sobre el movimiento
          Container(
            color: Colors.black.withOpacity(0.4),
          ),

          // 3. LA INTERFAZ DE USUARIO (Con Scaffold transparente)
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text(
                'Módulos de Aventura',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              centerTitle: true,
            ),
            body: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              itemCount: modules.length,
              itemBuilder: (context, index) {
                return GiantModuleCard(module: modules[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(BuildContext context, String title, String cholName, Color color) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModuleDetailScreen(
          moduleTitle: title,
          moduleCholName: cholName,
          themeColor: color,
        ),
      ),
    );
  }
}
