import 'package:supabase/supabase.dart';
import '../models/championship.dart';
import '../supabase_config.dart';

class ChampionshipService {
  final SupabaseClient _client = SupabaseClient(supabaseUrl, supabaseAnonKey);

  Future<List<Championship>> getChampionships() async {
    final response = await _client.from('championships').select().execute();
    if (response.error == null) {
      return (response.data as List).map((data) => Championship.fromMap(data)).toList();
    } else {
      throw response.error!;
    }
  }

  Future<void> createChampionship(String name) async {
    final response = await _client.from('championships').insert({
      'name': name,
    }).execute();
    if (response.error != null) {
      throw response.error!;
    }
  }
}
