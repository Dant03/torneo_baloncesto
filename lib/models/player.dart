class Player {
  String? id;
  final String nombre;
  final String? apellido;
  final String? cedula;
  final String? numeroCamiseta;
  final String? telefono;
  final String? correo;
  final String? generoId;
  final DateTime? fechaNacimiento;
  final DateTime? fechaCreacion;
  final String? estado;
  final String equipoId;
  final bool? aprobado;

  Player({
    this.id,
    required this.nombre,
    this.apellido,
    this.cedula,
    this.numeroCamiseta,
    this.telefono,
    this.correo,
    this.generoId,
    this.fechaNacimiento,
    this.fechaCreacion,
    this.estado,
    required this.equipoId,
    this.aprobado,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'cedula': cedula,
      'numero_camiseta': numeroCamiseta,
      'telefono': telefono,
      'correo': correo,
      'genero_id': generoId,
      'fecha_nacimiento': fechaNacimiento?.toIso8601String(),
      'fecha_creacion': fechaCreacion?.toIso8601String(),
      'estado': estado,
      'equipo_id': equipoId,
      'aprobado': aprobado,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      cedula: json['cedula'],
      numeroCamiseta: json['numero_camiseta'],
      telefono: json['telefono'],
      correo: json['correo'],
      generoId: json['genero_id'],
      fechaNacimiento: DateTime.parse(json['fecha_nacimiento']),
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      estado: json['estado'],
      equipoId: json['equipo_id'],
      aprobado: json['aprobado'],
    );
  }
}
