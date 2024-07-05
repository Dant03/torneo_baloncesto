import 'package:flutter/material.dart';
import '../models/player.dart';
import '../services/player_service.dart';

class PlayerProvider with ChangeNotifier {
  final PlayerService _playerService = PlayerService();

  List<Player> _players = [];

  List<Player> get players => _players;

  Future<void> fetchPlayers() async {
    _players = await _playerService.getPlayers();
    notifyListeners();
  }

  Future<String> createPlayer(Player player) async {
    final String playerId = await _playerService.createPlayer(player);
    player.id = playerId;
    _players.add(player);
    notifyListeners();
    return playerId;
  }

  Future<void> fetchPlayersByTeamId(String teamId) async {
    _players = await _playerService.fetchPlayersByTeamId(teamId);
    notifyListeners();
  }

  Future<void> updatePlayer(Player player) async {
    await _playerService.updatePlayer(player);
    final index = _players.indexWhere((p) => p.id == player.id);
    if (index != -1) {
      _players[index] = player;
      notifyListeners();
    }
  }
}
