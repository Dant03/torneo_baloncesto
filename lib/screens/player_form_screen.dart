import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Asegúrate de importar el paquete intl
import '../models/player.dart';

class PlayerFormScreen extends StatefulWidget {
  final Player? player;
  final String teamId;

  PlayerFormScreen({this.player, required this.teamId});

  @override
  _PlayerFormScreenState createState() => _PlayerFormScreenState();
}

class _PlayerFormScreenState extends State<PlayerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _idController = TextEditingController();
  final _numberController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthDateController = TextEditingController();
  String? _selectedGender;
  bool? _approved;

  @override
  void initState() {
    super.initState();
    if (widget.player != null) {
      _nameController.text = widget.player!.nombre;
      _lastNameController.text = widget.player!.apellido ?? '';
      _idController.text = widget.player!.cedula ?? '';
      _numberController.text = widget.player!.numeroCamiseta ?? '';
      _phoneController.text = widget.player!.telefono ?? '';
      _emailController.text = widget.player!.correo ?? '';
      _birthDateController.text = widget.player!.fechaNacimiento != null 
          ? DateFormat('yyyy-MM-dd').format(widget.player!.fechaNacimiento!)
          : '';
      _selectedGender = widget.player!.generoId ?? '';
      _approved = widget.player!.aprobado ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.player != null ? 'Editar Jugador' : 'Crear Jugador'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Verificar si es web o móvil
          if (kIsWeb) {
            return _buildWebLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  Widget _buildWebLayout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextFormField(_nameController, 'Nombre'),
                  _buildTextFormField(_lastNameController, 'Apellido'),
                  _buildTextFormField(_idController, 'Cédula'),
                  _buildTextFormField(_numberController, 'Número de Camiseta', TextInputType.number),
                  _buildTextFormField(_phoneController, 'Teléfono', TextInputType.phone),
                  _buildTextFormField(_emailController, 'Correo Electrónico', TextInputType.emailAddress),
                  _buildDatePickerFormField(_birthDateController, 'Fecha de Nacimiento'),
                  _buildDropdownFormField('Género', ['Masculino', 'Femenino']),
                  _buildSwitchListTile(),
                  SizedBox(height: 20),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            _buildTextFormField(_nameController, 'Nombre'),
            _buildTextFormField(_lastNameController, 'Apellido'),
            _buildTextFormField(_idController, 'Cédula'),
            _buildTextFormField(_numberController, 'Número de Camiseta', TextInputType.number),
            _buildTextFormField(_phoneController, 'Teléfono', TextInputType.phone),
            _buildTextFormField(_emailController, 'Correo Electrónico', TextInputType.emailAddress),
            _buildDatePickerFormField(_birthDateController, 'Fecha de Nacimiento'),
            _buildDropdownFormField('Género', ['Masculino', 'Femenino']),
            _buildSwitchListTile(),
            SizedBox(height: 20),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label, [TextInputType keyboardType = TextInputType.text]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese el $label';
        }
        return null;
      },
    );
  }

  Widget _buildDatePickerFormField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          setState(() {
            controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          });
        }
      },
      readOnly: true,
    );
  }

  Widget _buildDropdownFormField(String label, List<String> items) {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item.toLowerCase(),
          child: Text(item),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedGender = value;
        });
      },
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null) {
          return 'Por favor seleccione el $label';
        }
        return null;
      },
    );
  }

  Widget _buildSwitchListTile() {
    return SwitchListTile(
      title: Text('Aprobado'),
      value: _approved ?? false,
      onChanged: (value) {
        setState(() {
          _approved = value;
        });
      },
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Guardar jugador
        }
      },
      child: Text(widget.player != null ? 'Actualizar' : 'Guardar'),
    );
  }
}
