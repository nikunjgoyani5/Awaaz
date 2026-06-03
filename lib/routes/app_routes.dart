import 'package:eagle_eye/presentation/authentication/auth_screen/auth_screen.dart';
import 'package:eagle_eye/presentation/authentication/change_password_screen/change_password_screen.dart';
import 'package:eagle_eye/presentation/authentication/reset_password_screen/reset_password_screen.dart';
import 'package:eagle_eye/presentation/authentication/verify_otp_screen/verify_otp_screen.dart';
import 'package:eagle_eye/presentation/main/add_friend_screen/add_friend_screen.dart';
import 'package:eagle_eye/presentation/main/add_friend_screen/friends_screen.dart';
import 'package:eagle_eye/presentation/main/alerts_screen/alerts_screen.dart';
import 'package:eagle_eye/presentation/main/blocked_users/blocked_users_screen.dart';
import 'package:eagle_eye/presentation/main/chat_screen/chat_list_screen.dart';
import 'package:eagle_eye/presentation/main/delete_account_screen/delete_account_view.dart';
import 'package:eagle_eye/presentation/main/edit_profile_screen/edit_profile_screen.dart';
import 'package:eagle_eye/presentation/main/general_go_live/general_go_live.dart';
import 'package:eagle_eye/presentation/main/get_support_screen/add_support_screen.dart';
import 'package:eagle_eye/presentation/main/get_support_screen/support_screen.dart';
import 'package:eagle_eye/presentation/main/go_live_screen/go_live_screen.dart';
import 'package:eagle_eye/presentation/main/my_profile_screen/my_profile_screen.dart';
import 'package:eagle_eye/presentation/main/news_details_screen/news_details_screen.dart';
import 'package:eagle_eye/presentation/main/news_screen/news_screen.dart';
import 'package:eagle_eye/presentation/main/search_location_screen/search_location_screen.dart';
import 'package:eagle_eye/presentation/main/search_screen/search_screen.dart';
import 'package:eagle_eye/presentation/main/settings_screen/settings_screen.dart';
import 'package:eagle_eye/presentation/main/user_profile_screen/user_profile_screen.dart';
import 'package:eagle_eye/presentation/onboard/new_onboard_screen/new_onboard_screen.dart';
import 'package:eagle_eye/presentation/onboard/onboard_screen/onboard_birthdate_screen.dart';
import 'package:eagle_eye/presentation/onboard/onboard_screen/onboard_name_screen.dart';
import 'package:eagle_eye/presentation/onboard/onboard_screen/onboard_profile_screen.dart';
import 'package:eagle_eye/presentation/onboard/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

import '../presentation/main/delete_account_screen/account_removed_screen.dart';
import '../presentation/main/delete_account_screen/select_reason_screen.dart';
import '../presentation/main/get_support_screen/support_detail_screen.dart';
import '../presentation/main/home/home_screen.dart';
import '../presentation/main/notification_settings_screen/notification_settings_screen.dart';
import '../presentation/main/send_alert/send_alert.dart';

enum PageTransitionType {
  fade, // Fade in-out
  slide, // Slide from right
  scale, // Zoom in effect
  rotate, // Rotate in effect
}

class AppRoutes {
  // Onboarding
  static const String splash = '/';
  static const String onboardName = '/onboardName';
  static const String newOnboard = '/newOnboard';
  static const String onboardBirthdate = '/onboardBirthdate';
  static const String onboardProfile = '/onboardProfile';

  // Authentication
  static const String logInMain = '/logInMain';
  static const String authScreen = '/authScreen';
  static const String logInWithMail = '/logInWithEmail';
  static const String register = '/registerScreen';
  static const String verifyOtp = '/verifyOtpScreen';
  static const String resetPassword = '/resetPassword';
  static const String changePassword = '/changePassword';

  // Main
  static const String home = '/home';

  static const String chatList = '/chatList';
  static const String news = '/news';
  static const String newsDetails = '/newsDetails';
  static const String myProfile = '/myProfile';
  static const String editProfile = '/editProfile';
  static const String settingsScreen = '/settings';
  static const String alerts = '/alerts';
  static const String friend = '/friend';
  static const String addFriend = '/addFriend';
  static const String goLive = '/goLive';
  static const String generalGoLive = '/generalGoLive';
  static const String search = '/search';
  static const String userProfile = '/userProfile';
  static const String sendAlert = '/sendAlert';
  static const String searchLocation = '/searchLocation';
  static const String getSupport = '/getSupport';
  static const String addSupport = '/addSupport';
  static const String notificationSettings = '/notificationSettings';
  static const String blockedUsers = '/blockedUsers';

  // Delete account
  static const String deleteAccount = '/deleteAccount';
  static const String selectReason = '/selectReason';
  static const String accountRemove = '/accountRemove';

  //
  static const String supportDetailScreen = '/supportDetailScreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Onboarding
      case splash:
        return _pageRoute(SplashScreen(),
            transitionType: PageTransitionType.fade);
      case onboardName:
        return _pageRoute(const OnboardNameScreen(),
            transitionType: PageTransitionType.fade);
      case newOnboard:
        return _pageRoute(const NewOnBoardScreen(),
            transitionType: PageTransitionType.fade);
      case onboardBirthdate:
        return _pageRoute(OnboardBirthdateScreen());
      case onboardProfile:
        return _pageRoute(OnboardProfileScreen());
      // Authentication
      case authScreen:
        return _pageRoute(AuthScreen(),
            transitionType: PageTransitionType.fade);
      case verifyOtp:
        return _pageRoute(VerifyOtpScreen());
      // Main
      case home:
        return _pageRoute(HomeScreen(),
            transitionType: PageTransitionType.fade);
      case chatList:
        return _pageRoute(ChatListScreen(),
            transitionType: PageTransitionType.fade);
      case news:
        return _pageRoute(NewsScreen(),
            transitionType: PageTransitionType.fade);
      case newsDetails:
        dynamic arg = settings.arguments as Map<String, dynamic>?;
        return _pageRoute(
            NewsDetailsScreen(
              isHome: arg['isHome'] ?? false,
            ),
            transitionType: PageTransitionType.fade);
      case myProfile:
        return _pageRoute(MyProfileScreen(),
            transitionType: PageTransitionType.fade);
      case settingsScreen:
        return _pageRoute(SettingsScreen());
      case editProfile:
        return _pageRoute(EditProfileScreen(),
            transitionType: PageTransitionType.slide);
      case alerts:
        return _pageRoute(AlertsScreen(),
            transitionType: PageTransitionType.fade);
      case addFriend:
        return _pageRoute(AddFriendScreen());
      case friend:
        return _pageRoute(FriendsScreen());
      case goLive:
        return _pageRoute(GoLiveScreen(),
            transitionType: PageTransitionType.fade);
      case generalGoLive:
        return _pageRoute(GeneralGoLive(),
            transitionType: PageTransitionType.fade);
      case search:
        return _pageRoute(SearchScreen(),
            transitionType: PageTransitionType.fade);
      case userProfile:
        return _pageRoute(UserProfileScreen(),
            transitionType: PageTransitionType.fade);
      case sendAlert:
        return _pageRoute(SendAlert(), transitionType: PageTransitionType.fade);
      case searchLocation:
        return _pageRoute(SearchLocationScreen(),
            transitionType: PageTransitionType.fade);
      case getSupport:
        return _pageRoute(SupportScreen(),
            transitionType: PageTransitionType.fade);
      case addSupport:
        return _pageRoute(AddSupportScreen());
      case resetPassword:
        return _pageRoute(ResetPasswordScreen());
      case changePassword:
        return _pageRoute(ChangePasswordScreen());
      case deleteAccount:
        return _pageRoute(DeleteAccountView(),
            transitionType: PageTransitionType.fade);
      case blockedUsers:
        return _pageRoute(BlockedUsersScreen());
      case selectReason:
        return _pageRoute(SelectReasonScreen(),
            transitionType: PageTransitionType.fade);
      case accountRemove:
        return _pageRoute(AccountRemoveScreen());
      case notificationSettings:
        return _pageRoute(NotificationSettingsScreen(),
            transitionType: PageTransitionType.fade);
      case supportDetailScreen:
        return _pageRoute(
          SupportDetailScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
        );
    }
  }

  // Custom Page Transition
  static PageRouteBuilder _pageRoute(Widget page,
      {PageTransitionType? transitionType = PageTransitionType.slide}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (transitionType) {
          case PageTransitionType.fade:
            return FadeTransition(opacity: animation, child: child);

          case PageTransitionType.slide:
            var tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeOut));
            return SlideTransition(
                position: animation.drive(tween), child: child);

          case PageTransitionType.scale:
            return ScaleTransition(scale: animation, child: child);

          case PageTransitionType.rotate:
            return RotationTransition(turns: animation, child: child);

          default:
            return child;
        }
      },
      transitionDuration: const Duration(milliseconds: 200), // Animation speed
    );
  }
}
