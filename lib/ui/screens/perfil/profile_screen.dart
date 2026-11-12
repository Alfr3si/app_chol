import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 0;
  final ScrollController _syncScrollController = ScrollController();
  
  bool _isSyncing = false;
  String _lastSyncTime = "Hoy a las 10:30 AM";

  static const Color _bgBlack = Color(0xFF121212);
  static const Color _cardBlack = Color(0xFF1E1E1E);
  static const Color _orangePrimary = Color(0xFFFF7A00);
  static const Color _pureWhite = Color(0xFFFFFFFF);
  static const Color _grayText = Color(0xFFB3B3B3);

  @override
  void dispose() {
    _syncScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> profileViews = [
      _buildGeneralInfoView(),
      _buildStatisticsView(),
      _buildAccountManagementView(), // 👈 Sustituido por Administración de Cuenta / Sincronización
    ];

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo estático idéntico al de ExploraScreen
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/background/fondo2.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Capa superior con la barra de navegación lateral y el contenido activo
          SafeArea(
            child: Row(
              children: [
                // Panel Izquierdo: NavigationRail
                Container(
                  width: 110,
                  color: _bgBlack.withOpacity(0.85),
                  child: NavigationRail(
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (int index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    labelType: NavigationRailLabelType.all,
                    backgroundColor: Colors.transparent,
                    selectedIconTheme: const IconThemeData(color: _orangePrimary, size: 28),
                    unselectedIconTheme: const IconThemeData(color: _grayText, size: 22),
                    selectedLabelTextStyle: const TextStyle(
                      color: _orangePrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    unselectedLabelTextStyle: const TextStyle(
                      color: _grayText,
                      fontSize: 11,
                    ),
                    indicatorColor: _orangePrimary.withOpacity(0.2),
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.person_outline),
                        selectedIcon: Icon(Icons.person),
                        label: Text('Perfil'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.bar_chart_outlined),
                        selectedIcon: Icon(Icons.bar_chart),
                        label: Text('Progreso'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.cloud_sync_outlined),
                        selectedIcon: Icon(Icons.cloud_sync),
                        label: Text('Cuenta'),
                      ),
                    ],
                  ),
                ),

                const VerticalDivider(thickness: 2, width: 2, color: Color(0xFF2C2C2C)),

                // Panel Derecho: Renderiza la sección del perfil seleccionada
                Expanded(
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      title: Text(
                        _selectedIndex == 0
                            ? "Mi Perfil"
                            : _selectedIndex == 1
                                ? "Estadísticas y Progreso"
                                : "Administración de Cuenta",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: _pureWhite,
                          letterSpacing: 0.5,
                          shadows: [Shadow(color: Colors.black, blurRadius: 3)],
                        ),
                      ),
                      backgroundColor: _bgBlack.withOpacity(0.8),
                      elevation: 4,
                      iconTheme: const IconThemeData(color: _orangePrimary),
                    ),
                    body: IndexedStack(
                      index: _selectedIndex,
                      children: profileViews,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Vista 1: Información General del Perfil
  Widget _buildGeneralInfoView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _cardBlack.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _orangePrimary.withOpacity(0.5), width: 1),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: _orangePrimary,
                  child: Icon(Icons.person, size: 40, color: _pureWhite),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Usuario Ch'ol",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _pureWhite,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Explorador del conocimiento",
                        style: TextStyle(fontSize: 14, color: _grayText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Vista 2: Estadísticas de Progreso
  Widget _buildStatisticsView() {
    return const Center(
      child: Text(
        "Sección de Progreso y Estadísticas",
        style: TextStyle(color: _pureWhite, fontSize: 16),
      ),
    );
  }

  // Vista 3: Administración de Cuenta y Sincronización de Datos
  Widget _buildAccountManagementView() {
    return Scrollbar(
      controller: _syncScrollController,
      thumbVisibility: true,
      radius: const Radius.circular(8),
      child: SingleChildScrollView(
        controller: _syncScrollController,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta de Sincronización de Datos
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _cardBlack.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _orangePrimary.withOpacity(0.6), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.sync, color: _orangePrimary, size: 24),
                      SizedBox(width: 12),
                      Text(
                        "Sincronización con la Nube",
                        style: TextStyle(
                          color: _pureWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Mantén tu progreso y registros locales sincronizados de forma segura con el servidor PostgreSQL remoto.",
                    style: TextStyle(color: _grayText, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: _grayText),
                      const SizedBox(width: 8),
                      Text(
                        "Última sincronización: $_lastSyncTime",
                        style: const TextStyle(color: _grayText, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _orangePrimary,
                        foregroundColor: _pureWhite,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _isSyncing
                          ? null
                          : () {
                              setState(() {
                                _isSyncing = true;
                              });
                              // Simulación de proceso de sincronización asíncrona
                              Future.delayed(const Duration(seconds: 2), () {
                                setState(() {
                                  _isSyncing = false;
                                  _lastSyncTime = "Hace un momento";
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("¡Datos sincronizados correctamente con la nube!"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              });
                            },
                      icon: _isSyncing
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Icon(Icons.cloud_upload_outlined, size: 18),
                      label: Text(
                        _isSyncing ? "Sincronizando datos..." : "Sincronizar ahora",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tarjeta de Gestión de Datos Locales (Drift / Almacenamiento)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _cardBlack.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _grayText.withOpacity(0.3), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.storage_outlined, color: _orangePrimary, size: 24),
                      SizedBox(width: 12),
                      Text(
                        "Almacenamiento Local (Drift)",
                        style: TextStyle(
                          color: _pureWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Gestiona la base de datos local y los recursos multimedia almacenados en tu dispositivo.",
                    style: TextStyle(color: _grayText, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _pureWhite,
                      side: const BorderSide(color: _grayText),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Base de datos local verificada y optimizada.")),
                      );
                    },
                    icon: const Icon(Icons.cleaning_services_outlined, size: 18, color: _orangePrimary),
                    label: const Text("Optimizar base de datos local"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
