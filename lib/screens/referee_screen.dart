import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/referee.dart';
import '../providers/referee_provider.dart';

class RefereeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final refereeProvider = Provider.of<RefereeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Árbitros'),
      ),
      body: FutureBuilder(
        future: refereeProvider.fetchReferees(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar árbitros'));
          } else if (!snapshot.hasData || refereeProvider.referees.isEmpty) {
            return Center(child: Text('No hay árbitros disponibles'));
          } else {
            return ListView.builder(
              itemCount: refereeProvider.referees.length,
              itemBuilder: (context, index) {
                final referee = refereeProvider.referees[index];
                return ListTile(
                  title: Text(referee.name),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Agregar funcionalidad para eliminar árbitro
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Agregar funcionalidad para añadir un nuevo árbitro
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
