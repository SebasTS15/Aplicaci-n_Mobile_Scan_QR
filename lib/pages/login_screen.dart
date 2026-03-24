import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr_reader/providers/login_form_provider.dart';
import 'package:qr_reader/providers/sesion_provider.dart';
import 'package:qr_reader/providers/usuario_provider.dart';
import 'package:qr_reader/services/session_services.dart';
import 'package:qr_reader/ui/input_decorations.dart';
import 'package:qr_reader/widgets/widgets.dart';
import 'package:qr_reader/services/notifications_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF00897B),
                  const Color(0xFF00897B).withOpacity(0.8),
                  const Color(0xFF004D4A),
                ],
              ),
            ),
          ),
          // Animated background shapes
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(300),
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(250),
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  // Header
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.15),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.qr_code_2,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Bienvenido de vuelta',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ingresa a tu cuenta para continuar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  // Form Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ChangeNotifierProvider(
                            create: (_) => LoginFormProvider(),
                            child: const _LoginForm(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Sign up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿No tienes cuenta? ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'usuario');
                        },
                        child: const Text(
                          'Registrarse',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          // EMAIL
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'john.doe@gmail.com',
              labelText: 'Correo electrónico',
              prefixIcon: Icons.alternate_email_rounded,
            ),
            onChanged: (value) => loginForm.correo = value,
            validator: (value) {
              const pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              final regExp = RegExp(pattern);

              return regExp.hasMatch(value ?? '')
                  ? null
                  : 'El correo no es válido';
            },
          ),
          const SizedBox(height: 20),
          // PASSWORD
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.text,
            decoration: InputDecorations.authInputDecoration(
              hintText: '*****',
              labelText: 'Contraseña',
              prefixIcon: Icons.lock_outline,
            ),
            onChanged: (value) => loginForm.password = value,
            validator: (value) {
              return (value != null && value.length >= 6)
                  ? null
                  : 'La contraseña debe tener al menos 6 caracteres';
            },
          ),
          const SizedBox(height: 32),
          // LOGIN BUTTON
          SizedBox(
            width: double.infinity,
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              disabledColor: Colors.grey,
              elevation: 0,
              color: const Color(0xFF00897B),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                loginForm.isLoading ? 'Ingresando...' : 'Ingresar',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              onPressed: loginForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();

                      if (!loginForm.isValidForm()) return;

                      loginForm.isLoading = true;

                      final usuarioProvider = UsuarioProvider();

                      final usuario = await usuarioProvider.login(
                        loginForm.correo.trim(),
                        loginForm.password.trim(),
                      );

                      if (usuario != null) {
                        final sesion = Provider.of<SesionProvider>(
                          context,
                          listen: false,
                        );
                        sesion.iniciarSesion(
                          usuario['nombre'],
                          usuario['correo'],
                        );

                        await SessionService.iniciarSesion(loginForm.correo.trim());

                        NotificationsService.showSnackbar(
                          'Bienvenido ${usuario['nombre']}',
                        );

                        Navigator.pushReplacementNamed(context, 'home');
                      } else {
                        NotificationsService.showSnackbar(
                          'Correo o contraseña inválidos',
                        );
                      }

                      loginForm.isLoading = false;
                    },
            ),
          ),
        ],
      ),
    );
  }
}
