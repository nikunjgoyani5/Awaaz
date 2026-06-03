import 'package:eagle_eye/core/constant/app_assets.dart';
import 'package:eagle_eye/core/widget/common_app_image_show.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widget/app_common_loader_screen.dart';
import '../../../core/widget/common_app_bar.dart';
import '../../../core/widget/common_button.dart';
import '../../../gen/assets.gen.dart';
import 'bloc/delete_account_cubit.dart';

class DeleteAccountView extends StatefulWidget {
  const DeleteAccountView({super.key});

  @override
  State<DeleteAccountView> createState() => _DeleteAccountViewState();
}

class _DeleteAccountViewState extends State<DeleteAccountView> {
  @override
  void initState() {
    FirebaseEvents.setFirebaseEvent('delete_account_screen', {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeleteAccountCubit, DeleteAccountState>(
        buildWhen: (previous, current) {
      return previous.isLoading != current.isLoading;
    }, builder: (context, state) {
      return AppCommonLoaderScreen(
        inAsyncCall: state.isLoading,
        child: Scaffold(
          appBar: AppCommonAppBar(
            title: 'Are you sure?',
            centerTitle: true,
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.all(20.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 123.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColors.popUpTextFieldBlackColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(
                        text: '',
                        children: <InlineSpan>[
                          TextSpan(
                            text:
                                'Once you confirm, all of your account\ndata will be ',
                            style: TextStyles.semiBold(
                              18.sp,
                              fontColor: AppColors.whiteColor,
                            ),
                          ),
                          TextSpan(
                            text: 'Permanently deleted',
                            style: TextStyles.semiBold(
                              18.sp,
                              fontColor: AppColors.redColor,
                            ),
                          ),
                          TextSpan(
                            text: ' and all\nprogress you made will be lost',
                            style: TextStyles.semiBold(
                              18.sp,
                              fontColor: AppColors.whiteColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Gap(22.h),
                CommonButton(
                  onPressed: () {
                    FirebaseEvents.setFirebaseEvent('click_delete_btn', {});
                    context
                        .read<DeleteAccountCubit>()
                        .deleteUserAccount(context);
                  },
                  color: AppColors.redColor,
                  widget: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Assets.icons.icDeleteWhite.svg(),
                      Gap(10.w),
                      Text(
                        'Delete',
                        style: TextStyles.semiBold(18.sp,
                            fontColor: AppColors.whiteColor),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppImageViewer.showAssetImage(path: AppImageAsset.appIcon),
                  Spacer(),
                  Text(
                    'We’re sad to see you go!',
                    style: TextStyles.semiBold(
                      24.sp,
                      fontColor: AppColors.whiteColor,
                    ),
                  ),
                  Gap(14.h),
                  Text(
                    'Are you sure you don’t want to reconsider?\nDid we do something wrong?',
                    textAlign: TextAlign.center,
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
    });
  }
}
