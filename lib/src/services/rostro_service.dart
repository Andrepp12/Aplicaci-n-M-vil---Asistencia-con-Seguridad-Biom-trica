import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unt_biometric_auth/src/dtos/create_rostro_dto.dart';
import 'package:unt_biometric_auth/src/models/rostro.dart';
import 'package:unt_biometric_auth/src/services/docente_service.dart';
import 'package:uuid/uuid.dart';

class RostroService {
  final _client = Supabase.instance.client;
  final _docenteService = DocenteService();

  Future<bool> createRostro(CreateRostroDto rostroDto) async {
    try {

      // verificamos si el docente ya tiene un rostro registrado
      var ros = await _client
          .from("rostros")
          .select("*")
          .eq("docente_id", rostroDto.docenteId);
          
      if (ros!= null && ros.length > 0) {
        // si ya tiene un rostro registrado, entonces lo actualizamos
        await _client.from("rostros").update({
          "selfie": rostroDto.selfie,
          "estado": "pendiente",
        }).match({"docente_id": rostroDto.docenteId});

        final r =
            await _docenteService.setDocenteToPending(rostroDto.docenteId);
        if (!r) {
          return false;
        }

        return true;
      }

      var randomId = const Uuid().v4();
      var rostro = Rostro(
        id: randomId,
        docenteId: rostroDto.docenteId,
        selfie: rostroDto.selfie,
      );
      print("creando rostro: ${rostro.toJson()}");
      await _client.from("rostros").insert(rostro.toJson());

      return true;
    } catch (e) {
      print("====> Error al crear rostro: $e");
      return false;
    }
  }

  Future<bool> thisDocenteHasRostro(String docenteId) async {
    var rostros = await _client
        .from("rostros")
        .select("*")
        .or("estado.eq.pendiente,estado.eq.aprobado")
        .match({"docente_id": docenteId});
    if (rostros.length == 0) {
      return false;
    }
    return true;
  }
}
