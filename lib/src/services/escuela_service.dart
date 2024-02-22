import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unt_biometric_auth/src/models/escuela.dart';

class EscuelaService {
  final _client = Supabase.instance.client;

  Future<List<Escuela>> getEscuelas() async {
    final response = await _client.from('escuelas').select('''
      id,
      nombre,
      facultad: facultad_id(nombre) 
''');
    final List<Escuela> escuelas = [];
    for (final element in (response as List)) {
      escuelas.add(Escuela.fromJson(element));
    }
    return escuelas;
  }
}
