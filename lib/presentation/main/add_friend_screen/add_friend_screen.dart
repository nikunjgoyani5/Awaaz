import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/widget/common_app_bar.dart';
import 'package:eagle_eye/gen/assets.gen.dart';
import 'package:eagle_eye/presentation/main/add_friend_screen/friend_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/constant/app_constant.dart';
import '../../../core/theme/text_styles.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
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
      body: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        itemBuilder: (context, index) => FriendTileWidget(),
        separatorBuilder: (context, index) => Gap(10.h),
        itemCount: 5,
      ),
    );
  }
}
