import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../domain/models/item_vocabulario.dart';

class ActividadGenericaScreen extends StatefulWidget {
  final String tituloActividad;
  final List<ItemVocabulario> listaItems;
  final String backgroundImage;

  const ActividadGenericaScreen({
    super.key,
    required this.tituloActividad,
    required this.listaItems,
    required this.backgroundImage,
  });

  @override
  State<ActividadGenericaScreen> createState() => _ActividadGenericaScreenState();
}

class _ActividadGenericaScreenState extends State<ActividadGenericaScreen>
    with SingleTickerProviderStateMixin {
  late List<ItemVocabulario> _activeQueue;
  final List<ItemVocabulario> _failedQueue = [];

  int _currentIndex = 0;
  bool _isReviewRound = false;

  List<String> _opcionesActuales = [];
  String? _selectedAnswer;
  bool? _isAnswerCorrect;

  // 🎬 Controladores de animación
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _activeQueue = List.from(widget.listaItems)..shuffle();

    // Inicializamos el controlador de animaciones (duración de 300 milisegundos)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

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

    // Disparamos la animación cada vez que cambia la pregunta
    _animationController.forward(from: 0.0);
  }

  void _verificarRespuesta(String seleccion) {
    if (_isAnswerCorrect != null) return;

    final current = _activeQueue[_currentIndex];
    final bool esCorrecto = (seleccion == current.chol);

    setState(() {
      _selectedAnswer = seleccion;
      _isAnswerCorrect = esCorrecto;

      if (!esCorrecto) {
        if (!_failedQueue.contains(current)) {
          _failedQueue.add(current);
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
          '¡Has completado con éxito este desafío de aprendizaje!',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.orange)),
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
          child: Stack(
            children: [
              // Contenido principal animado con Fade y Scale
              Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Indicador superior mini
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _isReviewRound ? '🔄 Ronda de repaso de errores' : '💬 Elige la traducción correcta:',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: _isReviewRound ? Colors.orangeAccent : Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Tarjeta superior (Pregunta)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              border: Border.all(color: Colors.orangeAccent, width: 1.5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.school_outlined, color: Colors.orangeAccent, size: 18),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    current.espanol,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Cuadrícula 2x2 de respuestas
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _opcionesActuales.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 4.8,
                            ),
                            itemBuilder: (context, index) {
                              final opcion = _opcionesActuales[index];
                              
                              Color colorFondo = Colors.grey.shade900.withOpacity(0.85);
                              Color colorBorde = Colors.blueAccent.shade200;
                              Color colorTexto = Colors.white;

                              if (_selectedAnswer != null) {
                                if (opcion == current.chol) {
                                  colorFondo = Colors.green.shade900.withOpacity(0.95);
                                  colorBorde = Colors.greenAccent;
                                  colorTexto = Colors.white;
                                } else if (opcion == _selectedAnswer) {
                                  colorFondo = Colors.red.shade900.withOpacity(0.95);
                                  colorBorde = Colors.redAccent;
                                  colorTexto = Colors.white;
                                }
                              }

                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorFondo,
                                  foregroundColor: colorTexto,
                                  elevation: 1,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: BorderSide(color: colorBorde, width: 1.2),
                                  ),
                                ),
                                onPressed: () => _verificarRespuesta(opcion),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: Text(
                                      opcion,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.bold,
                                        color: colorTexto,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 🎯 CUADRO FLOTANTE CENTRADO CON ANIMACIÓN DE APARICIÓN
              if (_selectedAnswer != null)
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                    child: Center(
                      child: Container(
                        width: 260,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _isAnswerCorrect == true 
                              ? Colors.green.shade900.withOpacity(0.95) 
                              : Colors.red.shade900.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _isAnswerCorrect == true ? Colors.greenAccent : Colors.redAccent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isAnswerCorrect == true ? Icons.check_circle_rounded : Icons.cancel_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _isAnswerCorrect == true ? '¡Correcto!' : '¡Incorrecto!',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 14),
                            SizedBox(
                              width: double.infinity,
                              height: 38,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: _isAnswerCorrect == true ? Colors.green.shade900 : Colors.red.shade900,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                ),
                                onPressed: _siguientePaso,
                                child: const Text(
                                  'Continuar',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
