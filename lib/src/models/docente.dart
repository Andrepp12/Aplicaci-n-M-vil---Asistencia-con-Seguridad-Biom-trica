enum DocenteStatus {
  pending,
  approved,
  rejected,
}

class Docente {
  final String id;
  final String nombres;
  final String apellidos;
  final String correo;
  final String escuelaId;
  final String telefono;
  final Enum? status;
  final String userId;
  final String? avatarUrl;
  bool hasRostro = false;

  Docente({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.correo,
    required this.escuelaId,
    required this.telefono,
    required this.userId,
    this.status,
    this.avatarUrl,
  });

  // to json
  Map<String, dynamic> toJson() => {
        "id": id,
        "nombres": nombres,
        "apellidos": apellidos,
        "correo": correo,
        "escuela_id": escuelaId,
        "telefono": telefono,
        "status": status?.name,
        "avatar_url": avatarUrl,
        "user_id": userId,
      };

  // from json
  factory Docente.fromJson(Map<String, dynamic> json) => Docente(
        id: json["id"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        correo: json["correo"],
        escuelaId: json["escuela_id"],
        telefono: json["telefono"],
        userId: json["user_id"],
        status: DocenteStatus.values.firstWhere(
            (element) => element.name == json["status"],
            orElse: () => DocenteStatus.pending),
        avatarUrl: json["avatar_url"],
      );
}
