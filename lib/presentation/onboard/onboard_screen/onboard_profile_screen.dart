import 'dart:io';

import 'package:eagle_eye/core/constant/app_constant.dart';
import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/utils/app_functions.dart';
import 'package:eagle_eye/core/utils/app_prefrence.dart';
import 'package:eagle_eye/presentation/onboard/onboard_screen/bloc/onboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/text_styles.dart';
import '../../../core/widget/app_common_loader_screen.dart';
import '../../../core/widget/common_app_bar.dart';
import '../../../core/widget/common_button.dart';
import '../../../gen/assets.gen.dart';
import '../../../routes/app_navigation.dart';

class OnboardProfileScreen extends StatelessWidget {
  const OnboardProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppCommonAppBar(
        leading: IconButton(
            onPressed: () {
              NavigatorRoute.navigateBack(context);
            },
            icon: Assets.icons.icBackArrowWhite.svg()),
        title: '',
        action: [
          TextButton(
              onPressed: () async {
                context.read<OnboardCubit>().clearPhoto();
                await context
                    .read<OnboardCubit>()
                    .onTapProfile(context, skipProfilePhoto: true);
              },
              child: Text(
                'Skip',
                style:
                    TextStyles.medium(18.sp, fontColor: AppColors.whiteColor),
              ))
        ],
      ),
      body: BlocBuilder<OnboardCubit, OnboardState>(
        builder: (context, state) {
          return Stack(
            children: [
              AppCommonLoaderScreen(
                inAsyncCall: state.isLoading,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Center(
                    child: Column(
                      children: [
                        spaceH(50.h),
                        BlocBuilder<OnboardCubit, OnboardState>(
                          builder: (context, state) {
                            return Text(
                              'hi ${state.nameController!.text}',
                              style: TextStyles.bold(50.sp,
                                  fontFamily: testTiemposHeadline),
                            );
                          },
                        ),
                        spaceH(5.h),
                        Text(
                          'Are you in the photo?',
                          // 'Please upload your profile picture.',
                          textAlign: TextAlign.center,
                          style: TextStyles.semiBold(
                            28.sp,
                          ),
                        ),
                        spaceH(50.h),
                        // BlocBuilder<OnboardCubit, OnboardState>(
                        //     builder: (context, state) => GestureDetector(
                        //           onTap: () async {
                        //             await context
                        //                 .read<OnboardCubit>()
                        //                 .onTapCamara(context);
                        //           },
                        //           child: Container(
                        //             padding: EdgeInsets.all(12.r),
                        //             decoration: BoxDecoration(
                        //                 shape: BoxShape.circle,
                        //                 border: Border.all(
                        //                     color: state.profilePicture != null
                        //                         ? AppColors.lightGreenColor
                        //                         : AppColors
                        //                             .onboardTextFieldColor,
                        //                     width: 3)),
                        //             child: Container(
                        //               height: 380.h,
                        //               width: 380.h,
                        //               decoration: BoxDecoration(
                        //                   image: state.profilePicture == null
                        //                       ? null
                        //                       : DecorationImage(
                        //                           fit: BoxFit.cover,
                        //                           image: Image.file(
                        //                                   state.profilePicture!)
                        //                               .image),
                        //                   shape: BoxShape.circle,
                        //                   color:
                        //                       AppColors.onboardTextFieldColor,
                        //                   border: Border.all(
                        //                       color: state.profilePicture !=
                        //                               null
                        //                           ? Colors.transparent
                        //                           : AppColors.actionBtnBgColor,
                        //                       width: 2.sp)),
                        //               child: state.profilePicture != null
                        //                   ? null
                        //                   : Padding(
                        //                       padding: EdgeInsets.all(140.sp),
                        //                       child:
                        //                           Assets.icons.icCamera.svg(),
                        //                     ),
                        //             ),
                        //           ),
                        //         )),
                        BlocBuilder<OnboardCubit, OnboardState>(
                          buildWhen: (previous, current) =>
                              previous.profilePicture != current.profilePicture,
                          builder: (context, state) {
                            return state.profilePicture != null
                                ? Container(
                                    height: 380.h,
                                    width: 380.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppColors.greenColor,
                                          width: 4.sp),
                                    ),
                                    padding: EdgeInsets.all(12.h),
                                    child: Container(
                                      height: 340.h,
                                      width: 340.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: FileImage(
                                            File(state.profilePicture!.path),
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ) /*AppImageViewer.showFileImage(
                                      file: state.profilePicture!,
                                      boxFit: BoxFit.cover,
                                    ),*/
                                    )
                                : Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () async {
                                            await context
                                                .read<OnboardCubit>()
                                                .onTapCamara(context);
                                          },
                                          child: Container(
                                            height: 180.h,
                                            width: 180.h,
                                            decoration: BoxDecoration(
                                                color:
                                                    AppColors.actionBtnBgColor,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                    color: state.profilePicture !=
                                                            null
                                                        ? AppColors.whiteColor
                                                        : AppColors
                                                            .actionBtnBgColor,
                                                    width: 2.sp)),
                                            padding: EdgeInsets.all(10.sp),
                                            child: Padding(
                                              padding: const EdgeInsets.all(35),
                                              child:
                                                  Assets.icons.icCamera.svg(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      spaceW(20.h),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () async {
                                            await context
                                                .read<OnboardCubit>()
                                                .onTapGallery(context);
                                          },
                                          child: Container(
                                            height: 180.h,
                                            width: 180.h,
                                            decoration: BoxDecoration(
                                                color:
                                                    AppColors.actionBtnBgColor,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                    color: state.profilePicture !=
                                                            null
                                                        ? AppColors.whiteColor
                                                        : AppColors
                                                            .actionBtnBgColor,
                                                    width: 2.sp)),
                                            padding: EdgeInsets.all(10.sp),
                                            child: Padding(
                                              padding: const EdgeInsets.all(35),
                                              child: Assets
                                                  .icons.icAddImageGalary
                                                  .svg(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                          },
                        ),
                        spaceH(20.h),
                        BlocBuilder<OnboardCubit, OnboardState>(
                          builder: (context, state) => state.profilePicture !=
                                  null
                              ? IconButton(
                                  onPressed: () {
                                    context.read<OnboardCubit>().clearPhoto();
                                  },
                                  icon: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        color: AppColors.redColorColor,
                                      ),
                                      spaceW(20.h),
                                      Text(
                                        'Delete photo',
                                        style: TextStyles.medium(22.sp,
                                            fontColor: AppColors.redColorColor),
                                      )
                                    ],
                                  ))
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              BlocBuilder<OnboardCubit, OnboardState>(
                builder: (context, state) => Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: 50.h, left: 100.w, right: 100.w),
                    child: Row(
                      children: [
                        // GestureDetector(
                        //   onTap: () async {
                        //     await context
                        //         .read<OnboardCubit>()
                        //         .onTapGallery(context);
                        //   },
                        //   child: Container(
                        //     padding: EdgeInsets.all(15.r),
                        //     decoration: BoxDecoration(
                        //         shape: BoxShape.circle,
                        //         color: AppColors.onboardTextFieldColor),
                        //     child: Assets.icons.icAddImageGalary.svg(),
                        //   ),
                        // ),
                        // SizedBox(width: 10.w),
                        Expanded(
                          child: CommonButton(
                              color: state.profilePicture == null
                                  ? AppColors.buttonDisabledColor
                                  : Colors.white,
                              onPressed: state.profilePicture == null
                                  ? null
                                  : () async {
                                      if (PrefService.getBool(
                                          PrefService.appleLogin)) {
                                        await context
                                            .read<OnboardCubit>()
                                            .onTapProfile(context);
                                      } else {
                                        if (state.profilePicture != null) {
                                          // await MapUtils.requestLocationPermission(context);
                                          await context
                                              .read<OnboardCubit>()
                                              .onTapProfile(context);
                                        } else {
                                          AppFunctions.showToast(
                                              'Upload profile picture');
                                        }
                                      }
                                    },
                              widget: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: state.profilePicture == null
                                    ? AppColors.textHintGrayColor
                                    : Colors.black,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
