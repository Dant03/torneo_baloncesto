import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category.dart';
import 'package:uuid/uuid.dart';

class CategoryService {
  final SupabaseClient supabase;

  CategoryService(this.supabase);

  Future<void> createCategory(String name, String? imageUrl) async {
    final String finalImageUrl = imageUrl ?? 'https://sezusjbiuccuqlyjjkud.supabase.co/storage/v1/object/public/ImagenesApp/defaultImage.png';
    
    final response = await supabase.from('categories').insert({
      'id': Uuid().v4(),
      'name': name,
      'image_url': finalImageUrl,
    }).execute();

    if (response.error != null) {
      throw Exception('Failed to create category: ${response.error!.message}');
    }
  }

  Future<List<Category>> getCategories() async {
    final response = await supabase.from('categories').select().execute();

    if (response.error != null) {
      throw Exception('Failed to fetch categories: ${response.error!.message}');
    }

    final data = response.data as List<dynamic>;
    return data.map((json) => Category.fromJson(json)).toList();
  }

  Future<List<Category>> getCategoriesByChampionship(String championshipId) async {
    final response = await supabase
        .from('categoria_campeonatos')
        .select('categorias(id, nombre)')
        .eq('campeonato_id', championshipId)
        .execute();

    if (response.error != null) {
      throw Exception('Failed to fetch categories: ${response.error!.message}');
    }

    final data = response.data as List<dynamic>;
    return data.map((json) => Category.fromJson(json['categorias'])).toList();
  }

  Future<void> deleteCategory(String id) async {
    final response = await supabase.from('categories').delete().eq('id', id).execute();

    if (response.error != null) {
      throw Exception('Failed to delete category: ${response.error!.message}');
    }
  }
}
