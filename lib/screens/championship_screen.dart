import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/championship_provider.dart';

class ChampionshipsScreen extends StatelessWidget {
  const ChampionshipsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final championshipProvider = Provider.of<ChampionshipProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campeonatos'),
      ),
      body: FutureBuilder(
        future: championshipProvider.fetchChampionships(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            if (championshipProvider.championships.isEmpty) {
              return const Center(child: Text('No hay campeonatos disponibles.'));
            } else {
              return ListView.builder(
                itemCount: championshipProvider.championships.length,
                itemBuilder: (context, index) {
                  final championship = championshipProvider.championships[index];
                  return ListTile(
                    title: Text(championship.name),
                    subtitle: Text('Número de Canchas: ${championship.numberOfCourts}'),
                    onTap: () {
                      // Navegar a los detalles del campeonato
                    },
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
