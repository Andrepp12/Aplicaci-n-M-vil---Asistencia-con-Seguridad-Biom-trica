class Rostro {
  final String id;
  final String? rekogId;
  final String docenteId;
  final String selfie;
  final String? estado = 'pendiente';

  Rostro({
    required this.id,
    required this.selfie,
    required this.docenteId,
    this.rekogId,
  });

  // to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'rekog_id': rekogId,
        'docente_id': docenteId,
        'selfie': selfie,
        'estado': estado,
      };

  // from json
  factory Rostro.fromJson(Map<String, dynamic> json) => Rostro(
        id: json['id'],
        rekogId: json['rekog_id'],
        docenteId: json['docente_id'],
        selfie: json['selfie'],
      );
}
