import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:torneo_baloncesto/models/championship.dart';
import 'dart:io'; // Importa dart:io

class ChampionshipService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Championship>> obtenerCampeonatos() async {
    final response = await _supabase.from('campeonatos').select().execute();
    if (response.error == null) {
      final data = response.data as List;
      return data.map((json) => Championship.fromJson(json)).toList();
    } else {
      throw response.error!;
    }
  }

  Future<String> crearCampeonato(Championship campeonato) async {
    final campeonatoJson = campeonato.toJson();
    campeonatoJson.remove('id'); // Asegúrate de que el id no esté incluido si es nulo

    final response = await _supabase.from('campeonatos').insert(campeonatoJson).execute();
    if (response.error == null) {
      final data = response.data as List;
      return data[0]['id'];
    } else {
      throw response.error!;
    }
  }

  Future<void> asociarCategoriasConCampeonato(String campeonatoId, List<String> categorias) async {
    final List<Map<String, dynamic>> data = categorias.map((categoriaId) => {
      'campeonato_id': campeonatoId,
      'categoria_id': categoriaId,
    }).toList();
    final response = await _supabase.from('campeonato_categorias').insert(data).execute();
    if (response.error != null) {
      throw response.error!;
    }
  }

  Future<void> eliminarCategoriasDeCampeonato(String campeonatoId) async {
    final response = await _supabase.from('campeonato_categorias').delete().eq('campeonato_id', campeonatoId).execute();
    if (response.error != null) {
      throw response.error!;
    }
  }

  Future<void> eliminarEquiposDeCampeonato(String campeonatoId) async {
    final response = await _supabase.from('campeonato_equipos').delete().eq('campeonato_id', campeonatoId).execute();
    if (response.error != null) {
      throw response.error!;
    }
  }

  Future<void> eliminarCampeonato(String campeonatoId) async {
    await eliminarCategoriasDeCampeonato(campeonatoId);
    await eliminarEquiposDeCampeonato(campeonatoId);
    final response = await _supabase.from('campeonatos').delete().eq('id', campeonatoId).execute();
    if (response.error != null) {
      throw response.error!;
    }
  }

  Future<void> actualizarCampeonato(Championship campeonato) async {
    final response = await _supabase
        .from('campeonatos')
        .update(campeonato.toJson())
        .eq('id', campeonato.id)
        .execute();
    if (response.error != null) {
      throw response.error!;
    }
  }

  Future<void> subirReglamento(String campeonatoId, String filePath) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(filePath); // Convertir la ruta del archivo a un objeto File
    final response = await _supabase.storage.from('campeonatos').upload(fileName, file);

    if (response.error == null) {
      final pdfUrl = Supabase.instance.client.storage.from('campeonatos').getPublicUrl(fileName);
      await _supabase.from('campeonatos').update({'reglamento': pdfUrl.data}).eq('id', campeonatoId).execute();
    } else {
      throw response.error!;
    }
  }
}
