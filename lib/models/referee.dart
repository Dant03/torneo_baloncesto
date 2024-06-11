class Referee {
  final String id;
  final String name;

  Referee({
    required this.id,
    required this.name,
  });

  factory Referee.fromMap(Map<String, dynamic> map) {
    return Referee(
      id: map['id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
