import 'package:flutter/material.dart';
import 'package:unt_biometric_auth/src/models/docente.dart';
import 'package:unt_biometric_auth/src/services/docente_service.dart';
import 'package:unt_biometric_auth/src/services/rostro_service.dart';

class DocenteModel extends ChangeNotifier {
  Docente? _docente;
  final DocenteService _docenteService = DocenteService();
  final RostroService _rostroService = RostroService();
  Future<void> init() async {
    _docente = await _docenteService.getDocenteOfCurrentUser();
    if (_docente != null) {
      bool hasRostro =
          await _rostroService.thisDocenteHasRostro(_docente!.id);
      _docente!.hasRostro = hasRostro;
      _docenteService.suscribeDocenteOnUpdate(_docente!.id, (docente) {
        _docente = docente;
        _docente!.hasRostro = hasRostro;
        notifyListeners();
      });
    }

    notifyListeners();
  }

  Docente? get docente => _docente;
}
