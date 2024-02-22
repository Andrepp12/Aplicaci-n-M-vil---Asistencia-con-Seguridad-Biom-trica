// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDv1S6q54CiaPxAABW8DesNlJTC8rIFC4k',
    appId: '1:748441863528:android:999c3088046b04200c42dd',
    messagingSenderId: '748441863528',
    projectId: 'untbiometricauth-397903',
    storageBucket: 'untbiometricauth-397903.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB71VmKbUW_U7FMzWSR0LCyC-_PCvsMAKY',
    appId: '1:748441863528:ios:89883f1d0d1441a50c42dd',
    messagingSenderId: '748441863528',
    projectId: 'untbiometricauth-397903',
    storageBucket: 'untbiometricauth-397903.appspot.com',
    androidClientId: '748441863528-12h686hkgnvotlpn69aii7rc1nuefauu.apps.googleusercontent.com',
    iosClientId: '748441863528-te46krjl3n9osgfj6q6oiaur8epiahrk.apps.googleusercontent.com',
    iosBundleId: 'com.example.untBiometricAuth',
  );
}