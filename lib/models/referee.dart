class Referee {
  final String id;
  final String name;
  final List<String> matchesIds;

  Referee({required this.id, required this.name, required this.matchesIds});

  factory Referee.fromMap(Map<String, dynamic> map) {
    return Referee(
      id: map['id'],
      name: map['name'],
      matchesIds: List<String>.from(map['matchesIds']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'matchesIds': matchesIds,
    };
  }
}
