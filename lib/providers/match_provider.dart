import 'package:flutter/material.dart';
import '../services/match_service.dart';
import '../models/match.dart';

class MatchProvider with ChangeNotifier {
  final MatchService _matchService = MatchService();
  List<Match> _matches = [];

  List<Match> get matches => _matches;

  Future<void> fetchMatches() async {
    _matches = await _matchService.getMatches();
    notifyListeners();
  }
}
