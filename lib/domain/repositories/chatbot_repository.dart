abstract class ChatbotRepository {
  /// Envía un mensaje o pregunta al asistente y devuelve la respuesta generada
  Future<String> getResponse(String prompt);
}
