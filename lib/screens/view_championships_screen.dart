import 'package:flutter/material.dart';

class ViewChampionshipsScreen extends StatelessWidget {
  const ViewChampionshipsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ver Campeonatos'),
      ),
      body: Center(
        child: const Text('Aquí se mostrarán los campeonatos.'),
      ),
    );
  }
}
