import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/theme/text_styles.dart';
import 'package:eagle_eye/core/widget/app_custom_loader.dart';
import 'package:eagle_eye/core/widget/common_app_bar.dart';
import 'package:eagle_eye/core/widget/common_button.dart';
import 'package:eagle_eye/core/widget/common_textfield.dart';
import 'package:eagle_eye/gen/assets.gen.dart';
import 'package:eagle_eye/presentation/authentication/change_password_screen/bloc/change_password_screen_cubit.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../core/constant/app_constant.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  void initState() {
    FirebaseEvents.setFirebaseEvent('change_password_screen', {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state.isLoading,
          progressIndicator: AppCustomLoader(),
          child: Scaffold(
            appBar: HomeAppBar(
              title: Text(
                "Change Password",
                style:
                    TextStyles.semiBold(30.sp, fontFamily: testTiemposHeadline),
              ),
              centerTitle: true,
              titleSize: 26.sp,
              action: [],
            ),
            floatingActionButton: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w) +
                  EdgeInsets.only(bottom: 20.h),
              child: CommonButton(
                color: AppColors.whiteColor,
                onPressed: () {
                  FirebaseEvents.setFirebaseEvent(
                      'click_change_password_btn', {});
                  context
                      .read<ChangePasswordCubit>()
                      .onSubmitChangePassword(context);
                },
                widget: Text(
                  'Change Password',
                  style: TextStyles.bold(
                    18.sp,
                    fontColor: AppColors.blackColor,
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Form(
                  key: state.resetPasswordKey,
                  child: Column(
                    children: [
                      Gap(20.h),
                      CommonMainTextField(
                        hintText: "Old Password",
                        controller: state.oldPasswordController!,
                        maxLines: 1,
                        labelText: "Old Password",
                        obscureText: state.isShowOldPassword,
                        fillColor: AppColors.actionBtnBgColor,
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return 'Please enter old password';
                          }
                          return null;
                        },
                        suffixIcon: InkWell(
                          onTap: () => context
                              .read<ChangePasswordCubit>()
                              .onShowOldPassword(),
                          child: SizedBox(
                            height: 18.sp,
                            width: 18.sp,
                            child: Center(
                                child: (state.isShowOldPassword == false)
                                    ? Assets.icons.icEyeOff
                                        .svg(height: 25.sp, width: 25.sp)
                                    : Assets.icons.icEye
                                        .svg(height: 25.sp, width: 25.sp)),
                          ),
                        ),
                      ),
                      Gap(20.h),
                      CommonMainTextField(
                        hintText: "New Password",
                        controller: state.newPasswordController!,
                        maxLines: 1,
                        labelText: "New Password",
                        obscureText: state.isShowPassword,
                        fillColor: AppColors.actionBtnBgColor,
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return 'Please enter new password';
                          }
                          return null;
                        },
                        suffixIcon: InkWell(
                          onTap: () => context
                              .read<ChangePasswordCubit>()
                              .onShowNewPassword(),
                          child: SizedBox(
                            height: 18.sp,
                            width: 18.sp,
                            child: Center(
                                child: (state.isShowPassword == false)
                                    ? Assets.icons.icEyeOff
                                        .svg(height: 25.sp, width: 25.sp)
                                    : Assets.icons.icEye
                                        .svg(height: 25.sp, width: 25.sp)),
                          ),
                        ),
                      ),
                      Gap(20.h),
                      CommonMainTextField(
                        hintText: "Confirm New Password",
                        controller: state.confirmPasswordController!,
                        maxLines: 1,
                        labelText: "Confirm New Password",
                        fillColor: AppColors.actionBtnBgColor,
                        obscureText: state.isShowConfirmPassword,
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return "Please enter confirm password";
                          }
                          if (p0 != state.newPasswordController?.text) {
                            return "Password doesn't match";
                          }
                          return null;
                        },
                        suffixIcon: InkWell(
                          onTap: () => context
                              .read<ChangePasswordCubit>()
                              .onShowConfirmNewPassword(),
                          child: SizedBox(
                            height: 18.sp,
                            width: 18.sp,
                            child: Center(
                                child: (state.isShowConfirmPassword == false)
                                    ? Assets.icons.icEyeOff
                                        .svg(height: 25.sp, width: 25.sp)
                                    : Assets.icons.icEye
                                        .svg(height: 25.sp, width: 25.sp)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
