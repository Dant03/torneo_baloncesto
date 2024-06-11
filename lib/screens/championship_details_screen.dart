import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/championship.dart';

class ChampionshipDetailsScreen extends StatelessWidget {
  final Championship championship;

  ChampionshipDetailsScreen({required this.championship});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(championship.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fecha: ${championship.date}', style: TextStyle(fontSize: 18)),
            Text('Ubicación: ${championship.location}', style: TextStyle(fontSize: 18)),
            Text('Inscripción hasta: ${championship.registrationDeadline}', style: TextStyle(fontSize: 18)),
            Text('Inicio: ${championship.startDate}', style: TextStyle(fontSize: 18)),
            Text('Días: ${championship.daysOfWeek}', style: TextStyle(fontSize: 18)),
            Text('Horario: ${championship.startTime} - ${championship.endTime}', style: TextStyle(fontSize: 18)),
            Text('Costo del torneo: \$${championship.tournamentFee}', style: TextStyle(fontSize: 18)),
            Text('Costo de inscripción: \$${championship.registrationFee}', style: TextStyle(fontSize: 18)),
            Text('Costo por partido: \$${championship.matchFee}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
