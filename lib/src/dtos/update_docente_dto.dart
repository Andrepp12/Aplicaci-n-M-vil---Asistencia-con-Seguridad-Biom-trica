class UpdateDocenteDto {
  final String id;
  final String nombres;
  final String apellidos;
  final String correo;
  final String escuelaId;
  final String telefono;
  final String? avatarUrl;

  UpdateDocenteDto(
      {required this.id,
      required this.nombres,
      required this.apellidos,
      required this.correo,
      required this.escuelaId,
      required this.telefono,
      this.avatarUrl});
}
