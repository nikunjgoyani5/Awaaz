// import 'dart:io';

import 'dart:developer';

// import 'package:bloc/bloc.dart';
import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart';
import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/utils/app_functions.dart';
import 'package:eagle_eye/data/repositories/main_repo.dart';
import 'package:eagle_eye/presentation/main/home/bloc/home_screen_bloc_cubit.dart';
import 'package:eagle_eye/routes/app_navigation.dart';
import 'package:eagle_eye/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_prefrence.dart';
import '../../../../data/models/my_profile_model.dart';
import '../../../../data/models/response_model.dart';
import '../../../../services/file_service.dart';
import '../../../main/news_screen/bloc/news_screen_bloc_cubit.dart';

part 'onboard_cubit.freezed.dart';
part 'onboard_state.dart';

class OnboardCubit extends Cubit<OnboardState> {
  OnboardCubit() : super(const OnboardState.initial());

  init() {
    emit(state.copyWith(
        nameController: TextEditingController(),
        dayController: TextEditingController(),
        monthController: TextEditingController(),
        yearController: TextEditingController(),
        mobileNumberController: TextEditingController(),
        userNameController: TextEditingController(),
        isLoading: false,
        day: '',
        month: '',
        year: '',
        pageController: PageController(),
        profilePicture: null));
  }

  goToPage(int pageIndex) {
    state.pageController!.animateToPage(pageIndex,
        duration: Duration(milliseconds: 100),
        curve: Curves.fastEaseInToSlowEaseOut);
    emit(state.copyWith(currentPage: pageIndex));
  }

  // Name

  setNameFiledData() {
    String name = PrefService.getString(PrefService.name);
    emit(state.copyWith(nameController: TextEditingController(text: name)));
  }

  setUserNameFiledData() {
    String userName = PrefService.getString(PrefService.userName);
    emit(state.copyWith(
        userNameController: TextEditingController(text: userName)));
  }

  onTapName(BuildContext context) {
    if (PrefService.getBool(PrefService.appleLogin)) {
      /*Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) {
            return OnboardBirthdateScreen();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Slide transition from right to left
            final offsetAnimation = Tween<Offset>(
              begin: Offset(1.0, 0.0), // Start from the right side
              end: Offset.zero, // End at the normal position
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut, // Smooth curve for transition
            ));

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
      );*/
      state.pageController?.animateToPage(
        1,
        duration: Duration(milliseconds: 250),
        curve: Curves.fastLinearToSlowEaseIn,
      );
    } else {
      if (state.userNameController!.text.isEmpty) {
        AppFunctions.showToast('Please enter a username.');
      } else if (state.nameController!.text.isEmpty) {
        AppFunctions.showToast('Please enter a name.');
      } else {
        state.pageController?.animateToPage(
          1,
          duration: Duration(milliseconds: 250),
          curve: Curves.fastLinearToSlowEaseIn,
        );
        /*Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 800),
            pageBuilder: (context, animation, secondaryAnimation) {
              return OnboardBirthdateScreen();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              // Slide transition from right to left
              final offsetAnimation = Tween<Offset>(
                begin: Offset(1.0, 0.0), // Start from the right side
                end: Offset.zero, // End at the normal position
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut, // Smooth curve for transition
              ));

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );*/
      }
    }
  }

  // Birthdate
  onTapBirthdate(BuildContext context) {
    closeKeyboard();
    if (PrefService.getBool(PrefService.appleLogin)) {
      state.pageController?.animateToPage(
        2,
        duration: Duration(milliseconds: 250),
        curve: Curves.fastLinearToSlowEaseIn,
      );
      // NavigatorRoute.navigateTo(context, AppRoutes.onboardProfile);
    } else {
      if (state.dayController!.text.isEmpty) {
        AppFunctions.showToast('Please enter date.');
      } else if (state.monthController!.text.isEmpty) {
        AppFunctions.showToast('Please enter month.');
      } else if (state.yearController!.text.isEmpty) {
        AppFunctions.showToast('Please enter year.');
      } else {
        // NavigatorRoute.navigateTo(context, AppRoutes.onboardProfile);
        /*Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(
              milliseconds: 700,
            ), // Smooth transition time
            pageBuilder: (context, animation, secondaryAnimation) {
              return OnboardProfileScreen();
            },
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );*/
        state.pageController?.animateToPage(
          2,
          duration: Duration(milliseconds: 250),
          curve: Curves.fastLinearToSlowEaseIn,
        );
      }
    }
  }

  Future onDobSelect(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        firstDate: DateTime(1800, 1, 01),
        initialDate: DateTime(
            DateTime.now().year - 16, DateTime.now().month, DateTime.now().day),
        lastDate: DateTime(
            DateTime.now().year - 16, DateTime.now().month, DateTime.now().day),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: AppColors.textHintGrayColor,
                onPrimary: Colors.white,
                surface: Colors.black,
                onSurface: Colors.white,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textHintGrayColor,
                ),
              ),
              dialogTheme: DialogThemeData(backgroundColor: Colors.grey[900]),
            ),
            child: child!,
          );
        });

    if (pickedDate != null) {
      emit(state.copyWith(
        dayController: TextEditingController(text: '${pickedDate.day}'),
        monthController: TextEditingController(text: '${pickedDate.month}'),
        yearController: TextEditingController(text: '${pickedDate.year}'),
        birthDateController: TextEditingController(
            text: DateFormat('dd/MM/yyyy').format(pickedDate)),
      ));
    }
  }

  // Profile picture
  clearPhoto() {
    emit(state.copyWith(profilePicture: null));
  }

  Future onTapCamara(BuildContext context) async {
    String? res = await FileService.pickFile(PickerMode.camera);
    if (res != null) {
      emit(state.copyWith(profilePicture: File(res)));
    }
  }

  Future onTapGallery(BuildContext context) async {
    String? res = await FileService.pickFile(PickerMode.gallery);
    if (res != null) {
      emit(state.copyWith(profilePicture: File(res)));
    }
  }

  Future onTapProfile(BuildContext context,
      {bool skipProfilePhoto = false}) async {
    emit(state.copyWith(isLoading: true));
    dynamic data = {
      if (state.yearController!.text != "" &&
          state.monthController!.text != "" &&
          state.dayController!.text != "")
        'dateOfBirth': DateTime(
                int.parse(state.yearController!.text),
                int.parse(state.monthController!.text),
                int.parse(state.dayController!.text))
            .toUtc(),
      'name': state.nameController?.text ?? 'User',
      'username': state.userNameController?.text ?? 'username',
      if (skipProfilePhoto == false)
        'profilePicture': state.profilePicture != null
            ? await MultipartFile.fromFile(state.profilePicture!.path)
            : '',
    };
    try {
      ResponseModel response = await MainRepository.updateProfile(data: data);
      debugPrint('Update Profile Data === ${response.body}');
      if (response.status == true) {
        // await OneSignalNotificationService.requestNotificationPermission();
        MyProfile myProfile = MyProfile.fromJson(response.body);
        PrefService.setValue(PrefService.email, myProfile.email ?? '');
        PrefService.setValue(PrefService.mobileNumber, myProfile.phone ?? '');
        PrefService.setValue(PrefService.name, myProfile.name ?? '');
        PrefService.setValue(PrefService.userName, myProfile.userName ?? '');
        PrefService.setValue(
            PrefService.dateOfBirth,
            (myProfile.dateOfBirth != null)
                ? DateFormat('dd/MM/yyyy')
                    .format(myProfile.dateOfBirth!.toLocal())
                : '');
        PrefService.setValue(PrefService.userId, myProfile.id ?? '');
        PrefService.setValue(
            PrefService.profileUrl, myProfile.profilePicture ?? '');
        PrefService.setValue(PrefService.isLogin, true);
        AppFunctions.showToast(response.message);
        context.read<NewsScreenBlocCubit>().init();
        context.read<NewsScreenBlocCubit>().getNewsEvents('latest');
        context.read<HomeScreenBlocCubit>().changePageIndex(0);
        NavigatorRoute.navigateToRemoveUntil(context, AppRoutes.home);
        emit(state.copyWith(isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false));
        AppFunctions.showToast(response.message);
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      debugPrint('Cache Error ${e.toString()}');
      AppFunctions.showToast(e.toString());
    }
  }

  onChangeDate(String val) {
    emit(state.copyWith(dayController: TextEditingController(text: val)));
  }

  onChangeMonth(String val) {
    emit(state.copyWith(monthController: TextEditingController(text: val)));
  }

  onSelectBirthdate() {}

  onChangeYear(String val) {
    emit(state.copyWith(yearController: TextEditingController(text: val)));
  }

  onChangeCountry(Country country) {
    emit(state.copyWith(countryData: country));
  }

  Future<ResponseModel?> checkUserName() async {
    try {
      final response = await MainRepository.checkUserName(data: {
        "username": state.userNameController!.text,
      });
      return response;
    } catch (e) {
      log("Check Username error is here :- $e");
      return null;
    }
  }
}
