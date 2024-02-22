// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

class LocalAuthService {
  final LocalAuthentication localAuth = LocalAuthentication();

  Future<bool> authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await localAuth.authenticate(
          localizedReason: "Validación biométrica necesaria",
          authMessages: const <AuthMessages>[
            AndroidAuthMessages(
              cancelButton: 'CANCELAR',
              goToSettingsDescription:
                  'Por favor, configure su acceso biométrico.',
              signInTitle: 'Autenticación Biométrica Local',
              biometricHint: 'Registre su entrada / salida.',
              biometricNotRecognized: 'Autentificación biométrica fallida.',
              biometricRequiredTitle: 'Autenticación biométrica requerida',
              biometricSuccess: 'Autenticación biométrica exitosa.',
              goToSettingsButton: 'CONFIGURAR',
            ),
            IOSAuthMessages(
              cancelButton: 'CANCELAR',
              goToSettingsDescription:
                  'Por favor, configure su acceso biométrico.',
              lockOut: 'Por favor, use el código de acceso para desbloquear.',
              goToSettingsButton: 'CONFIGURAR',
              localizedFallbackTitle: 'Usar código de acceso',
            ),
          ],
          options: const AuthenticationOptions(
              biometricOnly: true, useErrorDialogs: true, stickyAuth: true));
    } catch (e) {
      print(e);
    }
    return authenticated;
  }

  Future<bool> hasBiometric() async {
    try {
      final isDeviceSuported = await localAuth.isDeviceSupported();
      if (!isDeviceSuported) return false;
      final canCheckBiometrics = await localAuth.canCheckBiometrics;
      if (!canCheckBiometrics) return false;
      final biometrics = await localAuth.getAvailableBiometrics();
      if (biometrics.isEmpty) return false;
      return true;
    } on PlatformException catch (e) {
      return false;
    }
  }
}
