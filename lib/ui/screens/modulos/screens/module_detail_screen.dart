import 'package:flutter/material.dart';
import '../widgets/level_card_widget.dart';

class ModuleDetailScreen extends StatelessWidget {
  final String moduleTitle;
  final String moduleCholName;
  final Color themeColor;

  const ModuleDetailScreen({
    super.key,
    required this.moduleTitle,
    required this.moduleCholName,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: Text(
          '$moduleCholName - $moduleTitle',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: themeColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: themeColor, width: 2),
              ),
              child: Row(
                children: [
                  Icon(Icons.sports_esports_rounded, size: 40, color: themeColor),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selecciona una actividad',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          moduleTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Niveles de Juego',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  LevelCardWidget(
                    levelNumber: 1,
                    title: 'Vocabulario Básico',
                    description: 'Aprende las palabras principales escuchando y relacionando.',
                    isUnlocked: true,
                    color: Colors.greenAccent,
                    onTap: () => debugPrint('Nivel 1 seleccionado'),
                  ),
                  LevelCardWidget(
                    levelNumber: 2,
                    title: 'Memorama Ch\'ol',
                    description: 'Encuentra las parejas de palabras en español y ch\'ol.',
                    isUnlocked: true,
                    color: Colors.orangeAccent,
                    onTap: () => debugPrint('Nivel 2 seleccionado'),
                  ),
                  LevelCardWidget(
                    levelNumber: 3,
                    title: 'Desafío del Tiempo',
                    description: 'Pon a prueba tus conocimientos antes de que acabe el reloj.',
                    isUnlocked: false,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
