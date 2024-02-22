import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

typedef PositionCallBack = Function(Position position);

class LocationService {
  late StreamSubscription<Position> _positionStreamSubscription;

  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    serviceEnabled = await isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location service is not enabled');
    }

    return Geolocator.getCurrentPosition();
  }

  Future<void> startPositionStream(PositionCallBack functionCallback) async {
    try {
      bool serviceEnabled;
      serviceEnabled = await isLocationServiceEnabled();

      if (!serviceEnabled) {
        return Future.error('Location service is not enabled');
      }

      _positionStreamSubscription = Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
      )).listen(functionCallback);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> stopPositionStream() async {
    await _positionStreamSubscription.cancel();
  }

  Future<bool> isLocationServiceEnabled() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      return true;
    }

    // Permission not granted, request permission
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }


  Future<void> savePosition() async {
    print("hola");
    Position pos = await getCurrentPosition();
    
    var docente = await Supabase.instance.client.from("docentes")
      .select("*")
      .match(
        {
          "correo": Supabase.instance.client.auth.currentUser!.email
        }
      );

    print(docente[0]["id"]);

    await Supabase.instance.client.from("registros").insert(
      {
        "tipo": "Entrada",
        "docente_id": docente[0]["id"],
        "ubicacion": {
          "latitud": pos.latitude,
          "longitud": pos.longitude
        }
      }
    );

    print("ya creo");
  }

}
