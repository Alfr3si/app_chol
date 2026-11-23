//lib\ui\screens\perfil\widgets\perfil_general_tab.dart 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/providers/progreso_providers.dart';
import '../profile_viewmodel.dart';

class PerfilGeneralTab extends ConsumerWidget {
  final Color cardColor;
  final Color accentColor;
  final Color textPrimary;
  final Color textSecondary;

  const PerfilGeneralTab({
    super.key,
    required this.cardColor,
    required this.accentColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  static const List<String> _rangosEdad = [
    '6-7 años',
    '8-10 años',
    '11-12 años',
    '13+ años',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final profile = profileState.profile;
    final puntajeAsync = ref.watch(puntajeTotalProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tarjeta principal de identidad del usuario
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: accentColor,
                  child: ClipOval(
                    child: Image.asset(
                      profile.avatarPath,
                      width: 68,
                      height: 68,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Icon(Icons.person, size: 40, color: textPrimary),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.alias,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: accentColor.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Text(
                              profile.rankTitle,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: accentColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            profile.ageRange,
                            style: TextStyle(
                              fontSize: 13,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Editar perfil',
                  onPressed: profileState.isLoading
                      ? null
                      : () => _mostrarDialogoEdicion(context, ref),
                  icon: Icon(Icons.edit_outlined, color: accentColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Tarjeta de Puntaje Total Acumulado (Drift)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Puntaje Total Acumulado",
                      style: TextStyle(color: textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Suma de todas tus actividades",
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                puntajeAsync.when(
                  data: (puntaje) => Row(
                    children: [
                      Icon(Icons.stars_rounded, color: accentColor, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        "$puntaje pts",
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  loading: () => SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: accentColor,
                      strokeWidth: 2.5,
                    ),
                  ),
                  error: (_, __) => Text(
                    "0 pts",
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Tarjeta de Insignias Desbloqueadas
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: textSecondary.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.workspace_premium_outlined,
                      color: accentColor,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Insignias Desbloqueadas",
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (profile.unlockedInsignias.isEmpty)
                  Text(
                    "Completa módulos para ganar insignias.",
                    style: TextStyle(color: textSecondary, fontSize: 13),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: profile.unlockedInsignias.map((insignia) {
                      return Chip(
                        avatar: Icon(
                          Icons.verified,
                          size: 16,
                          color: accentColor,
                        ),
                        label: Text(
                          insignia,
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: accentColor.withValues(alpha: 0.15),
                        side: BorderSide(
                          color: accentColor.withValues(alpha: 0.4),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _mostrarDialogoEdicion(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final profile = ref.read(profileProvider).profile;
    final aliasController = TextEditingController(text: profile.alias);
    String edadSeleccionada = _rangosEdad.contains(profile.ageRange)
        ? profile.ageRange
        : _rangosEdad[1];

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: accentColor.withValues(alpha: 0.5)),
              ),
              title: Text(
                'Editar Perfil',
                style: TextStyle(
                  color: textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: aliasController,
                    style: TextStyle(color: textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Alias o Nombre',
                      labelStyle: TextStyle(color: textSecondary),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: textSecondary.withValues(alpha: 0.4),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: accentColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: edadSeleccionada,
                    dropdownColor: cardColor,
                    style: TextStyle(color: textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Rango de edad',
                      labelStyle: TextStyle(color: textSecondary),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: textSecondary.withValues(alpha: 0.4),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: accentColor),
                      ),
                    ),
                    items: _rangosEdad
                        .map(
                          (rango) => DropdownMenuItem(
                            value: rango,
                            child: Text(rango),
                          ),
                        )
                        .toList(),
                    onChanged: (nuevoValor) {
                      if (nuevoValor != null) {
                        setDialogState(() => edadSeleccionada = nuevoValor);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: textPrimary,
                  ),
                  onPressed: () async {
                    final nuevoAlias = aliasController.text.trim();
                    if (nuevoAlias.isEmpty) return;

                    final notifier = ref.read(profileProvider.notifier);
                    notifier.updateProfile(
                      alias: nuevoAlias,
                      ageRange: edadSeleccionada,
                    );
                    Navigator.of(dialogContext).pop();
                    await notifier.saveChanges();

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Perfil actualizado correctamente.'),
                        ),
                      );
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );

    aliasController.dispose();
  }
}
