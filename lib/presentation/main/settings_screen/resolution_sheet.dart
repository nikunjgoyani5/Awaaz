import 'package:eagle_eye/core/utils/app_functions.dart';
import 'package:eagle_eye/core/utils/app_prefrence.dart';
import 'package:eagle_eye/core/widget/common_button.dart';
import 'package:eagle_eye/routes/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/constant/app_constant.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../gen/assets.gen.dart';

class ResolutionSheet extends StatefulWidget {
  const ResolutionSheet({super.key});

  @override
  State<ResolutionSheet> createState() => _ResolutionSheetState();
}

class _ResolutionSheetState extends State<ResolutionSheet> {
  int selectedVideoIndex = 0;
  int selectedStampIndex = 0;

  @override
  void initState() {
    selectedVideoIndex = PrefService.getInt(PrefService.videoQualityIndex);
    selectedStampIndex = PrefService.getInt(PrefService.addressStampIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14.r),
          topRight: Radius.circular(14.r),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.close,
                  color: Colors.transparent,
                ),
                color: Colors.transparent,
              ),
              Text(
                'Post Download',
                style: TextStyles.bold(30.sp,
                    fontColor: AppColors.whiteColor,
                    fontFamily: testTiemposHeadline),
              ),
              IconButton(
                onPressed: () {
                  NavigatorRoute.navigateBack(context);
                },
                icon: Icon(Icons.close),
                color: AppColors.whiteColor,
              ),
            ],
          ),
          Gap(30.h),
          /*Row(
            children: [
              Assets.icons.icResolution.svg(
                height: 25.sp,
                width: 25.sp,
                fit: BoxFit.scaleDown,
                colorFilter: ColorFilter.mode(
                  AppColors.blackColor,
                  BlendMode.srcIn,
                ),
              ),
              Gap(14.w),
              Text(
                'Video',
                style: TextStyles.regular(24.sp,
                    fontFamily: robotoFont, fontColor: AppColors.blackColor),
              ),
            ],
          ),
          Gap(20.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                3,
                (index) {
                  return InkWell(
                    onTap: () {
                      selectedVideoIndex = index;
                      setState(() {});
                    },
                    child: Container(
                      height: 55.h,
                      width: 125.w,
                      margin: EdgeInsets.only(
                          left: (index == 0) ? 0.w : 10.w,
                          right: (index == 2) ? 0.w : 10.w),
                      decoration: BoxDecoration(
                        color: (selectedVideoIndex == index)
                            ? AppColors.blackColor
                            : AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: Text(
                          (index == 0)
                              ? '360P'
                              : (index == 1)
                                  ? '480P'
                                  : '720P',
                          style: TextStyles.medium(
                            20.sp,
                            fontColor: (selectedVideoIndex == index)
                                ? AppColors.whiteColor
                                : AppColors.blackColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Gap(30.h),*/
          Row(
            children: [
              Assets.icons.icStamp.svg(
                height: 25.sp,
                width: 25.sp,
                fit: BoxFit.scaleDown,
                colorFilter: ColorFilter.mode(
                  AppColors.whiteColor,
                  BlendMode.srcIn,
                ),
              ),
              Gap(14.w),
              Text(
                'Select Stamp',
                style: TextStyles.regular(24.sp,
                    fontFamily: robotoFont, fontColor: AppColors.whiteColor),
              ),
            ],
          ),
          Gap(20.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                4,
                (index) {
                  return GestureDetector(
                    onTap: () {
                      selectedStampIndex = index;
                      setState(() {});
                    },
                    child: Container(
                      height: 150.w,
                      width: 150.w,
                      margin: EdgeInsets.only(
                          left: (index == 0) ? 0.w : 10.w,
                          right: (index == 3) ? 0.w : 10.w),
                      padding: EdgeInsets.only(left: 8.w, top: 8.w, right: 8.w),
                      decoration: BoxDecoration(
                        color: AppColors.blackColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                (selectedStampIndex == index)
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                                color: AppColors.whiteColor,
                              ),
                            ],
                          ),
                          Gap(10.h),
                          (index == 0)
                              ? Assets.icons.icStamp1.image()
                              : (index == 1)
                                  ? Assets.icons.icStamp2.image()
                                  : (index == 2)
                                      ? Assets.icons.icStamp3.image()
                                      : Container(
                                          alignment: Alignment.center,
                                          child: Assets.images.noEntry.image(
                                              height: 50.h,
                                              color: AppColors.whiteColor
                                                  .withValues(alpha: 0.7)),
                                        ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Gap(30.h),
          CommonButton(
            color: AppColors.commentTextFieldColor,
            onPressed: () {
              PrefService.setValue(
                  PrefService.videoQualityIndex, selectedVideoIndex);
              PrefService.setValue(
                  PrefService.addressStampIndex, selectedStampIndex);
              NavigatorRoute.navigateBack(context);
              AppFunctions.showToast('Post download updated');
            },
            widget: Text(
              'Update',
              style:
                  TextStyles.semiBold(22.sp, fontColor: AppColors.whiteColor),
            ),
          ),
          Gap(20.h),
        ],
      ),
    );
  }
}
