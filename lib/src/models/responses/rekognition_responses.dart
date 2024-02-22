import 'package:unt_biometric_auth/src/models/docente.dart';

class DetectFaceResponse {
  final String type;
  final List<String>? errors;

  DetectFaceResponse({required this.type, this.errors});
  // from json
  factory DetectFaceResponse.fromJson(Map<String, dynamic> json) =>
      DetectFaceResponse(
        type: json["type"],
        errors:
            json["errors"] != null ? List<String>.from(json["errors"]) : null,
      );
}

class LoginRekognitionResponse {
  final String type;
  final List<String>? errors;
  final Docente? docente;
  final String? fotoVerificacion;
  final String? intentoId;

  LoginRekognitionResponse(
      {required this.type, this.errors, this.docente, this.fotoVerificacion, this.intentoId});

  // from json
  factory LoginRekognitionResponse.fromJson(Map<String, dynamic> json) =>
      LoginRekognitionResponse(
        type: json["type"],
        errors:
            json["errors"] != null ? List<String>.from(json["errors"]) : null,
        docente:
            json["docente"] != null ? Docente.fromJson(json["docente"]) : null,
        fotoVerificacion: json["foto_verificacion"],
        intentoId: json["intento_id"],
      );
  
  // to json
  Map<String, dynamic> toJson() => {
        "type": type,
        "errors": errors != null ? List<dynamic>.from(errors!) : null,
        "docente": docente?.toJson(),
        "foto_verificacion": fotoVerificacion,
        "intento_id": intentoId,
      };
}
