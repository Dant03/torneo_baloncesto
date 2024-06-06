import 'package:flutter/material.dart';
import '../services/category_service.dart';
import '../models/category.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];

  List<Category> get categories => _categories;

  Future<void> fetchCategories() async {
    _categories = await _categoryService.getCategories();
    notifyListeners();
  }
}
