import 'dart:developer';

import 'package:eagle_eye_admin/api/repository/user_repository.dart';
import 'package:eagle_eye_admin/controller/dashboard_controller.dart';
import 'package:eagle_eye_admin/controller/event_controller.dart';
import 'package:eagle_eye_admin/controller/report_controller.dart';
import 'package:eagle_eye_admin/controller/rescue_controller.dart';
import 'package:eagle_eye_admin/model/response_model.dart';
import 'package:eagle_eye_admin/page/event_screen/event_dashboard_view.dart';
import 'package:eagle_eye_admin/page/general_screen/general_dashboard_view.dart';
import 'package:eagle_eye_admin/page/reports_screen/report_dashboard_view.dart';
import 'package:eagle_eye_admin/page/rescue_screen/rescue_dashboard_view.dart';
import 'package:eagle_eye_admin/page/super_admin_dashboard/super_admin_dashboard_screen.dart';
import 'package:eagle_eye_admin/page/user_management_screen/user_management_dashboard_view.dart';
import 'package:eagle_eye_admin/utils/responsive_utils.dart';
import 'package:eagle_eye_admin/widget/drawer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  EventController eventController = Get.put(EventController());
  ReportController reportController = Get.put(ReportController());
  DashboardController controller = Get.put(DashboardController());

  RescueController rescueController = Get.put(RescueController());

  GlobalKey key = GlobalKey();

  @override
  void initState() {
    // disableBrowserBackButton();
    init();
    controller.onRefresh(context);
    super.initState();
  }

  init() async {
    permissionRequest();
  }

  Future updateTokenAPI({
    required String token,
  }) async {
    try {
      log('Token data :$token');
      ResponseModel res =
          await UserRepository.updateUserToken(token: token, context: context);
      if (res.status == true) {
        log('================ Token Updated ================= :- ${res.body}');
      } else {
        log('================ Error Token Updated ================= :- ${res.body}');
      }
    } catch (e) {
      log('================ Error Token Updated ================= :- ${e.toString()}');
    }
  }

  permissionRequest() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        String? fcmToken = await messaging.getToken();
        if (fcmToken != null && fcmToken.isNotEmpty) {
          log('FCM Token ## $fcmToken ##');
          await updateTokenAPI(token: fcmToken);
        }
      }
    } catch (e) {
      log('PERMISSION REQUEST ## ERROR ## $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      drawer: const DrawerWidget(),
      body: GetBuilder<DashboardController>(builder: (controller) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              const Expanded(
                child: DrawerWidget(),
              ),
            (controller.selectedTab == 0)
                ? const EventDashboardView()
                : (controller.selectedTab == 1)
                    ? const RescueDashboardView()
                    : (controller.selectedTab == 2)
                        ? const ReportDashboardView()
                        : (controller.selectedTab == 3)
                            ? const UserManagementDashboardView()
                            : (controller.selectedTab == 4)
                                ? const SuperAdminDashboardScreen()
                                : const GeneralDashBoardView()
          ],
        );
      }),
    );
  }
}
