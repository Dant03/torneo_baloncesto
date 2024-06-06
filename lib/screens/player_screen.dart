import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';

class PlayerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Players'),
      ),
      body: ListView.builder(
        itemCount: playerProvider.players.length,
        itemBuilder: (context, index) {
          final player = playerProvider.players[index];
          return ListTile(
            title: Text(player.name),
            subtitle: Text('Position: ${player.position}, Number: ${player.number}'),
          );
        },
      ),
    );
  }
}
