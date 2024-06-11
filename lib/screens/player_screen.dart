import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/player.dart';
import '../providers/player_provider.dart';

class PlayerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Jugadores'),
      ),
      body: FutureBuilder(
        future: playerProvider.fetchPlayers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar jugadores'));
          } else if (!snapshot.hasData || playerProvider.players.isEmpty) {
            return Center(child: Text('No hay jugadores disponibles'));
          } else {
            return ListView.builder(
              itemCount: playerProvider.players.length,
              itemBuilder: (context, index) {
                final player = playerProvider.players[index];
                return ListTile(
                  title: Text(player.name),
                  subtitle: Text('Equipo: ${player.teamId}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Agregar funcionalidad para eliminar jugador
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
          // Agregar funcionalidad para añadir un nuevo jugador
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
