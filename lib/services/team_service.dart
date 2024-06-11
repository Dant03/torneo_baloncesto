import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/team.dart';

class TeamService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<TeamResponse> getTeams() async {
    final response = await _supabase.from('teams').select().execute();

    if (response.error != null) {
      return TeamResponse(error: response.error);
    }

    final data = response.data as List<dynamic>;
    final teams = data.map((team) => Team.fromMap(team)).toList();

    return TeamResponse(data: teams);
  }
}

class TeamResponse {
  final List<Team>? data;
  final PostgrestError? error;

  TeamResponse({this.data, this.error});
}
