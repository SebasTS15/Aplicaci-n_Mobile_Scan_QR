import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/deleted_scans_provider.dart';
import 'package:intl/intl.dart';

class PapeleraPage extends StatefulWidget {
  const PapeleraPage({super.key});

  @override
  State<PapeleraPage> createState() => _PapeleraPageState();
}

class _PapeleraPageState extends State<PapeleraPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<DeletedScansProvider>(context, listen: false)
          .cargarScansEliminados();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeletedScansProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Papelera', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
            centerTitle: true,
            backgroundColor: const Color(0xFF00897B),
            elevation: 0,
            actions: [
              if (provider.deletedScans.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_sweep, color: Colors.white),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: const Text('¿Vaciar papelera?'),
                        content: const Text(
                            'Esta acción eliminará permanentemente todos los registros.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancelar', style: TextStyle(color: Color.fromARGB(255, 0, 157, 115))),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await provider.vaciarPapelera();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Papelera vaciada'),
                            backgroundColor: const Color(0xFF00897B),
                          ),
                        );
                      }
                    }
                  },
                ),
            ],
          ),
          body: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : provider.deletedScans.isEmpty
                  ? _EmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: provider.deletedScans.length,
                      itemBuilder: (context, index) {
                        final scan = provider.deletedScans[index];
                        final deletedAt = DateTime.parse(scan['deleted_at']);
                        final formattedDate = DateFormat('dd/MM/yyyy HH:mm')
                            .format(deletedAt);

                        return _DeletedScanCard(
                          scan: scan,
                          formattedDate: formattedDate,
                          provider: provider,
                        );
                      },
                    ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF00897B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.delete_outline,
              size: 80,
              color: const Color(0xFF00897B).withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Papelera vacía',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Los escaneos eliminados aparecerán aquí',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeletedScanCard extends StatelessWidget {
  final Map<String, dynamic> scan;
  final String formattedDate;
  final DeletedScansProvider provider;

  const _DeletedScanCard({
    required this.scan,
    required this.formattedDate,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _getIconByScanType(scan['content']),
            color: Colors.red.shade400,
            size: 24,
          ),
        ),
        title: Text(
          scan['content'] ?? 'Sin contenido',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Eliminado: $formattedDate',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: Colors.grey[400]),
          onSelected: (value) async {
            if (value == 'delete') {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: const Text('¿Eliminar permanentemente?'),
                  content: const Text('Esta acción no se puede deshacer.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar', style: TextStyle(color: Color.fromARGB(255, 0, 157, 115))),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Eliminar',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                final success = await provider
                    .eliminarPermanentemente(scan['id']);
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Eliminado permanentemente'),
                      backgroundColor: const Color(0xFF00897B),
                    ),
                  );
                }
              }
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red.shade400, size: 20),
                  const SizedBox(width: 12),
                  const Text('Eliminar permanentemente',
                      style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconByScanType(String content) {
    if (content.startsWith('http://') || content.startsWith('https://')) {
      return Icons.language;
    } else if (content.startsWith('geo:')) {
      return Icons.location_on;
    } else {
      return Icons.qr_code;
    }
  }
}
