import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../models/championship.dart';
import '../providers/championship_provider.dart';

class CreateChampionshipScreen extends StatefulWidget {
  @override
  _CreateChampionshipScreenState createState() => _CreateChampionshipScreenState();
}

class _CreateChampionshipScreenState extends State<CreateChampionshipScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _tournamentFeeController = TextEditingController();
  final _registrationFeeController = TextEditingController();
  final _matchFeeController = TextEditingController();
  final _numberOfCourtsController = TextEditingController();
  DateTime? _registrationDeadline;
  DateTime? _startDate;
  String _daysOfWeek = '';
  String _startTime = '';
  String _endTime = '';

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  void _createChampionship() async {
    if (_formKey.currentState!.validate()) {
      try {
        final registrationDeadline = _registrationDeadline ?? DateTime.now().add(Duration(days: 7));
        final startDate = _startDate ?? DateTime.now().add(Duration(days: 14));
        final tournamentFee = double.tryParse(_tournamentFeeController.text) ?? 0.0;
        final registrationFee = double.tryParse(_registrationFeeController.text) ?? 0.0;
        final matchFee = double.tryParse(_matchFeeController.text) ?? 0.0;
        final numberOfCourts = int.tryParse(_numberOfCourtsController.text) ?? 0;

        final championship = Championship(
          id: Uuid().v4(),
          name: _nameController.text,
          date: DateTime.now(),
          location: _locationController.text,
          registrationDeadline: registrationDeadline,
          startDate: startDate,
          daysOfWeek: _daysOfWeek,
          startTime: _startTime.isNotEmpty ? _startTime : '09:00',
          endTime: _endTime.isNotEmpty ? _endTime : '18:00',
          tournamentFee: tournamentFee,
          registrationFee: registrationFee,
          matchFee: matchFee,
          imageUrl: '',
          numberOfCourts: numberOfCourts,
        );

        final provider = Provider.of<ChampionshipProvider>(context, listen: false);
        await provider.createChampionship(championship);
        Navigator.pop(context);
      } catch (error) {
        print('Error creating championship: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${error.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Campeonato'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                  validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: 'Ubicación'),
                  validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                ),
                TextFormField(
                  controller: _tournamentFeeController,
                  decoration: InputDecoration(labelText: 'Costo del torneo'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                ),
                TextFormField(
                  controller: _registrationFeeController,
                  decoration: InputDecoration(labelText: 'Costo de inscripción'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                ),
                TextFormField(
                  controller: _matchFeeController,
                  decoration: InputDecoration(labelText: 'Costo por partido'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                ),
                TextFormField(
                  controller: _numberOfCourtsController,
                  decoration: InputDecoration(labelText: 'Número de canchas'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                ),
                ElevatedButton(
                  onPressed: _createChampionship,
                  child: Text('Crear Campeonato'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
