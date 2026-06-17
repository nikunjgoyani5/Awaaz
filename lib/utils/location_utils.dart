import 'dart:developer';

import 'package:eagle_eye_admin/service/location/location_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationUtils {
  static Position? position;
  static Placemark? placemark;

  static fetchLocation() async {
    try {
      if (await Geolocator.isLocationServiceEnabled()) {
        // await pl.show();
        position = await LocationService.getCurrentPosition();
        if (position == null) {
          throw Exception('Unable to fetch location.');
        }
        await LocationService.decodeLocation();
        placemark = LocationService.placemark;
        if (placemark == null) {
          log('Placemark could not be determined.');
        } else {
          log('Placemark: $placemark');
        }
        // await pl.hide();
        log('Latitude: ${position?.latitude}, longitude: ${position?.longitude}');
      } else {
        // await pl.hide();
        await Geolocator.openLocationSettings();
      }
    } catch (e) {
      // await pl.hide();
      log('Error: $e');
    }
  }
}
