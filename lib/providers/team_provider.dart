import 'package:flutter/material.dart';
import '../services/team_service.dart';
import '../models/team.dart';

class TeamProvider with ChangeNotifier {
  final TeamService _teamService = TeamService();
  List<Team> _teams = [];

  List<Team> get teams => _teams;

  Future<void> fetchTeams() async {
    _teams = await _teamService.getTeams();
    notifyListeners();
  }
}
