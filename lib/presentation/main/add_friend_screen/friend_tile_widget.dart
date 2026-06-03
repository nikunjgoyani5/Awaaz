import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/theme/text_styles.dart';
import 'package:eagle_eye/core/utils/app_functions.dart';
import 'package:eagle_eye/core/widget/common_button.dart';
import 'package:eagle_eye/gen/assets.gen.dart';
import 'package:eagle_eye/presentation/main/blocked_users/bloc/blocked_users_cubit.dart';
import 'package:eagle_eye/routes/app_navigation.dart';
import 'package:eagle_eye/routes/app_routes.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/widget/app_network_image_loader.dart';
import '../../../data/models/blocked_user_model.dart';
import '../user_profile_screen/bloc/user_profile_cubit.dart';

class FriendTileWidget extends StatelessWidget {
  const FriendTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              context.read<UserProfileCubit>().getUserId(
                    'userId',
                  );
              NavigatorRoute.navigateTo(context, AppRoutes.userProfile);
            },
            child: CircleAvatar(
              radius: 30.r,
              backgroundColor: AppColors.actionBtnBgColor,
              child: Image.asset(
                Assets.images.profile.path,
              ),
            ),
          ),
          Gap(15.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cristofer Aminoff',
                  style: TextStyles.semiBold(16.sp),
                ),
                Gap(2.h),
                Text(
                  '+91 991585965X',
                  style: TextStyles.medium(15.sp,
                      fontColor: AppColors.textHintGrayColor),
                ),
              ],
            ),
          ),
          Gap(10.w),
          CommonButton(
              height: 40.h,
              width: 100.w,
              onPressed: () {
                NavigatorRoute.navigateTo(context, AppRoutes.friend);
              },
              color: AppColors.whiteColor,
              widget: Text(
                'Invite',
                style: TextStyles.bold(18.sp, fontColor: AppColors.blackColor),
              ))
        ],
      ),
    );
  }
}

class InviteFriendTileWidget extends StatelessWidget {
  const InviteFriendTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: AppColors.actionBtnBgColor,
            child: Image.asset(
              Assets.images.profile.path,
            ),
          ),
          Gap(15.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cristofer Aminoff',
                  style: TextStyles.semiBold(16.sp),
                ),
                Gap(2.h),
                Text(
                  '+91 991585965X',
                  style: TextStyles.medium(15.sp,
                      fontColor: AppColors.textHintGrayColor),
                ),
              ],
            ),
          ),
          Gap(10.w),
          CircleAvatar(
            radius: 25.r,
            backgroundColor: AppColors.whiteColor,
            child: IconButton(
              icon: Assets.icons.icCheck.svg(),
              onPressed: () {},
            ),
          ),
          Gap(10.w),
          CircleAvatar(
            radius: 25.r,
            backgroundColor: AppColors.actionBtnBgColor,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: AppColors.whiteColor,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class InvitedMyFriendTileWidget extends StatelessWidget {
  const InvitedMyFriendTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: AppColors.actionBtnBgColor,
            child: Image.asset(
              Assets.images.profile.path,
            ),
          ),
          Gap(15.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cristofer Aminoff',
                  style: TextStyles.semiBold(16.sp),
                ),
                Gap(2.h),
                Text(
                  '+91 991585965X',
                  style: TextStyles.medium(15.sp,
                      fontColor: AppColors.textHintGrayColor),
                ),
              ],
            ),
          ),
          PopupMenuButton(
            splashRadius: 0,
            constraints:
                BoxConstraints(maxWidth: 90.w, maxHeight: 45.h, minWidth: 80.w),
            menuPadding: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            shadowColor: const Color(0xff000000).withValues(alpha: 0.2),
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(
                    color: const Color(0xff000000).withValues(alpha: 0.1))),
            offset: const Offset(0, 36),
            color: AppColors.actionBtnBgColor,
            child: CircleAvatar(
              radius: 20.r,
              backgroundColor: AppColors.actionBtnBgColor,
              child: Assets.icons.icMenu.svg(),
            ),
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  height: 40.h,
                  padding: EdgeInsets.zero,
                  value: 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Remove",
                      style: TextStyles.semiBold(16.sp),
                    ),
                  ),
                ),
              ];
            },
            onSelected: (value) {},
          ),
        ],
      ),
    );
  }
}

class BlockedUserTileWidget extends StatefulWidget {
  final BlockedUserData blockedUserData;

  const BlockedUserTileWidget({
    super.key,
    required this.blockedUserData,
  });

  @override
  State<BlockedUserTileWidget> createState() => _BlockedUserTileWidgetState();
}

class _BlockedUserTileWidgetState extends State<BlockedUserTileWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      child: Row(
        children: [
          SizedBox(
            height: 55,
            width: 55,
            child: AppNetworkImageLoader(
              url: widget.blockedUserData.profilePicture ?? '',
              boxFit: BoxFit.cover,
              placeHolderIMAGE: Assets.images.imgUserPlc,
              borderRadius: 300.r,
            ),
          ),
          Gap(15.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.blockedUserData.name ?? 'User',
                  style: TextStyles.semiBold(16.sp),
                ),
                Gap(2.h),
                Text(
                  widget.blockedUserData.email ?? '',
                  style: TextStyles.medium(15.sp,
                      fontColor: AppColors.textHintGrayColor),
                ),
              ],
            ),
          ),
          Gap(10.w),
          BlocBuilder<BlockedUsersCubit, BlockedUsersState>(
              builder: (context, state) {
            return CommonButton(
                height: 40.h,
                width: 100.w,
                onPressed: () async {
                  FirebaseEvents.setFirebaseEvent('click_unblock_user', {});
                  await context
                      .read<UserProfileCubit>()
                      .blockUser(uid: widget.blockedUserData.id,context: context);

                  // Refresh blocked users list
                  await context.read<BlockedUsersCubit>().getBlockedUserList();

                  // Show feedback to user
                  AppFunctions.showToast('User unblocked successfully');
                },
                color: AppColors.actionBtnBgColor,
                widget: Text(
                  'Unblock',
                  style: TextStyles.bold(18.sp,
                      fontColor: AppColors.textWhiteColor),
                ));
          })
        ],
      ),
    );
  }
}
