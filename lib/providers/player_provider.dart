import 'package:flutter/material.dart';
import '../models/player.dart';
import '../services/player_service.dart';

class PlayerProvider with ChangeNotifier {
  final PlayerService _playerService = PlayerService();
  List<Player> _players = [];

  List<Player> get players => _players;

  Future<void> fetchPlayers() async {
    final response = await _playerService.getPlayers();
    if (response.error == null) {
      _players = response.data!;
      notifyListeners();
    } else {
      throw Exception(response.error!.message);
    }
  }
}
