import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:qr_reader/models/scan_model.dart'; // Ajusta el import si tu ruta es diferente

class MapaPage extends StatefulWidget {
  const MapaPage({super.key});

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final Completer<GoogleMapController> _controller = Completer();
  MapType mapType = MapType.normal;

  LatLng? currentPosition;
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};

  bool loadingRoute = false;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  // 📍 Obtener ubicación actual
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  // 🧭 Obtener ruta de Directions API
  Future<void> _getRoute(LatLng origin, LatLng destination) async {
  setState(() => loadingRoute = true);

  const apiKey = 'AIzaSyDQZ6vfLniJwM7ZoYOB5mHwldcCTvFrtEM'; // usa tu misma key
  final url = Uri.parse('https://routes.googleapis.com/directions/v2:computeRoutes');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': apiKey,
      'X-Goog-FieldMask': 'routes.polyline.encodedPolyline', // pedimos solo lo necesario
    },
    body: jsonEncode({
      'origin': {
        'location': {
          'latLng': {
            'latitude': origin.latitude,
            'longitude': origin.longitude,
          }
        }
      },
      'destination': {
        'location': {
          'latLng': {
            'latitude': destination.latitude,
            'longitude': destination.longitude,
          }
        }
      },
      'travelMode': 'DRIVE',
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data['routes'] != null && data['routes'].isNotEmpty) {
      final points = data['routes'][0]['polyline']['encodedPolyline'];
      final routeCoords = _decodePolyline(points);

      setState(() {
        polylines.clear();
        polylines.add(Polyline(
          polylineId: const PolylineId('route'),
          points: routeCoords,
          color: Colors.blue,
          width: 5,
        ));
        loadingRoute = false;
      });
    } else {
      setState(() => loadingRoute = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se encontró ninguna ruta.')),
      );
    }
  } else {
    print('❌ Error HTTP: ${response.statusCode}');
    print('🧾 Body: ${response.body}');
    setState(() => loadingRoute = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error al consultar la API de rutas.')),
    );
  }
}


  // 🧮 Decodificar polyline
  List<LatLng> _decodePolyline(String poly) {
    List<LatLng> points = [];
    int index = 0, len = poly.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    final scan = ModalRoute.of(context)!.settings.arguments as ScanModel;
    final destination = scan.getLatLng();

    final CameraPosition initialPosition = CameraPosition(
      target: destination,
      zoom: 15,
      tilt: 50,
    );

    if (currentPosition != null) {
      markers = {
        Marker(markerId: const MarkerId('origen'), position: currentPosition!),
        Marker(markerId: const MarkerId('destino'), position: destination),
      };
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ruta hacia destino'),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_searching),
            onPressed: () async {
              final controller = await _controller.future;
              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: destination, zoom: 15, tilt: 50),
                ),
              );
            },
          ),
        ],
      ),
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              mapType: mapType,
              myLocationEnabled: true,
              polylines: polylines,
              markers: markers,
              initialCameraPosition: initialPosition,
              onMapCreated: (controller) => _controller.complete(controller),
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'toggleMapType',
            backgroundColor: Colors.blueGrey,
            child: const Icon(Icons.layers),
            onPressed: () {
              setState(() {
                mapType = mapType == MapType.normal
                    ? MapType.satellite
                    : MapType.normal;
              });
            },
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'startRoute',
            backgroundColor: Colors.blue,
            label: loadingRoute
                ? const Text('Generando...')
                : const Text('Iniciar ruta'),
            icon: const Icon(Icons.alt_route),
            onPressed: currentPosition == null || loadingRoute
                ? null
                : () => _getRoute(currentPosition!, destination),
          ),
        ],
      ),
    );
  }
}
