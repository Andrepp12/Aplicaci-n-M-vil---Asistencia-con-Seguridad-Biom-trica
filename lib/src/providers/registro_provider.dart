import 'package:flutter/material.dart';
import 'package:unt_biometric_auth/src/dtos/create_registro_dto.dart';
import 'package:unt_biometric_auth/src/models/registro.dart';
import 'package:unt_biometric_auth/src/services/docente_service.dart';
import 'package:unt_biometric_auth/src/services/registro_service.dart';

class RegistroProvider extends ChangeNotifier {
  final List<Registro> _registrosToday = [];
  final _registroService = RegistroService();

  Registro? _lastEntrada;
  Registro? get lastEntrada => _lastEntrada;

  Registro? _lastSalida;
  Registro? get lastSalida => _lastSalida;

  Registro? _lastRegistro;
  Registro? get lastRegistro => _lastRegistro;

  CreateRegistroDto? _creatingRegistro;
  CreateRegistroDto? get creatingRegistro => _creatingRegistro;

  List<Registro> get registrosToday => _registrosToday;

  final DocenteService _docenteService = DocenteService();

  RegistroProvider() {
    init();
  }

  void initCreateRegistro() {
    _creatingRegistro = CreateRegistroDto();
    _creatingRegistro?.inicioRegistro = DateTime.now().millisecondsSinceEpoch;
  }

  void setCreatingTerminoGeolocalizacion() {
    _creatingRegistro?.finGeolocalizacion =
        DateTime.now().millisecondsSinceEpoch;
  }

  void setCreatingInicioBiometricoLocal() {
    _creatingRegistro?.inicioBiometricoLocal =
        DateTime.now().millisecondsSinceEpoch;
  }

  void setCreatingFinBiometricoLocal() {
    _creatingRegistro?.finBiometricoLocal =
        DateTime.now().millisecondsSinceEpoch;
  }

  void setCreatingInicioBiometricoFacial() {
    _creatingRegistro?.inicioBiometricoFacial =
        DateTime.now().millisecondsSinceEpoch;
  }

  void setCreatingFinBiometricoFacial() {
    _creatingRegistro?.finBiometricoFacial =
        DateTime.now().millisecondsSinceEpoch;
  }

  void setCreatingRegistro(CreateRegistroDto? creatingRegistro) {
    _creatingRegistro?.docenteId = creatingRegistro!.docenteId;
    _creatingRegistro?.tipo = creatingRegistro!.tipo;
    _creatingRegistro?.latitud = creatingRegistro!.latitud;
    _creatingRegistro?.longitud = creatingRegistro!.longitud;
  }

  void setCreatingRegistroFoto(String foto) {
    _creatingRegistro?.fotoVerificacion = foto;
  }

  void clearCreatingRegistro() {
    _creatingRegistro = CreateRegistroDto();
  }

  void addIntento(String intentoID, String descripcion) {
    _creatingRegistro?.intentosBiometricosFacial
        .add(IntentoFacial(intentoId: intentoID, descripcion: descripcion));
  }

  Future<bool> createRegistro() async {
    if (_creatingRegistro == null) return false;
    final registro = await _registroService.createRegistro(_creatingRegistro!);
    if (registro == null) return false;
    _registrosToday.add(registro);
    refreshLastRegistro();
    refreshLastEntrada();
    refreshLastSalida();

    notifyListeners();
    return true;
  }

  Future<void> init() async {
    try {
      final docenteId = (await _docenteService.getDocenteOfCurrentUser())!.id;
      final registros =
          await _registroService.getRegistrosFromDocenteToday(docenteId);
      _registrosToday.clear();
      _registrosToday.addAll(registros);

      refreshLastRegistro();
      refreshLastEntrada();
      refreshLastSalida();

      notifyListeners();
    } catch (e) {
      return;
    }
  }

  void refreshLastEntrada() {
    try {
      if (_registrosToday.isEmpty) {
        _lastEntrada = null;
        return;
      }

      final sortedCopy = [..._registrosToday];

      sortedCopy.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      _lastEntrada = sortedCopy
          .firstWhere((element) => element.tipo == TipoRegistro.entrada);
    } catch (e) {
      // print("ERROR REFRESH LAST ENTRADA: ${e.toString()}");
      return;
    }
  }

  void refreshLastSalida() {
    try {
      if (_registrosToday.isEmpty) {
        _lastSalida = null;
        return;
      }

      final sortedCopy = [..._registrosToday];

      sortedCopy.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      _lastSalida = sortedCopy
          .firstWhere((element) => element.tipo == TipoRegistro.salida);

      // but if last salida is earlier than last entrada, then there is no salida
      if (_lastEntrada != null && _lastSalida != null) {
        if (_lastSalida!.createdAt.isBefore(_lastEntrada!.createdAt)) {
          _lastSalida = null;
        }
      }
    } catch (e) {
      // print("ERROR REFRESH LAST SALIDA: ${e.toString()}");
      return;
    }
  }

  void refreshLastRegistro() {
    try {
      if (_registrosToday.isEmpty) {
        _lastRegistro = null;
        return;
      }

      final sortedCopy = [..._registrosToday];

      sortedCopy.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      _lastRegistro = sortedCopy.first;
    } catch (e) {
      // print("ERROR REFRESH LAST REGISTRO: ${e.toString()}");
      return;
    }
  }
}
