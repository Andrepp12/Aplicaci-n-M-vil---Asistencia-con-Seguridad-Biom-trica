import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:unt_biometric_auth/src/models/responses/push_notification_data.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _messagesStreamController = StreamController<String>.broadcast();
  Stream<String> get messages => _messagesStreamController.stream;

  final _tokenStreamController = StreamController<String>.broadcast();

  Stream<String> get token => _tokenStreamController.stream;

  void dispose() {
    _messagesStreamController.close();
  }

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    if (message.data.isNotEmpty) {
      // final PushNotificationData data =
      // PushNotificationData.fromMap(message.data);
      // Since the handler runs in its own isolate outside your applications context, it is not possible to update application state or execute any UI impacting logic. You can, however, perform logic such as HTTP requests, perform IO operations (e.g. updating local storage), communicate with other plugins etc.
      // what can we do here?
    }
  }

  void handleMessage(RemoteMessage message, bool isTheAppOpen) {
    if (message.data.isNotEmpty) {
      final PushNotificationData data =
          PushNotificationData.fromMap(message.data);
      if (isTheAppOpen) {
        if (data.gotoWhileOpen!) {
          _messagesStreamController.sink.add(data.goto!);
        }
      } else {
        _messagesStreamController.sink.add(data.goto!);
      }
    }
  }

  Future<void> initialize() async {
    // Solicitar permiso para recibir notificaciones
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Obtener token del dispositivo
      String? token = await _firebaseMessaging.getToken();
      // Notificar token
      if (token != null) _tokenStreamController.sink.add(token);

      // configurar notificaciones
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        handleMessage(message, true);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        handleMessage(message, false);
      });

      FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    }
  }
}
