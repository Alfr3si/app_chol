import 'package:flutter/foundation.dart';
import '../../../domain/entities/chat_message.dart';
import '../../../domain/repositories/chatbot_repository.dart';
import '../../../data/repositories/chatbot_repository_impl.dart';

class ChatbotViewModel extends ChangeNotifier {
  final ChatbotRepository _repository;

  ChatbotViewModel({ChatbotRepository? repository})
      : _repository = repository ?? ChatbotRepositoryImpl();

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: '¡Hola! Pregúntame lo que quieras sobre el vocabulario y expresiones en Ch\'ol.',
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ];

  List<ChatMessage> get messages => _messages;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // 1. Agregar el mensaje del usuario a la lista local
    final userMessage = ChatMessage(
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );
    _messages.add(userMessage);
    notifyListeners();

    // 2. Activar indicador de que el bot está procesando
    _isLoading = true;
    notifyListeners();

    // 3. Consultar a la IA a través del repositorio
    final responseText = await _repository.getResponse(text.trim());

    // 4. Agregar la respuesta del bot a la lista
    final botMessage = ChatMessage(
      text: responseText,
      isUser: false,
      timestamp: DateTime.now(),
    );
    _messages.add(botMessage);

    // 5. Desactivar carga y notificar a la vista para redibujar
    _isLoading = false;
    notifyListeners();
  }
}
