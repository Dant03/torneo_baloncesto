import 'package:flutter/material.dart';

class AddCategoryModal extends StatelessWidget {
  final TextEditingController _categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Agregar Categoría'),
      content: TextField(
        controller: _categoryController,
        decoration: InputDecoration(labelText: 'Nombre de la Categoría'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            // Implementar lógica para agregar categoría
            Navigator.of(context).pop();
          },
          child: Text('Agregar'),
        ),
      ],
    );
  }
}
