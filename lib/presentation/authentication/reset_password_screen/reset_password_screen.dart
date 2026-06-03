import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/theme/text_styles.dart';
import 'package:eagle_eye/core/widget/app_custom_loader.dart';
import 'package:eagle_eye/core/widget/common_app_bar.dart';
import 'package:eagle_eye/core/widget/common_button.dart';
import 'package:eagle_eye/core/widget/common_textfield.dart';
import 'package:eagle_eye/gen/assets.gen.dart';
import 'package:eagle_eye/presentation/authentication/reset_password_screen/bloc/reset_password_screen_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../core/constant/app_constant.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? email;
  const ResetPasswordScreen({super.key, this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state.isLoading,
          progressIndicator: AppCustomLoader(),
          child: Scaffold(
            appBar: HomeAppBar(
              title:  Text(
                "Reset Password",
                style: TextStyles.semiBold(36.sp,
                    fontFamily: testTiemposHeadline),
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
                  context
                      .read<ResetPasswordCubit>()
                      .onSubmitResetPassword(context, widget.email ?? "");
                },
                widget: Text(
                  'Reset Password',
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
                              .read<ResetPasswordCubit>()
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
                            return "Confirm new password is not matches";
                          }
                          return null;
                        },
                        suffixIcon: InkWell(
                          onTap: () => context
                              .read<ResetPasswordCubit>()
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
