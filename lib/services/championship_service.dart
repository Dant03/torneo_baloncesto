import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/championship.dart';

class ChampionshipService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<List<Championship>> fetchChampionships() async {
    final response = await _supabase.from('championships').select().execute();
    if (response.error != null) {
      throw response.error!;
    }
    return (response.data as List)
        .map((json) => Championship.fromMap(json))
        .toList();
  }

  static Future<void> createChampionship(Championship championship) async {
    final response = await _supabase.from('championships').insert(championship.toMap()).execute();
    if (response.error != null) {
      print('Error inserting championship: ${response.error!.message}');
      throw response.error!;
    }
  }
}
