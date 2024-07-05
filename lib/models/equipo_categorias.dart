class EquipoCategoria {
  String? id;
  final String equipoId;
  final String categoriaId;

  EquipoCategoria({
    this.id,
    required this.equipoId,
    required this.categoriaId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'equipo_id': equipoId,
      'categoria_id': categoriaId,
    };
  }

  factory EquipoCategoria.fromJson(Map<String, dynamic> json) {
    return EquipoCategoria(
      id: json['id'],
      equipoId: json['equipo_id'],
      categoriaId: json['categoria_id'],
    );
  }
}
