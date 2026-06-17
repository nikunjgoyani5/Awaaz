import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/widget/common_expantion_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CommentDailoge extends StatefulWidget {
  const CommentDailoge({super.key});

  @override
  State<CommentDailoge> createState() => _CommentDailogeState();
}

class _CommentDailogeState extends State<CommentDailoge> {
  GlobalKey key = GlobalKey();
  bool isOpenReply = false;
  ScrollController commentScrollController = ScrollController();

  Widget commentWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  radius: 20.r,
                  child: Image.asset(Assets.image.profilePic.path),
                ),
              ),
              Gap(10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Ruben Levin',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w500),
                        ),
                        Gap(5.w),
                        Text(
                          '30m',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: AppColors.grey909090,
                                  fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Text(
                      'I pray that the fire is extinguished quickly.',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.white, fontWeight: FontWeight.w100),
                      maxLines: 2,
                    ),
                    Gap(5.h),
                    Row(
                      children: [
                        Text(
                          '1,579 likes',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: AppColors.grey909090,
                                  fontWeight: FontWeight.w500),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Gap(10.w),
              const Spacer(),
              DropdownButtonHideUnderline(
                child: DropdownButton2<int>(
                  customButton: Assets.icons.icMenu.svg(),
                  buttonStyleData: ButtonStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                  ),
                  items: [
                    DropdownMenuItem<int>(
                      value: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "Delete",
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                  ),
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == 0) {}
                  },
                  dropdownStyleData: DropdownStyleData(
                    padding: EdgeInsets.zero,
                    maxHeight: 200.h,
                    width: 120.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.textFeildBorderColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha:0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    offset: const Offset(-80, -2),
                    elevation: 4,
                    useRootNavigator: true,
                    scrollbarTheme: ScrollbarThemeData(
                      thumbColor:
                          WidgetStateProperty.all(AppColors.borderColor),
                      radius: const Radius.circular(20),
                      thickness: WidgetStateProperty.all(4),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                  ),
                ),
              ),
              Gap(10.w),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 50.w, right: 10.w),
            child: CommonExpansionTile(
              initiallyOpenTile: isOpenReply,
              title: Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'View replies(1)',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.white, fontWeight: FontWeight.w500),
                      maxLines: 2,
                    ),
                    Gap(10.w),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 15.sp,
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
              childrenItems: List.generate(
                3,
                (index) => Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: commentReplayWidget(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget commentReplayWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20.r,
          child: Image.asset(Assets.image.rescueProfilePic.path),
        ),
        Gap(10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Ruben Levin',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: AppColors.white, fontWeight: FontWeight.w500),
                  ),
                  Gap(5.w),
                  Text(
                    '30m',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: AppColors.grey909090,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Text(
                'I pray that the fire is extinguished quickly.',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: AppColors.white, fontWeight: FontWeight.w100),
                maxLines: 2,
              ),
              Gap(5.h),
              Text(
                '1,579 likes',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: AppColors.grey909090, fontWeight: FontWeight.w500),
                maxLines: 2,
              ),
            ],
          ),
        ),
        Gap(10.w),
        const Spacer(),
        DropdownButtonHideUnderline(
          child: DropdownButton2<int>(
            customButton: Assets.icons.icMenu.svg(),
            buttonStyleData: ButtonStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.r),
              ),
            ),
            items: [
              DropdownMenuItem<int>(
                value: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    "Delete",
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                  ),
                ),
              ),
            ],
            onChanged: (value) {
              if (value == 0) {}
            },
            dropdownStyleData: DropdownStyleData(
              padding: EdgeInsets.zero,
              maxHeight: 200.h,
              width: 120.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.textFeildBorderColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              offset: const Offset(-80, -2),
              elevation: 4,
              useRootNavigator: true,
              scrollbarTheme: ScrollbarThemeData(
                thumbColor: WidgetStateProperty.all(AppColors.borderColor),
                radius: const Radius.circular(20),
                thickness: WidgetStateProperty.all(4),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            ),
          ),
        ),
        Gap(10.w),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      key: key,
      alignment: Alignment.topCenter,
      insetPadding: EdgeInsets.only(top: 40.h, bottom: 40.h),
      backgroundColor: AppColors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 1536
              ? MediaQuery.of(context).size.width * 0.30
              : MediaQuery.of(context).size.width > 1024
                  ? MediaQuery.of(context).size.width * 0.30
                  : MediaQuery.of(context).size.width > 600
                      ? MediaQuery.of(context).size.width * 0.2
                      : MediaQuery.of(context).size.width * 0.1,
        ),
        decoration: BoxDecoration(
          color: AppColors.borderColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  "Comments",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: AppColors.white, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    NavigatorRoute.navigateBack(context: context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            Gap(20.h),
            Expanded(
              child: Theme(
                data: ThemeData(
                  scrollbarTheme: ScrollbarThemeData(
                    trackColor: WidgetStateProperty.all(
                        AppColors.textFeildBorderColor.withValues(alpha:0.5)),
                    thumbColor: WidgetStateProperty.all(
                        AppColors.white.withValues(alpha:0.2)),
                  ),
                ),
                child: Scrollbar(
                  radius: const Radius.circular(0),
                  trackVisibility: true,
                  scrollbarOrientation: ScrollbarOrientation.right,
                  thumbVisibility: true,
                  interactive: true,
                  controller: commentScrollController,
                  child: ListView.separated(
                    controller: commentScrollController,
                    padding: EdgeInsets.only(top: 20.h, right: 20.w),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return commentWidget();
                    },
                    separatorBuilder: (context, index) => Gap(10.h),
                    itemCount: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
