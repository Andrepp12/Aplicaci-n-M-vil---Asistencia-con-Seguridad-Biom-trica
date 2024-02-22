import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:unt_biometric_auth/env/env.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unt_biometric_auth/src/constants/routes.dart';
import 'package:unt_biometric_auth/src/pages/biometric/face_rekognition_page.dart';
import 'package:unt_biometric_auth/src/pages/biometric/register_face/register_face_instructions_page.dart';
import 'package:unt_biometric_auth/src/pages/docente/new_docente_page.dart';
import 'package:unt_biometric_auth/src/pages/biometric/register_face/register_face_page.dart';
import 'package:unt_biometric_auth/src/pages/home_page.dart';
import 'package:unt_biometric_auth/src/pages/auth/login_page.dart';
import 'package:unt_biometric_auth/src/pages/splash_page.dart';
import 'package:unt_biometric_auth/src/pages/marcar_asistencia_page.dart';
import 'package:unt_biometric_auth/src/providers/device_provider.dart';
import 'package:unt_biometric_auth/src/providers/docente_provider.dart';
import 'package:unt_biometric_auth/src/providers/registro_provider.dart';
import 'package:unt_biometric_auth/src/services/notification/push_notification_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnnonKey,
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => DocenteModel(),
      ),
      ChangeNotifierProvider(
        create: (_) => RegistroProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => DeviceProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  void initState() {
    super.initState();

    PushNotificationService pushNotificationService = PushNotificationService();
    pushNotificationService.initialize();

    pushNotificationService.messages.listen((String goto) {
      navigatorKey.currentState?.pushNamed(goto);
    });

    pushNotificationService.token.listen((String? token) async {
      await navigatorKey.currentState?.context
          .read<DeviceProvider>()
          .setDeviceToken(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Supabase Flutter',
      navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        AppRoutes.splashRoute: (_) => const SplashPage(),
        AppRoutes.loginRoute: (_) => const LogInPage(),
        AppRoutes.registerFaceRoute: (_) => const RegisterFacePage(),
        AppRoutes.newDocenteRoute: (_) => const NewDocentePage(),
        AppRoutes.marcarAsistenciaRoute: (_) => const MarcarAsistenciaPage(),
        AppRoutes.homeRoute: (_) => const MyHomePage(),
        AppRoutes.faceRekognitionRoute: (_) => const FaceRekognitionPage(),
        AppRoutes.registerFaceInstructionsRoute: (_) =>
            const RegisterFaceInstrucionsPage(),
      },
    );
  }
}
