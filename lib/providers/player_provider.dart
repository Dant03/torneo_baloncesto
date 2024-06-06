import 'package:flutter/material.dart';
import '../services/player_service.dart';
import '../models/player.dart';

class PlayerProvider with ChangeNotifier {
  final PlayerService _playerService = PlayerService();
  List<Player> _players = [];

  List<Player> get players => _players;

  Future<void> fetchPlayers() async {
    _players = await _playerService.getPlayers();
    notifyListeners();
  }
}
