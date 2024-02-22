class CreateDocenteDto {
  final String nombres;
  final String apellidos;
  final String correo;
  final String escuelaId;
  final String telefono;
  final String? avatarUrl;

  CreateDocenteDto({
    required this.nombres,
    required this.apellidos,
    required this.correo,
    required this.escuelaId,
    required this.telefono,
    this.avatarUrl,
  });
}
