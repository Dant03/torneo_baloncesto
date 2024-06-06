import 'package:supabase/supabase.dart';
import '../models/category.dart';
import '../supabase_config.dart';

class CategoryService {
  final SupabaseClient _client = SupabaseClient(supabaseUrl, supabaseAnonKey);

  Future<List<Category>> getCategories() async {
    final response = await _client.from('categories').select().execute();
    if (response.error == null) {
      return (response.data as List).map((data) => Category.fromMap(data)).toList();
    } else {
      throw response.error!;
    }
  }
}
