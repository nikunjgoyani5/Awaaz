// import 'package:eagle_eye_admin/middleware/auth_middleware.dart';
// import 'package:eagle_eye_admin/page/dashboard_screen/dashboard_screen.dart';
// import 'package:eagle_eye_admin/page/event_screen/attach_event_view.dart';
// import 'package:eagle_eye_admin/page/event_screen/event_details_screen.dart';
// import 'package:eagle_eye_admin/page/forgot_password_screen.dart/forgot_password_screen.dart';
// import 'package:eagle_eye_admin/page/forgot_password_screen.dart/otp_screen.dart';
// import 'package:eagle_eye_admin/page/forgot_password_screen.dart/reset_password_screen.dart';
// import 'package:eagle_eye_admin/page/login_screen/login_screen.dart';
// import 'package:eagle_eye_admin/page/onboarding_screen/onboarding_screen.dart';
// import 'package:eagle_eye_admin/page/register_screen.dart/register_screen.dart';
// import 'package:eagle_eye_admin/page/rescue_screen/rescue_dashboard_view.dart';
// import 'package:eagle_eye_admin/page/rescue_screen/rescue_details_screen.dart';
// import 'package:eagle_eye_admin/page/splash_screen/splash_screen.dart';
// import 'package:eagle_eye_admin/page/super_admin_dashboard/super_admin_dashboard_screen.dart';
// import 'package:eagle_eye_admin/page/user_profile_screen/user_profile_view.dart';
// import 'package:get/get.dart';
//
// class AppRoutes {
//   static const splash = '/';
//   static const login = '/login';
//   static const register = '/register';
//   static const forgotPassword = '/forgotPassword';
//   static const otpScreen = '/otpScreen';
//   static const resetPassword = '/resetPassword';
//   static const onBoarding = '/onBoarding';
//   static const event = '/dashboard';
//   static const rescue = '/rescue';
//   static const userProfile = '/event/userProfile';
//   static const attachEvent = '/event/attachEvent';
//   static const eventDetails = '/event/eventDetails';
//   static const rescueDetails = '/rescue/rescueDetails';
//   static const superAdminDashboard = '/superAdminDashboard';
//
//   static final routes = [
//     GetPage(
//         participatesInRootNavigator: false,
//         opaque: false,
//         name: splash,
//         page: () => const SplashScreen()),
//     GetPage(
//         participatesInRootNavigator: false,
//         opaque: false,
//         name: login,
//         page: () => const LoginScreen()),
//     GetPage(
//         participatesInRootNavigator: false,
//         opaque: false,
//         name: register,
//         page: () => const RegisterScreen()),
//     GetPage(
//         participatesInRootNavigator: false,
//         opaque: false,
//         name: forgotPassword,
//         page: () => const ForgotPasswordScreen()),
//     GetPage(
//         participatesInRootNavigator: false,
//         opaque: false,
//         name: otpScreen,
//         page: () => const OtpScreen()),
//     GetPage(
//         participatesInRootNavigator: false,
//         opaque: false,
//         name: resetPassword,
//         page: () => const ResetPasswordScreen()),
//     GetPage(
//         participatesInRootNavigator: false,
//         opaque: false,
//         name: event,
//         middlewares: [AuthMiddleware()],
//         page: () => const DashboardScreen()),
//     GetPage(
//         participatesInRootNavigator: false,
//         opaque: false,
//         name: rescue,
//         middlewares: [AuthMiddleware()],
//         page: () => const RescueDashboardView()),
//     GetPage(
//         participatesInRootNavigator: false,
//         opaque: false,
//         name: userProfile,
//         middlewares: [AuthMiddleware()],
//         page: () => const UserProfileView(userId: '',)),
//     GetPage(
//         participatesInRootNavigator: false,
//         opaque: false,
//         name: attachEvent,
//         middlewares: [AuthMiddleware()],
//         page: () => const AttachEventView()),
//     GetPage(
//         participatesInRootNavigator: false,
//         opaque: false,
//         name: eventDetails,
//         middlewares: [AuthMiddleware()],
//         page: () => const EventDetailsScreen()),
//     GetPage(
//         participatesInRootNavigator: false,
//         opaque: false,
//         name: rescueDetails,
//         middlewares: [AuthMiddleware()],
//         page: () => const RescueDetailsScreen()),
//     GetPage(
//         participatesInRootNavigator: false,
//         opaque: false,
//         name: onBoarding,
//         middlewares: [AuthMiddleware()],
//         page: () => const OnboardingScreen()),
//     GetPage(
//         participatesInRootNavigator: false,
//         opaque: false,
//         name: superAdminDashboard,
//         page: () => const SuperAdminDashboardScreen()),
//   ];
// }
import 'package:eagle_eye_admin/page/dashboard_screen/dashboard_screen.dart';
import 'package:eagle_eye_admin/page/event_screen/attach_event_view.dart';
import 'package:eagle_eye_admin/page/event_screen/event_details_screen.dart';
import 'package:eagle_eye_admin/page/forgot_password_screen.dart/forgot_password_screen.dart';
import 'package:eagle_eye_admin/page/forgot_password_screen.dart/otp_screen.dart';
import 'package:eagle_eye_admin/page/forgot_password_screen.dart/reset_password_screen.dart';
import 'package:eagle_eye_admin/page/general_screen/component/general_detail_screen.dart';
import 'package:eagle_eye_admin/page/login_screen/login_screen.dart';
import 'package:eagle_eye_admin/page/onboarding_screen/onboarding_screen.dart';
import 'package:eagle_eye_admin/page/register_screen.dart/register_screen.dart';
import 'package:eagle_eye_admin/page/rescue_screen/rescue_dashboard_view.dart';
import 'package:eagle_eye_admin/page/rescue_screen/rescue_details_screen.dart';
import 'package:eagle_eye_admin/page/splash_screen/splash_screen.dart';
import 'package:eagle_eye_admin/page/super_admin_dashboard/super_admin_dashboard_screen.dart';
import 'package:eagle_eye_admin/page/user_profile_screen/user_profile_view.dart';

import 'package:go_router/go_router.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgotPassword';
  static const otpScreen = '/otpScreen';
  static const resetPassword = '/resetPassword';
  static const onBoarding = '/onBoarding';
  static const event = '/dashboard';
  static const rescue = '/rescue';
  static const userProfile = '/event/userProfile';
  static const attachEvent = '/event/attachEvent';
  static const eventDetails = '/event/eventDetails';
  static const rescueDetails = '/rescue/rescueDetails';
  static const generalDetails = '/general/generalDetails';
  static const superAdminDashboard = '/superAdminDashboard';

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: otpScreen,
        builder: (context, state) => const OtpScreen(),
      ),
      GoRoute(
        path: resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: onBoarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: event,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: rescue,
        builder: (context, state) => const RescueDashboardView(),
      ),
      GoRoute(
        path: '/event/userProfile/:userId',
        builder: (context, state) {
          final String userId = state.pathParameters['userId'] ?? '';
          return UserProfileView(userId: userId);
        },
      ),
      GoRoute(
        path: attachEvent,
        builder: (context, state) => const AttachEventView(),
      ),
      GoRoute(
        path: eventDetails,
        builder: (context, state) {
          // final String eventId = state.pathParameters['eventId'] ?? '';
          return const EventDetailsScreen(
              // eventId: eventId,
              );
        },
      ),
      GoRoute(
        path: rescueDetails,
        builder: (context, state) => const RescueDetailsScreen(),
      ),
      GoRoute(
        path: superAdminDashboard,
        builder: (context, state) => const SuperAdminDashboardScreen(),
      ),
      GoRoute(
        path: generalDetails,
        builder: (context, state) => const GeneralDetailsScreen(),
      ),
    ],
    // redirect: (BuildContext context, GoRouterState state) {
    //   if (StorageService.getToken() == null) {
    //     return '/login';
    //   }
    //   /*   else  if (StorageService.getToken() != null){
    //     return '/dashboard';
    //   }*/
    //   return null;
    // },
  );
}
