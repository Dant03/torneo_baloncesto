class Position {
  final String id;
  final String name;

  Position({required this.id, required this.name});

  factory Position.fromMap(Map<String, dynamic> map) {
    return Position(
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
