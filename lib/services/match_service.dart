import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/match.dart';

class MatchService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<MatchResponse> getMatches() async {
    final response = await _supabase.from('matches').select().execute();

    if (response.error != null) {
      return MatchResponse(error: response.error);
    }

    final data = response.data as List<dynamic>;
    final matches = data.map((match) => Match.fromMap(match)).toList();

    return MatchResponse(data: matches);
  }
}

class MatchResponse {
  final List<Match>? data;
  final PostgrestError? error;

  MatchResponse({this.data, this.error});
}
