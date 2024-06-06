import 'package:supabase/supabase.dart';
import '../models/referee.dart';
import '../supabase_config.dart';

class RefereeService {
  final SupabaseClient _client = SupabaseClient(supabaseUrl, supabaseAnonKey);

  Future<List<Referee>> getReferees() async {
    final response = await _client.from('referees').select().execute();
    if (response.error == null) {
      return (response.data as List).map((data) => Referee.fromMap(data)).toList();
    } else {
      throw response.error!;
    }
  }
}
