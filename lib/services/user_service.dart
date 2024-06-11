import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';

class UserService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<UserResponse> getUsers() async {
    final response = await _supabase.from('users').select().execute();

    if (response.error != null) {
      return UserResponse(error: response.error);
    }

    final data = response.data as List<dynamic>;
    final users = data.map((user) => AppUser.fromMap(user)).toList();

    return UserResponse(data: users);
  }
}

class UserResponse {
  final List<AppUser>? data;
  final PostgrestError? error;

  UserResponse({this.data, this.error});
}
