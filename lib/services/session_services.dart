import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _keyUsuarioLogueado = 'usuarioLogueado';
  static const _keyCorreo = 'correo';

  /// Guarda la sesión del usuario
  static Future<void> iniciarSesion(String correo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyUsuarioLogueado, true);
    await prefs.setString(_keyCorreo, correo);
  }

  /// Cierra la sesión
  static Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsuarioLogueado);
    await prefs.remove(_keyCorreo);
  }

  /// Verifica si hay una sesión activa
  static Future<bool> estaLogueado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyUsuarioLogueado) ?? false;
  }

  /// Devuelve el correo del usuario actual (si existe)
  static Future<String?> obtenerCorreo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCorreo);
  }
}
