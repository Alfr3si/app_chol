import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../../game_canvas/menu_game.dart';
import 'profile_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileViewModel _viewModel;
  late final TextEditingController _aliasController;

  @override
  void initState() {
    super.initState();
    _viewModel = ProfileViewModel();
    _aliasController = TextEditingController(text: _viewModel.profile.alias);
  }

  @override
  void dispose() {
    _aliasController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. FONDO DE FLAME DEL HOMESCREEN
          GameWidget(game: MenuGame(backgroundAsset: 'background/fondo_modulos.webp')),

          // 2. CAPA SUPERIOR CON LA INFORMACIÓN DEL PERFIL
          SafeArea(
            child: ListenableBuilder(
              listenable: _viewModel,
              builder: (context, child) {
                final profile = _viewModel.profile;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: SingleChildScrollView(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- COLUMNA IZQUIERDA: AVATAR Y DATOS DE USUARIO ---
                        Container(
                          width: 220,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            // Sustituido por tu imagen de fondo
                            image: const DecorationImage(
                              image: AssetImage('assets/image/background/fondo_tabloide.webp'), // Cambia por tu ruta de imagen si es otra
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.orange.shade400, width: 3),
                                  image: DecorationImage(
                                    image: AssetImage(profile.avatarPath),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                profile.alias,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                  shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                profile.ageRange,
                                style: const TextStyle(color: Colors.white70, fontSize: 13, shadows: [Shadow(color: Colors.black, blurRadius: 2)]),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade900,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  profile.rankTitle,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 24),

                        // --- COLUMNA DERECHA: PROGRESO, INSIGNIAS Y CONFIGURACIÓN ---
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              // Sustituido por tu imagen de fondo
                              image: const DecorationImage(
                                image: AssetImage('assets/image/background/fondo_tabloide.webp'), // Cambia por tu ruta de imagen si es otra
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // --- CABECERA INTEGRADA: TÍTULO / CONTENIDO Y BOTÓN SALIR ---
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Mi Avance',
                                      style: TextStyle(
                                        color: Colors.orangeAccent,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        shadows: [Shadow(color: Colors.black, blurRadius: 3)],
                                      ),
                                    ),
                                    // Botón de salida
                                    GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage('assets/image/elements/button_x.webp'),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${profile.completedThemes}/16 Temas completados',
                                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: profile.completedThemes / 16,
                                    minHeight: 12,
                                    backgroundColor: Colors.black54,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.shade600),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Insignias
                                const Text(
                                  'Mis Insignias',
                                  style: TextStyle(
                                    color: Colors.orangeAccent,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    shadows: [Shadow(color: Colors.black, blurRadius: 3)],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _buildInsigniaChip('Familia', Icons.home, profile.unlockedInsignias.contains('Familia')),
                                    _buildInsigniaChip('Donde Vivo', Icons.public, profile.unlockedInsignias.contains('Donde Vivo')),
                                    _buildInsigniaChip('Escuela', Icons.school, profile.unlockedInsignias.contains('Escuela')),
                                    _buildInsigniaChip('Gustos', Icons.palette, profile.unlockedInsignias.contains('Gustos')),
                                    _buildInsigniaChip('Mi Cuerpo', Icons.person, profile.unlockedInsignias.contains('Mi Cuerpo')),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // Campo de texto Alias
                                TextField(
                                  controller: _aliasController,
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                  decoration: InputDecoration(
                                    labelText: 'Alias (Visible)',
                                    labelStyle: const TextStyle(color: Colors.white70, fontSize: 13),
                                    filled: true,
                                    fillColor: Colors.black54,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: const BorderSide(color: Colors.orangeAccent, width: 1.5),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(color: Colors.orange.shade800, width: 1.5),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  ),
                                  onChanged: (value) {
                                    _viewModel.updateProfile(alias: value);
                                  },
                                ),
                                const SizedBox(height: 24),

                                // Botones de acción inferiores
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: _viewModel.isLoading
                                            ? null
                                            : () async {
                                                await _viewModel.saveChanges();
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('¡Cambios guardados con éxito!')),
                                                  );
                                                }
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.teal.shade700,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                        ),
                                        child: _viewModel.isLoading
                                            ? const SizedBox(
                                                width: 18,
                                                height: 18,
                                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                              )
                                            : const Text('Guardar Cambios', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          _viewModel.resetProgress();
                                          _aliasController.text = _viewModel.profile.alias;
                                        },
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(color: Colors.white54, width: 1.5),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                        ),
                                        child: const Text('Reiniciar', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsigniaChip(String label, IconData icon, bool unlocked) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: unlocked ? Colors.orange.shade800 : Colors.black54,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: unlocked ? Colors.orange.shade300 : Colors.white24,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: unlocked ? Colors.white : Colors.white54),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: unlocked ? Colors.white : Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
