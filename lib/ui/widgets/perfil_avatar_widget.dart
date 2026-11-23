// lib/ui/widgets/perfil_avatar_widget.dart
import 'dart:io';
import 'package:flutter/material.dart';

class PerfilAvatarWidget extends StatelessWidget {
  final String avatarPath;
  final double size;

  const PerfilAvatarWidget({
    super.key,
    required this.avatarPath,
    this.size = 84,
  });

  static const String fallbackAsset = 'assets/image/learning/grupo.webp';

  @override
  Widget build(BuildContext context) {
    final ruta = avatarPath.trim();

    Widget imagen;
    if (ruta.startsWith('assets/')) {
      imagen = Image.asset(
        ruta,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Image.asset(fallbackAsset, fit: BoxFit.cover),
      );
    } else if (ruta.startsWith('http://') || ruta.startsWith('https://')) {
      imagen = Image.network(
        ruta,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Image.asset(fallbackAsset, fit: BoxFit.cover),
      );
    } else if (ruta.isNotEmpty && File(ruta).existsSync()) {
      imagen = Image.file(
        File(ruta),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Image.asset(fallbackAsset, fit: BoxFit.cover),
      );
    } else {
      imagen = Image.asset(fallbackAsset, fit: BoxFit.cover);
    }

    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: imagen,
      ),
    );
  }
}
