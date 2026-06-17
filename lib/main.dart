//
// import 'package:eagle_eye_admin/controller/app_controller.dart';
// import 'package:eagle_eye_admin/firebase_options.dart';
// import 'package:eagle_eye_admin/route/app_route.dart';
// import 'package:eagle_eye_admin/theme/colors.dart';
// import 'package:eagle_eye_admin/utils/api_controller_main.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   ApiControllerMain.init();
//
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   await GetStorage.init();
//   runApp(const MyApp());
// }
//
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//         designSize: const Size(1920, 1080),
//         minTextAdapt: true,
//         splitScreenMode: true,
//         builder: (_, child) {
//           return MediaQuery(
//             data: MediaQuery.of(context)
//                 .copyWith(textScaler: const TextScaler.linear(1)),
//             child: GetMaterialApp(
//               title: 'Awaaz Oprator',
//               initialRoute: AppRoutes.splash,
//               getPages: AppRoutes.routes,
//
//               navigatorKey: navigatorKey,
//               debugShowCheckedModeBanner: false,
//               onInit: () {
//                 Get.put(AppController(), permanent: true);
//               },
//               theme: ThemeData(
//                 colorScheme: ColorScheme.fromSeed(
//                   seedColor: Colors.black,
//                   brightness: Brightness.dark,
//                 ),
//                 scaffoldBackgroundColor: AppColors.black,
//                 appBarTheme:
//                     const AppBarTheme(backgroundColor: AppColors.black),
//                 fontFamily: "Poppins",
//                 textSelectionTheme: const TextSelectionThemeData(
//                   selectionHandleColor: AppColors.black,
//                 ),
//                 progressIndicatorTheme: const ProgressIndicatorThemeData(
//                   color: AppColors.black,
//                 ),
//                 dialogBackgroundColor: AppColors.black,
//                 dialogTheme: const DialogTheme(
//                   backgroundColor: AppColors.black,
//                 ),
//                 scrollbarTheme: ScrollbarThemeData(
//                   thumbColor:
//                       WidgetStateColor.resolveWith((states) => AppColors.black),
//                 ),
//                 useMaterial3: true,
//               ),
//             ),
//           );
//         });
//   }
// }
import 'package:eagle_eye_admin/firebase_options.dart';
import 'package:eagle_eye_admin/route/app_route.dart'; // Updated route management
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/utils/api_controller_main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ApiControllerMain.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: ScreenUtilInit(
        designSize: const Size(1920, 1080),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1)),
            child: GetMaterialApp.router(
              title: 'Awaaz Operator',
              debugShowCheckedModeBanner: false,
              routerDelegate: AppRoutes.router.routerDelegate,
              routeInformationParser: AppRoutes.router.routeInformationParser,
              routeInformationProvider:
                  AppRoutes.router.routeInformationProvider,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.black,
                  brightness: Brightness.dark,
                ),
                scaffoldBackgroundColor: AppColors.black,
                appBarTheme:
                    const AppBarTheme(backgroundColor: AppColors.black),
                fontFamily: "Poppins",
                textSelectionTheme: const TextSelectionThemeData(
                  selectionHandleColor: AppColors.black,
                ),
                progressIndicatorTheme: const ProgressIndicatorThemeData(
                  color: AppColors.black,
                ),
                dialogBackgroundColor: AppColors.black,
                dialogTheme: const DialogTheme(
                  backgroundColor: AppColors.black,
                ),
                scrollbarTheme: ScrollbarThemeData(
                  thumbColor:
                      WidgetStateColor.resolveWith((states) => AppColors.black),
                ),
                useMaterial3: true,
              ),
            ),
          );
        },
      ),
    );
  }
}
