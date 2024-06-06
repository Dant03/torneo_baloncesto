class Team {
  final String id;
  final String name;
  final String coachId;

  Team({required this.id, required this.name, required this.coachId});

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['id'],
      name: map['name'],
      coachId: map['coachId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'coachId': coachId,
    };
  }
}
