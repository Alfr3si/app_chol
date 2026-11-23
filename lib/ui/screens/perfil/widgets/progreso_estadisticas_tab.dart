//lib\ui\screens\perfil\widgets\progreso_estadisticas_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/providers/progreso_providers.dart';
import 'modulo_progreso_card.dart';

class ProgresoEstadisticasTab extends ConsumerStatefulWidget {
  final Color backgroundColor;
  final Color cardColor;
  final Color accentColor;
  final Color textPrimary;
  final Color textSecondary;

  const ProgresoEstadisticasTab({
    super.key,
    required this.backgroundColor,
    required this.cardColor,
    required this.accentColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  ConsumerState<ProgresoEstadisticasTab> createState() =>
      _ProgresoEstadisticasTabState();
}

class _ProgresoEstadisticasTabState
    extends ConsumerState<ProgresoEstadisticasTab> {
  final ScrollController _scrollController = ScrollController();

  static const List<(int id, String titulo, int actividades)> _modulos = [
    (1, 'Mi familia y yo', 7),
    (2, 'El lugar donde vivo', 6),
    (3, 'Mi escuela', 5),
    (4, 'Gustos y Pasatiempos', 5),
    (5, 'Mi cuerpo', 5),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final puntajeAsync = ref.watch(puntajeTotalProvider);

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      radius: const Radius.circular(8),
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: widget.cardColor.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.accentColor.withValues(alpha: 0.6),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.emoji_events_outlined,
                    color: widget.accentColor,
                    size: 32,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      "Puntaje General",
                      style: TextStyle(
                        color: widget.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  puntajeAsync.when(
                    data: (puntaje) => Text(
                      "$puntaje pts",
                      style: TextStyle(
                        color: widget.accentColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    loading: () => SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: widget.accentColor,
                        strokeWidth: 2,
                      ),
                    ),
                    error: (_, __) => Text(
                      "-- pts",
                      style: TextStyle(color: widget.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            ..._modulos.map(
              (modulo) => ModuloProgresoCard(
                moduloId: modulo.$1,
                tituloModulo: modulo.$2,
                totalActividades: modulo.$3,
                backgroundColor: widget.backgroundColor,
                cardColor: widget.cardColor,
                accentColor: widget.accentColor,
                textPrimary: widget.textPrimary,
                textSecondary: widget.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
