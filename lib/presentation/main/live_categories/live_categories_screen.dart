import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/constant/app_constant.dart' as font_family;
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/app_functions.dart';
import '../../../core/widget/common_bottom_sheet.dart';
import '../../../core/widget/common_button.dart';
import '../../../gen/assets.gen.dart';
import '../../../routes/app_navigation.dart';
import '../../../routes/app_routes.dart';
import '../send_alert/bloc/send_alert_cubit.dart';

class LiveCategoriesScreen extends StatefulWidget {
  const LiveCategoriesScreen({super.key});

  @override
  State<LiveCategoriesScreen> createState() => _LiveCategoriesScreenState();
}

class _LiveCategoriesScreenState extends State<LiveCategoriesScreen> {
  String selectedLiveType = "Events";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              children: [
                Gap(50.h),
                Center(
                  child: Text(
                    'Choose Live Category',
                    textAlign: TextAlign.center,
                    style: TextStyles.bold(32.sp,
                        fontColor: AppColors.whiteColor,
                        fontFamily: font_family.testTiemposHeadline),
                  ),
                ),
                Gap(5.h),
                Center(
                  child: Text(
                    'Select the type of live stream you\nwant to start',
                    textAlign: TextAlign.center,
                    style: TextStyles.medium(20.sp,
                        fontColor: AppColors.whiteColor,
                        fontFamily: font_family.robotoFont),
                  ),
                ),
                Gap(60.h),
                buildItem(
                    onTap: () {
                      selectedLiveType = "Events";
                      setState(() {});
                    },
                    leading: Assets.icons.truck.svg(
                        height: 24.h,
                        width: 24.w,
                        colorFilter: ColorFilter.mode(
                          AppColors.whiteColor,
                          BlendMode.srcIn,
                        )),
                    title: "Events",
                    subTitle:
                        "Live record incidents that take\nplace around you in real-time."),
                buildItem(
                    onTap: () {
                      selectedLiveType = "Rescue";
                      setState(() {});
                    },
                    leading: Assets.icons.rescue.svg(
                        height: 30.h,
                        width: 30.w,
                        colorFilter: ColorFilter.mode(
                          AppColors.whiteColor,
                          BlendMode.srcIn,
                        )),
                    title: "Rescue",
                    subTitle:
                        "Alert citizens in your surroundings\nfor lost person, animal, object."),
                buildItem(
                    onTap: () {
                      selectedLiveType = "General";
                      setState(() {});
                    },
                    leading: Assets.icons.bag.svg(
                        height: 24.h,
                        width: 24.w,
                        colorFilter: ColorFilter.mode(
                          AppColors.whiteColor,
                          BlendMode.srcIn,
                        )),
                    title: "General",
                    subTitle:
                        "Notify people around you about\nyour requirements. (Services,\nObject Requirements, Marketing)"),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonButton(
                color: AppColors.whiteColor,
                onPressed: () {
                  if (selectedLiveType == "Events") {
                    showAppBottomSheet(
                        context,
                        AppCommonBottomSheet(
                          isOpenWithGradient: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.gradientRed.withValues(alpha: 0.5),
                              AppColors.actionBtnBgColor,
                              AppColors.actionBtnBgColor,
                              AppColors.actionBtnBgColor
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          body: EventBottomSheet(onTapOk: () {
                            NavigatorRoute.navigateBack(context);
                            NavigatorRoute.navigateTo(
                                context, AppRoutes.goLive);
                          }),
                        ));
                  } else if (selectedLiveType == "Rescue") {
                    showAppBottomSheet(
                        context,
                        AppCommonBottomSheet(
                          isOpenWithGradient: true,
                          borderRadius: BorderRadius.circular(30),
                          body: RescueBottomSheet(onTapOk: () {
                            NavigatorRoute.navigateBack(context);
                            context.read<SendAlertCubit>().init();
                            NavigatorRoute.navigateTo(
                                context, AppRoutes.sendAlert);
                          }),
                        ));
                  } else if (selectedLiveType == "General") {
                    showAppBottomSheet(
                        context,
                        AppCommonBottomSheet(
                          isOpenWithGradient: true,
                          borderRadius: BorderRadius.circular(30),
                          body: GeneralBottomSheet(onTapOk: () {
                            NavigatorRoute.navigateBack(context);
                            NavigatorRoute.navigateTo(
                                context, AppRoutes.generalGoLive);
                          }),
                        ));
                  }
                },
                widget: Text(
                  'Start Live',
                  style: TextStyles.bold(18.sp,
                      fontColor: AppColors.blackColor,
                      fontFamily: font_family.robotoFont),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(
      {required Widget leading,
      required String title,
      required String subTitle,
      void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      customBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
            color: AppColors.actionBtnBgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: selectedLiveType == title
                    ? AppColors.whiteColor
                    : Colors.transparent,
                width: 1.5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                leading,
                SizedBox(width: 10.w),
                Text(
                  title,
                  style: TextStyles.semiBold(24.sp,
                      fontColor: AppColors.whiteColor,
                      fontFamily: font_family.testTiemposHeadline),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subTitle,
              textAlign: TextAlign.center,
              style: TextStyles.regular(18.sp,
                  fontColor: AppColors.whiteColor,
                  fontFamily: font_family.robotoFont),
            ),
          ],
        ),
      ),
    );
  }
}
