import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:qr_reader/pages/home_page.dart';
import 'package:qr_reader/pages/login_screen.dart';
import 'package:qr_reader/pages/mapa_page.dart';
import 'package:qr_reader/pages/usuario_screen.dart';
import 'package:qr_reader/pages/splash_screen.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/providers/sesion_provider.dart';
import 'package:qr_reader/providers/ui_provider.dart';
import 'package:qr_reader/services/notifications_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dhcjnkzqqybmkmfpdann.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRoY2pua3pxcXlibWttZnBkYW5uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI5Njg4NDEsImV4cCI6MjA3ODU0NDg0MX0.u3SL9mJeNfQDOrK7Vwz03Hw8z7hC-ap__rwGw9Ltb1k',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UiProvider()),
        ChangeNotifierProvider(create: (_) => ScanListProvider()),
        ChangeNotifierProvider(create: (_) => SesionProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QR Reader',
        initialRoute: 'splash',
        routes: {
          'splash': (_) => const SplashScreen(),
          'home': (_) => HomePage(),
          'mapa': (_) => MapaPage(),
          'login': (_) => const LoginScreen(),
          'usuario': (_) => const UsuarioScreen(),
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.deepPurple,
          ),
        ),
        scaffoldMessengerKey: NotificationsService.messengerKey,
      ),
    );
  }
}
