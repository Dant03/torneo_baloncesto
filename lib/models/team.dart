class Team {
  String? id;
  final String nombre;
  final String? logotipo;
  final String? nombreCapitan;
  final String? telefono;
  final String? correo;
  final DateTime? fechaCreacion;
  final String? estado;

  Team({
    this.id,
    required this.nombre,
    this.logotipo,
    this.nombreCapitan,
    this.telefono,
    this.correo,
    this.fechaCreacion,
    this.estado,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'logotipo': logotipo,
      'nombre_capitan': nombreCapitan,
      'telefono': telefono,
      'correo': correo,
      'fecha_creacion': fechaCreacion?.toIso8601String(),
      'estado': estado,
    };
  }

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      nombre: json['nombre'],
      logotipo: json['logotipo'],
      nombreCapitan: json['nombre_capitan'],
      telefono: json['telefono'],
      correo: json['correo'],
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      estado: json['estado'],
    );
  }
}
