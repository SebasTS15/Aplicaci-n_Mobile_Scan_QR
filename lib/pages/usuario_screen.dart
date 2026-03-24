import 'package:qr_reader/providers/usuario_form_provider.dart';
import 'package:qr_reader/providers/usuario_provider.dart';
import 'package:qr_reader/services/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr_reader/ui/input_decorations.dart';
import 'package:qr_reader/widgets/widgets.dart';

class UsuarioScreen extends StatelessWidget {
  const UsuarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
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
            top: -150,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(300),
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(280),
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Back button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white.withOpacity(0.15),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
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
                          Icons.person_add_alt_1_rounded,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Crear tu cuenta',
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
                        'Únete a la comunidad de QR Scanner',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
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
                            create: (_) => UsuarioFormProvider(),
                            child: const _UsuarioForm(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿Ya tienes cuenta? ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'login');
                        },
                        child: const Text(
                          'Inicia sesión',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            decoration: TextDecoration.underline,
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

class _UsuarioForm extends StatelessWidget {
  const _UsuarioForm();

  @override
  Widget build(BuildContext context) {
    final usuarioForm = Provider.of<UsuarioFormProvider>(context);

    return Form(
      key: usuarioForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          // NAME
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.name,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'Juan Pérez',
              labelText: 'Nombre completo',
              prefixIcon: Icons.person_outline,
            ),
            onChanged: (value) => usuarioForm.nombre = value,
            validator: (value) {
              return (value != null && value.length >= 3)
                  ? null
                  : 'El nombre debe tener al menos 3 caracteres';
            },
          ),
          const SizedBox(height: 20),
          // EMAIL
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'juan@ejemplo.com',
              labelText: 'Correo electrónico',
              prefixIcon: Icons.alternate_email_rounded,
            ),
            onChanged: (value) => usuarioForm.correo = value,
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = RegExp(pattern);

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
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecorations.authInputDecoration(
              hintText: '*****',
              labelText: 'Contraseña',
              prefixIcon: Icons.lock_outline,
            ),
            onChanged: (value) => usuarioForm.password = value,
            validator: (value) {
              return (value != null && value.length >= 6)
                  ? null
                  : 'La contraseña debe tener al menos 6 caracteres';
            },
          ),
          const SizedBox(height: 32),
          // REGISTER BUTTON
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
                usuarioForm.isLoading ? 'Registrando...' : 'Crear Cuenta',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              onPressed: usuarioForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();

                      if (!usuarioForm.isValidForm()) return;

                      usuarioForm.isLoading = true;
                      final usuarioProvider = UsuarioProvider();

                      final res = await usuarioProvider.crearUsuario(
                        usuarioForm.nombre.trim(),
                        usuarioForm.correo.trim(),
                        usuarioForm.password.trim(),
                      );

                      if (res > 0) {
                        NotificationsService.showSnackbar(
                          'Cuenta creada exitosamente',
                        );
                        Navigator.pushReplacementNamed(context, 'home');
                      } else {
                        NotificationsService.showSnackbar(
                          'El correo ya está registrado',
                        );
                      }

                      usuarioForm.isLoading = false;
                    },
            ),
          ),
        ],
      ),
    );
  }
}
