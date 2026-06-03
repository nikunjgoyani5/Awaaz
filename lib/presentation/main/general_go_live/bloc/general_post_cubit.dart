import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:textfield_tags/textfield_tags.dart';

import '../../../../core/utils/app_functions.dart';
import '../../../../core/utils/map_utils.dart';
import '../../../../data/models/draft_event_model.dart';
import '../../../../data/models/general_category_model.dart';
import '../../../../data/models/google_address_data_model.dart';
import '../../../../data/models/response_model.dart';
import '../../../../data/repositories/main_repo.dart';
import '../../../../routes/app_navigation.dart';
import '../../../../routes/app_routes.dart';
import '../../home/bloc/home_screen_bloc_cubit.dart';
import '../general_video_post.dart';

part 'general_post_cubit.freezed.dart';
part 'general_post_state.dart';

class GeneralPostCubit extends Cubit<GeneralPostState> {
  GeneralPostCubit() : super(GeneralPostState.initial());

  loading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  clearPostValue() {
    emit(
      state.copyWith(
          selectedSubCategory: null,
          postTime: null,
          selectedCategory: null,
          videoFile: null,
          videoThumbImageFile: null,
          isLoading: false,
          descriptionController: TextEditingController(),
          hashTagController: TextEditingController(),
          addressController: TextEditingController(),
          titleController: TextEditingController(),
          phoneNumberController: TextEditingController(),
          userLatitude: 0.0,
          userLongitude: 0.0,
          categoryList: [],
          countryCode: "+91",
          subCategoryList: [],
          stringTagController: StringTagController(),
          hashtagList: [],
          shareAnonymous: false),
    );
  }

  void setVideoFile(File videoFile, File videoThumbImageFile) {
    emit(state.copyWith(videoFile: videoFile, videoThumbImageFile: videoThumbImageFile));
    log("videoFile :- $videoFile \n videoThumbImageFile :- $videoThumbImageFile");
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

  Future getCurrentLatLonAndTime(BuildContext context) async {
    emit(state.copyWith(userLongitude: 0.0, userLatitude: 0.0));
    await MapUtils.getUserCurrentLocation(context, isOnTap: true);
    emit(state.copyWith(
        postTime: DateTime.now().toUtc(),
        userLatitude: MapUtils.position?.latitude ?? 0.0,
        userLongitude: MapUtils.position?.longitude ?? 0.0));
  }

  Future<void> getCategory() async {
    try {
      ResponseModel response = await MainRepository.generalEventCat();
      if (response.status == true) {
        GeneralCategoryModel generalCategoryModel = GeneralCategoryModel.fromJson(response.toJson());
        emit(state.copyWith(categoryList: generalCategoryModel.categorysModel ?? []));
        // AppFunctions.showToast(response.message);
      } else {
        AppFunctions.showToast(response.message);
      }
    } catch (e) {
      AppFunctions.showToast(e.toString());
      debugPrint('Cache Error ${e.toString()}');
    }
  }

  List<String> extractHashtags(String input) {
    final RegExp hashtagRegExp = RegExp(r'#[\w]+');
    return hashtagRegExp.allMatches(input).map((match) => match.group(0)!).toList();
  }

  Future<ResponseModel?> generalPostDraft(BuildContext context) async {
    List<String> hashTagList = extractHashtags(state.hashTagController!.text);
    emit(state.copyWith(isLoading: true, hashtagList: hashTagList));
    try {
      final response = await MainRepository.generalPostDraft(data: {
        "postType": "general_category",
        "latitude": state.userLatitude,
        "longitude": state.userLongitude,
        if (state.titleController?.text.isNotEmpty ?? false) "title": state.titleController!.text,
        if (state.descriptionController?.text.isNotEmpty ?? false)
          "additionalDetails": state.descriptionController!.text,
        "eventTime": DateTime.now().toUtc().toIso8601String(),
        if (state.addressController?.text.isNotEmpty ?? false) "address": state.addressController!.text,
        "countryCode": state.countryCode,
        "additionMobileNumber": state.phoneNumberController!.text,
        "attachment": await MultipartFile.fromFile(state.videoFile?.path ?? ''),
        "thumbnail": await MultipartFile.fromFile(state.videoThumbImageFile?.path ?? ''),
        "hashTags[]": "",
        "shareAnonymous": false,
        if (state.selectedCategory?.id?.isNotEmpty ?? false) "mainCategoryId": state.selectedCategory?.id,
        if (state.selectedSubCategory?.id?.isNotEmpty ?? false) "subCategoryId": state.selectedSubCategory?.id,
      });
      if (response.status == true) {
        AppFunctions.navigatorKey.currentContext?.read<HomeScreenBlocCubit>().changePageIndex(1);
        NavigatorRoute.navigateToRemoveUntil(AppFunctions.navigatorKey.currentContext!, AppRoutes.home);

        clearPostValue();
      }
      AppFunctions.showToast(response.message);
      emit(state.copyWith(isLoading: false));
      return response;
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      AppFunctions.showToast(e.toString());
      return null;
    }
  }

  void selectLocationGen({required String add, required double lati, required double logi}) {
    emit(state.copyWith(userLatitude: lati, userLongitude: logi, addressController: TextEditingController(text: add)));
  }

  Future<ResponseModel?> generalPostCreate(BuildContext context, Function? onSubmit) async {
    try {
      final response = await MainRepository.generalAddPostApi(data: {
        "postType": "general_category",
        "latitude": state.userLatitude,
        "longitude": state.userLongitude,
        "title": state.titleController!.text,
        "additionalDetails": state.descriptionController!.text,
        "eventTime": DateTime.now().toUtc().toIso8601String(),
        "address": state.addressController!.text,
        "countryCode": state.countryCode,
        "additionMobileNumber": state.phoneNumberController!.text,
        "attachment": await MultipartFile.fromFile(state.videoFile?.path ?? ''),
        "thumbnail": await MultipartFile.fromFile(state.videoThumbImageFile?.path ?? ''),
        "hashTags[]": "",
        "shareAnonymous": false,
        "mainCategoryId": state.selectedCategory?.id,
        "subCategoryId": state.selectedSubCategory?.id,
      });
      if (response.status == true) {
        if (onSubmit != null) {
          onSubmit(false);
        }
        context.read<HomeScreenBlocCubit>().changePageIndex(1);
        NavigatorRoute.navigateToRemoveUntil(context, AppRoutes.home);
        clearPostValue();
      } else {
        if (onSubmit != null) {
          onSubmit(false);
        }
      }
      AppFunctions.showToast(response.message);
      return response;
    } catch (e) {
      AppFunctions.showToast(e.toString());
      // log("Check Username error is here :- $e");
      return null;
    }
  }

  Future<void> createDraftToPost({
    required DraftData draftData,
    required BuildContext context,
    Function? onSubmit,
  }) async {
    // emit(state.copyWith(isLoading: true));
    // emit(state.copyWith(isLoading: true, hashtagList: hashTagList));
    try {
      ResponseModel response = await MainRepository.generalAddPostApi(data: {
        "postType": "general_category",
        "latitude": state.userLatitude,
        "longitude": state.userLongitude,
        "title": state.titleController!.text,
        "additionalDetails": state.descriptionController!.text,
        "eventTime": DateTime.now().toUtc().toIso8601String(),
        "address": state.addressController!.text,
        "countryCode": state.countryCode,
        "additionMobileNumber": state.phoneNumberController!.text,
        "attachmentUrl": draftData.attachment,
        "thumbnailUrl": draftData.thumbnail,
        "hashTags[]": "",
        "shareAnonymous": false,
        'userPostDraftId': draftData.id,
        "mainCategoryId": state.selectedCategory?.id,
        "subCategoryId": state.selectedSubCategory?.id,
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

  setDraftData({required BuildContext context, DraftData? draftData}) async {
    NavigatorRoute.navigateBack(context);

    // getUsersCount(
    //     latitude: draftData?.latitude ?? 0,
    //     longitude: draftData?.longitude ?? 0,
    //     kmRadius: PrefService.getInt(PrefService.userRadius));

    if (state.categoryList.isEmpty) {
      await getCategory();
    }
    CategorysModel? categorysModel;
    SubCategory? subCategory;
    if (draftData?.mainCategoryId != null) {
      categorysModel =
          state.categoryList.firstWhere((e) => e.id == draftData?.mainCategoryId, orElse: () => CategorysModel());
      selectCat(categorysModel);
      if (draftData?.subCategoryId != null) {
        subCategory = state.subCategoryList.firstWhere(
          (element) => element.id == draftData?.subCategoryId,
          orElse: () => SubCategory(),
        );
        selectSub(subCategory);
      }
    }

    emit(
      state.copyWith(
        selectedCategory: categorysModel,
        selectedSubCategory: subCategory,
        titleController: TextEditingController(text: draftData?.title ?? ''),
        descriptionController: TextEditingController(text: draftData?.additionalDetails ?? ''),
        hashTagController: TextEditingController(text: draftData?.hashTags?.join(',')),
        shareAnonymous: draftData?.shareAnonymous ?? false,
        hashtagList: draftData?.hashTags ?? [],
        addressController: TextEditingController(text: draftData?.address ?? ""),
        phoneNumberController: TextEditingController(text: draftData?.additionMobileNumber ?? ""),
        userLatitude: draftData?.latitude ?? 0.0,
        userLongitude: draftData?.longitude ?? 0.0,
        countryCode: draftData?.countryCode ?? "+091",
      ),
    );
    Navigator.push(
      AppFunctions.navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (context) => GeneralVideoPostScreen(draftData: draftData),
      ),
    );
  }

  void selectCat(CategorysModel value) {
    emit(state.copyWith(selectedCategory: value, subCategoryList: value.subCategories ?? []));
  }

  bool getAddressWatermarkValue() {
    return state.isShowWatermarkAddress;
  }

  void selectSub(SubCategory value) {
    emit(state.copyWith(selectedSubCategory: value));
  }

  void clearSubCat() {
    emit(state.copyWith(selectedSubCategory: null));
  }

  void selectCountryCode(String value) {
    emit(state.copyWith(countryCode: value));
  }

  void updateState(GeneralPostState newState) {
    emit(newState);
  }
}
