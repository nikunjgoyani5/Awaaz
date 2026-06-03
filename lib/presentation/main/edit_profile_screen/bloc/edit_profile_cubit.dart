import 'package:dio/dio.dart';
import 'package:eagle_eye/core/utils/app_prefrence.dart';
import 'package:eagle_eye/presentation/main/map_screen/bloc/map_screen_cubit.dart';
import 'package:eagle_eye/presentation/main/my_profile_screen/bloc/bloc/my_profile_cubit.dart';
import 'package:eagle_eye/routes/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_functions.dart';
import '../../../../core/widget/common_bottom_sheet.dart';
import '../../../../data/models/my_profile_model.dart';
import '../../../../data/models/response_model.dart';
import '../../../../data/repositories/main_repo.dart';
import '../../../../services/file_service.dart';

part 'edit_profile_cubit.freezed.dart';
part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(const EditProfileState());

  //Get Profile picture
  Future onTapProfile(BuildContext context) async {
    await showAppBottomSheet(
        context,
        AppCommonBottomSheet(
            isOpenWithGradient: false,
            body: ImagePickerWidget(
              callback: (PickerMode pickerMode) async {
                String? res = await FileService.pickFile(pickerMode);
                NavigatorRoute.navigateBack(context);
                if (res != null) {
                  emit(state.copyWith(profilePicture: File(res)));
                }
              },
            )));
  }

  clearProfilePhoto(BuildContext context) async {
    // Clear both local file and URL
    emit(state.copyWith(profilePicture: null, profilePictureUrl: null));

    // Update profile with empty profile picture
    try {
      dynamic data = {'profilePicture': '', 'attachment': ''};
      ResponseModel response = await MainRepository.updateProfile(data: data);
      if (response.status == true) {
        await PrefService.setValue(PrefService.profileUrl, '');
        AppFunctions.showToast('Profile photo removed successfully');
        context.read<MyProfileCubit>().getProfileData();
        context.read<MyProfileCubit>().emit(
              context.read<MyProfileCubit>().state.copyWith(profilePic: ''),
            );
      } else {
        AppFunctions.showToast(response.message);
      }
    } catch (e) {
      debugPrint('Error clearing profile photo: ${e.toString()}');
      AppFunctions.showToast('Failed to remove profile photo');
    }
  }

  init() {
    emit(state.copyWith(
        profilePicture: null,
        nameController: TextEditingController(),
        userNameController: TextEditingController(),
        dob: null,
        dobNameController: TextEditingController(),
        profilePictureUrl: ""));
    setProfileData();
  }

  setProfileData() {
    String name = PrefService.getString(PrefService.name);
    String userName = PrefService.getString(PrefService.userName);
    String profileImageUrl = PrefService.getString(PrefService.profileUrl);
    String dob = PrefService.getString(PrefService.dateOfBirth);
    emit(state.copyWith(
        nameController: TextEditingController(text: name),
        userNameController: TextEditingController(text: userName),
        profilePictureUrl: profileImageUrl,
        dobNameController: TextEditingController(text: dob)));
  }

  Future onDobSelect(BuildContext context) async {
    String dobText = state.dobNameController?.text ?? "";
    DateTime initialDate;

    if (dobText.isEmpty ||
        DateFormat('dd/MM/yyyy')
            .parse(dobText)
            .isAfter(DateTime.now().subtract(Duration(days: 16 * 365)))) {
      initialDate = DateTime.now().subtract(Duration(days: 16 * 365));
    } else {
      try {
        initialDate = DateFormat('dd/MM/yyyy').parse(dobText);
      } catch (e) {
        initialDate = DateTime.now().subtract(Duration(days: 16 * 365));
      }
    }
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1800, 1, 01),
      lastDate: DateTime.now().subtract(Duration(days: 16 * 365)),
    );
    if (pickedDate != null) {
      emit(state.copyWith(
          dobNameController: TextEditingController(
              text: DateFormat('dd/MM/yyyy').format(pickedDate)),
          dob: pickedDate));
    }
  }

  Future validateField(BuildContext context) async {
    if (state.nameController!.text.isEmpty) {
      AppFunctions.showToast('Please enter name');
    } else if (state.dobNameController!.text.isEmpty) {
      AppFunctions.showToast('Please enter valid date of birth');
    } else {
      await onTapSave(context);
    }
  }

  Future onTapSave(BuildContext context) async {
    emit(state.copyWith(isLoading: true));
    try {
      dynamic data = {
        if (state.dob != null) 'dateOfBirth': state.dob!.toUtc(),
        'name': state.nameController?.text ?? '',
        if (state.profilePicture != null)
          'profilePicture':
              await MultipartFile.fromFile(state.profilePicture!.path),
        if (state.profilePictureUrl != null &&
            state.profilePictureUrl!.isNotEmpty &&
            state.profilePicture == null)
          'attachment': state.profilePictureUrl
      };
      ResponseModel response = await MainRepository.updateProfile(data: data);
      debugPrint('Update Profile Data === ${response.body}');
      if (response.status == true) {
        MyProfile myProfile = MyProfile.fromJson(response.body);

        await PrefService.setValue(PrefService.name, myProfile.name ?? '');

        await PrefService.setValue(
            PrefService.dateOfBirth,
            myProfile.dateOfBirth != null
                ? DateFormat('dd/MM/yyyy')
                    .format(myProfile.dateOfBirth!.toLocal())
                : '');

        await PrefService.setValue(
            PrefService.profileUrl, myProfile.profilePicture ?? '');

        context.read<MapScreenCubit>().setProfilePic();
        context.read<MyProfileCubit>().setProfile();

        AppFunctions.showToast(response.message);

        // Update local state with new profile picture URL
        emit(state.copyWith(
            isLoading: false,
            profilePictureUrl: myProfile.profilePicture,
            profilePicture: null // Clear the local file since it's now uploaded
            ));

        context.read<MyProfileCubit>().getProfileData();
        context.read<MyProfileCubit>().getProfileDraftData();
        NavigatorRoute.navigateBack(context);
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
}
