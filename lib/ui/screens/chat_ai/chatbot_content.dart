import 'package:flutter/material.dart';
import 'chatbot_viewmodel.dart';

class ChatbotContent extends StatefulWidget {
  const ChatbotContent({super.key});

  @override
  State<ChatbotContent> createState() => _ChatbotContentState();
}

class _ChatbotContentState extends State<ChatbotContent> {
  // Instanciamos el ViewModel
  late final ChatbotViewModel _viewModel;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _viewModel = ChatbotViewModel();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _enviarMensaje() {
    if (_controller.text.trim().isEmpty) return;
    
    final texto = _controller.text;
    _controller.clear();

    // Enviamos el mensaje a través del ViewModel
    _viewModel.sendMessage(texto).then((_) {
      // Opcional: auto-scroll hacia abajo al recibir la respuesta
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Lista de Mensajes Reactiva ---
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  itemCount: _viewModel.messages.length,
                  itemBuilder: (context, index) {
                    final msg = _viewModel.messages[index];
                    final esUsuario = msg.isUser;

                    return Align(
                      alignment: esUsuario
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 60,
                            maxWidth: MediaQuery.of(context).size.width * 0.65,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14.0,
                              vertical: 10.0,
                            ),
                            decoration: BoxDecoration(
                              color: esUsuario
                                  ? Colors.orange.shade700
                                  : Colors.blueGrey.shade800.withOpacity(0.95),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: Radius.circular(esUsuario ? 16 : 4),
                                bottomRight: Radius.circular(esUsuario ? 4 : 16),
                              ),
                            ),
                            child: Text(
                              msg.text,
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

              // Indicador visual opcional si la IA está redactando
              if (_viewModel.isLoading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'El asistente está consultando el vocabulario...',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 8),

              // --- Campo de Texto e Input ---
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: !_viewModel.isLoading,
                      decoration: InputDecoration(
                        hintText: _viewModel.isLoading
                            ? 'Esperando respuesta...'
                            : 'Escribe un mensaje...',
                        hintStyle: const TextStyle(
                          color: Colors.white60,
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: Colors.black45,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      onSubmitted: (_) => _enviarMensaje(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _viewModel.isLoading ? null : _enviarMensaje,
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.all(10),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
