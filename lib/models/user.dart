class AppUser {
  final String id;
  final String nombre;
  final String email;
  final String rol;

  AppUser({
    required this.id,
    required this.nombre,
    required this.email,
    required this.rol,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'],
      nombre: map['nombre'],
      email: map['email'],
      rol: map['rol'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'rol': rol,
    };
  }
}
