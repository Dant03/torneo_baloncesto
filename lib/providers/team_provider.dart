import 'package:flutter/material.dart';
import '../models/team.dart';
import '../services/team_service.dart';

class TeamProvider with ChangeNotifier {
  final TeamService _teamService = TeamService();

  List<Team> _teams = [];
  Map<String, String> _teamCategories = {};

  List<Team> get teams => _teams;

  Future<String> createTeam(Team team, String championshipId, List<String> categoryIds) async {
    final teamId = await _teamService.createTeam(team);
    team.id = teamId; // Asignar el id generado al equipo
    _teams.add(team);
    await _teamService.associateTeamWithChampionship(teamId, championshipId);
    await _teamService.associateTeamWithCategories(teamId, categoryIds);
    notifyListeners();
    return teamId; // Retorna el teamId
  }

  Future<void> fetchTeams(String championshipId) async {
    _teams = await _teamService.fetchTeams(championshipId);
    notifyListeners();
  }

  Team getTeamById(String teamId) {
    return _teams.firstWhere((team) => team.id == teamId);
  }

  Future<void> fetchTeamById(String teamId) async {
    final team = await _teamService.fetchTeamById(teamId);
    _teams.add(team);
    notifyListeners();
  }

  Future<void> fetchTeamCategory(String teamId) async {
    final categoryName = await _teamService.fetchTeamCategory(teamId);
    _teamCategories[teamId] = categoryName;
    notifyListeners();
  }

  String? getTeamCategory(String teamId) {
    return _teamCategories[teamId];
  }
}
