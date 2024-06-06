import 'package:flutter/material.dart';
import '../services/referee_service.dart';
import '../models/referee.dart';

class RefereeProvider with ChangeNotifier {
  final RefereeService _refereeService = RefereeService();
  List<Referee> _referees = [];

  List<Referee> get referees => _referees;

  Future<void> fetchReferees() async {
    _referees = await _refereeService.getReferees();
    notifyListeners();
  }
}
