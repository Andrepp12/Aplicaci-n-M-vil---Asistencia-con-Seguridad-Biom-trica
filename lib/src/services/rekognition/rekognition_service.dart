import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:unt_biometric_auth/env/env.dart';
import 'package:unt_biometric_auth/src/models/responses/rekognition_responses.dart';
import 'package:http/http.dart' as http;

class RekognitionService {
  final String _rekogApiUrl = Env.rekogApiUrl;

  Future<DetectFaceResponse> detectFace(XFile rostro) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$_rekogApiUrl/detect-face"),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          rostro.path,
        ),
      );
      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      var responseJson = jsonDecode(responseString);
      return DetectFaceResponse.fromJson(responseJson);
    } catch (e) {
      return DetectFaceResponse(type: 'errors', errors: [e.toString()]);
    }
  }

  Future<LoginRekognitionResponse> loginRekognition(
      XFile rostro, String docenteId) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$_rekogApiUrl/auth/login"),
      );
      request.fields['docente_id'] = docenteId;

      request.files.add(
        await http.MultipartFile.fromPath(
          'rostro',
          rostro.path,
        ),
      );
      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      var responseJson = jsonDecode(responseString);
      return LoginRekognitionResponse.fromJson(responseJson);
    } catch (e) {
      return LoginRekognitionResponse(type: 'errors', errors: [e.toString()]);
    }
  }
}
