import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeletedScansProvider extends ChangeNotifier {
  List<Map<String, dynamic>> deletedScans = [];
  bool isLoading = false;
  String? currentUserId;

  /// Obtener scans eliminados del usuario actual desde Supabase
  Future<void> cargarScansEliminados() async {
    try {
      isLoading = true;
      notifyListeners();

      // Obtener el usuario actual autenticado
      final user = Supabase.instance.client.auth.currentUser;
      
      if (user != null) {
        currentUserId = user.id;
        
        // Obtener scans eliminados asociados al usuario
        final response = await Supabase.instance.client
            .from('deleted_scans')
            .select()
            .eq('user_id', user.id)
            .order('deleted_at', ascending: false);

        deletedScans = List<Map<String, dynamic>>.from(response);
      } else {
        // Si no hay usuario autenticado, cargar todos los scans sin user_id
        final response = await Supabase.instance.client
            .from('deleted_scans')
            .select()
            .isFilter('user_id', null)
            .order('deleted_at', ascending: false);

        deletedScans = List<Map<String, dynamic>>.from(response);
      }

      debugPrint('Se cargaron ${deletedScans.length} scans eliminados');
      isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint(' Error al cargar scans eliminados: $e');
      isLoading = false;
      notifyListeners();
    }
  }


  /// Eliminar permanentemente un scan de la papelera
  Future<bool> eliminarPermanentemente(int id) async {
    try {
      await Supabase.instance.client
          .from('deleted_scans')
          .delete()
          .eq('id', id);

      deletedScans.removeWhere((scan) => scan['id'] == id);
      notifyListeners();

      debugPrint('Scan $id eliminado permanentemente');
      return true;
    } catch (e) {
      debugPrint(' Error al eliminar permanentemente: $e');
      return false;
    }
  }

  ///Vaciar toda la papelera
  Future<bool> vaciarPapelera() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      
      if (user != null) {
        await Supabase.instance.client
            .from('deleted_scans')
            .delete()
            .eq('user_id', user.id);
      } else {
        await Supabase.instance.client
            .from('deleted_scans')
            .delete()
            .isFilter('user_id', null);
      }

      deletedScans = [];
      notifyListeners();

      debugPrint('Papelera vaciada');
      return true;
    } catch (e) {
      debugPrint('Error al vaciar papelera: $e');
      return false;
    }
  }
}
