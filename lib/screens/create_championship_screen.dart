import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/championship.dart';
import '../providers/championship_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/counter.dart';  // Importar el widget Counter

class CreateChampionshipScreen extends StatefulWidget {
  const CreateChampionshipScreen({Key? key}) : super(key: key);

  @override
  _CreateChampionshipScreenState createState() => _CreateChampionshipScreenState();
}

class _CreateChampionshipScreenState extends State<CreateChampionshipScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _maxRegistrationDateController = TextEditingController();
  final _startDateController = TextEditingController();
  int _numberOfCourts = 1;
  DateTime? _selectedMaxRegistrationDate;
  DateTime? _selectedStartDate;
  List<String> _selectedGameDays = [];
  List<String> _selectedCategories = [];

  void _pickDate(BuildContext context, TextEditingController controller, Function(DateTime) onPicked) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.toIso8601String().split('T').first;
        onPicked(picked);
      });
    }
  }

  void _createChampionship(BuildContext context) {
    if (_formKey.currentState!.validate() && _selectedMaxRegistrationDate != null && _selectedStartDate != null && _selectedGameDays.isNotEmpty && _selectedCategories.isNotEmpty) {
      final championshipProvider = Provider.of<ChampionshipProvider>(context, listen: false);
      final Map<String, Map<String, int>> categories = {
        for (var category in _selectedCategories) category: {'min': 0, 'max': 0}
      };

      final championship = Championship(
        name: _nameController.text,
        numberOfCourts: _numberOfCourts,
        maxRegistrationDate: _selectedMaxRegistrationDate!,
        startDate: _selectedStartDate!,
        gameDays: _selectedGameDays,
        categories: categories,
      );

      championshipProvider.createChampionship(championship).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Campeonato creado exitosamente')),
        );
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear el campeonato: $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Campeonato'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre del Campeonato'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, introduce un nombre para el campeonato';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Número de Canchas'),
              Counter(
                minValue: 1,
                maxValue: 10,
                initialValue: _numberOfCourts,
                onChanged: (value) {
                  setState(() {
                    _numberOfCourts = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _maxRegistrationDateController,
                decoration: const InputDecoration(labelText: 'Fecha Máxima de Inscripción'),
                readOnly: true,
                onTap: () => _pickDate(context, _maxRegistrationDateController, (date) {
                  _selectedMaxRegistrationDate = date;
                }),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, selecciona una fecha';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _startDateController,
                decoration: const InputDecoration(labelText: 'Fecha de Inicio'),
                readOnly: true,
                onTap: () => _pickDate(context, _startDateController, (date) {
                  _selectedStartDate = date;
                }),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, selecciona una fecha';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Días de Juego'),
              Wrap(
                spacing: 8.0,
                children: ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo']
                    .map((day) => FilterChip(
                          label: Text(day),
                          selected: _selectedGameDays.contains(day),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedGameDays.add(day);
                              } else {
                                _selectedGameDays.remove(day);
                              }
                            });
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              const Text('Categorías'),
              Wrap(
                spacing: 8.0,
                children: ['Infantil', 'Juvenil', 'Adulto', 'Senior']
                    .map((category) => FilterChip(
                          label: Text(category),
                          selected: _selectedCategories.contains(category),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedCategories.add(category);
                              } else {
                                _selectedCategories.remove(category);
                              }
                            });
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Crear Campeonato',
                onPressed: () => _createChampionship(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
