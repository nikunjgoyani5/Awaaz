import 'package:eagle_eye/core/constant/app_constant.dart';
import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/utils/app_prefrence.dart';
import 'package:eagle_eye/core/widget/common_textfield.dart';
import 'package:eagle_eye/routes/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/text_styles.dart';
import '../../../core/utils/app_functions.dart';
import '../../../core/widget/common_app_bar.dart';
import '../../../core/widget/common_button.dart';
import '../../../gen/assets.gen.dart';
import 'bloc/onboard_cubit.dart';

class OnboardBirthdateScreen extends StatefulWidget {
  const OnboardBirthdateScreen({super.key});

  @override
  State<OnboardBirthdateScreen> createState() => _OnboardBirthdateScreenState();
}

class _OnboardBirthdateScreenState extends State<OnboardBirthdateScreen> {
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppCommonAppBar(
        leading: IconButton(
            onPressed: () {
              NavigatorRoute.navigateBack(context);
            },
            icon: Assets.icons.icBackArrowWhite.svg()),
        title: '',
        action: [
          // IconButton(
          //     onPressed: () {
          //       closeKeyboard();
          //       context.read<OnboardCubit>().onTapBirthdate(context);
          //     },
          //     icon: Icon(Icons.done_all))
        ],
      ),
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: EdgeInsets.only(left: 100.w, right: 100.w, bottom: 50.h),
          child: BlocBuilder<OnboardCubit, OnboardState>(
            builder: (context, state) => CommonButton(
                color:
                /*((state.dayController == null ||
                            state.dayController!.text.isEmpty) ||
                        (state.monthController == null ||
                            state.monthController!.text.isEmpty) ||
                        (state.yearController == null ||
                            state.yearController!.text.isEmpty))
                    ? AppColors.buttonDisabledColor
                    :*/
                    Colors.white,
                onPressed: () {
                  if (_focusNode1.hasFocus) {
                    if (state.dayController!.text.isEmpty) {
                      AppFunctions.showToast('Please enter month.');
                    } else {
                      _focusNode1.unfocus();
                      FocusScope.of(context).requestFocus(_focusNode2);
                    }
                  } else if (_focusNode2.hasFocus) {
                    if (state.monthController!.text.isEmpty) {
                      AppFunctions.showToast('Please enter month.');
                    } else {
                      _focusNode2.unfocus();
                      FocusScope.of(context).requestFocus(_focusNode3);
                    }
                  } else {
                    if (state.yearController!.text.isEmpty) {
                      AppFunctions.showToast('Please enter year.');
                    } else {
                      _focusNode3.unfocus();
                      context.read<OnboardCubit>().onTapBirthdate(context);
                    }
                  }
                },
                widget: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: /*((state.dayController == null ||
                              state.dayController!.text.isEmpty) ||
                          (state.monthController == null ||
                              state.monthController!.text.isEmpty) ||
                          (state.yearController == null ||
                              state.yearController!.text.isEmpty))
                      ? AppColors.textHintGrayColor
                      :*/
                      Colors.black,
                )),
          ),
        ),
      ),
      body: InkWell(
        splashColor: Colors.transparent, // Remove splash effect
        highlightColor: Colors.transparent, // Remove highlight effect
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        onTap: closeKeyboard,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 50.h),
                  BlocBuilder<OnboardCubit, OnboardState>(
                    builder: (context, state) {
                      return Text(
                        textAlign: TextAlign.center,
                        'Hey ${state.nameController?.text ?? ''}',
                        maxLines: 2,
                        style: TextStyles.bold(55.sp,
                            fontFamily: testTiemposHeadline,
                            textOverflow: TextOverflow.ellipsis),
                      );
                    },
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'When is your birthday?',
                    style: TextStyles.bold(
                      30.sp,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  BlocBuilder<OnboardCubit, OnboardState>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          BlocBuilder<OnboardCubit, OnboardState>(
                            buildWhen: (previous, current) =>
                                previous.dayController != current.dayController,
                            builder: (context, state) {
                              return Expanded(
                                  child: CommonTextField(
                                autofocus: true,
                                focusNode: _focusNode1,
                                contentPadding: EdgeInsets.only(
                                  bottom: 13,
                                ),
                                cursorColor: AppColors.whiteColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(2),
                                ],
                                onChanged: (val) {
                                  if (val.length == 2) {
                                    if (double.parse(val) > 31) {
                                      context
                                          .read<OnboardCubit>()
                                          .onChangeDate('31');
                                    }
                                    if (double.parse(val) == 0) {
                                      context
                                          .read<OnboardCubit>()
                                          .onChangeDate('01');
                                    }
                                    _focusNode1.unfocus();
                                    FocusScope.of(context)
                                        .requestFocus(_focusNode2);
                                  }
                                },
                                textStyle: TextStyles.medium(20.sp,
                                    fontColor: AppColors.whiteColor),
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                onSubmitted: (p0) {
                                  if (state.dayController!.text.isEmpty) {
                                    AppFunctions.showToast(
                                        'Please enter month.');
                                    FocusScope.of(context)
                                        .requestFocus(_focusNode1);
                                  } else {
                                    _focusNode1.unfocus();
                                    FocusScope.of(context)
                                        .requestFocus(_focusNode2);
                                  }
                                },
                                hintText: 'DD',
                                controller: state.dayController!,
                                radius: BorderRadius.circular(10),
                                fillColor: AppColors.actionBtnBgColor,
                              ));
                            },
                          ),
                          SizedBox(width: 8.w),
                          BlocBuilder<OnboardCubit, OnboardState>(
                            buildWhen: (previous, current) =>
                                previous.monthController !=
                                current.monthController,
                            builder: (context, state) {
                              return Expanded(

                                  child: CommonTextField(
                                focusNode: _focusNode2,
                                cursorColor: AppColors.whiteColor,
                                textStyle: TextStyles.medium(20.sp,
                                    fontColor: AppColors.whiteColor),
                                onChanged: (val) {
                                  if (val.length == 2) {
                                    if (double.parse(val) > 12) {
                                      context
                                          .read<OnboardCubit>()
                                          .onChangeMonth('12');
                                    }
                                    if (double.parse(val) == 0) {
                                      context
                                          .read<OnboardCubit>()
                                          .onChangeMonth('01');
                                    }
                                    _focusNode2.unfocus();
                                    FocusScope.of(context)
                                        .requestFocus(_focusNode3);
                                  }
                                },
                                onSubmitted: (p0) {
                                  if (state.monthController!.text.isEmpty) {
                                    AppFunctions.showToast(
                                        'Please enter month.');
                                    FocusScope.of(context)
                                        .requestFocus(_focusNode2);
                                  } else {
                                    _focusNode2.unfocus();
                                    FocusScope.of(context)
                                        .requestFocus(_focusNode3);
                                  }
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(2),
                                ],
                                contentPadding: EdgeInsets.only(
                                  bottom: 13,
                                ),
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                hintText: 'MM',
                                controller: state.monthController!,
                                radius: BorderRadius.circular(10),
                                fillColor: AppColors.actionBtnBgColor,
                              ));
                            },
                          ),
                          SizedBox(width: 8.w),
                          BlocBuilder<OnboardCubit, OnboardState>(
                            buildWhen: (previous, current) =>
                                previous.yearController !=
                                current.yearController,
                            builder: (context, state) {
                              return Expanded(
                                  child: CommonTextField(
                                focusNode: _focusNode3,
                                contentPadding: EdgeInsets.only(
                                  bottom: 13,
                                ),
                                textStyle: TextStyles.medium(20.sp,
                                    fontColor: AppColors.whiteColor),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                ],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                onChanged: (val) {
                                  if (val.length == 4) {
                                    _focusNode2.unfocus();
                                    closeKeyboard();
                                  }
                                },
                                onSubmitted: (p0) {
                                  if (state.yearController!.text.isEmpty) {
                                    AppFunctions.showToast(
                                        'Please enter year.');
                                    FocusScope.of(context)
                                        .requestFocus(_focusNode3);
                                  } else {
                                    _focusNode3.unfocus();
                                    context
                                        .read<OnboardCubit>()
                                        .onTapBirthdate(context);
                                  }
                                },
                                hintText: 'YYYY',
                                cursorColor: AppColors.whiteColor,
                                controller: state.yearController!,
                                radius: BorderRadius.circular(10),
                                fillColor: AppColors.actionBtnBgColor,
                              ));
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 30.h),
                  IconButton(
                      onPressed: () {
                        _focusNode1.unfocus();
                        _focusNode2.unfocus();
                        _focusNode3.unfocus();
                        context.read<OnboardCubit>().onDobSelect(context);
                      },
                      icon: Icon(
                        Icons.calendar_month_sharp,
                        color: AppColors.whiteColor,
                      ))
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: 311.h),
                // Center(
                //   child: Text(
                //     'e.g 26/04/2008',
                //     style: TextStyles.medium(
                //       18.sp,
                //       fontColor: AppColors.textHintGrayColor,
                //     ),
                //   ),
                // ),
                SizedBox(height: 20.h),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 40.w),
                //   child: CommonButton(
                //       color: Colors.white,
                //       onPressed: () {
                //         context.read<OnboardCubit>().onTapBirthdate(context);
                //       },
                //       widget: Icon(
                //         Icons.arrow_forward_ios_rounded,
                //         color: Colors.black,
                //       )),
                // ),
                SizedBox(height: 10.h),
                Visibility(
                  visible: PrefService.getBool(PrefService.appleLogin),
                  child: TextButton(
                      onPressed: () {
                        context.read<OnboardCubit>().onTapBirthdate(context);
                      },
                      child: Text(
                        'Skip',
                        style: TextStyles.medium(20.sp,
                            fontColor: AppColors.whiteColor),
                      )),
                ),
                SizedBox(height: 50.h),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget dobPicker(
      {required String text,
      required Function onTap,
      required TextStyle textStyle}) {
    return Expanded(
      child: InkWell(
        onTap: () => onTap.call(),
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          height: 60.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: AppColors.actionBtnBgColor,
              borderRadius: BorderRadius.circular(10.r)),
          child: Text(
            text,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
