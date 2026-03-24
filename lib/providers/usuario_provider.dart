import 'package:sqflite/sqflite.dart';
import 'package:qr_reader/providers/db_provider1.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsuarioProvider {
  final supabase = SupabaseClient(
    'https://dhcjnkzqqybmkmfpdann.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRoY2pua3pxcXlibWttZnBkYW5uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI5Njg4NDEsImV4cCI6MjA3ODU0NDg0MX0.u3SL9mJeNfQDOrK7Vwz03Hw8z7hC-ap__rwGw9Ltb1k',
  );
  Future<int> crearUsuario(String nombre, String correo, String password) async {
    final db = await DBProvider1.db.database;

    final res = await db.insert(
      'Usuarios',
      {
        'nombre': nombre,
        'correo': correo,
        'password': password,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore, // evita duplicados
    );

    return res;
  }

  Future<Map<String, dynamic>?> login(String correo, String password) async {
    final db = await DBProvider1.db.database;

    final res = await db.query(
      'Usuarios',
      where: 'correo = ? AND password = ?',
      whereArgs: [correo, password],
    );

    return res.isNotEmpty ? res.first : null;
  }
}
