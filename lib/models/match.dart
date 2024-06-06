class Match {
  final String id;
  final String team1Id;
  final String team2Id;
  final DateTime date;
  final int team1Score;
  final int team2Score;

  Match({required this.id, required this.team1Id, required this.team2Id, required this.date, required this.team1Score, required this.team2Score});

  factory Match.fromMap(Map<String, dynamic> map) {
    return Match(
      id: map['id'],
      team1Id: map['team1Id'],
      team2Id: map['team2Id'],
      date: DateTime.parse(map['date']),
      team1Score: map['team1Score'],
      team2Score: map['team2Score'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'team1Id': team1Id,
      'team2Id': team2Id,
      'date': date.toIso8601String(),
      'team1Score': team1Score,
      'team2Score': team2Score,
    };
  }
}
