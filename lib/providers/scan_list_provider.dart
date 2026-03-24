import 'package:flutter/material.dart';
import 'package:qr_reader/models/scan_model.dart';
import 'package:qr_reader/providers/db_provider1.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];
  String tipoSeleccionado = 'http';

  Future<ScanModel> nuevoScan(String valor) async {
    final nuevoScan = ScanModel(valor: valor);
    final id = await DBProvider1.db.nuevoScan(nuevoScan);

    // Asignar el ID de la base de datos al modelo
    nuevoScan.id = id;

    if (tipoSeleccionado == nuevoScan.tipo) {
      scans.add(nuevoScan);
      notifyListeners();
    }

    return nuevoScan;
  }

  Future<void> cargarScans() async {
    final scans = await DBProvider1.db.getTodosLosScans();
    this.scans = [...scans];
    notifyListeners();
  }

  Future<void> cargarScanPorTipo(String tipo) async {
    final scans = await DBProvider1.db.getScansPorTipo(tipo);
    this.scans = [...scans];
    tipoSeleccionado = tipo;
    notifyListeners();
  }

  Future<void> borrarTodos() async {
  try {
    // Guardar todos los scans eliminados en Supabase antes de borrarlos localmente
    for (final scan in scans) {
      await Supabase.instance.client.from('deleted_scans').insert({
        'user_id': null, // sin usuario autenticado
        'scan_id': scan.id,
        'content': scan.valor,
        'deleted_at': DateTime.now().toIso8601String(),
      });
    }

    // Borrar todos los registros locales
    await DBProvider1.db.deleteAllScans();
    scans = [];
    notifyListeners();

    debugPrint(' Todos los scans eliminados y guardados en Supabase (sin login).');
  } catch (e) {
    debugPrint(' Error al borrar todos los scans: $e');
  }
}



  /// 🔹 Método para borrar un scan específico y guardarlo en Supabase
  Future<void> borrarScanPorId(int id) async {
    try {
      final scan = await DBProvider1.db.getScanById(id);
      if (scan == null) return;

      await Supabase.instance.client.from('deleted_scans').insert({
        'user_id': null,
        'scan_id': scan.id,
        'content': scan.valor,
        'deleted_at': DateTime.now().toIso8601String(),
      });

      await DBProvider1.db.deleteScan(id);
      scans.removeWhere((s) => s.id == id);
      notifyListeners();

      debugPrint(' Scan ${scan.id} eliminado y guardado en Supabase (sin login).');
    } catch (e) {
      debugPrint(' Error al borrar y guardar el scan: $e');
    }
  }
}
