import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkConnectionService {
  StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;
  bool isNetworkConnected = false;

  Future<void> initConnectivityListener() async {
    await _checkConnectivity();
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) async {
      await _checkConnectivity();
    });
  }

  Future<void> _checkConnectivity() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult.length == 1 &&
          connectivityResult.contains(ConnectivityResult.none)) {
        isNetworkConnected = false;
      } else {
        isNetworkConnected = await InternetConnectionChecker().hasConnection;
      }

      log('🔥 Internet status: $isNetworkConnected');
    } catch (e) {
      log('⚠️ Error checking connectivity: $e');
      isNetworkConnected = false;
    }
  }

  Future<void> checkInternetConnection() async {
    try {
      isNetworkConnected = await InternetConnectionChecker().hasConnection;
      log('📡 Manual Internet Check: $isNetworkConnected');
    } catch (e) {
      log('⚠️ Error in manual check: $e');
      isNetworkConnected = false;
    }
  }

  void dispose() {
    connectivitySubscription?.cancel();
  }
}

final NetworkConnectionService networkConnectionServices =
    NetworkConnectionService();
