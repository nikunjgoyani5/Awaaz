import 'dart:developer';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Position? position;
  static Placemark? placemark;
  static Future<Position> getCurrentPosition() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return position!;
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<void> decodeLocation() async {
    try {
      placemark = (await placemarkFromCoordinates(
              position!.latitude, position!.longitude))
          .first;
      log(placemark.toString());
    } catch (e) {
      log('error');
      return Future.error(e);
    }
  }
}
