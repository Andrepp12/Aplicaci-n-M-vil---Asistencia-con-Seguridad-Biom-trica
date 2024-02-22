import 'package:unt_biometric_auth/src/models/registro.dart';

class CreateRegistroDto {
  String? docenteId;
  TipoRegistro? tipo;
  double? latitud;
  double? longitud;
  String? fotoVerificacion;
  late int inicioRegistro = DateTime.now().millisecondsSinceEpoch;
  int? finGeolocalizacion;
  int? inicioBiometricoLocal;
  int? finBiometricoLocal;
  int? inicioBiometricoFacial;
  int? finBiometricoFacial;
  int? finRegistro;

  late List<IntentoFacial> intentosBiometricosFacial = [];

  CreateRegistroDto({
    this.docenteId,
    this.tipo,
    this.latitud,
    this.longitud,
    this.fotoVerificacion,
    this.finRegistro,
  });
}


class IntentoFacial {
  String? intentoId;
  String? descripcion;

  IntentoFacial({this.intentoId, this.descripcion});
}