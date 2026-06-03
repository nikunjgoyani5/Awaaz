import 'dart:developer';
import 'dart:io';
import 'package:eagle_eye/presentation/main/notification_settings_screen/bloc/notification_settings_cubit.dart';
import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/widget/app_web_view_widget.dart';
import 'package:eagle_eye/core/widget/common_app_bar.dart';
import 'package:eagle_eye/presentation/authentication/auth_screen/bloc/auth_screen_cubit.dart';
import 'package:eagle_eye/presentation/authentication/change_password_screen/bloc/change_password_screen_cubit.dart';
import 'package:eagle_eye/presentation/main/blocked_users/bloc/blocked_users_cubit.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:animated_rating_bar/widgets/animated_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/app_functions.dart';
import '../../../core/utils/app_prefrence.dart';
import '../../../core/widget/common_alert_dialogue.dart';
import '../../../gen/assets.gen.dart';
import '../../../routes/app_navigation.dart';
import '../../../routes/app_routes.dart';
import '../get_support_screen/bloc/get_support_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String appVersion = "Loading...";

  @override
  void initState() {
    FirebaseEvents.setFirebaseEvent('setting_screen', {});
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = "Version ${packageInfo.version}";
    });
  }

  double ratting = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppCommonAppBar(
        title: 'Setting',
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              SizedBox(
                height: 20.h,
              ),
              // settingsTile(
              //     name: 'Alert Zones',
              //     icon: Assets.icons.icAlertZoneSettings.svg()),
              // settingsTile(
              //     name: 'Friends', icon: Assets.icons.icFriendsSettings.svg()),
              // settingsTile(
              //     name: 'Location Sharing',
              //     icon: Assets.icons.icLocationSharingSettings.svg()),
              // settingsTile(
              //     name: 'Add Friends',
              //     icon: Assets.icons.icAddFriendSettings.svg()),
              settingsTile(
                onTap: () {
                  FirebaseEvents.setFirebaseEvent('click_setting_block_user', {});
                  context.read<BlockedUsersCubit>().init();
                  context.read<BlockedUsersCubit>().getBlockedUserList(isLoading: true);
                  NavigatorRoute.navigateTo(context, AppRoutes.blockedUsers);
                },
                name: 'Blocked Users',
                icon: Assets.icons.icSettingsBlockUser.svg(),
              ),
              settingsTile(
                onTap: () {
                  FirebaseEvents.setFirebaseEvent('click_setting_change_password', {});
                  context.read<ChangePasswordCubit>().init();
                  NavigatorRoute.navigateTo(context, AppRoutes.changePassword);
                },
                name: 'Change Password',
                icon: Assets.icons.icChangePassSettings.svg(),
              ),
              settingsTile(
                onTap: () {
                  FirebaseEvents.setFirebaseEvent('click_setting_alert_setting', {});
                  context.read<NotificationSettingsCubit>().init();
                  context.read<NotificationSettingsCubit>().defaultCameraView();
                  NavigatorRoute.navigateTo(context, AppRoutes.notificationSettings);
                },
                name: 'Alert Setting',
                icon: Assets.icons.icAlertSelectedBottom.svg(
                  colorFilter: ColorFilter.mode(
                    AppColors.whiteColor.withValues(alpha: 0.6),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              // settingsTile(
              //   onTap: () {
              //     FirebaseEvents.setFirebaseEvent(
              //         'click_setting_resolution', {});
              //     showAppBottomSheet(
              //       context,
              //       ResolutionSheet(),
              //     );
              //   },
              //   name: 'Post Download',
              //   icon: Assets.icons.icResolution.svg(),
              // ),
              settingsTile(
                name: 'Rate us',
                icon: Assets.icons.icFeedbackSettings.svg(),
                onTap: () {
                  bool? isRate = PrefService.getBool(PrefService.isRate); //prefs.getBool("isRate") ?? false;
                  if (isRate) {
                    AppFunctions.showToast('You have already rated this application!');
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        titlePadding: EdgeInsets.zero,
                        contentPadding: EdgeInsets.all(10.sp),

                        // backgroundColor: AppColors.white,
                        title: Container(
                          padding: EdgeInsets.all(20),
                          // height: 400.h,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppColors.popUpTextFieldBlackColor,
                          ),
                          child: Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(5),
                                  height: 80,
                                  width: 80,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Assets.images.awazLogoWebp.image())),
                              Gap(15.h),
                              Text(
                                "Hope you enjoy our app",
                                style: TextStyles.medium(20.sp),
                              ),
                              Gap(15.h),
                              Text(
                                (Platform.isIOS)
                                    ? "If you enjoy our App,Would you like to rate us on App Store"
                                    : "If you enjoy our App,Would you like to rate us on google play?",
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyles.medium(18.sp),
                              ),
                              Gap(20.h),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.65,
                                child: AnimatedRatingBar(
                                  strokeColor: AppColors.whiteColor,
                                  activeFillColor: Colors.amber,
                                  initialRating: 0,
                                  height: 60,
                                  width: MediaQuery.of(context).size.width,
                                  animationColor: Colors.red,
                                  onRatingUpdate: (rating) {
                                    setState(() {
                                      ratting = rating;
                                    });
                                  },
                                ),
                              ),
                              Gap(25.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        NavigatorRoute.navigateBack(context);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: AppColors.primaryColor),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Maybe later",
                                            style: TextStyles.medium(18.sp, fontColor: AppColors.primaryColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Gap(10.h),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (ratting != 0) {
                                          PrefService.setValue(PrefService.isRate, true);
                                          try {
                                            NavigatorRoute.navigateBack(context);
                                            if (!await launchUrl(
                                                Uri.parse((Platform.isIOS)
                                                    ? "https://apps.apple.com/app/id6742005823"
                                                    : "https://play.google.com/store/apps/details?id=com.awaazeye.cityalerts"),
                                                mode: LaunchMode.externalApplication)) {
                                              throw Exception('');
                                            }
                                          } catch (e) {
                                            log("Error open URL :- $e ");
                                          }
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: AppColors.primaryColor),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Submit",
                                            style: TextStyles.medium(18.sp, fontColor: AppColors.whiteColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
              /*settingsTile(
                  name: 'Feedback',
                  icon: Assets.icons.icFeedbackSettings.svg()),*/
              settingsTile(
                  name: 'Get Support',
                  onTap: () async {
                    FirebaseEvents.setFirebaseEvent('click_setting_get_support_btn', {});
                    await context.read<GetSupportCubit>().getSupportTicketList();
                    NavigatorRoute.navigateTo(context, AppRoutes.getSupport);
                  },
                  icon: Assets.icons.icSupportSettings.svg()),
              // settingsTile(name: 'FAQ', icon: Assets.icons.icFaqSettings.svg()),
              settingsTile(
                  onTap: () {
                    FirebaseEvents.setFirebaseEvent('click_setting_privacy_policy', {});
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return AppWebViewWidget(
                            appbarTitle: 'Privacy Policy',
                            url: 'https://awaazapp.blogspot.com/2025/02/privacy-policy.html');
                      },
                    ));
                  },
                  name: 'Privacy Policy',
                  icon: Assets.icons.icPrivacyPolicySettings.svg()),

              settingsTile(
                onTap: () {
                  FirebaseEvents.setFirebaseEvent('click_setting_delete_account', {});
                  context.read<ChangePasswordCubit>().init();
                  NavigatorRoute.navigateTo(context, AppRoutes.selectReason);
                },
                name: 'Delete Account',
                icon: Assets.icons.icDeleteAccountSettings.svg(),
              ),
              // settingsTile(
              //   onTap: () {
              //     FirebaseEvents.setFirebaseEvent('click_setting_logout', {});
              //     showAppDialog(context,
              //         CommonAlertDialogue(dialogWidget: LogOutDialog(
              //       onEndTap: () async {
              //         bool isRemember =
              //             PrefService.getBool(PrefService.remember);
              //         String email = PrefService.getString(PrefService.email);
              //         String password =
              //             PrefService.getString(PrefService.password);
              //         bool goLiveTutorial =
              //             PrefService.getBool(PrefService.goLiveTutorial);
              //         bool startLiveTutorial =
              //             PrefService.getBool(PrefService.startLiveTutorial);
              //         PrefService.clear();
              //         await AppFunctions.googleSignOut();
              //         AppFunctions.showToast('Log Out successfully.');
              //         PrefService.setValue(
              //             PrefService.goLiveTutorial, goLiveTutorial);
              //         PrefService.setValue(
              //             PrefService.startLiveTutorial, startLiveTutorial);
              //         if (isRemember) {
              //           PrefService.setValue(PrefService.remember, isRemember);
              //           PrefService.setValue(PrefService.email, email);
              //           PrefService.setValue(PrefService.password, password);
              //         }
              //         context.read<AuthScreenCubit>().init();
              //         context.read<AuthScreenCubit>().showLogInWithMobile(
              //             isRemember: isRemember,
              //             email: (isRemember) ? email : null,
              //             password: (isRemember) ? password : null);
              //         NavigatorRoute.navigateToRemoveUntil(
              //             context, AppRoutes.authScreen);
              //       },
              //     )));
              //   },
              //   name: 'Log Out',
              //   icon: Assets.icons.icLogoutSettings.svg(),
              // ),
            ],
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Text(
                  appVersion,
                  style: TextStyles.semiBold(18.sp, fontColor: AppColors.textHintGrayColor),
                ),
              ))
        ],
      ),
    );
  }

  Widget settingsTile({required String name, required Widget icon, Function? onTap}) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap.call();
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 20.h,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(height: 30.h, width: 30.w, child: icon),
                    SizedBox(
                      width: 15.w,
                    ),
                    Text(name, style: TextStyles.regular(20.sp, fontColor: AppColors.whiteColor)),
                  ],
                ),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: AppColors.actionBtnBgColor,
            ),
          ],
        ),
      ),
    );
  }
}
