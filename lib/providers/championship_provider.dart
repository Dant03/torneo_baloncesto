import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart' as supabase;
import '../models/championship.dart';
import '../supabase_config.dart';

class ChampionshipProvider with ChangeNotifier {
  final supabase.SupabaseClient _client = supabase.SupabaseClient(supabaseUrl, supabaseAnonKey);

  List<Championship> _championships = [];

  List<Championship> get championships => _championships;

  Future<void> fetchChampionships() async {
    final response = await _client.from('championships').select().execute();
    if (response.error == null) {
      _championships = (response.data as List).map((data) => Championship.fromMap(data)).toList();
      notifyListeners();
    } else {
      throw response.error!;
    }
  }

  Future<void> createChampionship(Championship championship) async {
    final response = await _client.from('championships').insert(championship.toMap()).execute();
    if (response.error != null) {
      throw response.error!;
    }

    final championshipId = response.data[0]['id'];
    for (var category in championship.categories.entries) {
      final categoryResponse = await _client.from('categories').insert({
        'championship_id': championshipId,
        'name': category.key,
        'min_teams': category.value['min'],
        'max_teams': category.value['max'],
      }).execute();
      if (categoryResponse.error != null) {
        throw categoryResponse.error!;
      }
    }

    _championships.add(championship);
    notifyListeners();
  }
}
