import 'package:supabase/supabase.dart';
import '../models/match.dart';
import '../supabase_config.dart';

class MatchService {
  final SupabaseClient _client = SupabaseClient(supabaseUrl, supabaseAnonKey);

  Future<List<Match>> getMatches() async {
    final response = await _client.from('matches').select().execute();
    if (response.error == null) {
      return (response.data as List).map((data) => Match.fromMap(data)).toList();
    } else {
      throw response.error!;
    }
  }
}
