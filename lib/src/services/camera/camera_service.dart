import 'package:camera/camera.dart';
import 'package:unt_biometric_auth/src/utils/widget_state.dart';


class CameraService {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  late int _cameraIndex;


  Future<WidgetState> initCamera() async{
    _cameras = await availableCameras();
    _cameraIndex = 1;

    _cameraController = CameraController(
      _cameras[_cameraIndex], 
      ResolutionPreset.veryHigh,
      enableAudio: false
    );

    await _cameraController.initialize();

    if (_cameraController.value.hasError) {
      print("Camerra error");
      print(_cameraController.value.errorDescription);
      return WidgetState.ERROR;
    }

    return WidgetState.LOADED;
  }


  Future<WidgetState> changeCamera() async{

    _cameraIndex ++;

    if (_cameraIndex >= _cameras.length) {
      _cameraIndex = 0;
    }

    _cameraController = CameraController(
      _cameras[_cameraIndex], 
      ResolutionPreset.veryHigh,
      enableAudio: false
    );

    print("CAMERA INDEX");
    print(_cameraIndex);

    await _cameraController.initialize();

    print("CAMERA CONTROLLER");

    if (_cameraController.value.hasError) {
      print("Camerra error");
      print(_cameraController.value.errorDescription);
      return WidgetState.ERROR;
    }

    return WidgetState.LOADED;
  }


  CameraController getCameraController() {
    return _cameraController;
  }

}