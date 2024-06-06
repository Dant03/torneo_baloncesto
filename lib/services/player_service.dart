import 'package:supabase/supabase.dart';
import '../models/player.dart';
import '../supabase_config.dart';

class PlayerService {
  final SupabaseClient _client = SupabaseClient(supabaseUrl, supabaseAnonKey);

  Future<List<Player>> getPlayers() async {
    final response = await _client.from('players').select().execute();
    if (response.error == null) {
      return (response.data as List).map((data) => Player.fromMap(data)).toList();
    } else {
      throw response.error!;
    }
  }
}
