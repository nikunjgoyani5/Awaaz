import 'package:eagle_eye_admin/route/app_route.dart';
import 'package:eagle_eye_admin/service/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    bool isAuthenticated = checkUserAuthentication();
    if (!isAuthenticated) {
      return const RouteSettings(name: AppRoutes.login);
    }
    return null;
  }

  bool checkUserAuthentication() {
    return StorageService.getToken() != null;
  }
}
