import 'package:flutter/material.dart';

class CuentaSincronizacionTab extends StatefulWidget {
  final Color cardColor;
  final Color accentColor;
  final Color textPrimary;
  final Color textSecondary;

  const CuentaSincronizacionTab({
    super.key,
    required this.cardColor,
    required this.accentColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  State<CuentaSincronizacionTab> createState() =>
      _CuentaSincronizacionTabState();
}

class _CuentaSincronizacionTabState extends State<CuentaSincronizacionTab> {
  final ScrollController _syncScrollController = ScrollController();
  bool _isSyncing = false;
  String _lastSyncTime = "Pendiente de configurar";

  @override
  void dispose() {
    _syncScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.cardColor.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.accentColor.withValues(alpha: 0.6),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.sync, color: widget.accentColor, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        "Sincronización con la Nube",
                        style: TextStyle(
                          color: widget.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Preparado para sincronizar tu progreso y registros locales con tu servidor PostgreSQL cuando habilitemos el módulo de red.",
                    style: TextStyle(
                      color: widget.textSecondary,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 16, color: widget.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        "Estado: $_lastSyncTime",
                        style:
                            TextStyle(color: widget.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.accentColor,
                        foregroundColor: widget.textPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _isSyncing
                          ? null
                          : () {
                              setState(() => _isSyncing = true);
                              // Placeholder temporal hasta conectar la API/PostgreSQL
                              Future.delayed(const Duration(milliseconds: 600),
                                  () {
                                if (!mounted) return;
                                setState(() {
                                  _isSyncing = false;
                                  _lastSyncTime =
                                      "Sincronización pendiente (próximamente)";
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "La sincronización con el servidor se integrará en el siguiente paso.",
                                    ),
                                  ),
                                );
                              });
                            },
                      icon: _isSyncing
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: widget.textPrimary,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.cloud_upload_outlined, size: 18),
                      label: Text(
                        _isSyncing ? "Verificando..." : "Sincronizar con servidor",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.cardColor.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.textSecondary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.storage_outlined,
                        color: widget.accentColor,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Almacenamiento Local (Drift)",
                        style: TextStyle(
                          color: widget.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Tu avance se guarda localmente en SQLite/Drift sin necesidad de conexión a internet.",
                    style: TextStyle(
                      color: widget.textSecondary,
                      fontSize: 13,
                      height: 1.4,
                    ),
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
