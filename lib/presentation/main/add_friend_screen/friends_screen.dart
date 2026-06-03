import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/theme/text_styles.dart';
import 'package:eagle_eye/core/utils/app_functions.dart';
import 'package:eagle_eye/core/widget/common_app_bar.dart';
import 'package:eagle_eye/gen/assets.gen.dart';
import 'package:eagle_eye/presentation/main/add_friend_screen/friend_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/constant/app_constant.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        title: Text(
          'Add Friends',
          style: TextStyles.semiBold(36.sp,
              fontFamily: testTiemposHeadline),
        ),
        centerTitle: true,
        titleSize: 26.sp,
        action: [
          CircleAvatar(
            radius: 25.r,
            backgroundColor: AppColors.actionBtnBgColor,
            child: IconButton(
              icon: Assets.icons.icSearchHome.svg(),
              onPressed: () {},
            ),
          ),
          Gap(20.w),
        ],
      ),
      body: GestureDetector(
        onTap: closeKeyboard,
        child: DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(10.h),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(5.sp),
                  height: 58.h,
                  width: 260.w,
                  decoration: BoxDecoration(
                      color: AppColors.actionBtnBgColor,
                      borderRadius: BorderRadius.circular(50.r)),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerHeight: 0,
                    labelStyle: TextStyles.semiBold(18.sp),
                    unselectedLabelStyle: TextStyles.regular(18.sp),
                    indicator: BoxDecoration(
                      color: AppColors.tabbarIndicatorColor,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    tabs: [
                      Center(child: Text('Request')),
                      Center(child: Text('Friends')),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ListView.separated(
                      padding: EdgeInsets.only(top: 20.h),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InviteFriendTileWidget();
                      },
                      separatorBuilder: (context, index) => Gap(10.h),
                      itemCount: 5,
                    ),
                    ListView.separated(
                      padding: EdgeInsets.only(top: 20.h),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InvitedMyFriendTileWidget();
                      },
                      separatorBuilder: (context, index) => Gap(10.h),
                      itemCount: 5,
                    ),
                  ],
                ),
              ),
              Gap(20.h),
            ],
          ),
        ),
      ),
    );
  }
}
