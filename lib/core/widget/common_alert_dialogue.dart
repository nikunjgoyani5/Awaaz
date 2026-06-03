import 'package:eagle_eye/core/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../gen/fonts.gen.dart';
import '../../routes/app_navigation.dart';
import '../theme/text_styles.dart';
import 'common_button.dart';

class CommonAlertDialogue extends StatelessWidget {
  final Widget dialogWidget;

  const CommonAlertDialogue({super.key, required this.dialogWidget});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      backgroundColor: AppColors.actionBtnBgColor,
      child: dialogWidget,
    );
  }
}

class EndLiveVideoDialog extends StatelessWidget {
  final Function onEndTap;
  final Function onCancelTap;
  final String buttonText;

  const EndLiveVideoDialog(
      {super.key,
      required this.onEndTap,
      required this.buttonText,
      required this.onCancelTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 40.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            '$buttonText live video?',
            textAlign: TextAlign.center,
            style: TextStyles.bold(22.sp,
                fontColor: AppColors.whiteColor,
                fontFamily: FontFamily.testTiemposHeadline),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Text(
            'Exiting will stop the live broadcast. You can resume anytime from the Go Live.',
            textAlign: TextAlign.center,
            style: TextStyles.bold(
              16.sp,
              fontColor: AppColors.whiteColor,
            ),
          ),
        ),
        SizedBox(
          height: 50.h,
        ),
        // Divider(
        //   color: AppColors.popUpTextFieldBlackColor,
        // ),
        CommonButton(
          color: AppColors.whiteColor,
          width: 200,
          height: 50.sp,
          onPressed: () {
            onEndTap.call();
          },
          widget: Text(
            buttonText,
            style: TextStyles.medium(18.sp, fontColor: AppColors.blackColor),
          ),
        ),
        Gap(10.h),
        InkWell(
          onTap: () {
            onCancelTap.call();
          },
          child: SizedBox(
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                'Cancel',
                style: TextStyles.bold(18.sp, fontColor: AppColors.whiteColor),
              ),
            ),
          ),
        ),
        /*InkWell(
          onTap: () {
            onEndTap.call();
          },
          child: SizedBox(
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                buttonText,
                style:
                    TextStyles.bold(18.sp, fontColor: AppColors.redColorColor),
              ),
            ),
          ),
        ),
        Divider(
          color: AppColors.popUpTextFieldBlackColor,
        ),
        InkWell(
          onTap: () {
            onCancelTap.call();
          },
          child: SizedBox(
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                'Cancel',
                style: TextStyles.bold(18.sp, fontColor: AppColors.whiteColor),
              ),
            ),
          ),
        ),*/
        SizedBox(
          height: 20.h,
        ),
      ],
    );
  }
}

class LogOutDialog extends StatelessWidget {
  final Function onEndTap;

  const LogOutDialog({super.key, required this.onEndTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            'Are you sure ?',
            textAlign: TextAlign.center,
            style: TextStyles.bold(25.sp,
                fontColor: AppColors.whiteColor,
                fontFamily: FontFamily.testTiemposHeadline),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Divider(
          color: AppColors.popUpTextFieldBlackColor,
        ),
        InkWell(
          onTap: () {
            onEndTap.call();
          },
          child: SizedBox(
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                'Log out',
                style:
                    TextStyles.bold(20.sp, fontColor: AppColors.redColorColor),
              ),
            ),
          ),
        ),
        Divider(
          color: AppColors.popUpTextFieldBlackColor,
        ),
        InkWell(
          onTap: () {
            NavigatorRoute.navigateBack(context);
          },
          child: SizedBox(
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                'Cancel',
                style: TextStyles.bold(20.sp, fontColor: AppColors.whiteColor),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }
}

class AppPermissionDialog extends StatelessWidget {
  final String message;
  final String title;
  final bool? showCancelButton;

  const AppPermissionDialog(
      {super.key,
      required this.message,
      required this.title,
      this.showCancelButton});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Gap(20.h),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyles.bold(26.sp),
        ),
        Text(
          message,
          style: TextStyles.regular(19.sp),
          textAlign: TextAlign.center,
        ),
        Gap(30.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: CommonButton(
            onPressed: () {
              NavigatorRoute.navigateBack(context);
              openAppSettings();
            },
            radius: 30.r,
            widget: Text(
              'Allow Permission ',
              style: TextStyles.semiBold(
                20.sp,
                fontColor: AppColors.whiteColor,
              ),
            ),
          ),
        ),
        Visibility(
          visible: showCancelButton ?? true,
          child: Center(
            child: TextButton(
              onPressed: () {
                NavigatorRoute.navigateBack(context);
              },
              child: Text(
                'Not Right Now',
                style: TextStyles.medium(
                  18.sp,
                  fontColor: AppColors.textHintGrayColor,
                ),
              ),
            ),
          ),
        ),
        Gap(10.h),
      ],
    );
  }
}

class ExitDialog extends StatelessWidget {
  final Function exitOnTap;

  const ExitDialog({super.key, required this.exitOnTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 40.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            'Exit the app?',
            textAlign: TextAlign.center,
            style: TextStyles.bold(22.sp,
                fontColor: AppColors.whiteColor,
                fontFamily: FontFamily.testTiemposHeadline),
          ),
        ),
        SizedBox(
          height: 50.h,
        ),
        Divider(
          color: AppColors.popUpTextFieldBlackColor,
        ),
        InkWell(
          onTap: () {
            exitOnTap.call();
          },
          child: SizedBox(
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                'Exit now',
                style:
                    TextStyles.bold(18.sp, fontColor: AppColors.redColorColor),
              ),
            ),
          ),
        ),
        Divider(
          color: AppColors.popUpTextFieldBlackColor,
        ),
        InkWell(
            child: SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  'Cancel',
                  style:
                      TextStyles.bold(18.sp, fontColor: AppColors.whiteColor),
                ),
              ),
            ),
            onTap: () {
              NavigatorRoute.navigateBack(context);
            }),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }
}

class DraftPostDialog extends StatelessWidget {
  final Function draftOnTap;
  final Function cancelOnTap;

  const DraftPostDialog(
      {super.key, required this.draftOnTap, required this.cancelOnTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 40.h), // Add space for the close button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            'Want to save as draft?',
            textAlign: TextAlign.center,
            style: TextStyles.bold(24.sp,
                fontColor: AppColors.whiteColor,
                fontFamily: FontFamily.testTiemposHeadline),
          ),
        ),
        SizedBox(
          height: 25.h,
        ),
        Divider(
          color: AppColors.popUpTextFieldBlackColor,
          height: 1,
        ),
        InkWell(
          onTap: () {
            draftOnTap.call();
          },
          child: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                'Yes',
                style: TextStyles.bold(20.sp, fontColor: AppColors.whiteColor),
              ),
            ),
          ),
        ),
        Divider(
          color: AppColors.popUpTextFieldBlackColor,
          height: 1,
        ),
        InkWell(
          onTap: () {
            cancelOnTap.call();
          },
          child: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                "No",
                style:
                    TextStyles.bold(20.sp, fontColor: AppColors.redColorColor),
              ),
            ),
          ),
        ),
        Divider(
          color: AppColors.popUpTextFieldBlackColor,
          height: 1,
        ),
        InkWell(
          onTap: () {
            NavigatorRoute.navigateBack(context);
          },
          child: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                "Cancel",
                style: TextStyles.bold(20.sp, fontColor: AppColors.whiteColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class EventOrGeneralDialog extends StatelessWidget {
  final Function eventOnTap;
  final void Function() generalOnTap;
  final void Function() rescueOnTap;

  const EventOrGeneralDialog(
      {super.key,
      required this.eventOnTap,
      required this.generalOnTap,
      required this.rescueOnTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 40.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            'Which live you want?',
            textAlign: TextAlign.center,
            style: TextStyles.bold(22.sp,
                fontColor: AppColors.whiteColor,
                fontFamily: FontFamily.testTiemposHeadline),
          ),
        ),
        SizedBox(
          height: 25.h,
        ),
        Divider(
          color: AppColors.popUpTextFieldBlackColor,
        ),
        InkWell(
          onTap: () {
            eventOnTap.call();
          },
          child: SizedBox(
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                'Event Live',
                style: TextStyles.bold(18.sp, fontColor: AppColors.whiteColor),
              ),
            ),
          ),
        ),
        Divider(
          color: AppColors.popUpTextFieldBlackColor,
        ),
        InkWell(
          onTap: () {
            generalOnTap.call();
          },
          child: SizedBox(
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                "General Live",
                style: TextStyles.bold(18.sp, fontColor: AppColors.whiteColor),
              ),
            ),
          ),
        ),
        Divider(
          color: AppColors.popUpTextFieldBlackColor,
        ),
        InkWell(
          onTap: () {
            rescueOnTap.call();
          },
          child: SizedBox(
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                "Rescue",
                style: TextStyles.bold(18.sp, fontColor: AppColors.whiteColor),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }
}

class MicrophonePermissionDialog extends StatelessWidget {
  final Function onOpenSettings;
  final Function onCancel;

  const MicrophonePermissionDialog({
    super.key,
    required this.onOpenSettings,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 40.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            'Microphone Permission Required',
            textAlign: TextAlign.center,
            style: TextStyles.bold(
              22.sp,
              fontColor: AppColors.whiteColor,
              fontFamily: FontFamily.testTiemposHeadline,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Text(
            'Microphone permission is required to record audio. Please enable it in settings.',
            textAlign: TextAlign.center,
            style: TextStyles.bold(
              16.sp,
              fontColor: AppColors.whiteColor,
            ),
          ),
        ),
        SizedBox(height: 50.h),
        Divider(color: AppColors.popUpTextFieldBlackColor),
        InkWell(
          child: SizedBox(
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                'Open Settings',
                style: TextStyles.bold(
                  18.sp,
                  fontColor: AppColors.redColorColor,
                ),
              ),
            ),
          ),
          onTap: () => onOpenSettings.call(),
        ),
        Divider(color: AppColors.popUpTextFieldBlackColor),
        CupertinoButton(
          child: Text(
            'Cancel',
            style: TextStyles.bold(
              18.sp,
              fontColor: AppColors.whiteColor,
            ),
          ),
          onPressed: () => onCancel.call(),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}

class CameraPermissionDialog extends StatelessWidget {
  final Function onOpenSettings;
  final Function onCancel;

  const CameraPermissionDialog({
    super.key,
    required this.onOpenSettings,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 40.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            'Camera Permission Required',
            textAlign: TextAlign.center,
            style: TextStyles.bold(
              22.sp,
              fontColor: AppColors.whiteColor,
              fontFamily: FontFamily.testTiemposHeadline,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Text(
            'Camera permission is required to use this feature. Please enable it in settings.',
            textAlign: TextAlign.center,
            style: TextStyles.bold(
              16.sp,
              fontColor: AppColors.whiteColor,
            ),
          ),
        ),
        SizedBox(height: 50.h),
        Divider(color: AppColors.popUpTextFieldBlackColor),
        InkWell(
          child: SizedBox(
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                'Open Settings',
                style: TextStyles.bold(
                  18.sp,
                  fontColor: AppColors.redColorColor,
                ),
              ),
            ),
          ),
          onTap: () => onOpenSettings.call(),
        ),
        Divider(color: AppColors.popUpTextFieldBlackColor),
        CupertinoButton(
          child: Text(
            'Cancel',
            style: TextStyles.bold(
              18.sp,
              fontColor: AppColors.whiteColor,
            ),
          ),
          onPressed: () => onCancel.call(),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}
