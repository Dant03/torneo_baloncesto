import 'package:supabase/supabase.dart' as supabase;
import '../models/user.dart';
import '../supabase_config.dart';

class AuthService {
  final supabase.SupabaseClient _client = supabase.SupabaseClient(supabaseUrl, supabaseAnonKey);

  Future<User?> signInWithEmail(String email, String password) async {
    final response = await _client.auth.signIn(email: email, password: password);
    if (response.error == null && response.user != null) {
      // Obtener el rol del usuario desde la tabla de usuarios
      final userResponse = await _client.from('users').select().eq('id', response.user!.id).single().execute();
      if (userResponse.error == null && userResponse.data != null) {
        final data = userResponse.data as Map<String, dynamic>;
        return User(
          id: response.user!.id,
          email: response.user!.email ?? '',
          role: data['role'],
        );
      } else {
        // Manejar el error cuando no se encuentra un único usuario
        print('Error al obtener el usuario: ${userResponse.error?.message ?? 'No user found or multiple users found'}');
      }
    } else {
      print('Error al iniciar sesión: ${response.error?.message}');
    }
    return null;
  }

  Future<User?> signUpWithEmail(String email, String password) async {
    final response = await _client.auth.signUp(email, password);
    if (response.error == null && response.user != null) {
      // Crear un registro en la tabla de usuarios con el rol por defecto
      final userResponse = await _client.from('users').insert({
        'id': response.user!.id,
        'email': email,
        'role': 'user', // Cambia esto según tu lógica
      }).execute();
      if (userResponse.error == null) {
        return User(
          id: response.user!.id,
          email: response.user!.email ?? '',
          role: 'user', // Asigna el rol de acuerdo a tu lógica
        );
      } else {
        print('Error al insertar el usuario: ${userResponse.error?.message}');
      }
    } else {
      print('Error al registrarse: ${response.error?.message}');
    }
    return null;
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
