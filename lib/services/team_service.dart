import 'package:supabase/supabase.dart';
import '../models/team.dart';
import '../supabase_config.dart';

class TeamService {
  final SupabaseClient _client = SupabaseClient(supabaseUrl, supabaseAnonKey);

  Future<List<Team>> getTeams() async {
    final response = await _client.from('teams').select().execute();
    if (response.error == null) {
      return (response.data as List).map((data) => Team.fromMap(data)).toList();
    } else {
      throw response.error!;
    }
  }
}
