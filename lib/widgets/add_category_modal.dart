import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';

class AddCategoryModal extends StatefulWidget {
  @override
  _AddCategoryModalState createState() => _AddCategoryModalState();
}

class _AddCategoryModalState extends State<AddCategoryModal> {
  final _categoryNameController = TextEditingController();

  void _addCategory() async {
    final categoryName = _categoryNameController.text;
    if (categoryName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingrese el nombre de la categoría')),
      );
      return;
    }

    try {
      await Provider.of<CategoryProvider>(context, listen: false).addCategory(categoryName);
      Navigator.of(context).pop();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Añadir Categoría'),
      content: TextField(
        controller: _categoryNameController,
        decoration: InputDecoration(labelText: 'Nombre de la Categoría'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _addCategory,
          child: Text('Añadir'),
        ),
      ],
    );
  }
}
