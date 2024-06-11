import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category.dart';

class CategoryService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<CategoryResponse> getCategories() async {
    final response = await _supabase.from('categories').select().execute();

    if (response.error != null) {
      return CategoryResponse(error: response.error);
    }

    final data = response.data as List<dynamic>;
    final categories = data.map((category) => Category.fromMap(category)).toList();

    return CategoryResponse(data: categories);
  }
}

class CategoryResponse {
  final List<Category>? data;
  final PostgrestError? error;

  CategoryResponse({this.data, this.error});
}
