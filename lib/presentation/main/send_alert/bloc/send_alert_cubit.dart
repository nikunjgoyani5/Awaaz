import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:eagle_eye/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/utils/app_functions.dart';
import '../../../../core/utils/map_utils.dart';
import '../../../../core/widget/common_bottom_sheet.dart';
import '../../../../data/models/response_model.dart';
import '../../../../data/repositories/main_repo.dart';
import '../../../../routes/app_navigation.dart';
import '../../../../routes/app_routes.dart';
import '../../../../services/file_service.dart';
import '../../home/bloc/home_screen_bloc_cubit.dart';

part 'send_alert_cubit.freezed.dart';
part 'send_alert_state.dart';

class SendAlertCubit extends Cubit<SendAlertState> {
  SendAlertCubit() : super(const SendAlertState());

  // final ImagePicker _picker = ImagePicker();

  init() {
    emit(state.copyWith(
        profilePicture: null,
        videoFile: null,
        postTime: DateTime.now(),
        userLongitude: 0.0,
        userLatitude: 0.0,
        phoneNumberController: TextEditingController(),
        dateTimeController: TextEditingController(),
        fullNameController: TextEditingController(),
        locationController: TextEditingController(),
        descriptionController: TextEditingController(),
        isLoading: false,
        countryCode: '+91'));
  }

  Future validateField(BuildContext context, {bool? isUpdate, String? postId}) async {
    if (isUpdate ?? false) {
      if (state.descriptionController!.text.isEmpty) {
        AppFunctions.showToast('Please enter description');
      } else if (state.locationController!.text.isEmpty) {
        AppFunctions.showToast('Please enter location');
      } else if (state.phoneNumberController!.text.isEmpty) {
        AppFunctions.showToast('Please enter phone number');
      } else if (state.profilePicture == null) {
        AppFunctions.showToast('Please upload your missing essentials or loved ones picture.');
      } else {
        NavigatorRoute.navigateBack(context);
        await updateRescue(context: context, postId: postId ?? '');
      }
    } else {
      if (state.fullNameController!.text.isEmpty) {
        AppFunctions.showToast('Please enter name');
      } else if (state.locationController!.text.isEmpty) {
        AppFunctions.showToast('Select location');
      } else if (state.descriptionController!.text.isEmpty) {
        AppFunctions.showToast('Please enter description');
      } else if (state.postTime == null) {
        AppFunctions.showToast('Select date & time');
      } else if (state.phoneNumberController!.text.isEmpty) {
        AppFunctions.showToast('Please enter phone number');
      } else if (state.profilePicture == null) {
        AppFunctions.showToast('Please upload missing person picture');
      } else {
        await addRescuePost(context: context);
      }
    }
  }

  clearProfilePhoto() {
    emit(state.copyWith(
      profilePicture: null,
    ));
  }

  Future onDobSelect(BuildContext context) async {
    DateTime? pickedDate =
        await showDatePicker(context: context, firstDate: DateTime(1800, 1, 01), lastDate: DateTime.now());
    if (pickedDate != null) {
      emit(state.copyWith(
          dateTimeController: TextEditingController(text: DateFormat('dd/MM/yyyy').format(pickedDate)),
          postTime: pickedDate));
    }
  }

  Future getCurrentLatLonAndTime(BuildContext context) async {
    await MapUtils.getUserCurrentLocation(context, isOnTap: true);
    emit(state.copyWith(
        postTime: DateTime.now().toLocal(),
        userLatitude: MapUtils.position?.latitude ?? 0.0,
        userLongitude: MapUtils.position?.longitude ?? 0.0));
  }

  // Future getCurrentLatLonAndTime() async {
  //   await MapUtils.getUserCurrentLocation();
  //   emit(state.copyWith(
  //       userLatitude: MapUtils.position?.latitude ?? 0.0,
  //       userLongitude: MapUtils.position?.longitude ?? 0.0));
  // }

  setAddressFromMap(String address, {required double lat, required double long}) {
    emit(state.copyWith(
        locationController: TextEditingController(text: address), userLatitude: lat, userLongitude: long));
  }

  void getPhoneCode(String code) {
    emit(state.copyWith(countryCode: code));
  }

  Future<void> addRescuePost({
    required BuildContext context,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      Map<String, dynamic> data = {
        "longitude": state.userLongitude,
        "latitude": state.userLatitude,
        'lostItemName': state.fullNameController?.text ?? '',
        'countryCode': state.countryCode,
        'additionMobileNumber': state.phoneNumberController?.text ?? '',
        "address": state.locationController?.text ?? '',
        'additionalDetails': state.descriptionController?.text ?? '',
        "postType": 'rescue',
        "eventTime": state.postTime?.toIso8601String() ?? DateTime.now().toUtc().toIso8601String(),
        "attachment": await MultipartFile.fromFile(state.videoFile!.path),
        "thumbnail": await MultipartFile.fromFile(state.profilePicture!.path),
      };
      ResponseModel response = await MainRepository.postEvent(data: data);

      if (response.status == true) {
        AppFunctions.showToast(response.message);
        emit(state.copyWith(isLoading: false));
        context.read<HomeScreenBlocCubit>().changePageIndex(0);
        NavigatorRoute.navigateToRemoveUntil(context, AppRoutes.home);
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

  Future<void> updateRescue({
    required BuildContext context,
    required String postId,
  }) async {
    emit(state.copyWith(isLoading: true));
    AppFunctions.showToast('Updating rescue post');
    try {
      ResponseModel response = await MainRepository.updateRescue(data: {
        "eventPostId": postId,
        "description": state.descriptionController!.text,
        "longitude": state.userLatitude,
        "latitude": state.userLongitude,
        'address': state.locationController!.text,
        "eventTime": state.postTime ?? DateTime.now().toUtc(),
        "attachment": await MultipartFile.fromFile(state.profilePicture!.path),
        "thumbnail": await MultipartFile.fromFile(state.profilePicture!.path),
        "mobileNumber": state.phoneNumberController!.text,
        "countryCode": "+91"
      });
      debugPrint('response ${response.toString()}');
      if (response.status == true) {
        AppFunctions.showToast(response.message);
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
                  emit(state.copyWith(
                    profilePicture: File(res),
                    videoFile: File(res),
                  ));
                }
              },
            )));
  }

  Future<File> uint8ListToFile(Uint8List uint8List, String fileName) async {
    // Get the temporary directory of the app
    final tempDir = await getTemporaryDirectory();

    // Create a file in the temporary directory
    final file = File('${tempDir.path}/$fileName');

    // Write the Uint8List data to the file
    await file.writeAsBytes(uint8List);

    return file;
  }

  Future<void> generateThumbnail(File videoFileMain) async {
    try {
      final thumbnail = await VideoThumbnail.thumbnailData(
        video: videoFileMain.path,
        quality: 85, // Set the quality of the image
      );
      emit(
        state.copyWith(
          videoThumbnailImage: thumbnail,
        ),
      );

      int number = Random().nextInt(100000);
      File videoThumbnailImage = await uint8ListToFile(state.videoThumbnailImage!, 'thumbnail$number.jpg');
      emit(
        state.copyWith(videoThumbnailImageFile: videoThumbnailImage, profilePicture: videoThumbnailImage),
      );
    } catch (e) {
      debugPrint('Error generating thumbnail: $e');
    }
  }

  Future<void> onTapVideo(BuildContext context) async {
    await showAppBottomSheet(
      context,
      AppCommonBottomSheet(
        isOpenWithGradient: false,
        body: VideoPickerBottomSheet(
          onVideoSelected: (File videoFile) async {
            await generateThumbnail(videoFile);
            emit(state.copyWith(
              videoFile: videoFile,
            ));
          },
        ),
      ),
    );
  }

  void clearVideo() {
    emit(state.copyWith(videoFile: null));
  }

  Future<void> sendAlert({
    required File rescueImageOrVideo,
    required File rescueImageOrVideoThumbnail,
    required BuildContext context,
  }) async {
    emit(state.copyWith(isLoading: true));

    try {
      ResponseModel response = await MainRepository.postEvent(data: {
        "longitude": state.userLongitude,
        "latitude": state.userLatitude,
        'lostItemName': 'bgsdcuy',
        'countryCode': '+91',
        'mobileNumber': '9924617645',
        "title": 'lala',
        "address": 'rfaf',
        'description': state.descriptionController?.text ?? '',
        "postType": 'rescue',
        "eventTime": state.postTime?.toIso8601String() ?? DateTime.now().toUtc().toIso8601String(),
        "attachment": await MultipartFile.fromFile(rescueImageOrVideo.path),
        "thumbnail": await MultipartFile.fromFile(rescueImageOrVideoThumbnail.path),
      });
      if (response.status == true) {
        AppFunctions.showToast(
          response.message,
          color: AppColors.whiteColor,
          backgroundColor: AppColors.blackColor,
        );
        emit(state.copyWith(isLoading: false));
        context.read<HomeScreenBlocCubit>().changePageIndex(1);
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
