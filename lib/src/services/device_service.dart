import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:unt_biometric_auth/src/dtos/create_device_dto.dart';

class DeviceService {
  final _client = Supabase.instance.client;

  Future<bool> createDevice(CreateDeviceDto createDeviceDto) async {
    try {
      if (await deviceExists(createDeviceDto)) return false;
      await _client.from("devices").insert({
        "id": const Uuid().v4(),
        "user_id": createDeviceDto.userId,
        "token": createDeviceDto.token,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deviceExists(CreateDeviceDto createDeviceDto) async {
    try {
      final response = await _client
          .from("devices")
          .select()
          .eq("token", createDeviceDto.token)
          .eq("userId", createDeviceDto.userId)
          .single();
      return response.error == null;
    } catch (e) {
      return false;
    }
  }
}
