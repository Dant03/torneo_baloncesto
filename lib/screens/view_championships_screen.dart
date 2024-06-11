import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/championship_provider.dart';
import '../models/championship.dart';

class ViewChampionshipsScreen extends StatelessWidget {
  const ViewChampionshipsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campeonatos'),
      ),
      body: Consumer<ChampionshipProvider>(
        builder: (context, championshipProvider, child) {
          return FutureBuilder(
            future: championshipProvider.fetchChampionships(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final championships = championshipProvider.championships;
                if (championships.isEmpty) {
                  return const Center(child: Text('No hay campeonatos registrados.'));
                } else {
                  return ListView.builder(
                    itemCount: championships.length,
                    itemBuilder: (context, index) {
                      final championship = championships[index];
                      return ListTile(
                        title: Text(championship.name),
                        subtitle: Text('Fecha de inicio: ${championship.startDate}'),
                      );
                    },
                  );
                }
              }
            },
          );
        },
      ),
    );
  }
}
