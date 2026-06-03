import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../presentation/main/map_screen/bloc/map_screen_cubit.dart';
import '../widget/common_alert_dialogue.dart';
import 'app_functions.dart';

class MapUtils {
  static Position? position;
  static bool isAlreadyAsked = false;
  static Future requestLocationPermission(BuildContext context, {bool isOnTap = false}) async {
    if (isOnTap) {
      await Permission.locationWhenInUse.request();
      var status = await Permission.location.status;
      if (status.isGranted) {
        log('Location permission given');
        const LocationSettings locationSettings = LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        );
        position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
        log(position.toString());
        Timer(
          Duration(seconds: 2),
          () async {
            await context.read<MapScreenCubit>().defaultCameraView();
          },
        );
      } else if (status.isDenied) {
        log('Location permission denied');
        // const LocationSettings locationSettings = LocationSettings(
        //   accuracy: LocationAccuracy.high,
        //   distanceFilter: 100,
        // );
        // position = await Geolocator.getCurrentPosition(
        //     locationSettings: locationSettings);
        // log(position.toString());
        // context.read<MapScreenCubit>().defaultCameraView();
        await Permission.locationWhenInUse.request();
      } else if (status.isPermanentlyDenied) {
        log('Location permission permanently denied');
        showAppDialog(
            dismissDialog: true,
            context,
            CommonAlertDialogue(
                dialogWidget: AppPermissionDialog(
              showCancelButton: true,
              title: 'Location permission permanently denied',
              message:
                  'Your device Location permission permanently denied.\n To use application you need to give permission.',
            )));
      }
    }
    return;
  }

  static Future getUserCurrentLocation(BuildContext context, {bool isOnTap = false}) async {
    if (!isAlreadyAsked || isOnTap) {
      isAlreadyAsked = true;
      var status = await Permission.location.status;
      if (status.isGranted) {
        const LocationSettings locationSettings = LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        );
        position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
        context.read<MapScreenCubit>().defaultCameraView();
        context.read<MapScreenCubit>().updateUserCurrentLocation();
        // context.read<MapScreenCubit>().getAddressFromLatLang(position?.latitude ?? 0.0,position?.longitude ?? 0.0);
        log(position.toString());
      } else {
        if (!isAlreadyAsked || isOnTap) {
          isAlreadyAsked = true;
          requestLocationPermission(context, isOnTap: isOnTap);
        }
      }
    }
    return;
  }

  static Future getUserCurrentLocationNormal({bool isOnTap = false}) async {
    if (!isAlreadyAsked || isOnTap) {
      isAlreadyAsked = true;
      bool status = await Permission.locationWhenInUse.isGranted;
      if (status) {
        const LocationSettings locationSettings = LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        );
        position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
        log(position.toString());
      }
    }

    return;
  }
}
