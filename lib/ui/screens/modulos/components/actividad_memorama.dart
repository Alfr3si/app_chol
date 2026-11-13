// lib/modules/modulo1/components/actividad_memorama.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import '../../../../domain/models/item_vocabulario.dart';

class CartaMemorama {
  final String idUnico;
  final String textoMostrado;
  final String? pathImagen;
  final String? pathAudio;
  bool estaVolteada;
  bool estaEncontrada;

  CartaMemorama({
    required this.idUnico,
    required this.textoMostrado,
    this.pathImagen,
    this.pathAudio,
    this.estaVolteada = false,
    this.estaEncontrada = false,
  });
}

class ActividadMemorama extends StatefulWidget {
  final String tituloActividad;
  final List<ItemVocabulario> listaItems;
  final String backgroundImage;

  const ActividadMemorama({
    super.key,
    required this.tituloActividad,
    required this.listaItems,
    required this.backgroundImage,
  });

  @override
  State<ActividadMemorama> createState() => _ActividadMemoramaState();
}

class _ActividadMemoramaState extends State<ActividadMemorama> {
  List<CartaMemorama> _cartas = [];
  bool _isLoading = true;
  CartaMemorama? _primeraCartaSeleccionada;
  bool _esperandoValidacion = false;
  int _paresEncontrados = 0;
  int _totalPares = 4;

  @override
  void initState() {
    super.initState();
    _iniciarMemorama();
  }

  Future<void> _reproducirAudio(String? path) async {
    if (path == null || path.isEmpty) return;
    try {
      String assetName = path.replaceAll('assets/audio/palabras/', '');
      await FlameAudio.play('palabras/$assetName');
    } catch (e) {
      debugPrint('Error al reproducir audio: $e');
    }
  }

  void _iniciarMemorama() {
    // 🔍 FILTRO ESTRICTO: Solo elementos con texto en Ch'ol y que tengan una ruta de imagen válida
    List<ItemVocabulario> disponibles = widget.listaItems
        .where((item) =>
            item.chol.isNotEmpty &&
            item.pathImagen != null &&
            item.pathImagen!.isNotEmpty)
        .toList()
      ..shuffle(Random());

    int cantidad = disponibles.length >= 4 ? 4 : disponibles.length;
    List<ItemVocabulario> seleccionados = disponibles.sublist(0, cantidad);

    _totalPares = seleccionados.length;
    List<CartaMemorama> tempCartas = [];

    for (var item in seleccionados) {
      // Carta 1: Muestra el texto en Ch'ol
      tempCartas.add(CartaMemorama(
        idUnico: item.chol,
        textoMostrado: item.chol,
        pathAudio: item.pathAudio,
      ));

      // Carta 2: Muestra exclusivamente la imagen correspondiente
      tempCartas.add(CartaMemorama(
        idUnico: item.chol,
        textoMostrado: '',
        pathImagen: item.pathImagen,
        pathAudio: item.pathAudio,
      ));
    }

    tempCartas.shuffle(Random());

    setState(() {
      _cartas = tempCartas;
      _paresEncontrados = 0;
      _primeraCartaSeleccionada = null;
      _esperandoValidacion = false;
      _isLoading = false;
    });
  }

  void _voltearCarta(int index) {
    if (_esperandoValidacion) return;
    if (_cartas[index].estaVolteada || _cartas[index].estaEncontrada) return;

    setState(() {
      _cartas[index].estaVolteada = true;
    });

    if (_primeraCartaSeleccionada == null) {
      _primeraCartaSeleccionada = _cartas[index];
    } else {
      CartaMemorama segundaCarta = _cartas[index];
      _esperandoValidacion = true;

      if (_primeraCartaSeleccionada!.idUnico == segundaCarta.idUnico) {
        _primeraCartaSeleccionada!.estaEncontrada = true;
        segundaCarta.estaEncontrada = true;
        _paresEncontrados++;

        _reproducirAudio(segundaCarta.pathAudio);

        _primeraCartaSeleccionada = null;
        _esperandoValidacion = false;

        if (_paresEncontrados == _totalPares) {
          Future.delayed(const Duration(milliseconds: 600), () {
            if (!mounted) return;
            _mostrarDialogoVictoria();
          });
        }
      } else {
        Future.delayed(const Duration(milliseconds: 800), () {
          if (!mounted) return;
          setState(() {
            _primeraCartaSeleccionada!.estaVolteada = false;
            segundaCarta.estaVolteada = false;
            _primeraCartaSeleccionada = null;
            _esperandoValidacion = false;
          });
        });
      }
    }
  }

  void _mostrarDialogoVictoria() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.brown.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text(
          '🎉 ¡Memorama Completado!',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: const Text(
          '¡Has relacionado exitosamente todas las palabras con sus imágenes!',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Continuar', style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAF3E0),
        appBar: AppBar(backgroundColor: Colors.brown.shade800, title: const Text('Cargando memorama...')),
        body: const Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.brown.shade800,
        toolbarHeight: 40,
        title: Text(
          widget.tituloActividad,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '🧠 Encuentra las parejas ($_paresEncontrados / $_totalPares pares)',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      childAspectRatio: 1.4,
                    ),
                    itemCount: _cartas.length,
                    itemBuilder: (context, index) {
                      final carta = _cartas[index];

                      return GestureDetector(
                        onTap: () => _voltearCarta(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: carta.estaVolteada || carta.estaEncontrada
                                ? (carta.estaEncontrada ? Colors.green.shade800 : Colors.white)
                                : Colors.brown.shade800,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: carta.estaEncontrada ? Colors.greenAccent : Colors.orangeAccent,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Center(
                            child: carta.estaVolteada || carta.estaEncontrada
                                ? Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: carta.pathImagen != null && carta.pathImagen!.isNotEmpty
                                        ? Image.asset(
                                            carta.pathImagen!,
                                            fit: BoxFit.contain,
                                            errorBuilder: (context, error, stackTrace) =>
                                                const Icon(Icons.image, size: 20, color: Colors.grey),
                                          )
                                        : Text(
                                            carta.textoMostrado,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              color: carta.estaEncontrada ? Colors.white : Colors.brown.shade900,
                                            ),
                                          ),
                                  )
                                : const Icon(
                                    Icons.help_outline_rounded,
                                    color: Colors.orangeAccent,
                                    size: 20,
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
