import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unt_biometric_auth/src/constants/flutter_flow/flutter_flow_theme.dart';
import 'package:unt_biometric_auth/src/dtos/create_rostro_dto.dart';
import 'package:unt_biometric_auth/src/providers/docente_provider.dart';
import 'package:unt_biometric_auth/src/services/camera/camera_service.dart';
import 'package:unt_biometric_auth/src/services/rekognition/rekognition_service.dart';
import 'package:unt_biometric_auth/src/services/rostro_service.dart';
import 'package:unt_biometric_auth/src/services/storage/selfie_service.dart';
import 'package:unt_biometric_auth/src/utils/widget_state.dart';

class RegisterFacePage extends StatefulWidget {
  const RegisterFacePage({Key? key}) : super(key: key);

  @override
  _RegisterFacePageState createState() => _RegisterFacePageState();
}

class _RegisterFacePageState extends State<RegisterFacePage> {
  late WidgetState _widgetState = WidgetState.NONE;
  final _cameraService = CameraService();
  final _rekognitionService = RekognitionService();
  final _selfieService = SelfieService();
  final _rostroService = RostroService();
  var _captured = false;

  @override
  void initState() {
    super.initState();
    var state = _cameraService.initCamera();
    state
        .then((value) => {
              setState(() {
                _widgetState = value;
              })
            })
        .catchError((error) => {
              setState(() {
                _widgetState = WidgetState.ERROR;
              })
            });
  }

  Future _changeCamera() async {
    _widgetState = WidgetState.LOADING;
    setState(() {});

    _widgetState = await _cameraService.changeCamera();
    setState(() {});
  }

  void _takePicture() async {
    try {
      setState(() {
        _captured = true;
      });
      final image = await _cameraService.getCameraController().takePicture();
      final response = await _rekognitionService.detectFace(image);
      if (response.type == "success") {
        // create selfie
        var selfie = await _selfieService.createSelfie(image);
        if (selfie == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("¡Ooops! Error al capturar el rostro 😩"),
            backgroundColor: Colors.red,
          ));
          setState(() {
            _captured = false;
          });
          return;
        }
        if (!mounted) return;
        final docente = context.read<DocenteModel>().docente;
        var rostroRes = await _rostroService.createRostro(
            CreateRostroDto(docenteId: docente!.id, selfie: selfie));

        if (!rostroRes) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("¡Ooops! Error al capturar el rostro 😩"),
            backgroundColor: Colors.red,
          ));
          setState(() {
            _captured = false;
          });
          return;
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text("¡Rostro capturado! Espera la aprobación del administrador"),
          backgroundColor: Colors.green,
        ));
        Timer(const Duration(seconds: 2), () {
          Navigator.popAndPushNamed(context, "/home");
        });
      } else if (response.errors?.isNotEmpty ?? false) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response.errors![0]),
          backgroundColor: Colors.red,
        ));
      }
      setState(() {
        _captured = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("¡Ooops! Error al tomar la foto 😩"),
        backgroundColor: Colors.red,
      ));
      setState(() {
        _captured = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;

    switch (_widgetState) {
      case WidgetState.NONE:
      case WidgetState.LOADING:
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      case WidgetState.ERROR:
        return const Scaffold(
          body: Center(
              child: Text(
                  "¡Ooops! Error al cargar la cámara 😩. Reinicia la aplicación.")),
        );
      case WidgetState.LOADED:
        return Scaffold(
            body: Container(
                margin: const EdgeInsets.only(top: 20),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
                  child: Column(
                    children: [
                      Text(
                        "Registro Facial",
                        style: FlutterFlowTheme.of(context).titleLarge,
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 20),
                        child: const Text(
                          "Cuando estés listo coloca tu rostro en el recuadro y presiona el botón para escanear tu rostro.",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Stack(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(10),
                              width: size,
                              height: size,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  ClipRect(
                                    child: OverflowBox(
                                      alignment: Alignment.center,
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: SizedBox(
                                          width: size,
                                          // height:
                                          //     size / _cameraService.getCameraController().value.aspectRatio,
                                          child: CameraPreview(_cameraService
                                              .getCameraController()), // this is my CameraPreview
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_captured)
                                    Container(
                                      color: Colors.black.withOpacity(0.7),
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const CircularProgressIndicator(),
                                            const SizedBox(height: 16),
                                            Text(
                                              'Escaneando...',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .labelLarge
                                                      .override(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'Poppins'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              )),
                          Positioned(
                              bottom: 20,
                              right: 20,
                              child: IconButton(
                                  onPressed: () async => _changeCamera(),
                                  icon: const Icon(
                                    Icons.flip_camera_ios,
                                    color: Colors.white,
                                    size: 36,
                                  ))),
                        ],
                      ),
                      const Text(
                          "Presiona el botón para comenzar a escanear tu rostro"),
                      Container(
                        margin:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Center(
                            child: IconButton(
                                onPressed: _captured ? null : _takePicture,
                                enableFeedback: true,
                                icon: Icon(
                                  Icons.radio_button_checked,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 72,
                                ))),
                      )
                    ],
                  ),
                )));
    }
  }
}
