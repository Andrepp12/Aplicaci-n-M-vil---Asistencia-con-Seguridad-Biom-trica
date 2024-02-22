import 'dart:io';

import 'package:camera/camera.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class SelfieService {
  final _bucket = Supabase.instance.client.storage.from("selfies");

  Future<String?> createSelfie(XFile selfie) async {
    try {
      var randomId = const Uuid().v4();
      var name = "$randomId.jpg";
      await _bucket.upload(
        name,
        File(selfie.path),
      );
      return name;
    } catch (e) {
      return null;
    }
  }
}
