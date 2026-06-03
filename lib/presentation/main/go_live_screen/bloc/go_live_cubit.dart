import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eagle_eye/core/widget/category_model.dart';
import 'package:eagle_eye/data/models/draft_event_model.dart';
import 'package:eagle_eye/presentation/main/home/bloc/home_screen_bloc_cubit.dart';
import 'package:eagle_eye/routes/app_navigation.dart';
import 'package:eagle_eye/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:http/http.dart' as http;

import '../../../../core/utils/app_functions.dart';
import '../../../../core/utils/app_prefrence.dart';
import '../../../../core/utils/map_utils.dart';
import '../../../../data/models/google_address_data_model.dart';
import '../../../../data/models/response_model.dart';
import '../../../../data/repositories/main_repo.dart';
import '../video_post_screen.dart';

part 'go_live_cubit.freezed.dart';
part 'go_live_state.dart';

class GoLiveCubit extends Cubit<GoLiveState> {
  GoLiveCubit() : super(const GoLiveState());

  clearPostValue() {
    emit(
      state.copyWith(
          postTime: null,
          isLoading: false,
          descriptionController: TextEditingController(),
          hashTagController: TextEditingController(),
          // addressController: TextEditingController(),
          titleController: TextEditingController(),
          selectedPostCategory: null,
          categoryList: [],
          stringTagController: StringTagController(),
          hashtagList: [],
          videoFile: null,
          videoThumbImageFile: null,
          shareAnonymous: false),
    );
  }

  Future getCurrentLatLonAndTime(BuildContext context) async {
    emit(state.copyWith(userLongitude: 0.0, userLatitude: 0.0));
    await MapUtils.getUserCurrentLocation(context, isOnTap: true);
    emit(state.copyWith(
        postTime: DateTime.now().toUtc(),
        userLatitude: MapUtils.position?.latitude ?? 0.0,
        userLongitude: MapUtils.position?.longitude ?? 0.0));
  }

  updateSelectedEventCategory(Category? value) {
    emit(state.copyWith(selectedPostCategory: value));
  }

  void changeShareAnonymouslyValue(bool value) {
    emit(state.copyWith(
      shareAnonymous: value,
    ));
  }

  void setVideoFile(File videoFile, File videoThumbImageFile) {
    emit(state.copyWith(videoFile: videoFile, videoThumbImageFile: videoThumbImageFile));
    log("videoFile :- $videoFile \n videoThumbImageFile :- $videoThumbImageFile");
  }

  Future<void> validatePostFields(
      {required File attachmentVideo,
      required File attachmentThumbnailImageFile,
      required BuildContext context,
      Function? onSubmit}) async {
    /*if (state.descriptionController!.text.isEmpty) {
      AppFunctions.showToast('Please enter description');
    } else if (state.hashTagController!.text.isEmpty) {
      AppFunctions.showToast('Please enter hashtag');
    } else {*/
    await createEventPost(
        attachmentVideo: attachmentVideo, context: context, attachmentThumbnailImageFile: attachmentThumbnailImageFile);
    // }
  }

  setDraftData({required BuildContext context, DraftData? draftData}) async {
    NavigatorRoute.navigateBack(context);

    getUsersCount(
        latitude: draftData?.latitude ?? 0,
        longitude: draftData?.longitude ?? 0,
        kmRadius: PrefService.getInt(PrefService.userRadius));
    if (state.categoryList.isEmpty) {
      await getReactionList();
    }

    emit(
      state.copyWith(
        selectedPostCategory:
            state.categoryList.firstWhere((e) => e.id == draftData?.postCategoryId, orElse: () => Category()),
        titleController: TextEditingController(text: draftData?.title ?? ''),
        descriptionController: TextEditingController(text: draftData?.additionalDetails ?? ''),
        hashTagController: TextEditingController(text: draftData?.hashTags?.join(',')),
        shareAnonymous: draftData?.shareAnonymous ?? false,
        hashtagList: draftData?.hashTags ?? [],
      ),
    );
    // } else {
    //   emit(
    //     state.copyWith(
    //       selectedPostCategory: state.categoryList.firstWhere(
    //           (e) => e.id == draftData?.postCategoryId,
    //           orElse: () => Category()),
    //       titleController: TextEditingController(text: draftData?.title ?? ''),
    //       descriptionController:
    //           TextEditingController(text: draftData?.additionalDetails ?? ''),
    //       hashTagController:
    //           TextEditingController(text: draftData?.hashTags?.join(',')),
    //       shareAnonymous: draftData?.shareAnonymous ?? false,
    //       hashtagList: draftData?.hashTags ?? [],
    //     ),
    //   );
    // }
    Navigator.push(
      AppFunctions.navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (context) => VideoPostScreen(draftData: draftData),
      ),
    );
  }

  Future<void> saveDraftPost(BuildContext context
      // {
      // required File attachmentVideo,
      // required File attachmentThumbnailImageFile,
      // required BuildContext context,
      // Function? onSubmit,
      // }
      ) async {
    /*if (state.descriptionController!.text.isEmpty) {
      AppFunctions.showToast('Please enter description');
    } else if (state.hashTagController!.text.isEmpty) {
      AppFunctions.showToast('Please enter hashtag');
    } else {*/
    await createEventDraftPost(context
        // attachmentVideo: attachmentVideo,
        // context: context,
        // attachmentThumbnailImageFile: attachmentThumbnailImageFile,
        // onSubmit: onSubmit,
        );
    // }
  }

  List<String> extractHashtags(String input) {
    final RegExp hashtagRegExp = RegExp(r'#[\w]+');
    return hashtagRegExp.allMatches(input).map((match) => match.group(0)!).toList();
  }

  Future<void> createEventPost(
      {required File attachmentVideo,
      required File attachmentThumbnailImageFile,
      required BuildContext context,
      Function? onSubmit}) async {
    // emit(state.copyWith(isLoading: true));
    List<String> hashTagList = extractHashtags(state.hashTagController!.text);
    emit(state.copyWith(hashtagList: hashTagList));
    // emit(state.copyWith(isLoading: true, hashtagList: hashTagList));
    log("=== ${state.hashtagList}");
    try {
      ResponseModel response = await MainRepository.postEvent(data: {
        "longitude": state.userLongitude,
        "latitude": state.userLatitude,
        if (state.titleController?.text.isNotEmpty ?? false) "title": state.titleController!.text,

        /// CURRENT IT IS COMMENTED BECAUSE VEDANT SIR TOLD THIS.
        /* if (state.addressController?.text.isNotEmpty ?? false)
          "address": state.addressController!.text,*/
        if (state.selectedPostCategory?.id?.isNotEmpty ?? false) "postCategoryId": state.selectedPostCategory?.id ?? '',
        if (state.descriptionController?.text.isNotEmpty ?? false)
          "additionalDetails": state.descriptionController!.text,
        "hashTags": state.hashtagList,
        "shareAnonymous": state.shareAnonymous,
        "postType": 'incident',
        "eventTime": state.postTime?.toIso8601String() ?? DateTime.now().toUtc().toIso8601String(),
        "attachment": await MultipartFile.fromFile(attachmentVideo.path),
        "thumbnail": await MultipartFile.fromFile(attachmentThumbnailImageFile.path),
      });
      if (response.status == true) {
        AppFunctions.showToast(response.message);
        // emit(state.copyWith(isLoading: false));
        if (onSubmit != null) {
          onSubmit(false);
        }
        context.read<HomeScreenBlocCubit>().changePageIndex(1);
        NavigatorRoute.navigateToRemoveUntil(context, AppRoutes.home);
      } else {
        if (onSubmit != null) {
          onSubmit(false);
        }
        // emit(state.copyWith(isLoading: false));
        AppFunctions.showToast(response.message);
      }
    } catch (e) {
      // emit(state.copyWith(isLoading: false));
      debugPrint('Cache Error ${e.toString()}');
      AppFunctions.showToast(e.toString());
    }
  }

  Future<void> createDraftToPost({
    required DraftData draftData,
    required BuildContext context,
    Function? onSubmit,
  }) async {
    // emit(state.copyWith(isLoading: true));
    List<String> hashTagList = extractHashtags(state.hashTagController!.text);
    emit(state.copyWith(hashtagList: hashTagList));
    // emit(state.copyWith(isLoading: true, hashtagList: hashTagList));
    log("=== ${state.hashtagList}");
    try {
      ResponseModel response = await MainRepository.postEvent(data: {
        "longitude": draftData.longitude,
        "latitude": draftData.latitude,
        if (state.titleController?.text.isNotEmpty ?? false) "title": state.titleController?.text,

        /// CURRENT IT IS COMMENTED BECAUSE VEDANT SIR TOLD THIS.
        /* if (state.addressController?.text.isNotEmpty ?? false)
          "address": state.addressController!.text,*/
        if ((state.selectedPostCategory != null && state.categoryList.contains(state.selectedPostCategory)))
          "postCategoryId": state.selectedPostCategory?.id ?? '',
        if (state.descriptionController?.text.isNotEmpty ?? false)
          "additionalDetails": state.descriptionController!.text,
        "hashTags": state.hashtagList,
        "shareAnonymous": state.shareAnonymous,
        "postType": 'incident',
        "eventTime": /*state.postTime?.toIso8601String() ??*/
            DateTime.now().toUtc().toIso8601String(),
        'userPostDraftId': draftData.id,
        "attachmentUrl": draftData.attachment,
        "thumbnailUrl": draftData.thumbnail,
      });
      if (response.status == true) {
        AppFunctions.showToast(response.message);
        // emit(state.copyWith(isLoading: false));
        if (onSubmit != null) {
          onSubmit(false);
        }
        context.read<HomeScreenBlocCubit>().changePageIndex(1);
        NavigatorRoute.navigateToRemoveUntil(context, AppRoutes.home);
      } else {
        // emit(state.copyWith(isLoading: false));
        if (onSubmit != null) {
          onSubmit(false);
        }
        AppFunctions.showToast(response.message);
      }
    } catch (e) {
      // emit(state.copyWith(isLoading: false));.
      if (onSubmit != null) {
        onSubmit(false);
      }
      debugPrint('Cache Error ${e.toString()}');
      AppFunctions.showToast(e.toString());
    }
  }

  Future<void> createEventDraftPost(BuildContext context) async {
    // emit(state.copyWith(isLoading: true));
    List<String> hashTagList = extractHashtags(state.hashTagController!.text);
    emit(state.copyWith(isLoading: true, hashtagList: hashTagList));
    // emit(state.copyWith(hashtagList: hashTagList));
    try {
      ResponseModel response = await MainRepository.postDraftEvent(data: {
        "longitude": state.userLongitude,
        "latitude": state.userLatitude,
        if (state.titleController?.text.isNotEmpty ?? false) "title": state.titleController!.text,
        // "address": state.addressController!.text,
        if (state.selectedPostCategory?.id?.isNotEmpty ?? false) "postCategoryId": state.selectedPostCategory?.id ?? '',
        if (state.descriptionController?.text.isNotEmpty ?? false)
          "additionalDetails": state.descriptionController!.text,
        "hashTags": state.hashtagList,
        "shareAnonymous": state.shareAnonymous,
        "postType": 'incident',
        "eventTime": state.postTime?.toIso8601String() ?? DateTime.now().toUtc().toIso8601String(),
        "attachment": await MultipartFile.fromFile(state.videoFile?.path ?? ""),
        "thumbnail": await MultipartFile.fromFile(state.videoThumbImageFile?.path ?? ''),
      });
      if (response.status == true) {
        AppFunctions.navigatorKey.currentContext?.read<HomeScreenBlocCubit>().changePageIndex(1);
        NavigatorRoute.navigateToRemoveUntil(AppFunctions.navigatorKey.currentContext!, AppRoutes.home);
        clearPostValue();
      }
      AppFunctions.showToast(response.message);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      debugPrint('Cache Error ${e.toString()}');
      AppFunctions.showToast(e.toString());
    }
  }

  Future<void> getReactionList() async {
    emit(state.copyWith(isLoading: true));
    try {
      ResponseModel response = await MainRepository.getReactionList(value: '');
      if (response.status == true && response.body != null) {
        CategoryModel reactionsModel = CategoryModel.fromJson(response.toJson());
        List<Category> reactionCategoryList = reactionsModel.body ?? [];
        emit(state.copyWith(isLoading: false, categoryList: reactionCategoryList));
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

  loading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  Future<void> getAddressFromLatLang({double? latitude, double? longitude}) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latitude ?? state.userLatitude},${longitude ?? state.userLongitude}&key=AIzaSyA4LXDvgCM9A7jTRSexWE6aO6-5a924rM4'),
      );
      log('response.statusCode :- ${response.statusCode}');
      if (response.statusCode == 200) {
        GoogleAddressData googleAddressData = GoogleAddressData.fromJson(json.decode(response.body));

        log(jsonEncode(googleAddressData));

        if (googleAddressData.status == 'OK') {
          emit(state.copyWith(googleAddressData: googleAddressData));
          /*  emit(state.copyWith(
              addressController: TextEditingController(
                  text: '${googleAddressData.results?[0].formattedAddress}')));*/
        } else {
          emit(state.copyWith(googleAddressData: null));
          // emit(state.copyWith(addressController: TextEditingController()));
        }
      }
    } catch (e) {
      log('Error getting location: $e');
    }
  }

  Future<void> getUsersCount({
    required double latitude,
    required double longitude,
    required int kmRadius,
  }) async {
    try {
      ResponseModel model = await MainRepository.getUsersOfMyLocation(
        data: {'latitude': latitude, 'longitude': longitude, 'distance': 3},
      );
      emit(
        state.copyWith(totalUsers: (model.status) ? model.body['count'] : 0),
      );
    } catch (e) {
      emit(
        state.copyWith(totalUsers: 0),
      );
    }
  }

  bool getAddressWatermarkValue() {
    return state.isShowWatermarkAddress;
  }

  void updateState(GoLiveState newState) {
    emit(newState);
  }
}
