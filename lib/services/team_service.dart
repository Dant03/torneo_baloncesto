import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/team.dart';

class TeamService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<String> createTeam(Team team) async {
    final response = await _client
        .from('equipos')
        .insert(team.toJson())
        .execute();
    if (response.error != null) {
      throw response.error!;
    }
    return response.data[0]['id'] as String;
  }

  Future<void> associateTeamWithChampionship(String teamId, String championshipId) async {
    await _client
        .from('campeonato_equipos')
        .insert({'equipo_id': teamId, 'campeonato_id': championshipId})
        .execute();
  }

  Future<void> associateTeamWithCategories(String teamId, List<String> categoryIds) async {
    for (String categoryId in categoryIds) {
      await _client
          .from('equipo_categorias')
          .insert({'equipo_id': teamId, 'categoria_id': categoryId})
          .execute();
    }
  }

  Future<void> associateTeamWithUser(String teamId, String userId) async {
    await _client
        .from('usuarios_equipos')
        .insert({'equipo_id': teamId, 'usuario_id': userId})
        .execute();
  }

  Future<List<Team>> fetchTeams(String championshipId) async {
    final response = await _client
        .from('equipos')
        .select()
        .eq('campeonato_id', championshipId)
        .execute();

    if (response.error != null) {
      throw response.error!;
    }

    final data = response.data as List<dynamic>;
    return data.map((json) => Team.fromJson(json)).toList();
  }

  Future<Team> fetchTeamById(String teamId) async {
    final response = await _client
        .from('equipos')
        .select()
        .eq('id', teamId)
        .single()
        .execute();

    if (response.error != null) {
      throw response.error!;
    }

    return Team.fromJson(response.data);
  }

  Future<String> fetchTeamCategory(String teamId) async {
    final response = await _client
        .from('equipo_categorias')
        .select('categoria_id(categorias.nombre)')
        .eq('equipo_id', teamId)
        .single()
        .execute();

    if (response.error != null) {
      throw response.error!;
    }

    return response.data['categoria_id']['categorias']['nombre'];
  }
}
