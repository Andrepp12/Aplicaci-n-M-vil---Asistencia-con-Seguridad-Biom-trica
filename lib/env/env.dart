// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
abstract class Env {
  @EnviedField(defaultValue: '', varName: 'SUPABASE_URL')
  static const String supabaseUrl = _Env.supabaseUrl;
  @EnviedField(defaultValue: '', varName: 'SUPABASE_ANNON_KEY')
  static const String supabaseAnnonKey = _Env.supabaseAnnonKey;
  @EnviedField(defaultValue: '', varName: 'ANDROID_CLIENT_ID')
  static const String androidClientId = _Env.androidClientId;
  @EnviedField(defaultValue: '', varName: 'IOS_CLIENT_ID')
  static const String iosClientId = _Env.iosClientId;
  @EnviedField(defaultValue: '', varName: 'WEB_CLIENT_ID')
  static const String webClientId = _Env.webClientId;

  @EnviedField(defaultValue: '', varName: 'REKOG_API_URL')
  static const String rekogApiUrl = _Env.rekogApiUrl;
}
