// lib/data/services/avatar_storage_service.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class AvatarStorageService {
  Future<Directory> _obtenerDirectorioAvatares() async {
    final baseDir = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(baseDir.path, 'avatars'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<String?> guardarDesdeArchivoLocal(String origenPath) async {
    try {
      final origen = File(origenPath);
      if (!await origen.exists()) return null;

      final dir = await _obtenerDirectorioAvatares();
      final ext = p.extension(origenPath).isNotEmpty
          ? p.extension(origenPath)
          : '.jpg';
      final destinoPath = p.join(
        dir.path,
        'avatar_custom_${DateTime.now().millisecondsSinceEpoch}$ext',
      );

      final copia = await origen.copy(destinoPath);
      return copia.path;
    } catch (e) {
      debugPrint('Error guardando avatar de galería: $e');
      return null;
    }
  }

  Future<String?> guardarDesdeUrlGoogle(String photoUrl) async {
    if (photoUrl.trim().isEmpty) return null;
    try {
      final response = await http.get(Uri.parse(photoUrl));
      if (response.statusCode != 200 || response.bodyBytes.isEmpty) {
        return null;
      }

      final dir = await _obtenerDirectorioAvatares();
      final destinoPath = p.join(dir.path, 'avatar_google.jpg');
      final file = File(destinoPath);
      await file.writeAsBytes(response.bodyBytes, flush: true);
      return file.path;
    } catch (e) {
      debugPrint('Error descargando avatar de Google: $e');
      return null;
    }
  }
}
