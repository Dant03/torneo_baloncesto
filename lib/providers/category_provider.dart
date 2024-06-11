import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/category_service.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];

  List<Category> get categories => _categories;

  Future<void> fetchCategories() async {
    final response = await _categoryService.getCategories();
    if (response.error == null) {
      _categories = response.data!;
      notifyListeners();
    } else {
      throw Exception(response.error!.message);
    }
  }
}
