enum TipoRegistro {
  entrada,
  salida,
}

class Ubicacion {
  final double latitud;
  final double longitud;
  Ubicacion({required this.latitud, required this.longitud});
}

class Registro {
  final String id;
  final String docenteId;
  final TipoRegistro tipo;
  final Ubicacion ubicacion;
  final String? fotoVerificacion;
  final DateTime createdAt;
  int? inicioRegistro;
  int? finGeolocalizacion;
  int? inicioBiometricoLocal;
  int? finBiometricoLocal;
  int? inicioBiometricoFacial;
  int? finBiometricoFacial;
  int? finRegistro;

  int? totalIntentos;

  Registro({
    required this.id,
    required this.docenteId,
    required this.tipo,
    required this.ubicacion,
    required this.createdAt,
    this.fotoVerificacion,
    this.inicioRegistro,
    this.finGeolocalizacion,
    this.inicioBiometricoLocal,
    this.finBiometricoLocal,
    this.inicioBiometricoFacial,
    this.finBiometricoFacial,
    this.finRegistro,
    this.totalIntentos,
  });

  // to json
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "docente_id": docenteId,
      "tipo": tipo.name,
      "ubicacion": {
        "latitud": ubicacion.latitud,
        "longitud": ubicacion.longitud,
      },
      "foto_verificacion": fotoVerificacion,
      "created_at": createdAt.toUtc().toIso8601String(),
      "inicio_registro": inicioRegistro,
      "fin_geolocalizacion": finGeolocalizacion,
      "inicio_biometrico_local": inicioBiometricoLocal,
      "fin_biometrico_local": finBiometricoLocal,
      "inicio_biometrico_facial": inicioBiometricoFacial,
      "fin_biometrico_facial": finBiometricoFacial,
      "fin_registro": finRegistro,
      "total_intentos": totalIntentos,
    };
  }

  // from json
  factory Registro.fromJson(Map<String, dynamic> json) {
    return Registro(
      id: json["id"],
      docenteId: json["docente_id"],
      tipo: json["tipo"] == "entrada"
          ? TipoRegistro.entrada
          : TipoRegistro.salida,
      ubicacion: Ubicacion(
        latitud: json["ubicacion"]["latitud"],
        longitud: json["ubicacion"]["longitud"],
      ),
      fotoVerificacion: json["foto_verificacion"],
      createdAt: DateTime.parse(json["created_at"]).toLocal(),
    );
  }
}
