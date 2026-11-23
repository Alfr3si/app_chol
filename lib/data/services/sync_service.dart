import 'dart:convert';
import 'package:http/http.dart' as http;

class SyncService {
  SyncService({required this.baseUrl});

  // Ejemplo local:
  // Emulador Android -> 'http://10.0.2.2:8080'
  // Celular físico en misma Wi-Fi -> 'http://TU_IP_LOCAL:8080'
  final String baseUrl;

  Future> sincronizar({
    required Map<String, dynamic> usuario,
    required List> actividades,
  }) async {
    final uri = Uri.parse('$baseUrl/sync.php');

    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: jsonEncode({
            'usuario': usuario,
            'actividades': actividades,
          }),
        )
        .timeout(const Duration(seconds: 15));

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200 || data['ok'] != true) {
      throw Exception(data['error'] ?? 'Error al sincronizar con el servidor.');
    }

    return data;
  }
}
