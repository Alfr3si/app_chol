// lib/ui/screens/perfil/widgets/perfil_general_tab.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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

  // Avatares predefinidos (asegúrate de declarar assets/image/avatars/ en pubspec.yaml)
  static const List<String> _avataresPredefinidos = [
    'assets/image/learning/grupo.webp',
    'assets/image/avatars/invitado.webp',
    'assets/image/avatars/chol_1.webp',
    'assets/image/avatars/chol_2.webp',
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
                    child: SizedBox(
                      width: 68,
                      height: 68,
                      child: _buildAvatarImage(profile.avatarPath),
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

  Widget _buildAvatarImage(String rutaRaw) {
    final ruta = rutaRaw.trim();
    Widget fallback() => Icon(Icons.person, size: 40, color: textPrimary);

    if (ruta.startsWith('assets/')) {
      return Image.asset(
        ruta,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback(),
      );
    }

    if (ruta.startsWith('http://') || ruta.startsWith('https://')) {
      return Image.network(
        ruta,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback(),
      );
    }

    if (ruta.isNotEmpty && File(ruta).existsSync()) {
      return Image.file(
        File(ruta),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback(),
      );
    }

    return fallback();
  }

  /// Copia una imagen elegida de galería al directorio privado `.../avatars/` de la app.
  Future<String?> _guardarImagenEnAvataresLocales(String origenPath) async {
    try {
      final origen = File(origenPath);
      if (!await origen.exists()) return null;

      final docsDir = await getApplicationDocumentsDirectory();
      final avatarsDir = Directory(p.join(docsDir.path, 'avatars'));
      if (!await avatarsDir.exists()) {
        await avatarsDir.create(recursive: true);
      }

      final ext = p.extension(origenPath).isNotEmpty
          ? p.extension(origenPath)
          : '.jpg';
      final destino = File(
        p.join(
          avatarsDir.path,
          'avatar_${DateTime.now().millisecondsSinceEpoch}$ext',
        ),
      );
      await origen.copy(destino.path);
      return destino.path;
    } catch (_) {
      return null;
    }
  }

  Future<void> _mostrarOpcionesAvatar(
    BuildContext parentContext,
    void Function(void Function()) setDialogState,
    String avatarActual,
    void Function(String nuevaRuta) onAvatarSeleccionado,
  ) async {
    await showModalBottomSheet<void>(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        side: BorderSide(color: accentColor.withValues(alpha: 0.4)),
      ),
      builder: (sheetContext) {
        final bottomInset = MediaQuery.of(sheetContext).viewInsets.bottom;
        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 16 + bottomInset),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Elegir foto de perfil',
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.photo_library_outlined, color: accentColor),
                  title: Text(
                    'Subir desde galería',
                    style: TextStyle(color: textPrimary, fontSize: 14),
                  ),
                  subtitle: Text(
                    'Se guarda en tu almacenamiento local',
                    style: TextStyle(color: textSecondary, fontSize: 12),
                  ),
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    final picker = ImagePicker();
                    final picked = await picker.pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 512,
                      maxHeight: 512,
                      imageQuality: 80,
                    );
                    if (picked == null || !parentContext.mounted) return;

                    final rutaLocal =
                        await _guardarImagenEnAvataresLocales(picked.path);
                    if (rutaLocal != null && parentContext.mounted) {
                      setDialogState(() => onAvatarSeleccionado(rutaLocal));
                    }
                  },
                ),
                const Divider(height: 12),
                Text(
                  'Avatares de la app',
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _avataresPredefinidos.map((assetPath) {
                    final seleccionado = avatarActual == assetPath;
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() => onAvatarSeleccionado(assetPath));
                        Navigator.of(sheetContext).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(2.5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: seleccionado
                                ? accentColor
                                : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: accentColor.withValues(alpha: 0.2),
                          child: ClipOval(
                            child: SizedBox(
                              width: 44,
                              height: 44,
                              child: _buildAvatarImage(assetPath),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
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
    String avatarSeleccionado = profile.avatarPath;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;
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
              content: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: bottomInset),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => _mostrarOpcionesAvatar(
                        context,
                        setDialogState,
                        avatarSeleccionado,
                        (nuevaRuta) => avatarSeleccionado = nuevaRuta,
                      ),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 38,
                            backgroundColor: accentColor,
                            child: ClipOval(
                              child: SizedBox(
                                width: 72,
                                height: 72,
                                child: _buildAvatarImage(avatarSeleccionado),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: accentColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Toca para cambiar foto',
                      style: TextStyle(color: textSecondary, fontSize: 12),
                    ),
                    const SizedBox(height: 14),
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
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: edadSeleccionada,
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
                      avatarPath: avatarSeleccionado,
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
