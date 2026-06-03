import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:eagle_eye/presentation/onboard/splash_screen/bloc/splash_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_functions.dart';
import '../../../../core/utils/app_prefrence.dart';
import '../../../../data/models/login_model.dart';
import '../../../../data/models/response_model.dart';
import '../../../../data/repositories/main_repo.dart';
import '../../../../routes/app_navigation.dart';
import '../../../../routes/app_routes.dart';
import '../../../../services/firebase_analytics_service.dart';
import '../../../main/home/bloc/home_screen_bloc_cubit.dart';
import '../../../main/map_screen/bloc/map_screen_cubit.dart';
import '../../../main/news_screen/bloc/news_screen_bloc_cubit.dart';
import '../../onboard_screen/bloc/onboard_cubit.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashState());

  Future<void> deviceAuth(BuildContext context) async {
    emit(state.copyWith(isLoading: true));
    try {
      String deviceId = await getDeviceId() ?? "";

      ResponseModel response = await MainRepository.deviceAuth(
        data: {"deviceId": deviceId},
      );
      log("Device Auth :- $response");

      if (response.status == true) {
        FirebaseEvents.setFirebaseEvent('guest_login_success', {});
        Auth logInModel = Auth.fromJson(response.body);
        await PrefService.setValue(PrefService.accessToken, logInModel.token ?? '');

        await PrefService.setValue(PrefService.name, logInModel.user?.name ?? '');
        await PrefService.setValue(PrefService.userName, logInModel.user?.username ?? '');

        await PrefService.setValue(PrefService.userId, logInModel.user?.id ?? '');
        await PrefService.setValue(PrefService.userRadius, logInModel.user?.userRadius ?? 0);
        await PrefService.setValue(PrefService.isLogin, true);
        await PrefService.setValue(PrefService.deviceLogin, true);
        emit(state.copyWith(isLoading: false));
        // await AppFunctions.showToast(response.message);
        context.read<OnboardCubit>().init();
        context.read<OnboardCubit>().setNameFiledData();
        context.read<OnboardCubit>().setUserNameFiledData();
        await context.read<NewsScreenBlocCubit>().init();
        await context.read<NewsScreenBlocCubit>().getNewsEvents('latest');
        await NavigatorRoute.navigateToRemoveUntil(context, AppRoutes.home);
      } else {
        emit(state.copyWith(isLoading: false));
        AppFunctions.showToast(response.message);
      }
    } catch (e) {
      FirebaseEvents.setFirebaseEvent('guest_login_failed', {});
      log('$e');
    }
  }

  Future<String?> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // OR androidInfo.androidId for unique ID
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor; // Unique ID on iOS
    }

    return null;
  }
}
