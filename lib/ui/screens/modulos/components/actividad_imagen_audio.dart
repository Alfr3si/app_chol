// lib/modules/modulo1/components/actividad_imagen_audio.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import '../../../../domain/models/item_vocabulario.dart';

class ActividadImagenAudio extends StatefulWidget {
  final String tituloActividad;
  final List<ItemVocabulario> listaItems;
  final String backgroundImage;

  const ActividadImagenAudio({
    super.key,
    required this.tituloActividad,
    required this.listaItems,
    required this.backgroundImage,
  });

  @override
  State<ActividadImagenAudio> createState() => _ActividadImagenAudioState();
}

class _ActividadImagenAudioState extends State<ActividadImagenAudio>
    with SingleTickerProviderStateMixin {
  late List<ItemVocabulario> _activeQueue;
  final List<ItemVocabulario> _failedQueue = [];

  int _currentIndex = 0;
  bool _isReviewRound = false;

  List<String> _opcionesActuales = [];
  String? _selectedAnswer;
  bool? _isAnswerCorrect;
  int _intentosRestantes = 2;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Filtro flexible: acepta elementos con texto válido en Ch'ol y Español
    _activeQueue = List.from(
      widget.listaItems.where((item) => 
        item.chol.isNotEmpty && 
        item.espanol.isNotEmpty
      ),
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
    } catch (e) {
      debugPrint('Error al reproducir audio: $e');
    }
  }

  void _prepararPregunta() {
    if (_activeQueue.isEmpty) return;

    final current = _activeQueue[_currentIndex];
    final random = Random();

    List<String> opcionesFalsas = widget.listaItems
        .where((item) => item.chol != current.chol)
        .map((item) => item.chol)
        .toList()
      ..shuffle(random);

    _opcionesActuales = [
      current.chol,
      if (opcionesFalsas.isNotEmpty) opcionesFalsas[0],
      if (opcionesFalsas.length > 1) opcionesFalsas[1],
      if (opcionesFalsas.length > 2) opcionesFalsas[2],
    ]..shuffle(random);

    _selectedAnswer = null;
    _isAnswerCorrect = null;
    _intentosRestantes = 2;

    if (current.pathAudio != null && current.pathAudio!.isNotEmpty) {
      _reproducirAudio(current.pathAudio);
    }

    _animationController.forward(from: 0.0);
  }

  void _verificarRespuesta(String seleccion) {
    if (_isAnswerCorrect == true) return;

    final current = _activeQueue[_currentIndex];
    final bool esCorrecto = (seleccion == current.chol);

    setState(() {
      _selectedAnswer = seleccion;
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
              _selectedAnswer = null;
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
          '¡Has completado con éxito este desafío visual y auditivo!',
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
                    'Ronda ${_currentIndex + 1} de ${_activeQueue.length} (Intentos: $_intentosRestantes)',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: ScaleTransition(
                                scale: _scaleAnimation,
                                child: Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.orangeAccent, width: 2.5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.4),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(13.5),
                                    child: current.pathImagen != null && current.pathImagen!.isNotEmpty
                                        ? Image.asset(
                                            current.pathImagen!,
                                            fit: BoxFit.contain,
                                            errorBuilder: (context, error, stackTrace) =>
                                                const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                                          )
                                        : Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                current.espanol,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 12,
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
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.orange, width: 1.2),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    current.espanol,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.brown.shade900),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (current.pathAudio != null && current.pathAudio!.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    SizedBox(
                                      height: 28,
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange.shade700,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
                                        onPressed: () => _reproducirAudio(current.pathAudio),
                                        icon: const Icon(Icons.volume_up, size: 14),
                                        label: const Text('Escuchar', style: TextStyle(fontSize: 10)),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 5,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _opcionesActuales.length,
                          itemBuilder: (context, index) {
                            final opcion = _opcionesActuales[index];
                            final bool isSelected = (_selectedAnswer == opcion);

                            Color colorFondo = Colors.grey.shade900;
                            Color colorBorde = Colors.blueAccent.shade200;

                            if (isSelected) {
                              if (_isAnswerCorrect == true) {
                                colorFondo = Colors.green.shade800;
                                colorBorde = Colors.greenAccent;
                              } else {
                                colorFondo = Colors.red.shade800;
                                colorBorde = Colors.redAccent;
                              }
                            }

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: SizedBox(
                                height: 42,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colorFondo,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: colorFondo,
                                    disabledForegroundColor: Colors.white,
                                    elevation: 2,
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(color: colorBorde, width: 1.5),
                                    ),
                                  ),
                                  onPressed: _isAnswerCorrect == true
                                      ? () {}
                                      : () => _verificarRespuesta(opcion),
                                  child: Text(
                                    opcion,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
