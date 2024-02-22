import 'package:unt_biometric_auth/src/dtos/create_docente_dto.dart';
import 'package:unt_biometric_auth/src/dtos/update_docente_dto.dart';
import 'package:unt_biometric_auth/src/models/docente.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unt_biometric_auth/src/services/auth/auth_service.dart';
import 'package:uuid/uuid.dart';

class DocenteService {
  final _client = Supabase.instance.client;
  final _authService = AuthService();

  Future<Docente?> getDocenteOfCurrentUser() async {
    if (_client.auth.currentUser == null) {
      return null;
    }
    var docente = await _client
        .from("docentes")
        .select("*")
        .match({"correo": _client.auth.currentUser!.email});
    if (docente.length == 0) {
      return null;
    }

    var data = docente[0];

    return Docente.fromJson(data);
  }

  Future<bool> setDocenteToPending(String docenteId) async {
    try {
      await _client
          .from("docentes")
          .update({"status": "pending"}).match({"id": docenteId});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> createDocente(CreateDocenteDto dto) async {
    try {
      final id = const Uuid().v4();
      var docente = Docente(
          id: id,
          nombres: dto.nombres,
          apellidos: dto.apellidos,
          correo: dto.correo,
          telefono: dto.telefono,
          userId: _authService.getCurrentUser()!.id,
          escuelaId: dto.escuelaId,
          avatarUrl: dto.avatarUrl,
          status: DocenteStatus.pending);
      await _client.from("docentes").insert(docente.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateDocente(UpdateDocenteDto dto) async {
    try {
      var docente = Docente(
        id: dto.id,
        nombres: dto.nombres,
        apellidos: dto.apellidos,
        correo: dto.correo,
        telefono: dto.telefono,
        userId: _authService.getCurrentUser()!.id,
        escuelaId: dto.escuelaId,
        avatarUrl: dto.avatarUrl,
      );
      await _client
          .from("docentes")
          .update(docente.toJson())
          .match({"id": dto.id});
      return true;
    } catch (e) {
      return false;
    }
  }

  suscribeDocenteOnUpdate(String docenteId, Function(Docente) callback) {
    _client.channel('docentes').on(
        RealtimeListenTypes.postgresChanges,
        ChannelFilter(
            schema: 'public',
            table: 'docentes',
            event: 'UPDATE',
            filter: 'id=eq.$docenteId'), (payload, [ref]) {
      var data = payload['new'];
      var docente = Docente.fromJson(data);
      callback(docente);
    }).subscribe();
  }
}
