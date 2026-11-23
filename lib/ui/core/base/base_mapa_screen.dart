// lib/ui/core/base/base_mapa_screen.dart
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/progreso_providers.dart';
import '../../game_canvas/base_mapa_world.dart';

class BaseMapaScreen extends ConsumerStatefulWidget {
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
  ConsumerState<BaseMapaScreen> createState() => _BaseMapaScreenState();
}

class _BaseMapaScreenState extends ConsumerState<BaseMapaScreen> {
  late final BaseMapaWorld gameInstance;
  bool _showActivityPrompt = false;
  String _currentHouseTitle = '';
  int? _currentActivityNumber;

  @override
  void initState() {
    super.initState();
    gameInstance = BaseMapaWorld(
      backgroundAsset: widget.backgroundAsset,
      casasRects: widget.casasRects,
      houseNames: widget.houseNames,
      obstacles: widget.obstacles,
      onHouseEntered: (houseName) {
        if (!mounted) return;
        final idx = widget.houseNames.indexOf(houseName);
        setState(() {
          _currentHouseTitle = houseName;
          _currentActivityNumber = idx >= 0 ? idx + 1 : null;
          _showActivityPrompt = true;
        });
      },
      onHouseExited: () {
        if (!mounted) return;
        setState(() {
          _showActivityPrompt = false;
          _currentActivityNumber = null;
        });
      },
    );
  }

  Future<void> _abrirActividad() async {
    final destino = widget.onNavigateToActivity(_currentHouseTitle);
    gameInstance.player.move('idle');
    setState(() {
      _showActivityPrompt = false;
    });

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destino),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resumenAsync = ref.watch(resumenModuloProvider(widget.moduloId));
    final completadasSet =
        ref.watch(actividadesCompletadasProvider(widget.moduloId)).maybeWhen(
              data: (set) => set,
              orElse: () => const <int>{},
            );

    final bool actividadActualCompletada = _currentActivityNumber != null &&
        completadasSet.contains(_currentActivityNumber);

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
              onPressed: () {
                gameInstance.player.move('idle');
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: Text('Volver a Módulos (${widget.tituloModulo})'),
            ),
          ),

          // Indicador de Avance del Módulo en el Mapa
          Positioned(
            top: 40,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange, width: 1.5),
              ),
              child: resumenAsync.when(
                data: (resumen) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.orangeAccent,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${resumen.completadas}/${resumen.total} completadas',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                loading: () => const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.orangeAccent,
                  ),
                ),
                error: (_, __) => const Text(
                  '0/5 completadas',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),

          // Ventana Flotante de Actividad
          if (_showActivityPrompt)
            Center(
              child: Container(
                width: 320,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.brown.shade900.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: actividadActualCompletada
                        ? Colors.greenAccent
                        : Colors.orange,
                    width: 3,
                  ),
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
                    Icon(
                      actividadActualCompletada
                          ? Icons.verified
                          : Icons.home,
                      color: actividadActualCompletada
                          ? Colors.greenAccent
                          : Colors.orangeAccent,
                      size: 48,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '¡Actividad!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (actividadActualCompletada) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade800,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Completada',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
                          onPressed: _abrirActividad,
                          child: Text(
                            actividadActualCompletada
                                ? 'Repetir'
                                : 'Aceptar',
                          ),
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
