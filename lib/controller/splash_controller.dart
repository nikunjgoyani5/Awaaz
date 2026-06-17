import 'dart:developer';


import 'package:eagle_eye_admin/service/storage/storage_service.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  Future<void> onInit() async {
    log('StorageService.getToken() :- ${StorageService.getToken()}');
    // navigate();
    super.onInit();
  }

  // navigate() {
  //   Future.delayed(const Duration(seconds: 4)).then(
  //     (value) {
  //       if (StorageService.getToken() == null) {
  //         NavigatorRoute.navigateToRemoveUntil(AppRoutes.login);
  //       } else if (StorageService.getIsSuperAdmin() == true) {
  //         NavigatorRoute.navigateToRemoveUntil(AppRoutes.event);
  //         // NavigatorRoute.navigateToRemoveUntil(AppRoutes.superAdminDashboard);
  //       } else {
  //         NavigatorRoute.navigateToRemoveUntil(AppRoutes.event);
  //       }
  //     },
  //   );
  // }
}
