import 'package:eagle_eye/core/widget/app_common_loader_screen.dart';
import 'package:eagle_eye/core/widget/common_app_bar.dart';
import 'package:eagle_eye/presentation/authentication/auth_screen/bloc/auth_screen_cubit.dart';
import 'package:eagle_eye/presentation/main/delete_account_screen/bloc/delete_account_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widget/common_button.dart';
import '../../../routes/app_navigation.dart';
import '../../../routes/app_routes.dart';

class AccountRemoveScreen extends StatelessWidget {
  const AccountRemoveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeleteAccountCubit, DeleteAccountState>(
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder: (context, state) {
        return AppCommonLoaderScreen(
          inAsyncCall: state.isLoading,
          child: Scaffold(
            appBar: AppCommonAppBar(
                title: 'Account Deactivated',
                centerTitle: true,
                leading: SizedBox
                    .shrink() /*IconButton(
                  onPressed: () {
                    context.read<AuthScreenCubit>().showLogInWithMobile();
                    NavigatorRoute.navigateToRemoveUntil(
                        context, AppRoutes.authScreen);
                  },
                  icon: Assets.icons.icBackArrowWhite.svg()),*/
                ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.all(20.sp),
              child: CommonButton(
                onPressed: () {
                  context.read<AuthScreenCubit>().showLogInWithMobile();
                  NavigatorRoute.navigateToRemoveUntil(
                      context, AppRoutes.authScreen);
                },
                widget: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Done',
                      style: TextStyles.semiBold(18.sp,
                          fontColor: AppColors.whiteColor),
                    ),
                  ],
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.only(left: 22.w, right: 22.w, top: 30.h),
              child: SingleChildScrollView(
                // controller: controller.scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thank you for using our app!',
                      style: TextStyles.bold(
                        24.sp,
                        fontColor: AppColors.whiteColor,
                      ),
                    ),
                    Gap(20.h),
                    Text(
                      'We’re sorry to see you go, but we respect your decision to delete your account. Your account deletion request has been successfully processed, and your account is now permanently deactivated.',
                      style: TextStyles.medium(
                        18.sp,
                        fontColor: AppColors.whiteColor,
                      ),
                    ),
                    Gap(35.h),
                    Text(
                      'If you ever decide to return, we’ll be here with new updates and features to make your experience even better. ',
                      style: TextStyles.medium(
                        18.sp,
                        fontColor: AppColors.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
