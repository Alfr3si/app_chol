import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'explora_item.dart';

class GastronomiaView extends StatefulWidget {
  final bool isCholLanguage;

  const GastronomiaView({super.key, required this.isCholLanguage});

  @override
  State<GastronomiaView> createState() => _GastronomiaViewState();
}

class _GastronomiaViewState extends State<GastronomiaView> {
  List<ExploraItem> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/gastronomia.json');
      final List<dynamic> decodedData = json.decode(jsonString);
      setState(() {
        _items = decodedData.map((e) => ExploraItem.fromJson(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error al cargar gastronomia.json: $e");
      setState(() => _isLoading = false);
    }
  }

  // Método para mostrar el modal con la descripción completa y la imagen del platillo
  void _showDetailModal(BuildContext context, String title, String content, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFFF7A00), width: 1.5),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Color(0xFFFF7A00),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (imagePath.isNotEmpty) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        imagePath,
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 50, color: Colors.white54),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Text(
                    content,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFFF7A00),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cerrar", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFFFF7A00)));
    }

    if (_items.isEmpty) {
      return const Center(
        child: Text("No hay datos de gastronomía disponibles", style: TextStyle(color: Colors.white)),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 14.0,
        crossAxisSpacing: 14.0,
        childAspectRatio: 2.2,
      ),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        final title = widget.isCholLanguage && item.titleChol.isNotEmpty 
            ? item.titleChol 
            : item.titleEsp;
        final content = widget.isCholLanguage && item.contentChol.isNotEmpty 
            ? item.contentChol 
            : item.contentEsp;

        return InkWell(
          onTap: () => _showDetailModal(context, title, content, item.imagePath),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E).withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFF7A00).withOpacity(0.7), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF121212),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFF9E3D), width: 1),
                    ),
                    child: Center(
                      child: item.imagePath.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: Image.asset(
                                item.imagePath,
                                width: 60,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.restaurant, size: 26, color: Color(0xFFFF7A00)),
                              ),
                            )
                          : const Icon(Icons.restaurant, size: 26, color: Color(0xFFFF7A00)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white,
                            shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          content,
                          style: const TextStyle(fontSize: 10, color: Color(0xFFB3B3B3)),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
