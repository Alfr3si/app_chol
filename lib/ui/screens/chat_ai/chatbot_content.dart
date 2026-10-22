import 'package:flutter/material.dart';

class ChatbotContent extends StatefulWidget {
  const ChatbotContent({super.key});

  @override
  State<ChatbotContent> createState() => _ChatbotContentState();
}

class _ChatbotContentState extends State<ChatbotContent> {
  final List<Map<String, String>> _mensajes = [
    {
      'remitente': 'bot',
      'texto':
          '¡Hola! Pregúntame lo que quieras sobre el vocabulario en Ch\'ol.',
    },
  ];

  final TextEditingController _controller = TextEditingController();

  void _enviarMensaje() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _mensajes.add({'remitente': 'usuario', 'texto': _controller.text});
      _mensajes.add({
        'remitente': 'bot',
        'texto': '¡Excelente pregunta! Lo estoy procesando.',
      });
    });

    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Título del Asistente ---
          const Text(
            'Asistente Ch\'ol',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 8),

          // --- Lista de Mensajes ---
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                itemCount: _mensajes.length,
                itemBuilder: (context, index) {
                  final msg = _mensajes[index];
                  final esUsuario = msg['remitente'] == 'usuario';

                  return Align(
                    alignment: esUsuario
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: ConstrainedBox(
                        // Máximo 75% del ancho disponible, mínimo para que se vea la burbuja
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.3,
                          minWidth: 200,
                          minHeight: 400,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                esUsuario
                                    ? 'assets/images/background/chat_bubble_right.webp'
                                    : 'assets/images/background/chat_bubble_left.webp',
                              ),
                              fit: BoxFit.fill,
                              // Si tu imagen tiene bordes/colitas, usa centerSlice (ver abajo)
                            ),
                          ),
                          padding: EdgeInsets.fromLTRB(
                            esUsuario ? 16 : 28,
                            10,
                            esUsuario ? 28 : 16,
                            10,
                          ),
                          child: Text(
                            msg['texto'] ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 8),

          // --- Campo de Texto e Input ---
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Escribe un mensaje...',
                    hintStyle: const TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                    ),
                    filled: true,
                    fillColor: Colors.black38,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  onSubmitted: (_) => _enviarMensaje(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _enviarMensaje,
                icon: const Icon(Icons.send, color: Colors.white, size: 18),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.all(10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
