import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthResponse> signUp(String email, String password, String nombre) async {
    final response = await _supabase.auth.signUp(email, password);

    if (response.error != null) {
      return AuthResponse(error: response.error!.message); // Capturar mensaje de error detallado
    }

    final user = response.user;
    if (user == null) {
      return AuthResponse(error: 'Error de autenticación'); // Mensaje de error si el usuario es nulo
    }

    final insertResponse = await _supabase.from('users').insert({
      'id': user.id,
      'nombre': nombre,
      'email': email,
      'role': 'user',
    }).execute();

    if (insertResponse.error != null) {
      return AuthResponse(error: insertResponse.error!.message);
    }

    return AuthResponse(data: AppUser(
      id: user.id,
      nombre: nombre,
      email: email,
      rol: 'user',
    ));
  }

  Future<AuthResponse> signIn(String email, String password) async {
    final response = await _supabase.auth.signIn(email: email, password: password);

    if (response.error != null) {
      return AuthResponse(error: response.error!.message); // Capturar mensaje de error detallado
    }

    final user = response.user;
    if (user == null) {
      return AuthResponse(error: 'Error de autenticación'); // Mensaje de error si el usuario es nulo
    }

    final userResponse = await _supabase.from('users').select().eq('id', user.id).single().execute();

    if (userResponse.error != null) {
      return AuthResponse(error: userResponse.error!.message); // Capturar mensaje de error detallado
    }

    final userData = userResponse.data;
    final appUser = AppUser.fromMap(userData);

    return AuthResponse(data: appUser);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}

class AuthResponse {
  final AppUser? data;
  final String? error;

  AuthResponse({this.data, this.error});
}
