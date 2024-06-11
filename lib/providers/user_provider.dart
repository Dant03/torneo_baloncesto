import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();
  List<AppUser> _users = [];

  List<AppUser> get users => _users;

  Future<void> fetchUsers() async {
    final response = await _userService.getUsers();
    if (response.error == null) {
      _users = response.data!;
      notifyListeners();
    } else {
      throw Exception(response.error!.message);
    }
  }
}
