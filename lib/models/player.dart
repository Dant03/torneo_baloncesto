class Player {
  final String id;
  final String name;
  final String teamId;
  final String position;
  final int number;

  Player({required this.id, required this.name, required this.teamId, required this.position, required this.number});

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'],
      name: map['name'],
      teamId: map['teamId'],
      position: map['position'],
      number: map['number'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'teamId': teamId,
      'position': position,
      'number': number,
    };
  }
}
