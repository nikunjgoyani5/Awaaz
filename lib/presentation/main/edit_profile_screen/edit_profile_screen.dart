import 'package:eagle_eye/core/constant/app_constant.dart';
import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/utils/app_functions.dart';
import 'package:eagle_eye/core/widget/common_app_bar.dart';
import 'package:eagle_eye/core/widget/common_button.dart';
import 'package:eagle_eye/core/widget/common_textfield.dart';
import 'package:eagle_eye/presentation/main/edit_profile_screen/bloc/edit_profile_cubit.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/text_styles.dart';
import '../../../core/widget/app_common_loader_screen.dart';
import '../../../core/widget/app_network_image_loader.dart';
import '../../../gen/assets.gen.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppCommonAppBar(
        title: 'Edit Profile',
        centerTitle: true,
        action: [
          MediaQuery.of(context).viewInsets.bottom > 0
              ? TextButton(
                  onPressed: () async {
                    FirebaseEvents.setFirebaseEvent(
                        'click_save_profile_btn', {});
                    closeKeyboard();
                    await context
                        .read<EditProfileCubit>()
                        .validateField(context);
                  },
                  child: Text(
                    'Save',
                    style: TextStyles.medium(18.sp,
                        fontColor: AppColors.whiteColor),
                  ),
                )
              : SizedBox.shrink()
        ],
      ),
      body: BlocBuilder<EditProfileCubit, EditProfileState>(
        buildWhen: (previous, current) =>
            previous.isLoading != current.isLoading,
        builder: (context, state) {
          return AppCommonLoaderScreen(
            inAsyncCall: state.isLoading,
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      spaceH(60.h),
                      BlocBuilder<EditProfileCubit, EditProfileState>(
                        builder: (context, state) {
                          return GestureDetector(
                            onTap: () async {
                              await context
                                  .read<EditProfileCubit>()
                                  .onTapProfile(context);
                            },
                            child: Stack(
                              children: [
                                Container(
                                  height: 145.h,
                                  width: 145.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.actionBtnBgColor,
                                  ),
                                  child: (state.profilePicture != null)
                                      ? CircleAvatar(
                                          radius: 160.w,
                                          backgroundImage: FileImage(
                                            state.profilePicture!,
                                          ),
                                        )
                                      : (state.profilePictureUrl != null &&
                                              state.profilePictureUrl!
                                                  .isNotEmpty)
                                          ? AppNetworkImageLoader(
                                              url: state.profilePictureUrl!,
                                              boxFit: BoxFit.cover,
                                              borderRadius: 300.r,
                                            )
                                          : Assets.images.imgUserPlc.svg(),
                                ),
                                Positioned(
                                    top: 0,
                                    right: 0,
                                    child:
                                        Assets.icons.icCameraEditProfile.svg())
                              ],
                            ),
                          );
                        },
                      ),
                      spaceH(10.h),
                      BlocBuilder<EditProfileCubit, EditProfileState>(
                        buildWhen: (previous, current) =>
                            previous.profilePicture != current.profilePicture ||
                            previous.profilePictureUrl !=
                                current.profilePictureUrl,
                        builder: (context, state) {
                          final hasImage = state.profilePicture != null ||
                              (state.profilePictureUrl != null &&
                                  state.profilePictureUrl!.isNotEmpty);

                          return hasImage
                              ? IconButton(
                                  onPressed: () {
                                    context
                                        .read<EditProfileCubit>()
                                        .clearProfilePhoto(context);
                                  },
                                  icon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Assets.icons.icDeleteRed.svg(),
                                      Text(
                                        'Delete photo',
                                        style: TextStyles.semiBold(18.sp,
                                            fontColor: AppColors.redColorColor),
                                      )
                                    ],
                                  ))
                              : SizedBox();
                        },
                      ),
                      spaceH(30.h),
                      BlocBuilder<EditProfileCubit, EditProfileState>(
                        buildWhen: (previous, current) =>
                            previous.nameController != current.nameController,
                        builder: (context, state) {
                          return CommonMainTextField(
                            hintText: 'Enter Name',
                            controller: state.nameController!,
                            radius: BorderRadius.circular(10.r),
                            labelText: 'Name',
                          );
                        },
                      ),
                      spaceH(15.h),
                      BlocBuilder<EditProfileCubit, EditProfileState>(
                        buildWhen: (previous, current) =>
                            previous.userNameController !=
                            current.userNameController,
                        builder: (context, state) {
                          return CommonMainTextField(
                            hintText: 'Enter user name',
                            readOnly: true,
                            controller: state.userNameController!,
                            radius: BorderRadius.circular(10.r),
                            labelText: 'User name',
                          );
                        },
                      ),
                      spaceH(15.h),
                      BlocBuilder<EditProfileCubit, EditProfileState>(
                        buildWhen: (previous, current) =>
                            previous.dobNameController !=
                            current.dobNameController,
                        builder: (context, state) {
                          return CommonMainTextField(
                            onTap: () {
                              context
                                  .read<EditProfileCubit>()
                                  .onDobSelect(context);
                            },
                            readOnly: true,
                            hintText: 'Enter birthdate',
                            controller: state.dobNameController!,
                            radius: BorderRadius.circular(10.r),
                            labelText: 'Birthdate',
                            suffixIcon: Icon(Icons.calendar_month_outlined),
                          );
                        },
                      ),
                      spaceH(60.h),
                      CommonButton(
                        color: Colors.white,
                        widget: Text(
                          'SAVE',
                          style: TextStyles.semiBold(19.sp,
                              fontColor: AppColors.blackColor),
                        ),
                        onPressed: () async {
                          FirebaseEvents.setFirebaseEvent(
                              'click_save_profile_btn', {});
                          await context
                              .read<EditProfileCubit>()
                              .validateField(context);
                        },
                      ),
                      spaceH(20.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
