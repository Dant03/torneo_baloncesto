import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'Jugador';
  bool _isEmailValid = false;

  void _validateEmail(String email) {
    setState(() {
      _isEmailValid = EmailValidator.validate(email);
    });
  }

  void _register(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.signUpWithEmail(
      _emailController.text,
      _passwordController.text,
      _selectedRole,
    ).then((_) {
      if (authProvider.user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.error ?? 'Error al registrarse')),
        );
      }
    });
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
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
                    onChanged: _validateEmail,
                  ),
                  if (!_isEmailValid && _emailController.text.isNotEmpty)
                    const Text('Correo electrónico no válido', style: TextStyle(color: Colors.red)),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    value: _selectedRole,
                    items: <String>['Administrador', 'Entrenador', 'Jugador']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedRole = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Register',
                    onPressed: () {
                      if (_isEmailValid) {
                        _register(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Correo electrónico no válido')),
                        );
                      }
                    },
                  ),
                  TextButton(
                    onPressed: _navigateToLogin,
                    child: const Text(
                      'Ya tienes una cuenta? Iniciar sesión',
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
