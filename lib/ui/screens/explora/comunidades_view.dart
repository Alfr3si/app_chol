import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'explora_item.dart';

class ComunidadesView extends StatefulWidget {
  final bool isCholLanguage;

  const ComunidadesView({super.key, required this.isCholLanguage});

  @override
  State<ComunidadesView> createState() => _ComunidadesViewState();
}

class _ComunidadesViewState extends State<ComunidadesView> {
  List<ExploraItem> _items = [];
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();

  // Paleta de colores consistente
  static const Color _bgBlack = Color(0xFF121212);
  static const Color _cardBlack = Color(0xFF1E1E1E);
  static const Color _orangePrimary = Color(0xFFFF7A00);
  static const Color _orangeAccent = Color(0xFFFF9E3D);
  static const Color _pureWhite = Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/comunidades.json');
      final List<dynamic> decodedData = json.decode(jsonString);
      setState(() {
        _items = decodedData.map((e) => ExploraItem.fromJson(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error al cargar comunidades.json: $e");
      setState(() => _isLoading = false);
    }
  }

  // Método para mostrar el modal con indicador de scroll visible en la descripción
  void _showDetailModal(BuildContext context, String title, String content, String imagePath) {
    final ScrollController modalScrollController = ScrollController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _cardBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: _orangePrimary, width: 1.5),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: _orangePrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Scrollbar(
              controller: modalScrollController,
              thumbVisibility: true, // 👈 Indicador de scroll visible dentro del modal
              radius: const Radius.circular(8),
              child: SingleChildScrollView(
                controller: modalScrollController,
                padding: const EdgeInsets.only(right: 8.0),
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
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: _pureWhite,
                backgroundColor: _orangePrimary,
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
      return const Center(child: CircularProgressIndicator(color: _orangePrimary));
    }

    if (_items.isEmpty) {
      return const Center(
        child: Text("No hay datos de comunidades disponibles", style: TextStyle(color: _pureWhite)),
      );
    }

    // Scrollbar principal visible para la cuadrícula de tarjetas
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      radius: const Radius.circular(8),
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 columnas en landscape
          mainAxisSpacing: 14.0,
          crossAxisSpacing: 14.0,
          childAspectRatio: 2.2,
        ),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          
          final title = widget.isCholLanguage 
              ? item.titleEsp 
              : (item.titleChol.isNotEmpty ? item.titleChol : item.titleEsp);
              
          final content = widget.isCholLanguage 
              ? item.contentEsp 
              : (item.contentChol.isNotEmpty ? item.contentChol : item.contentEsp);

          return InkWell(
            onTap: () => _showDetailModal(context, title, content, item.imagePath),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: _cardBlack.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _orangePrimary.withOpacity(0.7), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      decoration: BoxDecoration(
                        color: _bgBlack,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _orangeAccent, width: 1),
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
                                      const Icon(Icons.map, size: 26, color: _orangePrimary),
                                ),
                              )
                            : const Icon(Icons.map, size: 26, color: _orangePrimary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Center(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: _pureWhite,
                            shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
