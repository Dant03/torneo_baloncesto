import 'package:flutter/material.dart';
import '../models/position.dart';
import '../services/position_service.dart';

class PositionProvider with ChangeNotifier {
  final PositionService _positionService = PositionService();
  List<Position> _positions = [];

  List<Position> get positions => _positions;

  Future<void> fetchPositions() async {
    final response = await _positionService.getPositions();
    if (response.error == null) {
      _positions = response.data!;
      notifyListeners();
    } else {
      throw Exception(response.error!.message);
    }
  }
}
