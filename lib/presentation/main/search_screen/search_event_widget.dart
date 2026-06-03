import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/theme/text_styles.dart';
import 'package:eagle_eye/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class RecentSearchWidget extends StatelessWidget {
  const RecentSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 95.h,
      contentPadding: EdgeInsets.zero,
      shape: Border(
        bottom: BorderSide(
          color: AppColors.actionBtnBgColor.withValues(alpha:0.6),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28.r,
            backgroundColor: AppColors.actionBtnBgColor,
            child: Assets.icons.icLocation.svg(
              height: 25,
              colorFilter: const ColorFilter.mode(
                AppColors.whiteColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          Gap(10.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mumbai',
                  style: TextStyles.medium(16.sp),
                ),
                Text(
                  'Maharastra',
                  style: TextStyles.regular(14.sp,
                      fontColor: AppColors.textHintGrayColor),
                )
              ],
            ),
          ),
          Gap(10.w),
        ],
      ),
      trailing: IconButton(
          onPressed: () {},
          icon: Assets.icons.icDeleteRed.svg(
              colorFilter: const ColorFilter.mode(
            AppColors.textHintGrayColor,
            BlendMode.srcIn,
          ))),
    );
  }
}

class SearchEventWidget extends StatelessWidget {
  const SearchEventWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 95.h,
      contentPadding: EdgeInsets.zero,
      shape: Border(
        bottom: BorderSide(
          color: AppColors.actionBtnBgColor.withValues(alpha:0.6),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28.r,
            backgroundColor: AppColors.actionBtnBgColor,
            child: Assets.icons.icLocation.svg(
              height: 25,
              colorFilter: const ColorFilter.mode(
                AppColors.whiteColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          Gap(10.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mumbai',
                  style: TextStyles.medium(16.sp),
                ),
                Text(
                  'Amsterbilt Avenue, New York,Ny, U...',
                  style: TextStyles.regular(14.sp,
                      fontColor: AppColors.textHintGrayColor),
                )
              ],
            ),
          ),
          Gap(10.w),
        ],
      ),
    );
  }
}
