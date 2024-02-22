import 'dart:async';
import 'package:flutter/material.dart';
import 'package:unt_biometric_auth/src/constants/colors.dart';
import 'package:unt_biometric_auth/src/constants/flutter_flow/flutter_flow_theme.dart';
import 'package:unt_biometric_auth/src/services/auth/auth_service.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService _authService = AuthService();
  var isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleLoginWithGoogle() async {
    setState(() {
      isLoading = true;
    });
    await _authService.deleteSessionIfExits();
    final result = await _authService.signInWithGoogleV0();
    if (!mounted) return;
    if (result.session == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo iniciar sesión'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      Navigator.of(context).pushReplacementNamed('/home');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(),
      child: Scaffold(
          key: scaffoldKey,
          // backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg-unt.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                SafeArea(
                  top: true,
                  child: Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Container(
                      width: 440,
                      decoration: const BoxDecoration(),
                      child: Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 24),
                              child: Material(
                                color: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Image.asset(
                                  'assets/images/logo-unt-nobg-white.png',
                                  // width: 128,
                                  height: 128,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SelectionArea(
                                child: Text(
                              'Aplicacion para docentes',
                              style: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .override(
                                      fontFamily: 'Outfit',
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                      lineHeight: 1.2,
                                      color: ColorsApp.primaryForegroundColor),
                            )),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  30, 12, 30, 0),
                              child: SelectionArea(
                                  child: Text(
                                '¡Bienvenido! Por favor, inicie sesión utilizando su cuenta institucional unitru.',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      color: ColorsApp.primaryForegroundColor
                                          .withOpacity(0.6),
                                      fontFamily: 'Readex Pro',
                                      lineHeight: 1.5,
                                    ),
                              )),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 32, 0, 0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  // color: FlutterFlowTheme.of(context)
                                  //     .primaryBackground,
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 8,
                                      color: Color(0x1917171C),
                                      offset: Offset(0, 4),
                                      spreadRadius: 0,
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      32, 32, 32, 32),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 16, 0, 0),
                                        child: Material(
                                          color: Colors.transparent,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: ColorsApp
                                                  .primaryForegroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: const Color(0xFFD0D5DD),
                                                width: 1,
                                              ),
                                            ),
                                            child: Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        0, 0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0, 10, 0, 10),
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      await _handleLoginWithGoogle();
                                                    },
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/logo-google.png',
                                                          width: 24,
                                                          height: 24,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  12, 0, 0, 0),
                                                          child: Text(
                                                            'Ingresar con Google',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Readex Pro',
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (isLoading)
                  Opacity(
                    opacity: 0.5,
                    child: Container(
                      color: Colors
                          .black, // Puedes ajustar el color de fondo aquí.
                    ),
                  ),
                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      color: ColorsApp.primaryColor,
                    ),
                  ),
              ],
            ),
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
