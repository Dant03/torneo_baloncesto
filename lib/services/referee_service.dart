import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/referee.dart';

class RefereeService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<RefereeResponse> getReferees() async {
    final response = await _supabase.from('referees').select().execute();

    if (response.error != null) {
      return RefereeResponse(error: response.error);
    }

    final data = response.data as List<dynamic>;
    final referees = data.map((referee) => Referee.fromMap(referee)).toList();

    return RefereeResponse(data: referees);
  }
}

class RefereeResponse {
  final List<Referee>? data;
  final PostgrestError? error;

  RefereeResponse({this.data, this.error});
}
