// lib/ui/screens/perfil/widgets/modulo_progreso_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/providers/progreso_providers.dart';
import '../../../../data/repositories/progreso_repository.dart';

class ModuloProgresoCard extends ConsumerWidget {
  final int moduloId;
  final String tituloModulo;
  final int totalActividades;
  final Color backgroundColor;
  final Color cardColor;
  final Color accentColor;
  final Color textPrimary;
  final Color textSecondary;

  const ModuloProgresoCard({
    super.key,
    required this.moduloId,
    required this.tituloModulo,
    this.totalActividades = 5,
    required this.backgroundColor,
    required this.cardColor,
    required this.accentColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumenAsync = ref.watch(resumenModuloProvider(moduloId));

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: textSecondary.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: resumenAsync.when(
        data: (ResumenModulo resumen) {
          final int completadas = resumen.completadas;
          final int total = resumen.total > 0 ? resumen.total : totalActividades;
          final double ratio = resumen.porcentaje.clamp(0.0, 1.0);
          final int porcentajeEntero = (ratio * 100).round();
          final bool estaCompleto = completadas >= total && total > 0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        if (estaCompleto) ...[
                          Icon(
                            Icons.check_circle,
                            color: accentColor,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                        ],
                        Expanded(
                          child: Text(
                            "Módulo $moduloId: $tituloModulo",
                            style: TextStyle(
                              color: textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "$completadas/$total ($porcentajeEntero%)",
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 8,
                  backgroundColor: backgroundColor,
                  valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                ),
              ),
              if (estaCompleto) ...[
                const SizedBox(height: 8),
                Text(
                  "Módulo completado",
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          );
        },
        loading: () => Row(
          children: [
            Expanded(
              child: Text(
                "Módulo $moduloId: $tituloModulo",
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                color: accentColor,
                strokeWidth: 2,
              ),
            ),
          ],
        ),
        error: (_, __) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Módulo $moduloId: $tituloModulo",
              style: TextStyle(
                color: textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Sin datos",
              style: TextStyle(color: textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
