

import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;

class LocationUtils{
  static bool isPointInPolygon(LatLng point, List<LatLng> polygonPoints) {
    List<mp.LatLng> convertedPoints = polygonPoints.map((e) => 
      mp.LatLng(e.latitude, e.longitude)
    ).toList();

    return mp.PolygonUtil.containsLocation(
        mp.LatLng(point.latitude, point.longitude), 
        convertedPoints, 
        false
      );
  }

  static LatLngBounds getBoundFromTwoPoints(LatLng point1, LatLng point2) {
    double minLat = min(point1.latitude, point2.latitude);
    double maxLat = max(point1.latitude, point2.latitude);
    double minLng = min(point1.longitude, point2.longitude);
    double maxLng = max(point1.longitude, point2.longitude);

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng)
    );
  }

  static LatLng getCenterOfPolygon(List<LatLng> polygonPoints) {
    double latSum = 0;
    double lngSum = 0;
    for (var element in polygonPoints) {
      latSum += element.latitude;
      lngSum += element.longitude;
    }

    return LatLng(latSum/polygonPoints.length, lngSum/polygonPoints.length);
  }


}