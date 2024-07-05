import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/championship.dart';
import '../models/category.dart';
import '../providers/championship_provider.dart';
import '../providers/category_provider.dart';

class CreateChampionshipScreen extends StatefulWidget {
  final Championship? championship;
  final String apiKey;

  CreateChampionshipScreen({this.championship, required this.apiKey});

  @override
  _CreateChampionshipScreenState createState() => _CreateChampionshipScreenState();
}

class _CreateChampionshipScreenState extends State<CreateChampionshipScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _nombre;
  File? _imagenFile;
  String? _ubicacion;
  int? _numeroDeCanchas;
  DateTime? _fechaInscripciones;
  DateTime? _fechaInicio;
  List<String> _diasDeJuego = [];
  double? _costoCampeonato;
  double? _costoInscripcion;
  double? _costoPartido;
  String? _telefonoContacto;
  File? _reglamentoFile;
  List<String> _selectedCategories = [];
  Map<String, bool> _daysOfWeek = {
    'Lunes': false,
    'Martes': false,
    'Miércoles': false,
    'Jueves': false,
    'Viernes': false,
    'Sábado': false,
    'Domingo': false,
  };

  @override
  void initState() {
    super.initState();
    if (widget.championship != null) {
      _nombre = widget.championship!.nombre;
      _ubicacion = widget.championship!.ubicacion;
      _numeroDeCanchas = widget.championship!.numeroDeCanchas;
      _fechaInscripciones = widget.championship!.fechaInscripciones;
      _fechaInicio = widget.championship!.fechaInicio;
      _diasDeJuego = widget.championship!.diasDeJuego;
      _costoCampeonato = widget.championship!.costoCampeonato;
      _costoInscripcion = widget.championship!.costoInscripcion;
      _costoPartido = widget.championship!.costoPartido;
      _telefonoContacto = widget.championship!.telefonoContacto;
      _diasDeJuego.forEach((day) {
        if (_daysOfWeek.containsKey(day)) {
          _daysOfWeek[day] = true;
        }
      });
      // Aquí deberías cargar las categorías existentes del campeonato si estás editando
    }
    Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagenFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        _reglamentoFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _selectDate(BuildContext context, Function(DateTime?) onDateSelected) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        onDateSelected(pickedDate);
      });
    }
  }

  Future<void> _selectLocation(BuildContext context) async {
    LatLng? selectedLocation;
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text('Seleccionar Ubicación'),
        ),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(0, 0),
            zoom: 2,
          ),
          onTap: (LatLng latLng) {
            selectedLocation = latLng;
            Navigator.of(context).pop();
          },
        ),
      ),
    ));

    if (selectedLocation != null) {
      setState(() {
        _ubicacion = '${selectedLocation!.latitude},${selectedLocation!.longitude}';
      });
    }
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate() || _selectedCategories.isEmpty) {
      return;
    }
    _formKey.currentState!.save();
    _diasDeJuego = _daysOfWeek.entries.where((entry) => entry.value).map((entry) => entry.key).toList();
    final championship = Championship(
      id: widget.championship?.id,
      nombre: _nombre!,
      imagen: _imagenFile != null ? _imagenFile!.path : '',
      ubicacion: _ubicacion ?? '',
      numeroDeCanchas: _numeroDeCanchas ?? 0,
      fechaInscripciones: _fechaInscripciones ?? DateTime.now(),
      fechaInicio: _fechaInicio ?? DateTime.now(),
      diasDeJuego: _diasDeJuego,
      costoCampeonato: _costoCampeonato ?? 0.0,
      costoInscripcion: _costoInscripcion ?? 0.0,
      costoPartido: _costoPartido ?? 0.0,
      telefonoContacto: _telefonoContacto ?? '',
      estado: 'abierto', // El estado es fijo, ya que dijiste que no se necesita campo
      reglamento: _reglamentoFile != null ? _reglamentoFile!.path : null,
    );

    if (widget.championship == null) {
      await Provider.of<ChampionshipProvider>(context, listen: false).crearCampeonato(championship, _selectedCategories);
    } else {
      await Provider.of<ChampionshipProvider>(context, listen: false).updateChampionship(championship, _selectedCategories);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<CategoryProvider>(context).categorias;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.championship == null ? 'Crear Campeonato' : 'Editar Campeonato'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre'),
                initialValue: _nombre,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nombre = value;
                },
              ),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _imagenFile != null
                      ? Image.file(_imagenFile!, fit: BoxFit.cover)
                      : Center(child: Text('Seleccionar Imagen')),
                ),
              ),
              GestureDetector(
                onTap: () => _selectLocation(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Ubicación'),
                    initialValue: _ubicacion,
                    onSaved: (value) {
                      _ubicacion = value;
                    },
                  ),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Número de Canchas'),
                initialValue: _numeroDeCanchas?.toString(),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _numeroDeCanchas = int.tryParse(value ?? '0');
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Fecha de Inscripciones'),
                      controller: TextEditingController(
                        text: _fechaInscripciones != null ? _fechaInscripciones!.toIso8601String().split('T')[0] : '',
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context, (date) => _fechaInscripciones = date),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, (date) => _fechaInscripciones = date),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Fecha de Inicio'),
                      controller: TextEditingController(
                        text: _fechaInicio != null ? _fechaInicio!.toIso8601String().split('T')[0] : '',
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context, (date) => _fechaInicio = date),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, (date) => _fechaInicio = date),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _daysOfWeek.keys.map((day) {
                  return CheckboxListTile(
                    title: Text(day),
                    value: _daysOfWeek[day],
                    onChanged: (bool? value) {
                      setState(() {
                        _daysOfWeek[day] = value ?? false;
                      });
                    },
                  );
                }).toList(),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Costo del Campeonato'),
                initialValue: _costoCampeonato?.toString(),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _costoCampeonato = double.tryParse(value ?? '0.0');
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Costo de Inscripción'),
                initialValue: _costoInscripcion?.toString(),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _costoInscripcion = double.tryParse(value ?? '0.0');
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Costo por Partido'),
                initialValue: _costoPartido?.toString(),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _costoPartido = double.tryParse(value ?? '0.0');
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Teléfono de Contacto'),
                initialValue: _telefonoContacto,
                onSaved: (value) {
                  _telefonoContacto = value;
                },
              ),
              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _reglamentoFile != null
                      ? Center(child: Text('Archivo seleccionado: ${_reglamentoFile!.path.split('/').last}'))
                      : Center(child: Text('Seleccionar Reglamento (PDF)')),
                ),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Categorías'),
                items: categories.map((Category category) {
                  return DropdownMenuItem<String>(
                    value: category.id,
                    child: Text(category.nombre),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null && !_selectedCategories.contains(value)) {
                    setState(() {
                      _selectedCategories.add(value);
                    });
                  }
                },
                validator: (value) {
                  if (_selectedCategories.isEmpty) {
                    return 'Por favor seleccione al menos una categoría';
                  }
                  return null;
                },
              ),
              Wrap(
                spacing: 8.0,
                children: _selectedCategories.map((categoryId) {
                  final category = categories.firstWhere((cat) => cat.id == categoryId);
                  return Chip(
                    label: Text(category.nombre),
                    onDeleted: () {
                      setState(() {
                        _selectedCategories.remove(categoryId);
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text(widget.championship == null ? 'Crear' : 'Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
