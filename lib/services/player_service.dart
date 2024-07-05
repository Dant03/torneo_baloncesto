import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/player.dart';

class PlayerService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Player>> getPlayers() async {
    final response = await _client.from('jugadores').select().execute();

    if (response.error != null) {
      throw response.error!;
    }

    final data = response.data as List;
    return data.map((json) => Player.fromJson(json)).toList();
  }

  Future<String> createPlayer(Player player) async {
    final response = await _client.from('jugadores').insert(player.toJson()).execute();

    if (response.error != null) {
      throw response.error!;
    }

    final data = response.data as List;
    return data[0]['id'] as String;
  }

  Future<List<Player>> fetchPlayersByTeamId(String teamId) async {
    final response = await _client
        .from('jugadores')
        .select()
        .eq('equipo_id', teamId)
        .execute();

    if (response.error != null) {
      throw response.error!;
    }

    return (response.data as List)
        .map((playerData) => Player.fromJson(playerData))
        .toList();
  }

  Future<void> updatePlayer(Player player) async {
    final response = await _client
        .from('jugadores')
        .update(player.toJson())
        .eq('id', player.id)
        .execute();

    if (response.error != null) {
      throw response.error!;
    }
  }
}
