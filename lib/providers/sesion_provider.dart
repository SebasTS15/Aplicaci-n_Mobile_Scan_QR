import 'package:flutter/material.dart';

class SesionProvider extends ChangeNotifier {
  String? _nombreUsuario;
  String? _correoUsuario;

  String? get nombreUsuario => _nombreUsuario;
  String? get correoUsuario => _correoUsuario;

  bool get isLoggedIn => _correoUsuario != null;

  void iniciarSesion(String nombre, String correo) {
    _nombreUsuario = nombre;
    _correoUsuario = correo;
    notifyListeners();
  }

  void cerrarSesion() {
    _nombreUsuario = null;
    _correoUsuario = null;
    notifyListeners();
  }
}
