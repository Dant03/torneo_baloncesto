import 'package:flutter/material.dart';
import '../services/position_service.dart';
import '../models/position.dart';

class PositionProvider with ChangeNotifier {
  final PositionService _positionService = PositionService();
  List<Position> _positions = [];

  List<Position> get positions => _positions;

  Future<void> fetchPositions() async {
    _positions = await _positionService.getPositions();
    notifyListeners();
  }
}
