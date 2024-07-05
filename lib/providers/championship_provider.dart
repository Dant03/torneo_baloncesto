import 'package:flutter/material.dart';
import 'package:torneo_baloncesto/models/championship.dart';
import 'package:torneo_baloncesto/services/championship_service.dart';

class ChampionshipProvider with ChangeNotifier {
  final ChampionshipService _championshipService = ChampionshipService();

  List<Championship> _campeonatos = [];
  List<Championship> get campeonatos => _campeonatos;

  Future<void> obtenerCampeonatos() async {
    try {
      _campeonatos = await _championshipService.obtenerCampeonatos();
      notifyListeners();
    } catch (error) {
      print('Error obteniendo campeonatos: $error');
    }
  }

  Future<String> crearCampeonato(Championship campeonato, List<String> categorias) async {
    final String campeonatoId = await _championshipService.crearCampeonato(campeonato);
    campeonato.id = campeonatoId;
    _campeonatos.add(campeonato);
    
    // Asociar categorías con el campeonato en la tabla intermedia
    await _championshipService.asociarCategoriasConCampeonato(campeonatoId, categorias);

    notifyListeners();
    return campeonatoId; // Retornar el ID del campeonato
  }

  Future<void> updateChampionship(Championship campeonato, List<String> categorias) async {
    await _championshipService.actualizarCampeonato(campeonato);
    final index = _campeonatos.indexWhere((c) => c.id == campeonato.id);
    if (index != -1) {
      _campeonatos[index] = campeonato;
      await _championshipService.eliminarCategoriasDeCampeonato(campeonato.id!);
      await _championshipService.asociarCategoriasConCampeonato(campeonato.id!, categorias);
      notifyListeners();
    }
  }

  Future<void> removeChampionship(String campeonatoId) async {
    try {
      await _championshipService.eliminarCampeonato(campeonatoId);
      _campeonatos.removeWhere((campeonato) => campeonato.id == campeonatoId);
      notifyListeners();
    } catch (error) {
      print('Error eliminando campeonato: $error');
    }
  }

  Future<void> subirReglamento(String campeonatoId, String filePath) async {
    await _championshipService.subirReglamento(campeonatoId, filePath);
    notifyListeners();
  }
}
