class CampeonatoEquipo {
  String? id;
  final String campeonatoId;
  final String equipoId;

  CampeonatoEquipo({
    this.id,
    required this.campeonatoId,
    required this.equipoId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'campeonato_id': campeonatoId,
      'equipo_id': equipoId,
    };
  }

  factory CampeonatoEquipo.fromJson(Map<String, dynamic> json) {
    return CampeonatoEquipo(
      id: json['id'],
      campeonatoId: json['campeonato_id'],
      equipoId: json['equipo_id'],
    );
  }
}
