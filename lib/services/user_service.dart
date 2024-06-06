import 'package:supabase/supabase.dart' as supabase;
import '../models/user.dart';
import '../supabase_config.dart';

class UserService {
  final supabase.SupabaseClient _client = supabase.SupabaseClient(supabaseUrl, supabaseAnonKey);

  Future<List<User>> getUsers() async {
    final response = await _client.from('users').select().execute();
    if (response.error == null) {
      return (response.data as List).map((data) => User.fromMap(data)).toList();
    } else {
      throw response.error!;
    }
  }

  Future<void> createUser(String email, String password, String role) async {
    final response = await _client.auth.signUp(email, password);
    if (response.error == null && response.user != null) {
      await _client.from('users').insert({
        'id': response.user!.id,
        'email': email,
        'role': role,
      }).execute();
    } else {
      throw response.error!;
    }
  }
}
