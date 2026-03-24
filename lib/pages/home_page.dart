import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/pages/direcciones_page.dart';
import 'package:qr_reader/pages/mapas_page.dart';
import 'package:qr_reader/pages/otras_opciones_page.dart';
import 'package:qr_reader/pages/papelera_page.dart';
import 'package:qr_reader/providers/deleted_scans_provider.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/providers/sesion_provider.dart';
import 'package:qr_reader/providers/ui_provider.dart';
import 'package:qr_reader/widgets/custom_navigatorbar.dart';
import 'package:qr_reader/widgets/scan_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sesion = Provider.of<SesionProvider>(context, listen: false);
      if (!sesion.isLoggedIn) {
        Navigator.pushReplacementNamed(context, 'login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sesion = Provider.of<SesionProvider>(context);

    if (!sesion.isLoggedIn) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text('Historial', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22, color: Colors.white)),
        centerTitle: false,
        backgroundColor: const Color(0xFF00897B),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white, size: 24),
            tooltip: 'Ver papelera',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (_) => DeletedScansProvider(),
                    child: const PapeleraPage(),
                  ),
                ),
              );
            },
          ),
          if (sesion.isLoggedIn)
            PopupMenuButton<String>(
              icon: const Icon(Icons.account_circle, color: Colors.white, size: 26),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onSelected: (value) {
                if (value == 'logout') {
                  sesion.cerrarSesion();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sesión cerrada correctamente')),
                  );
                  Navigator.pushReplacementNamed(context, 'login');
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  enabled: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sesion.nombreUsuario ?? 'Usuario',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        sesion.correoUsuario ?? '',
                        style: const TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Color(0xFFFF6F00)),
                      SizedBox(width: 8),
                      Text('Cerrar sesión'),
                    ],
                  ),
                ),
              ],
            ),
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Color.fromARGB(255, 255, 255, 255)),
            tooltip: 'Eliminar historial',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('¿Eliminar todo el historial?'),
                  content: const Text(
                      'Esta acción eliminará todos los registros de forma permanente.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar', style: TextStyle(color:  Color.fromARGB(255, 17, 192, 175))),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Eliminar', style: TextStyle(color: Color(0xFFFF6F00))),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                Provider.of<ScanListProvider>(context, listen: false)
                    .borrarTodos();
              }
            },
          ),
        ],
      ),
      body: const _HomePageBody(),
      bottomNavigationBar: const CustomNavigatorbar(),
      floatingActionButton: const ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _HomePageBody extends StatelessWidget {
  const _HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiProvider>(context);
    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);

    final currentIndex = uiProvider.selectedMenuOpt;

    switch (currentIndex) {
      case 0:
        scanListProvider.cargarScanPorTipo('geo');
        return const MapasPage();
      case 1:
        scanListProvider.cargarScanPorTipo('http');
        return const DireccionesPage();
      case 2:
        scanListProvider.cargarScanPorTipo('otro');
        return const OtraPage();
      default:
        return const MapasPage();
    }
  }
}
