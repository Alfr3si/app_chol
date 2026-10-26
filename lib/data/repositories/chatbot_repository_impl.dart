import '../../domain/repositories/chatbot_repository.dart';
import '../datasources/chatbot_remote_datasource.dart';

class ChatbotRepositoryImpl implements ChatbotRepository {
  final ChatbotRemoteDatasource _remoteDatasource;

  // Hacemos el parámetro opcional y asignamos una instancia por defecto si es null
  ChatbotRepositoryImpl({ChatbotRemoteDatasource? remoteDatasource})
      : _remoteDatasource = remoteDatasource ?? ChatbotRemoteDatasource();

  @override
  Future<String> getResponse(String prompt) async {
    try {
      // Delegamos la llamada al datasource remoto que ya maneja los JSON y la IA
      return await _remoteDatasource.sendMessage(prompt);
    } catch (e) {
      throw Exception('Error en el repositorio del chatbot: $e');
    }
  }
}
