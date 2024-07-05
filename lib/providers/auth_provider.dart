import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  AppUser? _user;
  AppUser? get user => _user;

  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> login({required String email, required String password}) async {
    final response = await _supabase.auth.signIn(email: email, password: password);
    if (response.error != null) {
      throw response.error!;
    }
    await _fetchUserDetails();
  }

  Future<void> register({required String email, required String password, required String nombre}) async {
    final response = await _supabase.auth.signUp(email, password);
    if (response.error != null) {
      throw response.error!;
    }

    final user = response.user;
    if (user != null) {
      final insertResponse = await _supabase
          .from('usuarios')
          .insert({
            'id': user.id,
            'email': email,
            'nombre': nombre,
            'rol': 'jugador',
          })
          .execute();
      if (insertResponse.error != null) {
        throw insertResponse.error!;
      }
    }

    await _fetchUserDetails();
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> _fetchUserDetails() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      final response = await _supabase
          .from('usuarios')
          .select()
          .eq('id', user.id)
          .single()
          .execute();
      if (response.error == null && response.data != null) {
        _user = AppUser.fromMap(response.data);
        notifyListeners();
      }
    }
  }
}
