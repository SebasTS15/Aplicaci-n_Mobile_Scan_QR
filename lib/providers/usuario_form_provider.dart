import 'package:flutter/material.dart';

class UsuarioFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String nombre = '';
  String correo = '';
  String password = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Valida si el formulario es correcto
  bool isValidForm() {
    final isValid = formKey.currentState?.validate() ?? false;

    debugPrint('Formulario válido: $isValid');
    debugPrint('Nombre: $nombre - Correo: $correo - Password: $password');

    return isValid;
  }
}
