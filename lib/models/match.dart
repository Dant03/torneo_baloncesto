class Match {
  final String id;
  final String team1Id;
  final String team2Id;
  final DateTime date;
  final String location;
  final int scoreTeam1;
  final int scoreTeam2;
  final String refereeId;

  Match({
    required this.id,
    required this.team1Id,
    required this.team2Id,
    required this.date,
    required this.location,
    required this.scoreTeam1,
    required this.scoreTeam2,
    required this.refereeId,
  });

  factory Match.fromMap(Map<String, dynamic> map) {
    return Match(
      id: map['id'],
      team1Id: map['team1_id'],
      team2Id: map['team2_id'],
      date: DateTime.parse(map['date']),
      location: map['location'],
      scoreTeam1: map['score_team1'],
      scoreTeam2: map['score_team2'],
      refereeId: map['referee_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'team1_id': team1Id,
      'team2_id': team2Id,
      'date': date.toIso8601String(),
      'location': location,
      'score_team1': scoreTeam1,
      'score_team2': scoreTeam2,
      'referee_id': refereeId,
    };
  }
}
