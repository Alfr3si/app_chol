import 'dart:convert'; // Importante para decodificar los JSON
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatbotRemoteDatasource {
  GenerativeModel? _model;
  ChatSession? _chatSession;
  bool _isInitialized = false;

  /// Inicializa el modelo extrayendo solo los pares de traducción en texto plano
  Future<void> initialize() async {
    if (_isInitialized) return;

    final modulePaths = [
      'assets/data/module_1_familia.json',
      'assets/data/module_2_dondeVivo.json',
      'assets/data/module_3_escuela.json',
      'assets/data/module_4_gustosYpasatiempos.json',
      'assets/data/module_5_miCuerpo.json',
    ];

    StringBuffer combinedCorpus = StringBuffer();

    for (String path in modulePaths) {
      try {
        final jsonString = await rootBundle.loadString(path);
        final Map<String, dynamic> jsonData = jsonDecode(jsonString);

        final nombreModulo = jsonData['nombre_modulo'] ?? '';
        combinedCorpus.writeln('--- Módulo: $nombreModulo ---');

        // Procesar muestras léxicas (Vocabulario)
        final List<dynamic> lexicas = jsonData['muestras_lexicas'] ?? [];
        for (var item in lexicas) {
          final es = item['espanol'] ?? '';
          final chol = item['chol'] ?? '';
          combinedCorpus.writeln('$es -> $chol');
        }

        // Procesar muestras sintácticas (Frases y Oraciones)
        final List<dynamic> sintacticas = jsonData['muestras_sintacticas'] ?? [];
        for (var item in sintacticas) {
          final es = item['espanol'] ?? '';
          final chol = item['chol'] ?? '';
          combinedCorpus.writeln('$es -> $chol');
        }
        
        combinedCorpus.writeln(''); // Espacio limpio entre módulos
      } catch (e) {
        print('Error al procesar el archivo de corpus: $path -> $e');
      }
    }

    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw Exception('La GEMINI_API_KEY no está configurada en el archivo .env');
    }

    // Construimos el modelo con un corpus ultraligero y limpio
    _model = GenerativeModel(
      model: 'gemini-3.5-flash-lite',
      apiKey: apiKey,
      systemInstruction: Content.text(
        '''
Eres el asistente lingüístico oficial de Cho'lApp, enfocado exclusivamente en rescatar, preservar y enseñar la lengua indígena Ch'ol hablada en Tabasco, México (Tacotalpa y la Sierra).

REGLA CRÍTICA DE CERO TOLERANCIA A ALUCINACIONES:
1. Tu base de conocimiento oficial es estrictamente el siguiente diccionario de traducciones directas:

$combinedCorpus

2. Debes responder basándote estrictamente en este vocabulario y frases anteriores.
3. FLEXIBILIDAD DE BÚSQUEDA: Ignora mayúsculas, minúsculas, tildes y busca coincidencias por prefijos o fragmentos (ej. "pap" para "papá"). Si encuentras una coincidencia cercana, indícalo amablemente al usuario.
4. Está estrictamente prohibido inventar o suponer traducciones que no estén documentadas aquí.
5. Mantén tus respuestas educativas, amigables, orientadas a niños de primaria y sumamente concisas.
''',
      ),
    );

    _chatSession = _model!.startChat();
    _isInitialized = true;
  }

  /// Envía un mensaje al chatbot asegurando que el modelo esté inicializado
  Future<String> sendMessage(String prompt) async {
    try {
      if (!_isInitialized || _chatSession == null) {
        await initialize();
      }

      final response = await _chatSession!.sendMessage(Content.text(prompt));
      return response.text ?? 'No se pudo generar una respuesta.';
    } catch (e) {
      final errorStr = e.toString();
      if (errorStr.contains('503') || errorStr.contains('high demand') || errorStr.contains('UNAVAILABLE')) {
        return '¡El asistente Ch\'ol está descansando un momento por alta demanda! Inténtalo de nuevo en unos segundos. 🌿';
      }
      return 'Error de conexión con el asistente: $e';
    }
  }
}
