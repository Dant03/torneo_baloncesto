import 'package:flutter/material.dart';
import '../models/referee.dart';
import '../services/referee_service.dart';

class RefereeProvider with ChangeNotifier {
  final RefereeService _refereeService = RefereeService();
  List<Referee> _referees = [];

  List<Referee> get referees => _referees;

  Future<void> fetchReferees() async {
    final response = await _refereeService.getReferees();
    if (response.error == null) {
      _referees = response.data!;
      notifyListeners();
    } else {
      throw Exception(response.error!.message);
    }
  }
}
