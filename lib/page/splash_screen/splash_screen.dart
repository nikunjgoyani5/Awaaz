import 'package:eagle_eye_admin/controller/splash_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/route/app_route.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/service/storage/storage_service.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashController splashController = Get.put(SplashController());


  @override
  void initState() {
    navigate();
    super.initState();
  }
  navigate() {
    Future.delayed(const Duration(seconds: 4)).then(
          (value) {
        if (StorageService.getToken() == null) {
          NavigatorRoute.navigateToRemoveUntil(AppRoutes.login,context);
        } else if (StorageService.getIsSuperAdmin() == true) {
          NavigatorRoute.navigateToRemoveUntil(AppRoutes.event,context);
          // NavigatorRoute.navigateToRemoveUntil(AppRoutes.superAdminDashboard);
        } else {
          NavigatorRoute.navigateToRemoveUntil(AppRoutes.event,context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(Assets.image.mapBg.path),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: AlignmentDirectional.center,
                child: Assets.image.aawazLogo.svg(),
              ),
              const Gap(30),
              Center(
                child: Column(
                  children: [
                    Text(
                      "WELCOME TO THE OPERATOR PANEL \n OF AWAAZ APP",
                      textAlign: TextAlign.center,

                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: AppColors.white, fontWeight: FontWeight.w700,),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
