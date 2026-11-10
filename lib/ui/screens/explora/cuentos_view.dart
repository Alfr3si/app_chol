import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'explora_item.dart';

class CuentosView extends StatefulWidget {
  final bool isCholLanguage;

  const CuentosView({super.key, required this.isCholLanguage});

  @override
  State<CuentosView> createState() => _CuentosViewState();
}

class _CuentosViewState extends State<CuentosView> {
  List<ExploraItem> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/cuentos.json');
      final List<dynamic> decodedData = json.decode(jsonString);
      setState(() {
        _items = decodedData.map((e) => ExploraItem.fromJson(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error al cargar cuentos.json: $e");
      setState(() => _isLoading = false);
    }
  }

  // Método para mostrar el diálogo con la historia completa
  void _showDetailModal(BuildContext context, String title, String content) {
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
            width: MediaQuery.of(context).size.width * 0.6,
            child: SingleChildScrollView(
              child: Text(
                content,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
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
        child: Text("No hay cuentos disponibles", style: TextStyle(color: Colors.white)),
      );
    }

    return GridView.builder(
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
        
        // CORRECCIÓN: Inicia mostrando Español por defecto, y conmuta a Ch'ol al presionar el botón superior.
        final title = widget.isCholLanguage 
            ? item.titleEsp 
            : (item.titleChol.isNotEmpty ? item.titleChol : item.titleEsp);
            
        final content = widget.isCholLanguage 
            ? item.contentEsp 
            : (item.contentChol.isNotEmpty ? item.contentChol : item.contentEsp);

        return InkWell(
          onTap: () => _showDetailModal(context, title, content),
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
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
