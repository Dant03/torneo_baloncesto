class Championship {
  String? id;
  final String nombre;
  final String imagen;
  final String ubicacion;
  final int numeroDeCanchas;
  final DateTime fechaInscripciones;
  final DateTime fechaInicio;
  final List<String> diasDeJuego;
  final double costoCampeonato;
  final double costoInscripcion;
  final double costoPartido;
  final String telefonoContacto;
  final String estado;
  String? reglamento;

  Championship({
    this.id,
    required this.nombre,
    required this.imagen,
    required this.ubicacion,
    required this.numeroDeCanchas,
    required this.fechaInscripciones,
    required this.fechaInicio,
    required this.diasDeJuego,
    required this.costoCampeonato,
    required this.costoInscripcion,
    required this.costoPartido,
    required this.telefonoContacto,
    required this.estado,
    this.reglamento,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'nombre': nombre,
      'imagen': imagen,
      'ubicacion': ubicacion,
      'numero_de_canchas': numeroDeCanchas,
      'fecha_inscripciones': fechaInscripciones.toIso8601String(),
      'fecha_inicio': fechaInicio.toIso8601String(),
      'dias_de_juego': diasDeJuego,
      'costo_campeonato': costoCampeonato,
      'costo_inscripcion': costoInscripcion,
      'costo_partido': costoPartido,
      'telefono_contacto': telefonoContacto,
      'estado': estado,
      'reglamento': reglamento
    };

    // Añadir el id solo si no es null
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }

  factory Championship.fromJson(Map<String, dynamic> json) {
    return Championship(
      id: json['id'],
      nombre: json['nombre'],
      imagen: json['imagen'],
      ubicacion: json['ubicacion'],
      numeroDeCanchas: json['numero_de_canchas'],
      fechaInscripciones: DateTime.parse(json['fecha_inscripciones']),
      fechaInicio: DateTime.parse(json['fecha_inicio']),
      diasDeJuego: List<String>.from(json['dias_de_juego']),
      costoCampeonato: json['costo_campeonato'],
      costoInscripcion: json['costo_inscripcion'],
      costoPartido: json['costo_partido'],
      telefonoContacto: json['telefono_contacto'],
      estado: json['estado'],
      reglamento: json['reglamento'],
    );
  }
}
