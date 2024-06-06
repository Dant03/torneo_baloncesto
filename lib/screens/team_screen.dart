import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/team_provider.dart';

class TeamScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final teamProvider = Provider.of<TeamProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Teams'),
      ),
      body: ListView.builder(
        itemCount: teamProvider.teams.length,
        itemBuilder: (context, index) {
          final team = teamProvider.teams[index];
          return ListTile(
            title: Text(team.name),
            subtitle: Text('Coach: ${team.coachId}'),
          );
        },
      ),
    );
  }
}
