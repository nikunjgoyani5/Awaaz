import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:eagle_eye/core/constant/app_constant.dart';
import 'package:eagle_eye/core/widget/common_app_bar.dart';
import 'package:eagle_eye/core/widget/common_app_image_show.dart';
import 'package:eagle_eye/presentation/main/send_alert/bloc/send_alert_cubit.dart';
import 'package:eagle_eye/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widget/app_common_loader_screen.dart';
import '../../../core/widget/common_button.dart';
import '../../../core/widget/common_textfield.dart';
import '../../../gen/assets.gen.dart';
import '../../../routes/app_navigation.dart';

class SendAlert extends StatelessWidget {
  const SendAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppCommonAppBar(
        title: 'Send Alerts',
        centerTitle: true,
      ),
      body: BlocBuilder<SendAlertCubit, SendAlertState>(
        builder: (context, state) {
          return AppCommonLoaderScreen(
            inAsyncCall: false,
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      spaceH(60.h),
                      /*        BlocBuilder<SendAlertCubit, SendAlertState>(
                        builder: (context, state) {
                          return Container(
                            height: 140.h,
                            width: 130.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: AppColors.actionBtnBgColor,
                            ),
                            child: state.videoThumbnailImageFile != null
                                ? Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        child:  AppImageViewer.showFileImage(
                                          file:  state.videoThumbnailImageFile!,
                                          boxFit: BoxFit.cover,
                                        )
                                      ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: IconButton(
                                          onPressed: () {
                                            context
                                                .read<SendAlertCubit>()
                                                .clearVideo();
                                          },
                                          icon: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 20.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Icon(
                                    Icons.video_library,
                                    size: 50.sp,
                                    color: Colors.white,
                                  ),
                          );
                        },
                      ),
                      spaceH(15.h),*/

                      BlocBuilder<SendAlertCubit, SendAlertState>(
                        builder: (context, state) {
                          return Container(
                            height: 140.h,
                            width: 130.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: AppColors.actionBtnBgColor,
                            ),
                            child: (state.profilePicture != null)
                                ? SizedBox(
                                    height: 140.h,
                                    width: 130.w,
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        child: AppImageViewer.showFileImage(
                                          file: state.profilePicture!,
                                          boxFit: BoxFit.cover,
                                        )))
                                : Padding(
                                    padding: const EdgeInsets.all(40.0),
                                    child: Assets.icons.icCamera.svg(),
                                  ),
                          );
                        },
                      ),
                      spaceH(20.h),
                      Text(
                        'Upload image/video',
                        style: TextStyles.semiBold(
                          20.sp,
                        ),
                      ),
                      Text(
                        'Size should be below 50 MB',
                        style: TextStyles.bold(16.sp,
                            fontColor: AppColors.textHintGrayColor),
                      ),
                      spaceH(15.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context
                                  .read<SendAlertCubit>()
                                  .onTapProfile(context);
                            },
                            child: Container(
                              width: 130.h,
                              height: 50.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                Color(0xff1FA9FF),
                                Color(0xff1C7EFF),
                              ])),
                              child: Text(
                                'Upload Image',
                                style: TextStyles.bold(
                                  16.sp,
                                ),
                              ),
                            ),
                          ),
                          spaceW(10.w),
                          Text(
                            'Or',
                            style: TextStyles.semiBold(
                              20.sp,
                            ),
                          ),
                          spaceW(10.w),
                          GestureDetector(
                            onTap: () {
                              context
                                  .read<SendAlertCubit>()
                                  .onTapVideo(context);
                            },
                            child: Container(
                              width: 130.h,
                              height: 50.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color(0xff1FA9FF),
                                  Color(0xff1C7EFF),
                                ]),
                              ),
                              child: Text(
                                'Upload Video',
                                style: TextStyles.bold(16.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (state.profilePicture != null) ...[
                        spaceH(15.h),
                        IconButton(
                            onPressed: () {
                              context
                                  .read<SendAlertCubit>()
                                  .clearProfilePhoto();
                            },
                            icon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Assets.icons.icDeleteRed.svg(),
                                Text(
                                  'Delete Photo/Video',
                                  style: TextStyles.semiBold(14.sp,
                                      fontColor: AppColors.redColorColor),
                                )
                              ],
                            )),
                      ],
                      spaceH(30.h),
                      BlocBuilder<SendAlertCubit, SendAlertState>(
                        buildWhen: (previous, current) =>
                            previous.fullNameController !=
                            current.fullNameController,
                        builder: (context, state) {
                          return CommonMainTextField(
                            hintText: 'Enter Name',
                            controller: state.fullNameController!,
                            radius: BorderRadius.circular(10.r),
                            labelText: 'Name',
                          );
                        },
                      ),
                      spaceH(15.h),
                      BlocBuilder<SendAlertCubit, SendAlertState>(
                        buildWhen: (previous, current) =>
                            previous.locationController !=
                            current.locationController,
                        builder: (context, state) {
                          return CommonMainTextField(
                            maxLines: 2,
                            hintText: 'Location',
                            readOnly: true,
                            onTap: () {
                              NavigatorRoute.navigateTo(
                                  context, AppRoutes.searchLocation);
                            },
                            suffixIcon: Icon(
                              Icons.location_on,
                              color: AppColors.whiteColor,
                            ),
                            controller: state.locationController!,
                            radius: BorderRadius.circular(10.r),
                            labelText: 'Location',
                          );
                        },
                      ),
                      spaceH(15.h),
                      BlocBuilder<SendAlertCubit, SendAlertState>(
                        buildWhen: (previous, current) =>
                            previous.descriptionController !=
                            current.descriptionController,
                        builder: (context, state) {
                          return CommonMainTextField(
                            maxLines: 4,
                            minLines: 1,
                            hintText: 'Enter event description',
                            controller: state.descriptionController!,
                            radius: BorderRadius.circular(10.r),
                            labelText: 'Enter description',
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                          );
                        },
                      ),
                      spaceH(15.h),
                      BlocBuilder<SendAlertCubit, SendAlertState>(
                        buildWhen: (previous, current) =>
                            previous.dateTimeController !=
                            current.dateTimeController,
                        builder: (context, state) {
                          return CommonMainTextField(
                            hintText: 'Select Date & Time',
                            onTap: () {
                              context
                                  .read<SendAlertCubit>()
                                  .onDobSelect(context);
                            },
                            readOnly: true,
                            controller: state.dateTimeController!,
                            radius: BorderRadius.circular(10.r),
                            labelText: 'Date & Time',
                          );
                        },
                      ),
                      spaceH(15.h),
                      BlocBuilder<SendAlertCubit, SendAlertState>(
                        buildWhen: (previous, current) =>
                            previous.phoneNumberController !=
                            current.phoneNumberController,
                        builder: (context, state) {
                          return CommonMainTextField(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            prefixIcon: SizedBox(
                              height: 50,
                              width: 80,
                              child: CountryCodePicker(
                                onChanged: (code) {
                                  if (code.dialCode != null &&
                                      code.dialCode!.isNotEmpty) {
                                    log(code.dialCode.toString());
                                    context
                                        .read<SendAlertCubit>()
                                        .getPhoneCode(code.dialCode ?? '');
                                  }
                                },
                                showDropDownButton: true,
                                dialogBackgroundColor: Colors.black,
                                initialSelection: 'IN',
                                showFlag: false,
                                padding: EdgeInsets.zero,
                                textStyle: TextStyles.medium(16.sp,
                                    fontColor: Colors.grey),
                              ),
                            ),
                            hintText: 'Enter phone number',
                            controller: state.phoneNumberController!,
                            keyboardType: TextInputType.phone,
                            radius: BorderRadius.circular(10.r),
                            labelText: 'Phone Number',
                          );
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      spaceH(40.h),
                      CommonButton(
                        color: Colors.white,
                        widget: state.isLoading
                            ? SizedBox(
                                height: 20.0,
                                width: 20.0,
                                child: CircularProgressIndicator(
                                  color: AppColors.blackColor,
                                ),
                              )
                            : Text(
                                'POST',
                                style: TextStyles.semiBold(19.sp,
                                    fontColor: AppColors.blackColor),
                              ),
                        onPressed: () async {
                          await context
                              .read<SendAlertCubit>()
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
