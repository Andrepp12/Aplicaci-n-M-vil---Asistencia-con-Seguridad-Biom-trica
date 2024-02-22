import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';
import 'package:unt_biometric_auth/src/dtos/create_registro_dto.dart';
import 'package:unt_biometric_auth/src/models/registro.dart';
import 'package:uuid/uuid.dart';

class RegistroService {
  final _client = Supabase.instance.client;

  Future<Registro?> createRegistro(CreateRegistroDto dto) async {
    try {
      // Carga la zona horaria de Perú
      initializeTimeZones();
      final peruLocation = getLocation('America/Lima');
      TZDateTime now = TZDateTime.now(peruLocation);

      final Registro registro = Registro(
          id: const Uuid().v4(),
          docenteId: dto.docenteId ?? "",
          tipo: dto.tipo ?? TipoRegistro.entrada,
          ubicacion:
              Ubicacion(latitud: dto.latitud ?? 0, longitud: dto.longitud ?? 0),
          fotoVerificacion: dto.fotoVerificacion,
          createdAt:
              now, // Usa la fecha y hora actual en la zona horaria de Perú
          inicioRegistro: dto.inicioRegistro,
          finGeolocalizacion: dto.finGeolocalizacion,
          inicioBiometricoLocal: dto.inicioBiometricoLocal,
          finBiometricoLocal: dto.finBiometricoLocal,
          inicioBiometricoFacial: dto.inicioBiometricoFacial,
          finBiometricoFacial: dto.finBiometricoFacial,
          finRegistro: dto.finRegistro,
          totalIntentos: dto.intentosBiometricosFacial.length);

      registro.finRegistro = now.millisecondsSinceEpoch;

      final responseJSON =
          await _client.from("registros").insert(registro.toJson()).select();
      final Registro response = Registro.fromJson(responseJSON[0]);

      for (final intento in dto.intentosBiometricosFacial) {
        await _client.from("intentos_reconocimiento_facial").update(
          {
            "registro_id": registro.id,
            "description": intento.descripcion ?? ""
          },
        ).eq("id", intento.intentoId);
      }

      return response;
    } catch (e) {
      print("ERROR: ${e.toString()}");
      return null;
    }
  }

  Future<List<Registro>> getRegistrosFromDocente(String docenteId) async {
    try {
      final response = await _client.from("registros").select().match({
        "docente_id": docenteId,
      });
      final List<Registro> registros = [];
      for (final row in (response as List)) {
        registros.add(Registro.fromJson(row));
      }
      return registros;
    } catch (e) {
      return [];
    }
  }

  Future<List<Registro>> getRegistrosFromDocenteToday(String docenteId) async {
    try {
      initializeTimeZones();
      final Location peruLocation = getLocation('America/Lima');
      TZDateTime now = TZDateTime.now(peruLocation);
      final date = now.toString().substring(0, 10);
      final end = now.add(const Duration(days: 1)).toString().substring(0, 10);
      final response = await _client
          .from("registros")
          .select()
          .eq("docente_id", docenteId)
          .gt("created_at", date)
          .lt("created_at", end)
          .order("created_at", ascending: true);

      final List<Registro> registros = [];
      for (final row in (response as List)) {
        registros.add(Registro.fromJson(row));
      }
      return registros;
    } catch (e) {
      print("ERROR: ${e.toString()}");
      return [];
    }
  }

  Future<bool> registerIntento(String itentoID, String registroID) async {
    try {
      await _client
          .from("intentos_reconocimiento_facial")
          .update({"registro_id": registroID}).eq("id", itentoID);
      return true;
    } catch (e) {
      return false;
    }
  }
}
