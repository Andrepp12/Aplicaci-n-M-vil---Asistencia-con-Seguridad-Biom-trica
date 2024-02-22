import 'package:flutter/material.dart';
import 'package:unt_biometric_auth/src/dtos/create_device_dto.dart';
import 'package:unt_biometric_auth/src/services/auth/auth_service.dart';
import 'package:unt_biometric_auth/src/services/device_service.dart';

class DeviceProvider extends ChangeNotifier {
  String? _deviceToken;
  String? get deviceToken => _deviceToken;
  final DeviceService _deviceService = DeviceService();
  final AuthService _authService = AuthService();

  Future<void> setDeviceToken(String? deviceToken) async {
    _deviceToken = deviceToken;
    final currentUser = _authService.getCurrentUser();
    if (currentUser == null) return;
    if (deviceToken == null) return;
    await _deviceService.createDevice(
        CreateDeviceDto(userId: currentUser.id, token: deviceToken));
    notifyListeners();
  }
}
