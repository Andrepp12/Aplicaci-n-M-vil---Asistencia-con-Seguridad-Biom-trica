import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unt_biometric_auth/src/components/drawer.dart';
import 'package:unt_biometric_auth/src/constants/colors.dart';
import 'package:unt_biometric_auth/src/constants/flutter_flow/flutter_flow_theme.dart';
import 'package:unt_biometric_auth/src/constants/routes.dart';
import 'package:unt_biometric_auth/src/models/docente.dart';
import 'package:unt_biometric_auth/src/pages/biometric/register_face/register_face_instructions_page.dart';
import 'package:unt_biometric_auth/src/pages/docente/new_docente_page.dart';
import 'package:unt_biometric_auth/src/providers/docente_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<DocenteModel>(context, listen: false).init(),
        builder: (context, snapshot) {
          // if laoding, return loading screen
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            final docente = Provider.of<DocenteModel>(context).docente;
            if (docente == null) return const NewDocentePage();
            if (!docente.hasRostro) return const RegisterFaceInstrucionsPage();
          }
          return Scaffold(
            drawer: const DrawerComponent(),
            appBar: AppBar(
              // backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              backgroundColor: ColorsApp.primaryColor,
              title: const Text("Control Biométrico"),
              foregroundColor: ColorsApp.secondaryColor,
            ),
            body: Center(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(
                    padding: const EdgeInsets.only(top: 100, bottom: 50),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 20, right: 20),
                          child: Text(
                            "Bienvenido, ${Provider.of<DocenteModel>(context).docente?.nombres}",
                            style: FlutterFlowTheme.of(context).headlineSmall,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ],
                    )),
                Container(
                  width: 300,
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: Image.asset('assets/images/logo-unt.png').image,
                    ),
                  ),
                ),
                if (Provider.of<DocenteModel>(context).docente?.status ==
                    DocenteStatus.pending)
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 100, bottom: 50, left: 20, right: 20),
                      child: Column(
                        children: [
                          Text(
                              "Tu solicitud de registro facial está siendo evaluada, te notificaremos cuando sea aprobada.",
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context).bodySmall),
                        ],
                      )),
                if (Provider.of<DocenteModel>(context).docente?.status ==
                    DocenteStatus.rejected)
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 100, bottom: 50, left: 20, right: 20),
                      child: Column(
                        children: [
                          Text(
                              "Tu solicitud de registro facial ha sido rechazada, por favor intenta nuevamente.",
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context).bodySmall),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).popAndPushNamed(
                                    AppRoutes.registerFaceInstructionsRoute);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        FlutterFlowTheme.of(context).primary),
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                fixedSize: MaterialStateProperty.all<Size>(
                                  const Size(200, 50),
                                ),
                              ),
                              child: Text('Intentar nuevamente',
                                  style: FlutterFlowTheme.of(context)
                                      .labelLarge
                                      .override(
                                        fontFamily: 'Outfit',
                                        color: Colors.white,
                                        fontSize: 16,
                                      )),
                            ),
                          ),
                        ],
                      )),
              ]),
            ),
          );
        });
  }
}
