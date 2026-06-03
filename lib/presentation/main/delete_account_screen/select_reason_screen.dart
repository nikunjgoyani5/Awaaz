import 'package:eagle_eye/core/widget/app_check_box.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/app_functions.dart';
import '../../../core/widget/common_app_bar.dart';
import '../../../core/widget/common_button.dart';
import '../../../core/widget/common_textfield.dart';
import '../../../routes/app_navigation.dart';
import '../../../routes/app_routes.dart';

class SelectReasonScreen extends StatefulWidget {
  const SelectReasonScreen({super.key});

  @override
  State<SelectReasonScreen> createState() => _SelectReasonScreenState();
}

class _SelectReasonScreenState extends State<SelectReasonScreen> {
  @override
  void initState() {
    FirebaseEvents.setFirebaseEvent('delete_account_reason_screen', {});
    super.initState();
  }

  List<Map<String, dynamic>> reasonList = [
    {
      'reason': 'I’m not using the app',
      'isSelected': false,
    },
    {
      'reason': 'I found a better alternative',
      'isSelected': false,
    },
    {
      'reason': 'The App Contains Feature that is Non of My Use',
      'isSelected': false,
    },
    {
      'reason':
          'The app didn’t have the features of functionality I were looking for',
      'isSelected': false,
    },
    {
      'reason': 'l’m not satisfied with the quality of content',
      'isSelected': false,
    },
    {
      'reason': 'The app was difficult to navigate',
      'isSelected': false,
    },
    {
      'reason': 'Other',
      'isSelected': false,
    },
  ];
  TextEditingController otherReasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppCommonAppBar(
        title: 'Select reason',
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20.sp),
        child: CommonButton(
          onPressed: () {
            FirebaseEvents.setFirebaseEvent(
                'click_delete_account_submit_btn', {});
            // NavigatorRoute.navigateTo(context, AppRoutes.deleteAccount);
            if (reasonList.every((e) => e['isSelected'] == false)) {
              AppFunctions.showToast('Select a reason');
            } else {
              // if (otherReasonController.text.isNotEmpty) {
              NavigatorRoute.navigateTo(context, AppRoutes.deleteAccount);
              // }
            }
          },
          color: AppColors.redColor,
          widget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Submit',
                style:
                    TextStyles.semiBold(18.sp, fontColor: AppColors.whiteColor),
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
                'Why do you leave Awaaz?',
                style: TextStyles.bold(
                  24.sp,
                  fontColor: AppColors.whiteColor,
                ),
              ),
              Gap(5.h),
              Text(
                'Give an optional feedback to help us improve!',
                style: TextStyles.medium(
                  16.sp,
                  fontColor: AppColors.whiteColor,
                ),
              ),
              Gap(35.h),
              ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (BuildContext context, int index) =>
                    Gap(30.h),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reasonList.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> data = reasonList[index];
                  return Row(
                    children: [
                      AppCheckBox(
                        onChanged: (newVal) {
                          setState(() {
                            data['isSelected'] = newVal;
                          });
                        },
                        isChecked: data['isSelected'],
                      ),
                      Gap(16.w),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              data['isSelected'] = !data['isSelected'];
                            });
                          },
                          child: Text(
                            data['reason'],
                            maxLines: 2,
                            style: TextStyles.medium(
                              18.sp,
                              fontColor: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Gap(10.h),
              Visibility(
                visible: reasonList.last['isSelected'],
                child: CommonMainTextField(
                  hintText: 'Enter Reason Here',
                  controller: otherReasonController,
                  cursorColor: AppColors.textHintGrayColor,
                  textStyle: TextStyles.regular(18.sp,
                      fontColor: AppColors.textHintGrayColor),
                  fillColor: AppColors.whiteColor,
                  errorBorderSide:
                      const BorderSide(color: AppColors.redColorColor),
                  focusedErrorBorderSide: BorderSide(color: AppColors.redColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
