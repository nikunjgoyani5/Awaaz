import 'package:eagle_eye/core/constant/app_constant.dart';
import 'package:eagle_eye/core/utils/app_functions.dart';
import 'package:eagle_eye/core/widget/app_common_loader_screen.dart';
import 'package:eagle_eye/presentation/main/get_support_screen/bloc/get_support_cubit.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widget/common_app_bar.dart';
import '../../../core/widget/common_app_image_show.dart';
import '../../../core/widget/common_button.dart';
import '../../../core/widget/common_textfield.dart';

class AddSupportScreen extends StatelessWidget {
  const AddSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppCommonAppBar(
        title: 'Add Support',
        centerTitle: true,
      ),
      body: BlocBuilder<GetSupportCubit, GetSupportState>(
        buildWhen: (previous, current) =>
            previous.isLoading != current.isLoading,
        builder: (context, state) {
          return AppCommonLoaderScreen(
            inAsyncCall: state.isLoading,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  children: [
                    spaceH(25.h),
                    BlocBuilder<GetSupportCubit, GetSupportState>(
                      buildWhen: (previous, current) =>
                          previous.emailController != current.emailController,
                      builder: (context, state) {
                        return CommonMainTextField(
                          hintText: 'Enter email',
                          controller: state.emailController!,
                          radius: BorderRadius.circular(10.r),
                          labelText: 'Email',
                        );
                      },
                    ),
                    spaceH(15.h),
                    BlocBuilder<GetSupportCubit, GetSupportState>(
                      buildWhen: (previous, current) =>
                          previous.subjectController !=
                          current.subjectController,
                      builder: (context, state) {
                        return CommonMainTextField(
                          hintText: 'Enter subject',
                          controller: state.subjectController!,
                          radius: BorderRadius.circular(10.r),
                          labelText: 'Subject',
                        );
                      },
                    ),
                    spaceH(15.h),
                    BlocBuilder<GetSupportCubit, GetSupportState>(
                      buildWhen: (previous, current) =>
                          previous.descriptionController !=
                          current.descriptionController,
                      builder: (context, state) {
                        return CommonMainTextField(
                          height: 150.h,
                          hintText: 'Enter description',
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          controller: state.descriptionController!,
                          minLines: 1,
                          maxLines: 3,
                          radius: BorderRadius.circular(10.r),
                          labelText: 'Description',
                        );
                      },
                    ),
                    spaceH(15.h),
                    BlocBuilder<GetSupportCubit, GetSupportState>(
                      buildWhen: (previous, current) =>
                          previous.file != current.file,
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: () async {
                            await context
                                .read<GetSupportCubit>()
                                .onTapProfile(context);
                          },
                          child: Container(
                            height: 145.h,
                            decoration: BoxDecoration(
                                color: AppColors.actionBtnBgColor,
                                borderRadius: BorderRadius.circular(10.r)),
                            child: (state.file != null)
                                ? AppImageViewer.showFileImage(
                                    file: state.file!, boxFit: BoxFit.fill)
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_a_photo,
                                        color: AppColors.textHintGrayColor,
                                      ),
                                      spaceW(10.w),
                                      Text(
                                        'Add media',
                                        style: TextStyles.medium(20.sp,
                                            fontColor:
                                                AppColors.textHintGrayColor),
                                      )
                                    ],
                                  ),
                          ),
                        );
                      },
                    ),
                    spaceH(60.h),
                    CommonButton(
                      color: Colors.white,
                      widget: Text(
                        'Submit Request',
                        style: TextStyles.semiBold(19.sp,
                            fontColor: AppColors.blackColor),
                      ),
                      onPressed: () async {
                        FirebaseEvents.setFirebaseEvent(
                            'submit_support_request', {});
                        closeKeyboard();
                        await context
                            .read<GetSupportCubit>()
                            .validateField(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
