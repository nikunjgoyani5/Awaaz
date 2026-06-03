import 'package:eagle_eye/presentation/authentication/change_password_screen/bloc/change_password_screen_cubit.dart';
import 'package:eagle_eye/presentation/authentication/reset_password_screen/bloc/reset_password_screen_cubit.dart';
import 'package:eagle_eye/presentation/main/blocked_users/bloc/blocked_users_cubit.dart';
import 'package:eagle_eye/presentation/main/delete_account_screen/bloc/delete_account_cubit.dart';
import 'package:eagle_eye/presentation/main/get_support_screen/bloc/get_support_cubit.dart';
import 'package:eagle_eye/presentation/main/go_live_screen/bloc/go_live_cubit.dart';
import 'package:eagle_eye/presentation/main/map_screen/bloc/map_screen_cubit.dart';
import 'package:eagle_eye/presentation/main/my_profile_screen/bloc/bloc/my_profile_cubit.dart';
import 'package:eagle_eye/presentation/main/notification_settings_screen/bloc/notification_settings_cubit.dart';
import 'package:eagle_eye/presentation/main/search_location_screen/bloc/search_location_cubit.dart';
import 'package:eagle_eye/presentation/main/send_alert/bloc/send_alert_cubit.dart';
import 'package:eagle_eye/presentation/main/user_profile_screen/bloc/user_profile_cubit.dart';
import 'package:eagle_eye/presentation/onboard/splash_screen/bloc/splash_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/authentication/auth_screen/bloc/auth_screen_cubit.dart';
import '../../presentation/authentication/verify_otp_screen/bloc/verify_otp_cubit.dart';
import '../../presentation/main/alerts_screen/bloc/alerts_screen_bloc_cubit.dart';
import '../../presentation/main/edit_profile_screen/bloc/edit_profile_cubit.dart';
import '../../presentation/main/general_go_live/bloc/general_post_cubit.dart';
import '../../presentation/main/home/bloc/home_screen_bloc_cubit.dart';
import '../../presentation/main/news_details_screen/bloc/news_details_screen_bloc_cubit.dart';
import '../../presentation/main/news_screen/bloc/news_screen_bloc_cubit.dart';
import '../../presentation/main/search_screen/bloc/search_screen_bloc_cubit.dart';
import '../../presentation/onboard/onboard_screen/bloc/onboard_cubit.dart';

class BlocProviders {
  static dynamic appBlocProviders = [
    BlocProvider<OnboardCubit>(
      create: (context) => OnboardCubit(),
    ),
    BlocProvider<AuthScreenCubit>(
      create: (context) => AuthScreenCubit(),
    ),
    BlocProvider<HomeScreenBlocCubit>(
      create: (context) => HomeScreenBlocCubit(),
    ),
    BlocProvider<NewsScreenBlocCubit>(
      create: (context) => NewsScreenBlocCubit(),
    ),
    BlocProvider<NewsDetailsScreenBlocCubit>(
      create: (context) => NewsDetailsScreenBlocCubit(),
    ),
    BlocProvider<AlertsScreenBlocCubit>(
      create: (context) => AlertsScreenBlocCubit(),
    ),
    BlocProvider<SearchScreenBlocCubit>(
      create: (context) => SearchScreenBlocCubit(),
    ),
    BlocProvider<VerifyOtpCubit>(
      create: (context) => VerifyOtpCubit(),
    ),
    BlocProvider<EditProfileCubit>(
      create: (context) => EditProfileCubit(),
    ),
    BlocProvider<SendAlertCubit>(
      create: (context) => SendAlertCubit(),
    ),
    BlocProvider<MyProfileCubit>(
      create: (context) => MyProfileCubit(),
    ),
    BlocProvider<MapScreenCubit>(
      create: (context) => MapScreenCubit(),
    ),
    BlocProvider<UserProfileCubit>(
      create: (context) => UserProfileCubit(),
    ),
    BlocProvider<GetSupportCubit>(
      create: (context) => GetSupportCubit(),
    ),
    BlocProvider<ResetPasswordCubit>(
      create: (context) => ResetPasswordCubit(),
    ),
    BlocProvider<ChangePasswordCubit>(
      create: (context) => ChangePasswordCubit(),
    ),
    BlocProvider<GoLiveCubit>(
      create: (context) => GoLiveCubit(),
    ),
    BlocProvider<SearchLocationCubit>(
      create: (context) => SearchLocationCubit(),
    ),
    BlocProvider<NotificationSettingsCubit>(
      create: (context) => NotificationSettingsCubit(),
    ),
    BlocProvider<DeleteAccountCubit>(
      create: (context) => DeleteAccountCubit(),
    ),
    BlocProvider<BlockedUsersCubit>(
      create: (context) => BlockedUsersCubit(),
    ),
    BlocProvider<GeneralPostCubit>(
      create: (context) => GeneralPostCubit(),
    ),
    BlocProvider<SplashCubit>(
      create: (context) => SplashCubit(),
    ),
  ];
}
