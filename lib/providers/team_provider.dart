import 'package:flutter/material.dart';
import '../models/team.dart';
import '../services/team_service.dart';

class TeamProvider with ChangeNotifier {
  final TeamService _teamService = TeamService();
  List<Team> _teams = [];

  List<Team> get teams => _teams;

  Future<void> fetchTeams() async {
    final response = await _teamService.getTeams();
    if (response.error == null) {
      _teams = response.data!;
      notifyListeners();
    } else {
      throw Exception(response.error!.message);
    }
  }
}
