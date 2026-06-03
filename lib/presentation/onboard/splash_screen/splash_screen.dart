import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/theme/text_styles.dart';
import 'package:eagle_eye/gen/fonts.gen.dart';
import 'package:eagle_eye/presentation/onboard/splash_screen/bloc/splash_cubit.dart';
import 'package:eagle_eye/routes/app_navigation.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constant/app_assets.dart';
import '../../../core/utils/app_prefrence.dart';
import '../../../core/utils/map_utils.dart';
import '../../../core/widget/common_app_image_show.dart';
import '../../../routes/app_routes.dart';
import '../../../services/remote_config_service/remote_config_label.dart';
import '../../authentication/auth_screen/bloc/auth_screen_cubit.dart';
import '../../main/news_screen/bloc/news_screen_bloc_cubit.dart';
import '../onboard_screen/bloc/onboard_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  bool isNewOnboard = false;
  @override
  void initState() {
    FirebaseEvents.setFirebaseEvent('splash_screen_init', {});
    isNewOnboard = remoteConfig.getBool(RemoteConfigLabel.isNewOnboard);
    super.initState();
    Future.delayed(
      Duration.zero,
      () async {
        await deviceIdAuth();
      },
    );
    // navigate();
  }

  Future<void> deviceIdAuth() async {
    if (PrefService.getBool(PrefService.isLogin)) {
      context.read<OnboardCubit>().init();
      context.read<OnboardCubit>().setNameFiledData();
      context.read<OnboardCubit>().setUserNameFiledData();
      context.read<NewsScreenBlocCubit>().init();
      await context.read<NewsScreenBlocCubit>().getNewsEvents('latest');
      await NavigatorRoute.navigateToRemoveUntil(context, AppRoutes.home);
    } else {
      await context.read<SplashCubit>().deviceAuth(context);
    }
  }

  // navigate() {
  //   Future.delayed(const Duration(seconds: 2)).then(
  //     (value) async {
  //       if (!mounted) {
  //         return;
  //       } else {
  //         context.read<AuthScreenCubit>().init();
  //         if (PrefService.getBool(PrefService.isLogin)) {
  //           context.read<OnboardCubit>().init();
  //           context.read<OnboardCubit>().setNameFiledData();
  //           context.read<OnboardCubit>().setUserNameFiledData();
  //           context.read<NewsScreenBlocCubit>().init();
  //           await context.read<NewsScreenBlocCubit>().getNewsEvents('latest');
  //         }
  //       }
  //       await NavigatorRoute.navigateToRemoveUntil(
  //         context,
  //         PrefService.getBool(PrefService.isLogin)
  //             ? ((PrefService.getString(PrefService.name).isNotEmpty) &&
  //                     (PrefService.getString(PrefService.userName).isNotEmpty))
  //                 ? AppRoutes.home
  //                 : isNewOnboard
  //                     ? AppRoutes.newOnboard
  //                     : AppRoutes.onboardName
  //             : AppRoutes.authScreen,
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: AppImageViewer.showAssetImage(
                path: AppImageAsset.appIcon,
                boxFit: BoxFit.fill,
              ),
            ),
            Text(
              'AWAAZ',
              style:
                  TextStyles.medium(60.sp, fontColor: AppColors.whiteColor, fontFamily: FontFamily.testTiemposHeadline),
            ),
            Text(
              'Be Where Things Happen',
              style: TextStyles.medium(18.sp, fontColor: AppColors.whiteColor),
            ),
          ],
        ),
      ),
    );
  }
}
