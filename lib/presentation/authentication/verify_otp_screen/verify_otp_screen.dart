import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/widget/common_button.dart';
import 'package:eagle_eye/core/widget/common_text_button.dart';
import 'package:eagle_eye/presentation/authentication/verify_otp_screen/bloc/verify_otp_cubit.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constant/app_constant.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/app_functions.dart';
import '../../../core/widget/app_common_loader_screen.dart';
import '../../../core/widget/common_app_bar.dart';
import '../../../core/widget/common_textfield.dart';
import '../../../gen/assets.gen.dart';
import '../../../routes/app_navigation.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String? email;
  final String? phone;
  final bool? isPhone;
  final String? screen;

  const VerifyOtpScreen(
      {super.key, this.email, this.phone, this.isPhone, this.screen});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  @override
  void initState() {
    FirebaseEvents.setFirebaseEvent('verify_otp_screen', {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (a, b) {
        context.read<VerifyOtpCubit>().stopTimer();
      },
      child: Scaffold(
        appBar: AppCommonAppBar(
          title: '',
          leading: IconButton(
              onPressed: () {
                closeKeyboard();
                context.read<VerifyOtpCubit>().stopTimer();
                NavigatorRoute.navigateBack(context);
              },
              icon: Assets.icons.icBackArrowWhite.svg()),
        ),
        bottomNavigationBar: BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
          builder: (context, state) => Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: EdgeInsets.only(left: 100.w, right: 100.w, bottom: 50.h),
              child: CommonButton(
                  color: state.otpController == null ||
                          state.otpController!.text.isEmpty
                      ? AppColors.buttonDisabledColor
                      : Colors.white,
                  onPressed: state.otpController == null ||
                          state.otpController!.text.isEmpty
                      ? () {
                          AppFunctions.showToast("Enter OTP");
                        }
                      : () {
                          closeKeyboard();
                          FirebaseEvents.setFirebaseEvent(
                              'click_verify_otp_btn', {});
                          context.read<VerifyOtpCubit>().onSubmitVerifyOTP(
                              context,
                              widget.email ?? '',
                              widget.phone ?? '',
                              widget.screen ?? '',
                              widget.isPhone ?? false);
                        },
                  widget: Icon(Icons.arrow_forward_ios_rounded,
                      color: state.otpController == null ||
                              state.otpController!.text.isEmpty
                          ? AppColors.textHintGrayColor
                          : Colors.black)),
            ),
          ),
        ),
        body: BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
          builder: (context, state) {
            return AppCommonLoaderScreen(
              inAsyncCall: state.isLoading,
              child: GestureDetector(
                onTap: closeKeyboard,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        SizedBox(height: 50.h),
                        Text(
                          'Enter Code',
                          style: TextStyles.bold(46.sp,
                              fontFamily: testTiemposHeadline),
                        ),
                        SizedBox(height: 30.h),
                        BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
                          builder: (context, state) {
                            return CommonTextField(
                              radius: BorderRadius.circular(10.r),
                              cursorColor: AppColors.whiteColor,
                              fillColor: AppColors.actionBtnBgColor,
                              autofocus: true,
                              onChanged: (p0) {
                                setState(() {
                                  state.otpController!.text = p0;
                                });
                              },
                              onSubmitted: (p0) {
                                closeKeyboard();
                                context
                                    .read<VerifyOtpCubit>()
                                    .onSubmitVerifyOTP(
                                        context,
                                        widget.email ?? '',
                                        widget.phone ?? '',
                                        widget.screen ?? '',
                                        widget.isPhone ?? false);
                              },
                              contentPadding: EdgeInsets.only(bottom: 14),
                              textAlign: TextAlign.center,
                              textStyle: TextStyles.medium(20.sp,
                                  fontColor: AppColors.whiteColor),
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(4),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              /* prefixIcon: SizedBox(
                                height: 10,
                                width: 0,
                              ),*/
                              /*    suffixIcon: SizedBox(
                                height: 50,
                                width: 0,
                              ), */
                              keyboardType: TextInputType.number,
                              hintText: 'Enter code',
                              hintTextStyle: TextStyles.medium(17.sp,
                                  fontColor: AppColors.textHintGrayColor),
                              controller: state.otpController!,
                            );
                          },
                        ),
                        SizedBox(height: 12.h),
                        BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
                            buildWhen: (previous, current) {
                          return previous.resendRemainingSeconds !=
                              current.resendRemainingSeconds;
                        }, builder: (context, state) {
                          if (((int.tryParse(context
                                  .read<VerifyOtpCubit>()
                                  .getTimerString(
                                      state.resendRemainingSeconds))! <=
                              0))) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Haven't receive a code ?",
                                  style: TextStyles.medium(16,
                                      fontColor: AppColors.textHintGrayColor),
                                ),
                                CommonTextButton(
                                  onPressed: /*(state.resendRemainingSeconds == 0)
                                    ?*/
                                      () {
                                    FirebaseEvents.setFirebaseEvent(
                                        'verify_otp_resend_btn', {});
                                    context
                                        .read<VerifyOtpCubit>()
                                        .resendButtonPressed(context,
                                            email: widget.email ?? '');
                                  } /*
                                    : null*/
                                  ,
                                  widget: Text(
                                    "Resend",
                                    style: TextStyles.medium(
                                      16,
                                      fontColor: AppColors.whiteColor,
                                      textDecoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          return SizedBox.shrink();
                        }),
                        SizedBox(height: 6.h),
                        BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
                          builder: (context, state) {
                            String timer = context
                                .read<VerifyOtpCubit>()
                                .getTimerString(state.resendRemainingSeconds);
                            if (((int.tryParse(context
                                    .read<VerifyOtpCubit>()
                                    .getTimerString(
                                        state.resendRemainingSeconds))! >
                                0))) {
                              return Center(
                                child: Text(
                                  '00:$timer Sec',
                                  style: TextStyles.medium(
                                    16,
                                    fontColor: AppColors.whiteColor,
                                  ),
                                ),
                              );
                            }
                            return SizedBox.shrink();
                          },
                        ),
                        // spaceH(300.h),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
