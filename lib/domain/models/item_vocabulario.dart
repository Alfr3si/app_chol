// lib/domain/models/item_vocabulario.dart
class ItemVocabulario {
  final String espanol;
  final String chol;
  final String? pathAudio;
  final String? pathImagen;
  final String? categoria; // 🏷️ Campo de categoría integrado

  ItemVocabulario({
    required this.espanol,
    required this.chol,
    this.pathAudio,
    this.pathImagen,
    this.categoria,
  });

  factory ItemVocabulario.fromJson(Map<String, dynamic> json) {
    return ItemVocabulario(
      espanol: json['espanol'] ?? '',
      chol: json['chol'] ?? '',
      pathAudio: json['path_audio'],
      pathImagen: json['path_imagen'],
      categoria: json['categoria'],
    );
  }
}
