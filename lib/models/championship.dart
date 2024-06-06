class Championship {
  final String name;
  final int numberOfCourts;
  final DateTime maxRegistrationDate;
  final DateTime startDate;
  final List<String> gameDays;
  final Map<String, Map<String, int>> categories;

  Championship({
    required this.name,
    required this.numberOfCourts,
    required this.maxRegistrationDate,
    required this.startDate,
    required this.gameDays,
    required this.categories,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'number_of_courts': numberOfCourts,
      'max_registration_date': maxRegistrationDate.toIso8601String(),
      'start_date': startDate.toIso8601String(),
      'game_days': gameDays,
      'categories': categories,
    };
  }

  factory Championship.fromMap(Map<String, dynamic> map) {
    return Championship(
      name: map['name'],
      numberOfCourts: map['number_of_courts'],
      maxRegistrationDate: DateTime.parse(map['max_registration_date']),
      startDate: DateTime.parse(map['start_date']),
      gameDays: List<String>.from(map['game_days']),
      categories: Map<String, Map<String, int>>.from(map['categories']),
    );
  }
}
