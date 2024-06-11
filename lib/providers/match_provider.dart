import 'package:flutter/material.dart';
import '../models/match.dart';
import '../services/match_service.dart';

class MatchProvider with ChangeNotifier {
  final MatchService _matchService = MatchService();
  List<Match> _matches = [];

  List<Match> get matches => _matches;

  Future<void> fetchMatches() async {
    final response = await _matchService.getMatches();
    if (response.error == null) {
      _matches = response.data!;
      notifyListeners();
    } else {
      throw Exception(response.error!.message);
    }
  }
}
