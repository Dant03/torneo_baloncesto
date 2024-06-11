class ChampionshipCategory {
  final String id;
  final String championshipId;
  final String categoryId;

  ChampionshipCategory({
    required this.id,
    required this.championshipId,
    required this.categoryId,
  });

  factory ChampionshipCategory.fromMap(Map<String, dynamic> map) {
    return ChampionshipCategory(
      id: map['id'],
      championshipId: map['championship_id'],
      categoryId: map['category_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'championship_id': championshipId,
      'category_id': categoryId,
    };
  }
}
