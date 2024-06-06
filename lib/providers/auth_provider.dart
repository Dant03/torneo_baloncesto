import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart' as supabase;
import 'package:local_auth/local_auth.dart'; // Añadir la librería para autenticación biométrica
import '../models/user.dart';
import '../supabase_config.dart';

class AuthProvider with ChangeNotifier {
  final supabase.SupabaseClient _client = supabase.SupabaseClient(supabaseUrl, supabaseAnonKey);
  User? user;
  String? error;

  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<void> signUpWithEmail(String email, String password, String role) async {
    final response = await _client.auth.signUp(email, password); // Corregir los parámetros aquí
    if (response.error == null) {
      user = User(
        id: response.user!.id,
        email: email,
        role: role,
      );
      await _client.from('users').insert(user!.toMap()).execute();
      notifyListeners();
    } else {
      error = response.error!.message;
      notifyListeners();
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    final response = await _client.auth.signIn(email: email, password: password);
    if (response.error == null) {
      final userResponse = await _client
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single()
          .execute();
      if (userResponse.error == null) {
        user = User.fromMap(userResponse.data);
        notifyListeners();
      } else {
        error = userResponse.error!.message;
        notifyListeners();
      }
    } else {
      error = response.error!.message;
      notifyListeners();
    }
  }

  Future<void> authenticateWithBiometrics() async {
    try {
      bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to login',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      if (authenticated) {
        // Aquí deberías definir la lógica de inicio de sesión después de la autenticación biométrica exitosa
        notifyListeners();
      }
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  void signOut() {
    _client.auth.signOut();
    user = null;
    notifyListeners();
  }
}
