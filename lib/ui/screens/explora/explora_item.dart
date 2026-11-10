class ExploraItem {
  final String id;
  final String titleChol;
  final String contentChol;
  final String titleEsp;
  final String contentEsp;
  final String imagePath;

  ExploraItem({
    required this.id,
    required this.titleChol,
    required this.contentChol,
    required this.titleEsp,
    required this.contentEsp,
    required this.imagePath,
  });

  factory ExploraItem.fromJson(Map<String, dynamic> json) {
    String rawPath = json['imagePath'] ?? '';

    // Limpiamos saltos de línea y espacios
    rawPath = rawPath.replaceAll('\n', '').trim();
    if (rawPath.startsWith('../')) {
      rawPath = rawPath.replaceFirst('../', '');
    }

    String formattedPath = '';
    if (rawPath.isNotEmpty) {
      // Si ya viene con assets, extraemos únicamente el nombre del archivo para asegurarnos
      // de construir una ruta limpia y evitar conflictos de mayúsculas/minúsculas en carpetas.
      String fileName = rawPath.contains('/')
          ? rawPath.split('/').last
          : rawPath;

      // Opcional: si tus archivos reales son .jpg/.jpeg en minúscula, esto evita problemas:
      // fileName = fileName.toLowerCase();

      formattedPath = 'assets/image/explora/$fileName';
    }

    return ExploraItem(
      id: json['id'] ?? '',
      titleChol: json['titleChol'] ?? '',
      contentChol: json['contentChol'] ?? '',
      titleEsp: json['titleEsp'] ?? '',
      contentEsp: json['contentEsp'] ?? '',
      imagePath: formattedPath,
    );
  }
}
