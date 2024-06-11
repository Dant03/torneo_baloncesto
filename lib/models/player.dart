class Player {
  final String id;
  final String name;
  final String teamId;

  Player({
    required this.id,
    required this.name,
    required this.teamId,
  });

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'],
      name: map['name'],
      teamId: map['team_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'team_id': teamId,
    };
  }
}
