import 'package:country_picker/country_picker.dart';
import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/theme/text_styles.dart';
import 'package:eagle_eye/core/utils/app_functions.dart';
import 'package:eagle_eye/core/widget/common_app_bar.dart';
import 'package:eagle_eye/core/widget/common_button.dart';
import 'package:eagle_eye/core/widget/common_textfield.dart';
import 'package:eagle_eye/gen/assets.gen.dart';
import 'package:eagle_eye/presentation/onboard/onboard_screen/bloc/onboard_cubit.dart';
import 'package:eagle_eye/services/firebase_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class NewOnBoardScreen extends StatefulWidget {
  const NewOnBoardScreen({super.key});

  @override
  State<NewOnBoardScreen> createState() => _NewOnBoardScreenState();
}

class _NewOnBoardScreenState extends State<NewOnBoardScreen> {
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
    FirebaseEvents.setFirebaseEvent('new_onboard', {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.blackColor,
      appBar: AppCommonAppBar(
        leading: IconButton(
            onPressed: () {
              closeKeyboard();
              SystemNavigator.pop();
            },
            icon: Assets.icons.icBackArrowWhite.svg()),
        title: '',
      ),
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 30.h),
          child: BlocBuilder<OnboardCubit, OnboardState>(
            // buildWhen: (previous, current) {
            //   return previous.pageController != current.pageController;
            // },
            builder: (context, state) => CommonButton(
                width: double.infinity,
                color: Colors.white,
                onPressed: () async {
                  closeKeyboard();
                  if (state.userNameController!.text.isEmpty) {
                    AppFunctions.showToast('Please enter a username.');
                  } else if (state.nameController!.text.isEmpty) {
                    AppFunctions.showToast('Please enter a name.');
                  } else if (state.birthDateController?.text.isEmpty ?? true) {
                    AppFunctions.showToast('Please select birth date.');
                  } else if (double.parse(state.yearController!.text) >
                      (DateTime.now().year - 16)) {
                    AppFunctions.showToast('Your age is bellow 16.');
                  } else if (state.mobileNumberController!.text.length != 10) {
                    AppFunctions.showToast(
                        'Please Enter a valid 10-digit mobile number');
                  } else if (state.profilePicture == null) {
                    AppFunctions.showToast('Upload profile picture');
                  } else {
                    await context
                        .read<OnboardCubit>()
                        .onTapProfile(context, skipProfilePhoto: false);
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
                    : Text(
                        'Done',
                        style: TextStyles.bold(20.sp,
                            fontColor: AppColors.blackColor),
                      )),
          ),
        ),
      ),
      body: BlocBuilder<OnboardCubit, OnboardState>(
        buildWhen: (previous, current) {
          return previous.pageController != current.pageController;
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 90.h),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome,',
                          style: TextStyles.regular(
                            16.sp,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          'Get set up on\nAwaaz App',
                          style: TextStyles.bold(
                            32.sp,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    BlocBuilder<OnboardCubit, OnboardState>(
                        builder: (context, state) => GestureDetector(
                              onTap: () async {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: const Color(0xFF2C2C2C),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                  ),
                                  builder: (context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            'Select Image Source',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          ListTile(
                                            leading: const Icon(
                                                Icons.camera_alt,
                                                color: Colors.white),
                                            title: const Text('Camera',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            onTap: () async {
                                              Navigator.pop(context);

                                              await context
                                                  .read<OnboardCubit>()
                                                  .onTapCamara(context);
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(
                                                Icons.photo_library,
                                                color: Colors.white),
                                            title: const Text('Gallery',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            onTap: () async {
                                              Navigator.pop(context);
                                              await context
                                                  .read<OnboardCubit>()
                                                  .onTapGallery(context);
                                            },
                                          ),
                                          const SizedBox(height: 8),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(5.r),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: state.profilePicture != null
                                            ? AppColors.lightGreenColor
                                            : AppColors.onboardTextFieldColor,
                                        width: 3)),
                                child: Container(
                                  height: 150.h,
                                  width: 150.h,
                                  decoration: BoxDecoration(
                                      image: state.profilePicture == null
                                          ? null
                                          : DecorationImage(
                                              fit: BoxFit.cover,
                                              image: Image.file(
                                                      state.profilePicture!)
                                                  .image),
                                      shape: BoxShape.circle,
                                      color: AppColors.onboardTextFieldColor,
                                      border: Border.all(
                                          color: state.profilePicture != null
                                              ? Colors.transparent
                                              : AppColors.actionBtnBgColor,
                                          width: 2.sp)),
                                  alignment: Alignment.center,
                                  child: state.profilePicture != null
                                      ? null
                                      : Wrap(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(7),
                                              decoration: BoxDecoration(
                                                  color: Color(
                                                    0xff3A3A3D,
                                                  ),
                                                  shape: BoxShape.circle),
                                              child: Assets
                                                  .icons.icAddImageGalary
                                                  .svg(
                                                      colorFilter:  const ColorFilter.mode(
                                                        Colors.white,
                                                        BlendMode.srcIn,
                                                      ),
                                                      width: 20,
                                                      height: 20,
                                                      fit: BoxFit.cover),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            )),
                  ],
                ),
                SizedBox(height: 30.h),
                BlocBuilder<OnboardCubit, OnboardState>(
                  buildWhen: (previous, current) =>
                      previous.userNameController != current.userNameController,
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
                        final response =
                            await context.read<OnboardCubit>().checkUserName();
                        setState(() {
                          userNameResponseMessage = response?.message ?? '';
                          isResponseSuccess = response?.status ?? false;
                        });
                      },
                      textStyle: TextStyles.medium(20.sp,
                          fontColor: AppColors.whiteColor),
                      suffixIcon: SizedBox(
                        height: 50,
                        width: 0,
                      ),
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.name,
                      hintText: 'Your name',
                      controller: state.userNameController!,
                    );
                  },
                ),
                (userNameResponseMessage != null &&
                        userNameResponseMessage != '' &&
                        state.userNameController!.text.trim().isNotEmpty)
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
                BlocBuilder<OnboardCubit, OnboardState>(
                  buildWhen: (previous, current) =>
                      previous.nameController != current.nameController,
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
                        // closeKeyboard();
                        // context
                        //     .read<OnboardCubit>()
                        //     .onTapName(context);
                      },
                      textStyle: TextStyles.medium(20.sp,
                          fontColor: AppColors.whiteColor),
                      suffixIcon: SizedBox(
                        height: 50,
                        width: 0,
                      ),
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.name,
                      hintText: 'Your nickname',
                      controller: state.nameController!,
                    );
                  },
                ),
                Gap(20.h),
                BlocBuilder<OnboardCubit, OnboardState>(
                  buildWhen: (previous, current) => previous != current,
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
                      hintText: 'Mobile number',
                      controller: state.mobileNumberController!,
                    );
                  },
                ),
                Gap(20.h),
                BlocBuilder<OnboardCubit, OnboardState>(
                  builder: (context, state) {
                    return CommonTextField(
                      radius: BorderRadius.circular(10.r),
                      autofocus: true,
                      readOnly: true,
                      cursorColor: AppColors.whiteColor,
                      fillColor: AppColors.onboardTextFieldColor,
                      hintTextStyle: TextStyles.medium(
                        20.sp,
                        fontColor: AppColors.textHintGrayColor,
                      ),
                      onChanged: (p0) {},
                      onSubmitted: (p0) {},
                      onTap: () {
                        context.read<OnboardCubit>().onDobSelect(context);
                      },
                      textStyle: TextStyles.medium(20.sp,
                          fontColor: AppColors.whiteColor),
                      suffixIcon: SizedBox(
                        height: 50,
                        width: 0,
                      ),
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.name,
                      hintText: 'Date of Birth',
                      controller:
                          state.birthDateController ?? TextEditingController(),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
