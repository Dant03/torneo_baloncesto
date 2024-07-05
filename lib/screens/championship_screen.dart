/* import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/championship.dart';
import '../providers/championship_provider.dart';

class ChampionshipScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final championshipProvider = Provider.of<ChampionshipProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Campeonatos'),
      ),
      body: FutureBuilder(
        future: championshipProvider.fetchChampionships(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar campeonatos'));
          } else if (!snapshot.hasData || championshipProvider.championships.isEmpty) {
            return Center(child: Text('No hay campeonatos disponibles'));
          } else {
            return ListView.builder(
              itemCount: championshipProvider.championships.length,
              itemBuilder: (context, index) {
                final championship = championshipProvider.championships[index];
                return ListTile(
                  title: Text(championship.name),
                  subtitle: Text('Número de canchas: ${championship.numberOfCourts}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Agregar funcionalidad para eliminar campeonato
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
          // Agregar funcionalidad para añadir un nuevo campeonato
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
 */