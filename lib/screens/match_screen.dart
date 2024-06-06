import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/match_provider.dart';

class MatchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final matchProvider = Provider.of<MatchProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Matches'),
      ),
      body: ListView.builder(
        itemCount: matchProvider.matches.length,
        itemBuilder: (context, index) {
          final match = matchProvider.matches[index];
          return ListTile(
            title: Text('Match: ${match.team1Id} vs ${match.team2Id}'),
            subtitle: Text('Date: ${match.date}, Score: ${match.team1Score}-${match.team2Score}'),
          );
        },
      ),
    );
  }
}
