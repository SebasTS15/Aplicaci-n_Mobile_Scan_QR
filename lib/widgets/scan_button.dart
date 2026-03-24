import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/pages/qr_scanner_page.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/providers/sesion_provider.dart';
import 'package:qr_reader/utils/utils.dart';
import 'package:geolocator/geolocator.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 8,
      highlightElevation: 12,
      backgroundColor: const Color.fromARGB(255, 4, 203, 183),
      foregroundColor: Colors.white,
      tooltip: 'Escanear QR',
      child: const Icon(Icons.filter_center_focus, size: 32),
      onPressed: () async {
        final sesion = Provider.of<SesionProvider>(context, listen: false);

        if (!sesion.isLoggedIn) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Por favor, inicia sesión para escanear códigos QR'),
              duration: Duration(seconds: 2),
            ),
          );

          Navigator.pushNamed(context, 'login');
          return;
        }

        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const QRScannerPage()),
        );

        if (result == null || result == '-1') return;

        try {
          Position position = await getCurrentLocation();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'QR detectado: $result\nUbicación: ${position.latitude}, ${position.longitude}',
              ),
              backgroundColor: const Color(0xFF00897B),
            ),
          );

          final scanListProvider =
              Provider.of<ScanListProvider>(context, listen: false);

          final nuevoScan = await scanListProvider.nuevoScan(result);

          launchURL(context, nuevoScan);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al obtener ubicación: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Servicios de ubicación deshabilitados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permisos de ubicación denegados');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Permisos de ubicación permanentemente denegados');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
