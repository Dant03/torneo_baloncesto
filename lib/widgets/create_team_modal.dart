import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import '../models/team.dart';
import '../providers/team_provider.dart';

class CreateTeamModal extends StatefulWidget {
  final String championshipId;
  final List<String> categoryIds;
  final List<String> categoryNames;

  CreateTeamModal({required this.championshipId, required this.categoryIds, required this.categoryNames});

  @override
  _CreateTeamModalState createState() => _CreateTeamModalState();
}

class _CreateTeamModalState extends State<CreateTeamModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _captainNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  File? _image;
  String? _selectedCategoryId;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() && _selectedCategoryId != null) {
      final team = Team(
        nombre: _nameController.text,
        logotipo: _image != null ? path.basename(_image!.path) : 'https://sezusjbiuccuqlyjjkud.supabase.co/storage/v1/object/public/campeonatos/defaultEquipo.png',
        nombreCapitan: _captainNameController.text,
        telefono: _phoneController.text,
        correo: _emailController.text,
        fechaCreacion: DateTime.now(),
        estado: 'pendiente',
      );

      try {
        final teamProvider = Provider.of<TeamProvider>(context, listen: false);
        final teamId = await teamProvider.createTeam(team, widget.championshipId, [_selectedCategoryId!]);

        if (_image != null) {
          // Subir la imagen al servidor aquí
        }

        Navigator.of(context).pop(); // Cierra el modal
        Navigator.of(context).pushNamed(
          '/team-details',
          arguments: {'teamId': teamId, 'teamName': team.nombre},
        );
      } catch (error) {
        print('Error: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Crear Equipo'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre del equipo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre del equipo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _captainNameController,
                decoration: InputDecoration(labelText: 'Nombre del Capitán'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre del capitán';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el teléfono';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Correo Electrónico'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el correo electrónico';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Categoría'),
                items: widget.categoryNames.map((categoryName) {
                  final index = widget.categoryNames.indexOf(categoryName);
                  return DropdownMenuItem<String>(
                    value: widget.categoryIds[index],
                    child: Text(categoryName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor seleccione una categoría';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: _image == null
                      ? Center(child: Icon(Icons.add_a_photo, size: 50))
                      : Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text('Guardar'),
        ),
      ],
    );
  }
}
