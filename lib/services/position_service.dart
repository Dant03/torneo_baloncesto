import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/position.dart';

class PositionService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<PositionResponse> getPositions() async {
    final response = await _supabase.from('positions').select().execute();

    if (response.error != null) {
      return PositionResponse(error: response.error);
    }

    final data = response.data as List<dynamic>;
    final positions = data.map((position) => Position.fromMap(position)).toList();

    return PositionResponse(data: positions);
  }
}

class PositionResponse {
  final List<Position>? data;
  final PostgrestError? error;

  PositionResponse({this.data, this.error});
}
