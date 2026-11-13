// lib/modules/modulo1/components/actividad_relacionar.dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../domain/models/item_vocabulario.dart';

class ActividadRelacionar extends StatefulWidget {
  final String tituloActividad;
  final List<ItemVocabulario> listaItems;
  final String backgroundImage;

  const ActividadRelacionar({
    super.key,
    required this.tituloActividad,
    required this.listaItems,
    required this.backgroundImage,
  });

  @override
  State<ActividadRelacionar> createState() => _ActividadRelacionarState();
}

class _ActividadRelacionarState extends State<ActividadRelacionar> {
  late List<ItemVocabulario> _poolItems;
  List<ItemVocabulario> _currentPairItems = []; // 4 items por ronda
  
  String? _selectedEspanol;
  String? _selectedChol;
  
  bool? _isLastAttemptCorrect;
  
  final Set<String> _matchedChol = {};
  int _currentIndex = 0;
  bool _isLoading = true;

  List<String> _columnEspanol = [];
  List<String> _columnChol = [];

  @override
  void initState() {
    super.initState();
    // Usamos directamente todos los items que recibe (ya vienen filtrados desde el contenedor)
    _poolItems = List.from(widget.listaItems)..shuffle();
    _prepararRonda();
  }

  void _prepararRonda() {
    if (_poolItems.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }

    int endIndex = (_currentIndex + 4 < _poolItems.length) ? _currentIndex + 4 : _poolItems.length;
    _currentPairItems = _poolItems.sublist(_currentIndex, endIndex);
    _matchedChol.clear();
    _selectedEspanol = null;
    _selectedChol = null;
    _isLastAttemptCorrect = null;

    _columnEspanol = _currentPairItems.map((e) => e.espanol).toList()..shuffle();
    _columnChol = _currentPairItems.map((e) => e.chol).toList()..shuffle();

    setState(() {
      _isLoading = false;
    });
  }

  void _verificarSeleccion() {
    if (_selectedEspanol == null || _selectedChol == null) return;

    final match = _currentPairItems.firstWhere(
      (item) => item.espanol == _selectedEspanol && item.chol == _selectedChol,
      orElse: () => ItemVocabulario(espanol: '', chol: ''),
    );

    setState(() {
      if (match.espanol.isNotEmpty) {
        _isLastAttemptCorrect = true;
        _matchedChol.add(_selectedChol!);

        Future.delayed(const Duration(milliseconds: 400), () {
          if (!mounted) return;
          setState(() {
            _selectedEspanol = null;
            _selectedChol = null;
            _isLastAttemptCorrect = null;

            if (_matchedChol.length == _currentPairItems.length) {
              Future.delayed(const Duration(milliseconds: 400), () {
                if (!mounted) return;
                if (_currentIndex + 4 < _poolItems.length) {
                  setState(() {
                    _currentIndex += 4;
                    _prepararRonda();
                  });
                } else {
                  _mostrarDialogoVictoria();
                }
              });
            }
          });
        });
      } else {
        _isLastAttemptCorrect = false;

        Future.delayed(const Duration(milliseconds: 600), () {
          if (!mounted) return;
          setState(() {
            _selectedEspanol = null;
            _selectedChol = null;
            _isLastAttemptCorrect = null;
          });
        });
      }
    });
  }

  void _mostrarDialogoVictoria() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.brown.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text(
          '🎉 ¡Actividad Completada!',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: const Text(
          '¡Has relacionado exitosamente todo el vocabulario!',
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
    if (_isLoading || _currentPairItems.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAF3E0),
        appBar: AppBar(backgroundColor: Colors.brown.shade800, title: const Text('Cargando actividad...')),
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '🔗 Relaciona la palabra en Español con su significado en Ch\'ol',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Row(
                    children: [
                      // --- Columna ESPAÑOL ---
                      Expanded(
                        child: ListView(
                          children: _columnEspanol.map((espanol) {
                            final bool isMatched = _currentPairItems.any(
                              (item) => item.espanol == espanol && _matchedChol.contains(item.chol),
                            );
                            final bool isSelected = _selectedEspanol == espanol;

                            Color colorFondo = Colors.grey.shade900;
                            Color colorBorde = Colors.blueAccent.shade200;

                            if (isMatched) {
                              colorFondo = Colors.green.shade800;
                              colorBorde = Colors.greenAccent;
                            } else if (isSelected) {
                              if (_isLastAttemptCorrect == true) {
                                colorFondo = Colors.green.shade700;
                                colorBorde = Colors.greenAccent;
                              } else if (_isLastAttemptCorrect == false) {
                                colorFondo = Colors.red.shade800;
                                colorBorde = Colors.redAccent;
                              } else {
                                colorFondo = Colors.orange.shade700;
                                colorBorde = Colors.orangeAccent;
                              }
                            }

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorFondo,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: colorFondo,
                                  disabledForegroundColor: Colors.white,
                                  elevation: 3,
                                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(color: colorBorde, width: 1.8),
                                  ),
                                ),
                                onPressed: (isMatched || _isLastAttemptCorrect != null)
                                    ? () {}
                                    : () {
                                        setState(() {
                                          _selectedEspanol = espanol;
                                        });
                                        _verificarSeleccion();
                                      },
                                child: Text(
                                  espanol,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // --- Columna CH'OL ---
                      Expanded(
                        child: ListView(
                          children: _columnChol.map((chol) {
                            final bool isMatched = _matchedChol.contains(chol);
                            final bool isSelected = _selectedChol == chol;

                            Color colorFondo = Colors.grey.shade900;
                            Color colorBorde = Colors.purpleAccent.shade200;

                            if (isMatched) {
                              colorFondo = Colors.green.shade800;
                              colorBorde = Colors.greenAccent;
                            } else if (isSelected) {
                              if (_isLastAttemptCorrect == true) {
                                colorFondo = Colors.green.shade700;
                                colorBorde = Colors.greenAccent;
                              } else if (_isLastAttemptCorrect == false) {
                                colorFondo = Colors.red.shade800;
                                colorBorde = Colors.redAccent;
                              } else {
                                colorFondo = Colors.orange.shade700;
                                colorBorde = Colors.orangeAccent;
                              }
                            }

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorFondo,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: colorFondo,
                                  disabledForegroundColor: Colors.white,
                                  elevation: 3,
                                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(color: colorBorde, width: 1.8),
                                  ),
                                ),
                                onPressed: (isMatched || _isLastAttemptCorrect != null)
                                    ? () {}
                                    : () {
                                        setState(() {
                                          _selectedChol = chol;
                                        });
                                        _verificarSeleccion();
                                      },
                                child: Text(
                                  chol,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            );
                          }).toList(),
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
