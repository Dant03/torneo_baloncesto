import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category.dart';

class CategoryRepository {
  final SupabaseClient supabaseClient;

  CategoryRepository(this.supabaseClient);

  Future<List<Category>> fetchCategories(String championshipId) async {
    final response = await supabaseClient
        .from('categorias')
        .select()
        .eq('campeonatoId', championshipId)
        .execute();
    if (response.error == null) {
      final data = response.data as List;
      return data.map((category) => Category.fromJson(category)).toList();
    }
    throw Exception(response.error!.message);
  }
}
