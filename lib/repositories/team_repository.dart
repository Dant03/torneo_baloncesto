import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/team.dart';

class TeamRepository {
  final SupabaseClient supabaseClient;

  TeamRepository(this.supabaseClient);

  Future<List<Team>> fetchTeams(String championshipId) async {
    final response = await supabaseClient
        .from('equipos')
        .select()
        .eq('campeonatoId', championshipId)
        .execute();
    if (response.error == null) {
      final data = response.data as List;
      return data.map((team) => Team.fromJson(team)).toList();
    }
    throw Exception(response.error!.message);
  }
}
