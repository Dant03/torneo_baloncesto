import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category.dart';
import '../services/category_service.dart';

class CategoryProvider with ChangeNotifier {
  final SupabaseClient _supabase;
  final CategoryService _categoryService;

  List<Category> _categories = [];

  CategoryProvider(this._supabase)
      : _categoryService = CategoryService(_supabase);

  List<Category> get categorias => _categories;

  Future<void> fetchCategories() async {
    _categories = await _categoryService.getCategories();
    notifyListeners();
  }

  Future<void> fetchCategoriesByChampionship(String championshipId) async {
    _categories = await _categoryService.getCategoriesByChampionship(championshipId);
    notifyListeners();
  }

  Future<void> addCategory(String name) async {
    final response = await _supabase.from('categorias').insert({'nombre': name}).execute();
    if (response.error == null) {
      _categories.add(Category.fromJson(response.data[0]));
      notifyListeners();
    } else {
      throw response.error!;
    }
  }
}
