// lib/modules/modulo1/components/actividad_seleccion_imagen.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import '../../../../domain/models/item_vocabulario.dart';

class ActividadSeleccionImagen extends StatefulWidget {
  final String tituloActividad;
  final List<ItemVocabulario> listaItems;
  final String backgroundImage;

  const ActividadSeleccionImagen({
    super.key,
    required this.tituloActividad,
    required this.listaItems,
    required this.backgroundImage,
  });

  @override
  State<ActividadSeleccionImagen> createState() => _ActividadSeleccionImagenState();
}

class _ActividadSeleccionImagenState extends State<ActividadSeleccionImagen>
    with SingleTickerProviderStateMixin {
  late List<ItemVocabulario> _activeQueue;
  final List<ItemVocabulario> _failedQueue = [];

  int _currentIndex = 0;
  bool _isReviewRound = false;

  List<ItemVocabulario> _opcionesImagenes = [];
  ItemVocabulario? _selectedItem;
  bool? _isAnswerCorrect;
  int _intentosRestantes = 2;

  // 🔤 Controla si el cuadro de texto (Ch'ol y Español) está desplegado
  bool _mostrarTraduccion = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Filtro flexible: acepta elementos de la lista recibida que tengan texto válido
    _activeQueue = List.from(
      widget.listaItems.where((item) =>
          item.chol.isNotEmpty &&
          item.espanol.isNotEmpty),
    )..shuffle();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _prepararPregunta();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _reproducirAudio(String? path) async {
    if (path == null || path.isEmpty) return;
    try {
      String assetName = path.replaceAll('assets/audio/palabras/', '');
      await FlameAudio.play('palabras/$assetName');
      
      setState(() {
        _mostrarTraduccion = true;
      });
    } catch (e) {
      debugPrint('Error al reproducir audio: $e');
    }
  }

  void _prepararPregunta() {
    if (_activeQueue.isEmpty) return;

    final current = _activeQueue[_currentIndex];
    final random = Random();

    List<ItemVocabulario> distractores = widget.listaItems
        .where((item) => item.chol != current.chol)
        .toList()
      ..shuffle(random);

    List<ItemVocabulario> seleccionadas = [
      current,
      if (distractores.isNotEmpty) distractores[0],
      if (distractores.length > 1) distractores[1],
    ]..shuffle(random);

    setState(() {
      _opcionesImagenes = seleccionadas;
      _selectedItem = null;
      _isAnswerCorrect = null;
      _intentosRestantes = 2;
      _mostrarTraduccion = false;
    });

    _animationController.forward(from: 0.0);
  }

  void _verificarRespuesta(ItemVocabulario itemSeleccionado) {
    if (_isAnswerCorrect == true) return;

    final current = _activeQueue[_currentIndex];
    final bool esCorrecto = (itemSeleccionado.chol == current.chol);

    setState(() {
      _selectedItem = itemSeleccionado;
      _isAnswerCorrect = esCorrecto;

      if (esCorrecto) {
        Future.delayed(const Duration(milliseconds: 800), () {
          if (!mounted) return;
          _siguientePaso();
        });
      } else {
        _intentosRestantes--;
        if (_intentosRestantes <= 0) {
          if (!_failedQueue.contains(current)) {
            _failedQueue.add(current);
          }
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (!mounted) return;
            _siguientePaso();
          });
        } else {
          Future.delayed(const Duration(milliseconds: 800), () {
            if (!mounted) return;
            setState(() {
              _selectedItem = null;
              _isAnswerCorrect = null;
            });
          });
        }
      }
    });
  }

  void _siguientePaso() {
    if (_currentIndex < _activeQueue.length - 1) {
      setState(() {
        _currentIndex++;
        _prepararPregunta();
      });
    } else {
      if (_failedQueue.isNotEmpty) {
        setState(() {
          _activeQueue = List.from(_failedQueue);
          _failedQueue.clear();
          _currentIndex = 0;
          _isReviewRound = true;
          _prepararPregunta();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Momento de repasar las palabras que fallaste! 💪'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        _mostrarDialogoVictoria();
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
          '🎉 ¡Actividad Superada!',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: const Text(
          '¡Has completado con éxito este desafío de escucha e identificación visual!',
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
    if (_activeQueue.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAF3E0),
        appBar: AppBar(backgroundColor: Colors.brown.shade800, title: const Text('Cargando...')),
        body: const Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }

    final current = _activeQueue[_currentIndex];
    double progreso = (_currentIndex + 1) / _activeQueue.length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.brown.shade800,
        toolbarHeight: 40,
        title: Text(
          _isReviewRound ? 'Repaso: ${widget.tituloActividad}' : widget.tituloActividad,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: LinearProgressIndicator(
            value: progreso,
            color: Colors.orangeAccent,
            backgroundColor: Colors.white24,
          ),
        ),
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
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Ronda ${_currentIndex + 1} de ${_activeQueue.length}: Escucha y selecciona la imagen. (Intentos: $_intentosRestantes)',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  flex: 4,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _opcionesImagenes.map((item) {
                          final bool isSelected = (_selectedItem == item);

                          Color colorBorde = Colors.orangeAccent;
                          Color colorFondo = Colors.white;

                          if (isSelected) {
                            if (_isAnswerCorrect == true) {
                              colorBorde = Colors.greenAccent;
                              colorFondo = Colors.green.shade100;
                            } else {
                              colorBorde = Colors.redAccent;
                              colorFondo = Colors.red.shade100;
                            }
                          }

                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6.0),
                              child: GestureDetector(
                                onTap: _isAnswerCorrect == true ? null : () => _verificarRespuesta(item),
                                child: Container(
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: colorFondo,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: colorBorde, width: 2.5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(13.5),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: item.pathImagen != null && item.pathImagen!.isNotEmpty
                                          ? Image.asset(
                                              item.pathImagen!,
                                              fit: BoxFit.contain,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  const Icon(Icons.image_not_supported, size: 32, color: Colors.grey),
                                            )
                                          : Center(
                                              child: Text(
                                                item.espanol,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.brown,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                      width: _mostrarTraduccion ? 250 : 0,
                      height: 50,
                      margin: EdgeInsets.only(right: _mostrarTraduccion ? 8.0 : 0.0),
                      padding: EdgeInsets.symmetric(horizontal: _mostrarTraduccion ? 10.0 : 0.0),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _mostrarTraduccion ? Colors.orange : Colors.transparent,
                          width: _mostrarTraduccion ? 1.5 : 0,
                        ),
                      ),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: _mostrarTraduccion ? 1.0 : 0.0,
                        child: ClipRect(
                          child: OverflowBox(
                            maxWidth: 250,
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ch\'ol: ${current.chol}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown.shade900,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Español: ${current.espanol}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown.shade800,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () => _reproducirAudio(current.pathAudio),
                      icon: const Icon(Icons.volume_up, size: 18),
                      label: const Text('Reproducir Audio', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
