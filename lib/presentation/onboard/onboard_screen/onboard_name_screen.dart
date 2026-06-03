import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:eagle_eye/presentation/onboard/onboard_screen/bloc/onboard_cubit.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/app_functions.dart';
import '../../../core/utils/app_prefrence.dart';
import '../../../core/widget/common_app_bar.dart';
import '../../../core/widget/common_button.dart';
import '../../../core/widget/common_textfield.dart';
import '../../../gen/assets.gen.dart';

class OnboardNameScreen extends StatefulWidget {
  const OnboardNameScreen({super.key});

  @override
  State<OnboardNameScreen> createState() => _OnboardNameScreenState();
}

class _OnboardNameScreenState extends State<OnboardNameScreen> {
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  String? userNameResponseMessage;
  bool isResponseSuccess = false;

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    super.dispose();
  }

  @override
  void initState() {
    FirebaseEvents.setFirebaseEvent('onboard_name_page', {});
    super.initState();
  }

  final GlobalKey tooltipKey = GlobalKey();
  void showTooltip() {
    final dynamic tooltip = tooltipKey.currentState;
    tooltip?.ensureTooltipVisible(); // Manually show tooltip
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.blackColor,
      appBar: AppCommonAppBar(
        leading: (context.read<OnboardCubit>().state.currentPage == 0)
            ? SizedBox.shrink()
            : IconButton(
                onPressed: () {
                  closeKeyboard();
                  if (context.read<OnboardCubit>().state.pageController?.page ==
                      0) {
                    SystemNavigator.pop();
                  } else if (context
                          .read<OnboardCubit>()
                          .state
                          .pageController
                          ?.page ==
                      1) {
                    context
                        .read<OnboardCubit>()
                        .state
                        .pageController
                        ?.animateToPage(
                          0,
                          duration: Duration(milliseconds: 250),
                          curve: Curves.fastLinearToSlowEaseIn,
                        );
                  } else if (context
                          .read<OnboardCubit>()
                          .state
                          .pageController
                          ?.page ==
                      2) {
                    context
                        .read<OnboardCubit>()
                        .state
                        .pageController
                        ?.animateToPage(
                          1,
                          duration: Duration(milliseconds: 250),
                          curve: Curves.fastLinearToSlowEaseIn,
                        );
                  } else if (context
                          .read<OnboardCubit>()
                          .state
                          .pageController
                          ?.page ==
                      3) {
                    context
                        .read<OnboardCubit>()
                        .state
                        .pageController
                        ?.animateToPage(
                          2,
                          duration: Duration(milliseconds: 250),
                          curve: Curves.fastLinearToSlowEaseIn,
                        );
                  }
                },
                icon: Assets.icons.icBackArrowWhite.svg()),
        title: '',
        action: [
          BlocBuilder<OnboardCubit, OnboardState>(
            builder: (context, state) {
              if (state.currentPage != 0 &&
                  state.currentPage != 1 &&
                  state.currentPage != 2) {
                return IconButton(
                    onPressed: () async {
                      closeKeyboard();
                      if (context
                              .read<OnboardCubit>()
                              .state
                              .pageController
                              ?.page ==
                          0) {
                        FirebaseEvents.setFirebaseEvent(
                            'onboard_name_skip_btn', {});
                        context
                            .read<OnboardCubit>()
                            .state
                            .pageController
                            ?.animateToPage(
                              1,
                              duration: Duration(milliseconds: 250),
                              curve: Curves.fastLinearToSlowEaseIn,
                            );
                      } else if (context
                              .read<OnboardCubit>()
                              .state
                              .pageController
                              ?.page ==
                          1) {
                        FirebaseEvents.setFirebaseEvent(
                            'onboard_birthdate_skip_btn', {});
                        context.read<OnboardCubit>().onTapBirthdate(context);
                      } else if (context
                              .read<OnboardCubit>()
                              .state
                              .pageController
                              ?.page ==
                          3) {
                        FirebaseEvents.setFirebaseEvent(
                            'onboard_profile_photo_skip_btn', {});
                        context.read<OnboardCubit>().clearPhoto();

                        await context
                            .read<OnboardCubit>()
                            .onTapProfile(context, skipProfilePhoto: true);
                      }
                    },
                    icon: /*Icon(Icons.done_all)*/
                        Text(
                      'Skip',
                      style: TextStyles.medium(20.sp,
                          fontColor: AppColors.whiteColor),
                    ));
              } else {
                return SizedBox.shrink();
              }
            },
          ),
          Visibility(
            visible: (context.read<OnboardCubit>().state.currentPage == 1) &&
                PrefService.getBool(PrefService.appleLogin),
            child: TextButton(
                onPressed: () {
                  context.read<OnboardCubit>().onTapBirthdate(context);
                },
                child: Text(
                  'Skip',
                  style:
                      TextStyles.medium(20.sp, fontColor: AppColors.whiteColor),
                )),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: EdgeInsets.only(left: 100.w, right: 100.w, bottom: 30.h),
          child: BlocBuilder<OnboardCubit, OnboardState>(
            // buildWhen: (previous, current) {
            //   return previous.pageController != current.pageController;
            // },
            builder: (context, state) => CommonButton(
                color:
                    (context.read<OnboardCubit>().state.pageController?.page ==
                                    0 &&
                                (state.nameController == null ||
                                    state.nameController!.text.isEmpty) ||
                            !isResponseSuccess)
                        ? AppColors.buttonDisabledColor
                        : Colors.white,
                onPressed: () async {
                  closeKeyboard();
                  if (context.read<OnboardCubit>().state.pageController?.page ==
                      0) {
                    // This RegExp allows letters, numbers, dot, and spaces
                    final pattern = RegExp(r'^[a-zA-Z0-9.]+$');
                    if ((!pattern
                            .hasMatch(state.userNameController?.text ?? "")) ||
                        !isResponseSuccess) {
                      AppFunctions.showToast('Please enter valid username.');
                    } else {
                      FirebaseEvents.setFirebaseEvent(
                          'onboard_name_next_btn', {});
                      await context.read<OnboardCubit>().onTapName(context);
                      setState(() {});
                    }
                  } else if (context
                          .read<OnboardCubit>()
                          .state
                          .pageController
                          ?.page ==
                      1) {
                    FirebaseEvents.setFirebaseEvent(
                        'onboard_birthdate_next_btn', {});
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
                        final year = int.tryParse(state.yearController!.text);
                        if ((year ?? 0000) < 1900) {
                          AppFunctions.showToast('Enter valid year.');
                        } else {
                          try {
                            final birthDate = DateTime(
                              int.parse(state.yearController!.text),
                              int.parse(state.monthController!.text),
                              int.parse(state.dayController!.text),
                            );

                            final today = DateTime.now();
                            int age = today.year - birthDate.year;

                            // Adjust age if birthday hasn't occurred this year
                            if (today.month < birthDate.month ||
                                (today.month == birthDate.month &&
                                    today.day < birthDate.day)) {
                              age--;
                            }

                            if (age < 16) {
                              AppFunctions.showToast('Your age is below 16');
                              FocusScope.of(context).requestFocus(_focusNode3);
                              return;
                            }

                            _focusNode3.unfocus();
                            context
                                .read<OnboardCubit>()
                                .onTapBirthdate(context);
                          } catch (e) {
                            // Handle invalid date combinations
                            AppFunctions.showToast('Invalid date combination');
                            FocusScope.of(context).requestFocus(_focusNode3);
                          }
                        }
                        setState(() {});
                      }
                    }
                  } else if (context
                          .read<OnboardCubit>()
                          .state
                          .pageController
                          ?.page ==
                      2) {
                    FirebaseEvents.setFirebaseEvent(
                        'onboard_mobilenumber_next_btn', {});
                    if (state.mobileNumberController!.text.length != 10) {
                      AppFunctions.showToast(
                          'Please Enter a valid 10-digit mobile number');
                    } else {
                      await context
                          .read<OnboardCubit>()
                          .state
                          .pageController
                          ?.animateToPage(
                            3,
                            duration: Duration(milliseconds: 250),
                            curve: Curves.fastLinearToSlowEaseIn,
                          );
                      setState(() {});
                    }
                  } else if (context
                          .read<OnboardCubit>()
                          .state
                          .pageController
                          ?.page ==
                      3) {
                    FirebaseEvents.setFirebaseEvent(
                        'onboard_profile_next_btn', {});
                    if (PrefService.getBool(PrefService.appleLogin)) {
                      await context.read<OnboardCubit>().onTapProfile(context);
                      setState(() {});
                    } else {
                      await context.read<OnboardCubit>().onTapProfile(context);
                      setState(() {});
                      // if (state.profilePicture != null) {
                      //   // await MapUtils.requestLocationPermission(context);
                      //   await context
                      //       .read<OnboardCubit>()
                      //       .onTapProfile(context);
                      //   setState(() {});
                      // } else {
                      //   AppFunctions.showToast('Upload profile picture');
                      // }
                    }
                  }
                },
                widget: state.isLoading
                    ? SizedBox(
                        height: 20.0,
                        width: 20.0,
                        child: CircularProgressIndicator(
                          color: AppColors.blackColor,
                        ),
                      )
                    : Icon(Icons.arrow_forward_ios_rounded,
                        color: (context
                                            .read<OnboardCubit>()
                                            .state
                                            .pageController
                                            ?.page ==
                                        0 &&
                                    (state.nameController == null ||
                                        state.nameController!.text.isEmpty) ||
                                !isResponseSuccess)
                            ? AppColors.textHintGrayColor
                            : Colors.black)),
          ),
        ),
      ),
      body: BlocBuilder<OnboardCubit, OnboardState>(
        buildWhen: (previous, current) {
          return previous.pageController != current.pageController;
        },
        builder: (context, state) {
          return PageView(
            physics: const BouncingScrollPhysics(),
            pageSnapping: true,
            onPageChanged: (value) {
              context.read<OnboardCubit>().goToPage(value);
              if (value == 3) {
                closeKeyboard();
              }
            },
            controller: state.pageController,
            children: [
              InkWell(
                splashColor: Colors.transparent,
                // Remove splash effect
                highlightColor: Colors.transparent,
                // Remove highlight effect
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: closeKeyboard,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 90.h),
                          // Text(
                          //   'Hello!',
                          //   style: TextStyles.bold(55.sp,
                          //       fontFamily: testTiemposHeadline),
                          // ),
                          // SizedBox(height: 5.h),
                          Center(
                            child: Text(
                              'Please Enter Your Details',
                              textAlign: TextAlign.center,
                              style: TextStyles.bold(
                                30.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: 30.h),
                          Text(
                            "Username:",
                            style: TextStyles.medium(20.sp,
                                fontColor: AppColors.whiteColor),
                          ),
                          Gap(10.h),
                          BlocBuilder<OnboardCubit, OnboardState>(
                            buildWhen: (previous, current) =>
                                previous.userNameController !=
                                current.userNameController,
                            builder: (context, state) {
                              return CommonTextField(
                                radius: BorderRadius.circular(10.r),
                                autofocus: true,
                                cursorColor: AppColors.whiteColor,
                                fillColor: AppColors.onboardTextFieldColor,
                                hintTextStyle: TextStyles.medium(
                                  20.sp,
                                  fontColor: AppColors.textHintGrayColor,
                                ),
                                onChanged: (p0) async {
                                  setState(() {
                                    state.userNameController!.text = p0;
                                  });
                                  final response = await context
                                      .read<OnboardCubit>()
                                      .checkUserName();
                                  setState(() {
                                    userNameResponseMessage =
                                        response?.message ?? '';
                                    isResponseSuccess =
                                        response?.status ?? false;
                                  });
                                },
                                textStyle: TextStyles.medium(20.sp,
                                    fontColor: AppColors.whiteColor),
                                // prefixIcon: SizedBox(
                                //   height: 50,
                                //   width: 0,
                                // ),
                                suffixIcon: SizedBox(
                                  height: 50,
                                  width: 0,
                                ),
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.name,
                                hintText: 'Enter your username',
                                controller: state.userNameController!,
                              );
                            },
                          ),
                          (userNameResponseMessage != null &&
                                  userNameResponseMessage != '' &&
                                  state.userNameController!.text
                                      .trim()
                                      .isNotEmpty)
                              ? (isResponseSuccess == true)
                                  ? Padding(
                                      padding: EdgeInsets.only(left: 10.w),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          userNameResponseMessage ?? '',
                                          style: TextStyles.medium(16.sp,
                                              fontColor: AppColors.greenColor),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.only(left: 10.w),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          userNameResponseMessage ?? '',
                                          style: TextStyles.medium(16.sp,
                                              fontColor: AppColors.redColor),
                                        ),
                                      ),
                                    )
                              : SizedBox.shrink(),
                          Gap(20.h),
                          Row(
                            children: [
                              Text(
                                "Nickname:",
                                style: TextStyles.medium(20.sp,
                                    fontColor: AppColors.whiteColor),
                              ),
                              Builder(builder: (context) {
                                return IconButton(
                                  onPressed: () {
                                    final RenderBox button =
                                        context.findRenderObject() as RenderBox;
                                    final RenderBox overlay =
                                        Overlay.of(context)
                                            .context
                                            .findRenderObject() as RenderBox;
                                    final buttonPosition = button.localToGlobal(
                                        Offset.zero,
                                        ancestor: overlay);

                                    OverlayEntry? overlayEntry;
                                    overlayEntry = OverlayEntry(
                                      builder: (context) => Positioned(
                                        left: 20.w,
                                        top: buttonPosition.dy + 110,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                40.w,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withValues(alpha: 0.5),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              "Nickname is utilize for your personal references.",
                                              style: TextStyles.regular(14.sp,
                                                  fontColor:
                                                      AppColors.blackColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );

                                    Overlay.of(context).insert(overlayEntry);

                                    Future.delayed(Duration(seconds: 3), () {
                                      overlayEntry?.remove();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: AppColors.textHintGrayColor,
                                    size: 20.sp,
                                  ),
                                );
                              }),
                            ],
                          ),
                          BlocBuilder<OnboardCubit, OnboardState>(
                            buildWhen: (previous, current) =>
                                previous.nameController !=
                                current.nameController,
                            builder: (context, state) {
                              return CommonTextField(
                                radius: BorderRadius.circular(10.r),
                                autofocus: true,
                                cursorColor: AppColors.whiteColor,
                                fillColor: AppColors.onboardTextFieldColor,
                                hintTextStyle: TextStyles.medium(
                                  20.sp,
                                  fontColor: AppColors.textHintGrayColor,
                                ),
                                onChanged: (p0) {
                                  setState(() {
                                    state.nameController!.text = p0;
                                  });
                                },
                                onSubmitted: (p0) {
                                  closeKeyboard();
                                  context
                                      .read<OnboardCubit>()
                                      .onTapName(context);
                                },
                                textStyle: TextStyles.medium(20.sp,
                                    fontColor: AppColors.whiteColor),
                                // prefixIcon: SizedBox(
                                //   height: 50,
                                //   width: 0,
                                // ),
                                suffixIcon: SizedBox(
                                  height: 50,
                                  width: 0,
                                ),
                                // textAlign: TextAlign.center,
                                keyboardType: TextInputType.name,
                                hintText: 'Enter your nickname',
                                controller: state.nameController!,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                // Remove splash effect
                highlightColor: Colors.transparent,
                // Remove highlight effect
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: closeKeyboard,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          SizedBox(height: 90.h),
                          // BlocBuilder<OnboardCubit, OnboardState>(
                          //   builder: (context, state) {
                          //     return Text(
                          //       textAlign: TextAlign.center,
                          //       'Hey ${state.nameController?.text ?? ''}',
                          //       maxLines: 2,
                          //       style: TextStyles.bold(55.sp,
                          //           fontFamily: testTiemposHeadline,
                          //           textOverflow: TextOverflow.ellipsis),
                          //     );
                          //   },
                          // ),
                          // SizedBox(height: 5.h),
                          Center(
                            child: Text(
                              'Please Enter Your Birthday',
                              textAlign: TextAlign.center,
                              style: TextStyles.bold(
                                30.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: 30.h),
                          BlocBuilder<OnboardCubit, OnboardState>(
                            builder: (context, state) {
                              return Row(
                                children: [
                                  BlocBuilder<OnboardCubit, OnboardState>(
                                    buildWhen: (previous, current) =>
                                        previous.dayController !=
                                        current.dayController,
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
                                          FilteringTextInputFormatter
                                              .digitsOnly,
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
                                          if (state
                                              .dayController!.text.isEmpty) {
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
                                          if (state
                                              .monthController!.text.isEmpty) {
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
                                          FilteringTextInputFormatter
                                              .digitsOnly,
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
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(4),
                                        ],
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        onChanged: (val) {
                                          if (val.isNotEmpty) {
                                            if (double.parse(val) >
                                                (DateTime.now().year - 16)) {
                                              AppFunctions.showToast(
                                                  'Your age is bellow 16.');
                                              // context
                                              //     .read<OnboardCubit>()
                                              //     .onChangeYear(
                                              //         (DateTime.now().year - 16)
                                              //             .toString());
                                            }

                                            if (val.length == 4) {
                                              final year = int.tryParse(val);
                                              if ((year ?? 0000) < 1900) {
                                                AppFunctions.showToast(
                                                    'Enter valid year.');
                                              }
                                              _focusNode2.unfocus();
                                              closeKeyboard();
                                            }
                                          }
                                        },
                                        onSubmitted: (p0) {
                                          if (state
                                              .yearController!.text.isEmpty) {
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
                                context
                                    .read<OnboardCubit>()
                                    .onDobSelect(context);
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
                        SizedBox(height: 20.h),
                        SizedBox(height: 10.h),
                        SizedBox(height: 50.h),
                      ],
                    )
                  ],
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                // Remove splash effect
                highlightColor: Colors.transparent,
                // Remove highlight effect
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: closeKeyboard,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          SizedBox(height: 90.h),
                          // BlocBuilder<OnboardCubit, OnboardState>(
                          //   builder: (context, state) {
                          //     return Text(
                          //       textAlign: TextAlign.center,
                          //       'Hey ${state.nameController?.text ?? ''}',
                          //       maxLines: 2,
                          //       style: TextStyles.bold(55.sp,
                          //           fontFamily: testTiemposHeadline,
                          //           textOverflow: TextOverflow.ellipsis),
                          //     );
                          //   },
                          // ),
                          // SizedBox(height: 5.h),
                          Center(
                            child: Text(
                              'Please Enter Your Mobile Number',
                              textAlign: TextAlign.center,
                              style: TextStyles.bold(
                                30.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: 30.h),
                          BlocBuilder<OnboardCubit, OnboardState>(
                            buildWhen: (previous, current) =>
                                previous != current,
                            builder: (context, state) {
                              return CommonTextField(
                                radius: BorderRadius.circular(10.r),
                                autofocus: true,
                                cursorColor: AppColors.whiteColor,
                                fillColor: AppColors.onboardTextFieldColor,
                                hintTextStyle: TextStyles.medium(
                                  20.sp,
                                  fontColor: AppColors.textHintGrayColor,
                                ),
                                onChanged: (p0) {
                                  setState(() {
                                    state.mobileNumberController!.text = p0;
                                  });
                                },
                                onSubmitted: (p0) {
                                  closeKeyboard();
                                  /*context
                                      .read<OnboardCubit>()
                                      .onTapName(context);*/
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(
                                      state.countryData?.example.length ?? 10),
                                ],
                                textStyle: TextStyles.medium(20.sp,
                                    fontColor: AppColors.whiteColor),
                                prefixIcon: GestureDetector(
                                  onTap: () {
                                    showCountryPicker(
                                      context: context,
                                      showPhoneCode: true,
                                      // optional. Shows phone code before the country name.
                                      onSelect: (Country country) {
                                        context
                                            .read<OnboardCubit>()
                                            .onChangeCountry(country);
                                      },
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: AppColors.whiteColor,
                                      ),
                                      Text(
                                        '+${state.countryData?.phoneCode ?? 91}',
                                        style: TextStyles.medium(20.sp,
                                            fontColor: AppColors.whiteColor),
                                      ),
                                    ],
                                  ),
                                ),
                                prefixPadding: EdgeInsets.only(
                                    left: 10, top: 10, right: 10, bottom: 10),
                                keyboardType: TextInputType.number,
                                hintText: 'Enter your mobile number',
                                controller: state.mobileNumberController!,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(height: 311.h),
                        SizedBox(height: 20.h),
                        SizedBox(height: 10.h),
                        SizedBox(height: 50.h),
                      ],
                    )
                  ],
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                // Remove splash effect
                highlightColor: Colors.transparent,
                // Remove highlight effect
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: closeKeyboard,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 90.h),
                            // BlocBuilder<OnboardCubit, OnboardState>(
                            //   builder: (context, state) {
                            //     return Text(
                            //       textAlign: TextAlign.center,
                            //       'Hey ${state.nameController?.text ?? ''}',
                            //       maxLines: 2,
                            //       style: TextStyles.bold(55.sp,
                            //           fontFamily: testTiemposHeadline,
                            //           textOverflow: TextOverflow.ellipsis),
                            //     );
                            //   },
                            // ),
                            // SizedBox(height: 5.h),
                            Text(
                              'Please Enter Your Photo',
                              textAlign: TextAlign.center,
                              style: TextStyles.semiBold(
                                28.sp,
                              ),
                            ),
                            SizedBox(height: 40.h),
                            BlocBuilder<OnboardCubit, OnboardState>(
                              buildWhen: (previous, current) =>
                                  previous.profilePicture !=
                                  current.profilePicture,
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
                                                File(
                                                    state.profilePicture!.path),
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ))
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
                                                height: 175.h,
                                                width: 175.h,
                                                decoration: BoxDecoration(
                                                    color: AppColors
                                                        .actionBtnBgColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    border: Border.all(
                                                        color: state.profilePicture !=
                                                                null
                                                            ? AppColors
                                                                .whiteColor
                                                            : AppColors
                                                                .actionBtnBgColor,
                                                        width: 2.sp)),
                                                padding: EdgeInsets.all(10.sp),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(35),
                                                  child: Assets.icons.icCamera
                                                      .svg(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20.h),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () async {
                                                await context
                                                    .read<OnboardCubit>()
                                                    .onTapGallery(context);
                                              },
                                              child: Container(
                                                height: 175.h,
                                                width: 175.h,
                                                decoration: BoxDecoration(
                                                    color: AppColors
                                                        .actionBtnBgColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    border: Border.all(
                                                        color: state.profilePicture !=
                                                                null
                                                            ? AppColors
                                                                .whiteColor
                                                            : AppColors
                                                                .actionBtnBgColor,
                                                        width: 2.sp)),
                                                padding: EdgeInsets.all(10.sp),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(35),
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
                            SizedBox(height: 20.h),
                            BlocBuilder<OnboardCubit, OnboardState>(
                              builder: (context, state) =>
                                  state.profilePicture != null
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: IconButton(
                                              onPressed: () async {
                                                // await context
                                                //     .read<OnboardCubit>()
                                                //     .onTapGallery(context);
                                                context
                                                    .read<OnboardCubit>()
                                                    .clearPhoto();
                                              },
                                              icon: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.edit,
                                                    color:
                                                        AppColors.redColorColor,
                                                    size: 20.sp,
                                                  ),
                                                  SizedBox(width: 15.w),
                                                  Text(
                                                    'Edit photo',
                                                    style: TextStyles.medium(
                                                        22.sp,
                                                        fontColor: AppColors
                                                            .redColorColor),
                                                  )
                                                ],
                                              )),
                                        )
                                      : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
