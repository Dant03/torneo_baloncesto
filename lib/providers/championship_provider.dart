import 'package:flutter/material.dart';
import '../models/championship.dart';
import '../services/championship_service.dart';

class ChampionshipProvider with ChangeNotifier {
  List<Championship> _championships = [];

  List<Championship> get championships => _championships;

  Future<void> fetchChampionships() async {
    _championships = await ChampionshipService.fetchChampionships();
    notifyListeners();
  }

  Future<void> createChampionship(Championship championship) async {
    await ChampionshipService.createChampionship(championship);
    await fetchChampionships();
  }
}
