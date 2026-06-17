import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkConnectionService {
  static late StreamSubscription connectivitySubscription;
  static bool isNetworkConnected = false;

  Future init() async {
    initConnectivity();
    await checkConnectivity();
  }

  initConnectivity() {
    connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((event) async {
      await checkConnectivity();
    });
  }

  static Future<void> checkConnectivity() async {
    isNetworkConnected = await InternetConnectionChecker().hasConnection;
    debugPrint('isNetworkConnected: $isNetworkConnected');
    if (!isNetworkConnected) {
    } else {}
  }
}

NetworkConnectionService networkConnectionServices = NetworkConnectionService();
