import 'dart:ui';

import 'package:eagle_eye/core/constant/app_constant.dart';
import 'package:eagle_eye/services/camera_services.dart';
import 'package:eagle_eye/services/connectivity_check/connectivity.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
import 'package:eagle_eye/services/one_signal_notification_service.dart';
import 'package:eagle_eye/services/remote_config_service/remote_config_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as map;
import 'package:showcaseview/showcaseview.dart';

import 'core/bloc_provider/bloc_providers.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_functions.dart';
import 'core/utils/app_prefrence.dart';
import 'data/api_controller.dart';
import 'firebase_options.dart';
import 'routes/app_routes.dart';
import 'services/deep_linking.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _minimalInit();
  _deferredInit(); // don't await
  runApp(const EagleEye());
}

Future<void> _minimalInit() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await PrefService.init();
  await networkConnectionServices.initConnectivityListener();
  await firebaseRemoteConfigService.initializeConfig();
  await FlutterBranchSdk.init(enableLogging: true);
  const accessToken = String.fromEnvironment("ACCESS_TOKEN");
  if (accessToken.isNotEmpty) {
    map.MapboxOptions.setAccessToken(accessToken);
  }
  ApiController.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

Future<void> _deferredInit() async {
  MobileAds.instance.initialize();
  if (isLiveMode) {
    try {
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    } catch (e) {
      debugPrint('Crashlytics Error ${e.toString()}');
    }
  }
  await OneSignalNotificationService.initOneSignalPlatformState();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  OneSignalNotificationService.initOneSignalPlatformState();
  CameraService.initializeCameras();
  // if (PrefService.getBool(PrefService.isLogin)) {
  //   MapUtils.getUserCurrentLocationNormal();
  // }
  isAppInitialized = true;
}

class EagleEye extends StatefulWidget {
  const EagleEye({super.key});

  @override
  State<EagleEye> createState() => _EagleEyeState();
}

class _EagleEyeState extends State<EagleEye> {
  late final Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _deferredInit();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(430, 990),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
            child: MultiBlocProvider(
              providers: BlocProviders.appBlocProviders,
              child: Builder(builder: (context) {
                DeepLinkingUtils.branchListenLinks(context);
                // AppLinksDeepLink.instance.initDeepLinks(context);
                return ShowCaseWidget(builder: (context) {
                  return MaterialApp(
                    navigatorKey: AppFunctions.navigatorKey,
                    debugShowCheckedModeBanner: false,
                    title: 'Awaaz:Real Time City Alert',
                    theme: darkTheme,
                    initialRoute: AppRoutes.splash,
                    onGenerateRoute: AppRoutes.generateRoute,
                    navigatorObservers: [FirebaseEvents.observer],
                  );
                });
              }),
            ),
          );
        });
  }
}
