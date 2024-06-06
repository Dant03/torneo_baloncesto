import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.signInWithEmail(
      _emailController.text,
      _passwordController.text,
    ).then((_) {
      if (authProvider.user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.error ?? 'Error al iniciar sesión')),
        );
      }
    });
  }

  void _navigateToRegister() {
    Navigator.pushReplacementNamed(context, '/register');
  }

  void _resetPassword() {
    // Implementar funcionalidad para restablecer la contraseña
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://sezusjbiuccuqlyjjkud.supabase.co/storage/v1/object/public/ImagenesApp/background.jpg?t=2024-06-05T06%3A06%3A18.729Z',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://sezusjbiuccuqlyjjkud.supabase.co/storage/v1/object/public/ImagenesApp/logo.png?t=2024-06-05T06%3A06%3A39.858Z',
                    height: 100,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Email',
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    obscureText: true,
                  ),
                  CustomButton(
                    text: 'Login',
                    onPressed: () => _login(context),
                  ),
                  CustomButton(
                    text: 'Login with Biometrics',
                    onPressed: () {
                      final authProvider = Provider.of<AuthProvider>(context, listen: false);
                      authProvider.authenticateWithBiometrics();
                    },
                  ),
                  TextButton(
                    onPressed: _navigateToRegister,
                    child: const Text(
                      'No tienes una cuenta? Regístrate',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: _resetPassword,
                    child: const Text(
                      'Olvidé mi contraseña',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
