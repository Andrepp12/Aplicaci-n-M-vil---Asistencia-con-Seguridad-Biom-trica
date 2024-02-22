import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unt_biometric_auth/src/constants/flutter_flow/flutter_flow_theme.dart';
import 'package:unt_biometric_auth/src/providers/docente_provider.dart';
import 'package:unt_biometric_auth/src/providers/registro_provider.dart';
import 'package:unt_biometric_auth/src/services/camera/camera_service.dart';
import 'package:unt_biometric_auth/src/services/rekognition/rekognition_service.dart';
import 'package:unt_biometric_auth/src/utils/widget_state.dart';

class FaceRekognitionPage extends StatefulWidget {
  const FaceRekognitionPage({Key? key}) : super(key: key);

  @override
  _FaceRekognitionPageState createState() => _FaceRekognitionPageState();
}

class _FaceRekognitionPageState extends State<FaceRekognitionPage> {
  late WidgetState _widgetState = WidgetState.NONE;
  final _cameraService = CameraService();
  var _captured = false;
  var _cameraPhoto;
  var _sending = false;
  final RekognitionService _rekognitionService = RekognitionService();

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

  @override
  void dispose() {
    _cameraService.getCameraController().dispose();
    super.dispose();
  }

  Future _changeCamera() async {
    _widgetState = WidgetState.LOADING;
    setState(() {});

    _widgetState = await _cameraService.changeCamera();
    setState(() {});
  }

  void _takePicture() async {
    try {
      
      final image = await _cameraService.getCameraController().takePicture();

      setState(() {
        _captured = true;
        _cameraPhoto = image;
      });
    } catch (e) {
      print(e.toString());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("¡Ooops! Error al capturar el rostro 😩"),
        backgroundColor: Colors.red,
      ));
      setState(() {
        _captured = false;
      });
    }
  }

  void _sendImage() async {

    RegistroProvider registroProvider = context.read<RegistroProvider>();
    DocenteModel docenteProvider = context.read<DocenteModel>();

    registroProvider.setCreatingInicioBiometricoFacial();
    final docente = docenteProvider.docente!;
    setState(() {
      _sending = true;
    });

    try{
      final response =
          await _rekognitionService.loginRekognition(_cameraPhoto, docente.id);

      if (response.type == "success") {
        registroProvider.setCreatingRegistroFoto(response.fotoVerificacion!);

        registroProvider.addIntento(response.intentoId!, "");

        if (!mounted) return;
        registroProvider.setCreatingFinBiometricoFacial();

        Navigator.of(context).pop('success');

      } else {
        if (response.intentoId != null) {
          registroProvider.addIntento(response.intentoId!, response.errors!.join('\n'));
        }
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response.errors!.join('. ')),
          backgroundColor: Colors.red,
        ));
      }
      setState(() {
        _captured = false;
        _sending = false;
      });


    }catch (e) {
      print(e.toString());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("¡Ooops! Error al capturar el rostro 😩"),
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
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                  child: Column(
                    children: [
                      // Generated code for this Row Widget...
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  12, 0, 0, 0),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_rounded,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 30,
                                ),
                                onPressed: () async {
                                  Navigator.pop(context, 'error');
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "Reconocimiento Facial",
                        style: FlutterFlowTheme.of(context).titleLarge,
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 20),
                        child: const Text(
                          "Cuando estés listo coloca tu rostro en el recuadro y presiona el botón para detectar tu rostro.",
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
                                          child:
                                            _captured ?
                                               Image.file(File(_cameraPhoto.path))
                                            :
                                              CameraPreview(_cameraService
                                                .getCameraController()),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_sending)
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
                                              'Reconociendo...',
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
                          "Presiona el botón para comenzar a detectar tu rostro"),
                      Container(
                        margin:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Center(
                          child: 
                            _captured ? 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                children: [
                                  IconButton(
                                    onPressed: _sending ? null : () => setState(() {
                                      _captured = false;
                                    }),
                                    iconSize: 72,
                                    padding: EdgeInsets.zero,
                                    enableFeedback: true,
                                    icon: Icon(
                                      Icons.refresh,
                                      color: FlutterFlowTheme.of(context).primary,
                                      size: 72,

                                    )
                                  ),
                                  IconButton(
                                    onPressed: _sending ? null : _sendImage,
                                    enableFeedback: true,
                                    padding: EdgeInsets.zero,
                                    iconSize: 72,
                                    icon: Icon(
                                      Icons.send,
                                      color: FlutterFlowTheme.of(context).primary,
                                      size: 72,

                                    ),
                                    alignment: Alignment.centerRight,
                                  )
                                ],
                              )
                              :
                          
                            IconButton(
                                onPressed: _captured ? null : _takePicture,
                                enableFeedback: true,
                                padding: EdgeInsets.zero,
                                iconSize: 72,

                                icon: Icon(
                                  Icons.radio_button_checked,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 72,

                                ),
                                
                              )
                        ),
                      )
                    ],
                  ),
                )));
    }
  }
}
