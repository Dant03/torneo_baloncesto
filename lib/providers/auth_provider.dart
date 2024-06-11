import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  AppUser? _user;

  AppUser? get user => _user;

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _authService.signUp(email, password, name);
    if (response.error == null) {
      _user = response.data;
      notifyListeners();
    } else {
      throw Exception(response.error ?? 'Error desconocido'); // Capturar mensaje de error detallado
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final response = await _authService.signIn(email, password);
    if (response.error == null) {
      _user = response.data;
      notifyListeners();
    } else {
      throw Exception(response.error ?? 'Error desconocido'); // Capturar mensaje de error detallado
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}
