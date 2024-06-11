class Team {
  final String id;
  final String name;
  final String championshipId;
  final String categoryId;
  final String coachId;

  Team({
    required this.id,
    required this.name,
    required this.championshipId,
    required this.categoryId,
    required this.coachId,
  });

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['id'],
      name: map['name'],
      championshipId: map['championship_id'],
      categoryId: map['category_id'],
      coachId: map['coach_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'championship_id': championshipId,
      'category_id': categoryId,
      'coach_id': coachId,
    };
  }
}
