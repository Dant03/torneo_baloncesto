import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/player.dart';

class PlayerService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<PlayerResponse> getPlayers() async {
    final response = await _supabase.from('players').select().execute();

    if (response.error != null) {
      return PlayerResponse(error: response.error);
    }

    final data = response.data as List<dynamic>;
    final players = data.map((player) => Player.fromMap(player)).toList();

    return PlayerResponse(data: players);
  }
}

class PlayerResponse {
  final List<Player>? data;
  final PostgrestError? error;

  PlayerResponse({this.data, this.error});
}
