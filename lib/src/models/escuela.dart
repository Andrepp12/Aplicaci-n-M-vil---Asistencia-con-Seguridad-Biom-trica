class Escuela {
  final String id;
  final String nombre;
  final String facultad;

  Escuela({
    required this.id,
    required this.nombre,
    required this.facultad,
  });

  // from json
  factory Escuela.fromJson(Map<String, dynamic> json) => Escuela(
        id: json['id'],
        nombre: json['nombre'],
        facultad: (json['facultad'] as Map<String, dynamic>)['nombre'],
      );
}
