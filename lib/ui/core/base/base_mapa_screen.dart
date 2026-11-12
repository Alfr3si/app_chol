// lib/screens/base_mapa_screen.dart (o la ruta donde organices tus pantallas)
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../../game_canvas/base_mapa_world.dart'; // Crearemos este world genérico en el Paso 2

class BaseMapaScreen extends StatefulWidget {
  final int moduloId;
  final String tituloModulo;
  final String backgroundAsset;
  final List<Rect> casasRects;
  final List<String> houseNames;
  final List<Rect> obstacles;
  final Widget Function(String activityName) onNavigateToActivity;

  const BaseMapaScreen({
    super.key,
    required this.moduloId,
    required this.tituloModulo,
    required this.backgroundAsset,
    required this.casasRects,
    required this.houseNames,
    required this.obstacles,
    required this.onNavigateToActivity,
  });

  @override
  State<BaseMapaScreen> createState() => _BaseMapaScreenState();
}

class _BaseMapaScreenState extends State<BaseMapaScreen> {
  late final BaseMapaWorld gameInstance;
  bool _showActivityPrompt = false;
  String _currentHouseTitle = '';

  @override
  void initState() {
    super.initState();
    gameInstance = BaseMapaWorld(
      backgroundAsset: widget.backgroundAsset,
      casasRects: widget.casasRects,
      houseNames: widget.houseNames,
      obstacles: widget.obstacles,
      onHouseEntered: (houseName) {
        setState(() {
          _currentHouseTitle = houseName;
          _showActivityPrompt = true;
        });
      },
      onHouseExited: () {
        setState(() {
          _showActivityPrompt = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: gameInstance),

          // Botón de Regreso
          Positioned(
            top: 40,
            left: 20,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade800,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: Text('Volver a Módulos (${widget.tituloModulo})'),
            ),
          ),

          // Ventana Flotante de Actividad
          if (_showActivityPrompt)
            Center(
              child: Container(
                width: 320,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.brown.shade900.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orange, width: 3),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.home,
                      color: Colors.orangeAccent,
                      size: 48,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '¡Has llegado a una casa!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _currentHouseTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _showActivityPrompt = false;
                            });
                          },
                          child: const Text('Rechazar'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _showActivityPrompt = false;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => widget.onNavigateToActivity(_currentHouseTitle),
                              ),
                            );
                          },
                          child: const Text('Aceptar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // D-Pad Táctil (Controles de Movimiento)
          Positioned(
            bottom: 30,
            left: 30,
            child: SizedBox(
              width: 160,
              height: 160,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onTapDown: (_) => gameInstance.player.move('up'),
                      onTapUp: (_) => gameInstance.player.move('idle'),
                      onTapCancel: () => gameInstance.player.move('idle'),
                      child: _buildControlButton(Icons.arrow_drop_up),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTapDown: (_) => gameInstance.player.move('down'),
                      onTapUp: (_) => gameInstance.player.move('idle'),
                      onTapCancel: () => gameInstance.player.move('idle'),
                      child: _buildControlButton(Icons.arrow_drop_down),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTapDown: (_) => gameInstance.player.move('left'),
                      onTapUp: (_) => gameInstance.player.move('idle'),
                      onTapCancel: () => gameInstance.player.move('idle'),
                      child: _buildControlButton(Icons.arrow_left),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTapDown: (_) => gameInstance.player.move('right'),
                      onTapUp: (_) => gameInstance.player.move('idle'),
                      onTapCancel: () => gameInstance.player.move('idle'),
                      child: _buildControlButton(Icons.arrow_right),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.black54,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white70, width: 2),
      ),
      child: Icon(icon, color: Colors.white, size: 32),
    );
  }
}
