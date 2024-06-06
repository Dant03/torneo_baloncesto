import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/referee_provider.dart';

class RefereeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final refereeProvider = Provider.of<RefereeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Referees'),
      ),
      body: ListView.builder(
        itemCount: refereeProvider.referees.length,
        itemBuilder: (context, index) {
          final referee = refereeProvider.referees[index];
          return ListTile(
            title: Text(referee.name),
            subtitle: Text('Matches: ${referee.matchesIds.length}'),
          );
        },
      ),
    );
  }
}
