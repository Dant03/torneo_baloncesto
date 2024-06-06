import 'package:supabase/supabase.dart';
import '../models/position.dart';
import '../supabase_config.dart';

class PositionService {
  final SupabaseClient _client = SupabaseClient(supabaseUrl, supabaseAnonKey);

  Future<List<Position>> getPositions() async {
    final response = await _client.from('positions').select().execute();
    if (response.error == null) {
      return (response.data as List).map((data) => Position.fromMap(data)).toList();
    } else {
      throw response.error!;
    }
  }
}
