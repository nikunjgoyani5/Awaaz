import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:eagle_eye_admin/api/repository/event_repository.dart';
import 'package:eagle_eye_admin/api/repository/general_repository.dart';
import 'package:eagle_eye_admin/api/repository/reaction_and_category_repository.dart';
import 'package:eagle_eye_admin/controller/event_controller.dart';
import 'package:eagle_eye_admin/model/categories_model.dart';
import 'package:eagle_eye_admin/model/get_event_drafts_model.dart';
import 'package:eagle_eye_admin/model/get_filter_general_post.dart';
import 'package:eagle_eye_admin/model/response_model.dart';
import 'package:eagle_eye_admin/page/general_screen/component/add_new_general_dialog.dart';
import 'package:eagle_eye_admin/page/general_screen/component/general_filter_popup_dialog.dart';
import 'package:eagle_eye_admin/page/general_screen/component/general_location_and_calender_view.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/service/storage/storage_service.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/widget/dailoges.dart';
import 'package:eagle_eye_admin/widget/toast.dart';
import 'package:dio/dio.dart' as test;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:image_picker/image_picker.dart';
import '../page/dashboard_screen/components/location_dailoge.dart';

class GeneralController extends GetxController {
  TextEditingController generalSearchController = TextEditingController();
  TextEditingController generalTitleController = TextEditingController();
  TextEditingController generalDesController = TextEditingController();
  TextEditingController generalLatController = TextEditingController();
  TextEditingController generalLongController = TextEditingController();
  TextEditingController generalAddressController = TextEditingController();
  TextEditingController generalHashController = TextEditingController();
  TextEditingController generalCategoryController = TextEditingController();
  TextEditingController subCategoryNameController = TextEditingController();

  Color finalTotalGeneralContainerColor = AppColors.drawerBgColor;
  Color totalGeneralApproveContainerColor = AppColors.drawerBgColor;
  Color totalGeneralDisApproveContainerColor = AppColors.drawerBgColor;
  ScrollController dashboardGeneralScrollController = ScrollController();

  int selectedContainerValue = 0;

  double selectedSubTab = 5.1;
  RxBool loader = false.obs;

  bool isFilter = false;
  bool isGeneralSensitive = false;
  bool isDropDownOpen = false;

  DateTime focusedDay = DateTime.now();

  GlobalKey<FormState> subCategoryFormKey = GlobalKey();
  XFile? subCategoryIcon;

  Uint8List? subCategoryIconBytes;

  List filterListBool = [];
  final List<CalendarDatum> staticCalendarData = [
    CalendarDatum(date: DateTime(2024, 12, 1), approve: true, update: true),
    CalendarDatum(date: DateTime(2024, 12, 12), approve: true, update: true),
    CalendarDatum(date: DateTime(2024, 12, 22), approve: true, update: true),
  ];

  XFile? selectedImageOrVideo;
  XFile? selectedFile;

  Uint8List? selectedImageOrVideoBytes;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ScrollController createGeneralScrollController = ScrollController();

  XFile? thumbnailImage;
  Uint8List? thumbnailImageBytes;

  Timer? debounce;

  String? filterType;

  openAddGeneralDialog(
    bool isUser,
    BuildContext context,
  ) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AddNewGeneral(
          isUser: isUser,
        );
      },
    );
  }

  openGeneralFilterDialog(BuildContext context) {
    showDialog(
      barrierColor: AppColors.transparent,
      context: context,
      builder: (context) {
        return const GeneralFilterPopupDialog();
      },
    );
  }

  List<String> extractHashtags(String input) {
    final RegExp hashtagRegExp = RegExp(r'#[\w]+');
    return hashtagRegExp
        .allMatches(input)
        .map((match) => match.group(0)!)
        .toList();
  }

  onSelectCategory(String id) {
    if (selectedFilterCategoryList.contains(id)) {
      selectedFilterCategoryList.remove(id);
    } else {
      selectedFilterCategoryList.add(id);
    }
    update();
  }

  createNewGeneral(BuildContext context, ProgressLoader pl, bool isUser) async {
    if (selectedCategory == null) {
      showToast(
          context: context,
          title: 'General Post!',
          message: 'Please select post category',
          bgColor: AppColors.red);
      return;
    } else if (selectedSubCategory == null) {
      showToast(
          context: context,
          title: 'General Post!',
          message: 'Please select sub category',
          bgColor: AppColors.red);
      return;
    } else if (isUser == false && selectedImageOrVideo == null) {
      showToast(
          context: context,
          title: 'General Post!',
          message: 'Please select attachment',
          bgColor: AppColors.red);
      return;
    } else if (formKey.currentState?.validate() == true) {
      try {
        await pl.show();

        List hashTags = [];

        DateTime? postTime;

        if (isUser == true) {
          postTime = selectedGeneral.eventTime != null &&
                  selectedGeneral.eventTime!.isNotEmpty
              ? DateTime.parse(selectedGeneral.eventTime!).toLocal()
              : DateTime.now();
        } else {
          postTime = DateTime.now();
        }

        if (generalHashController.text.isNotEmpty) {
          hashTags = extractHashtags(generalHashController.text);
        }

        Uint8List? attachmentByte;

        if (selectedImageOrVideo != null) {
          attachmentByte = await selectedImageOrVideo!.readAsBytes();
        }

        var data = {
          'postType': 'general_category',
          'latitude': num.parse(generalLatController.text),
          'longitude': num.parse(generalLongController.text),
          'title': generalTitleController.text,
          if (generalDesController.text.isNotEmpty)
            'description': generalDesController.text,
          'eventTime': postTime.toUtc().toIso8601String(),
          if (generalAddressController.text.isNotEmpty)
            'address': generalAddressController.text,
          if (isUser == true) 'userId': selectedGeneral.userId ?? '',
          if (isUser == true) 'userRequestedEventId': selectedGeneral.id ?? '',
          'isSensitiveContent': isGeneralSensitive,
          'mainCategoryId': selectedCategory?.id ?? '',
          'subCategoryId': selectedSubCategory?.id ?? '',
          if (isUser == true) 'attachment': selectedGeneral.attachment ?? '',
          if (isUser == true) 'thumbnail': selectedGeneral.thumbnail ?? '',
          "isDirectAdminPost": isUser == true ? false : true,
          if (isUser == false && selectedImageOrVideo != null)
            'gallaryAttachment': test.MultipartFile.fromBytes(
              attachmentByte ?? Uint8List(0),
              filename: selectedImageOrVideo!.name,
            ),
          'hashTags[]': hashTags,
          if (isUser == false && thumbnailImage != null)
            'gallaryThumbnail': test.MultipartFile.fromBytes(
                thumbnailImageBytes ?? Uint8List(0),
                filename: 'thumbnail.png'),
        };

        log('Create post Data :- $data');

        ResponseModel res = await GeneralPostRepository.createGeneralPost(
            context: context, data: data);
        await pl.hide();
        if (res.status == true) {
          NavigatorRoute.navigateBack(context: context);
          showToast(context: context, title: 'Success', message: res.message);
          filterGeneralList.clear();
          pageNumber = 1;
          generalSearchController.clear();
          await getGeneralPostList(context: context);

          notifyUser(data: {
            "_id": res.body['_id']??"",
            "latitude": res.body['latitude']??"",
            "longitude": res.body["longitude"]??"",
            "title": res.body['title']??"",
            "description": res.body['description']??"",
            "eventTypeId": res.body['mainCategoryId']??"",
            "notificationType": "eventPost"
          }, context: context);
        } else {
          showToast(
              context: context,
              title: 'Error',
              message: res.message,
              bgColor: AppColors.red);
        }
      } catch (e) {
        await pl.hide();
        log('Create post :- $e');
      }
    }
  }

  bool isSubCategoryOpen = false;
  createSubCategory(BuildContext context, ProgressLoader pl) async {
    if (subCategoryIcon == null) {
      showToast(
          context: context,
          title: 'Sub Category!',
          message: 'Please select attachment',
          bgColor: AppColors.red);
      return;
    } else if (subCategoryFormKey.currentState?.validate() == true) {
      try {
        await pl.show();
        Uint8List? attachmentByte;
        if (subCategoryIcon != null) {
          attachmentByte = await subCategoryIcon!.readAsBytes();
        }

        var data = {
          'eventName': subCategoryNameController.text,
          if (subCategoryIcon != null)
            'eventIcon': test.MultipartFile.fromBytes(
              attachmentByte ?? Uint8List(0),
              filename: subCategoryIcon!.name,
            ),
          'notificationCategotyName':
              selectedCategory?.notificationCategotyName ?? '',
        };

        log('Create sub  Category Data :- $data');

        ResponseModel res =
            await ReactionAndCategoryRepository.createSubCategoryForGeneral(
                context: context,
                data: data,
                categoryId: selectedCategory?.id ?? '');
        await pl.hide();
        if (res.status == true) {
          NavigatorRoute.navigateBack(context: context);

          showToast(context: context, title: 'Success', message: res.message);

          await getAllCategories(context: context);

          update();
        } else {
          showToast(
              context: context,
              title: 'Error',
              message: res.message,
              bgColor: AppColors.red);
        }
      } catch (e) {
        await pl.hide();
        log('Create sub Category :- $e');
      }
    }
  }

  Future<void> statusUpdateAPI(
      {required String postId,
      required bool isNotify,
      required String status,
      required BuildContext context}) async {
    try {
      loader.value = true;
      ResponseModel res = await EventRepository.eventStatusChange(
          context: context,
          eventPostId: postId,
          isSendNotification: isNotify,
          status: status);

      if (res.status == true) {
        filterGeneralList.clear();
        pageNumber = 1;

        generalSearchController.clear();
        await getGeneralPostList(context: context);

        showToast(
            title: 'General  Post Status',
            message: 'Status updated successfully',
            context: context);
      } else {
        showToast(
            title: 'General  Post Status',
            message: res.message,
            bgColor: AppColors.red,
            context: context);
        log('General  Post status :- $res');
      }
      update();
      loader.value = false;
    } catch (e) {
      loader.value = false;
      log(' General  Post Status :- $e');
    }
  }

  openLocationDailoge(BuildContext context) async {
    showDialog<bool>(
      context: context,
      routeSettings: const RouteSettings(name: '/event/location'),
      builder: (context) {
        return const LocationDailoge();
      },
    ).then(
      (value) async {
        if (value == true) {
          filterGeneralList.clear();
          pageNumber = 1;
          generalSearchController.clear();
          await getGeneralPostList(context: context);
        }
      },
    );
  }

  openVideoOrImageDialog({required BuildContext context}) async {
    showDialog(
      // barrierDismissible: false,
      context: context,
      routeSettings: const RouteSettings(name: '/event/videoOrImage'),
      builder: (context) {
        return PhotoOrVideoOptionDailoge(
          onPhotoTap: () async {
            selectedImageOrVideo = await pickMedia(MediaType.image);
            selectedImageOrVideoBytes =
                await selectedImageOrVideo!.readAsBytes();
            thumbnailImage = selectedImageOrVideo;
            thumbnailImageBytes = await selectedImageOrVideo!.readAsBytes();
            update();
            NavigatorRoute.navigateBack(context: context);
          },
          onVideoTap: () async {
            selectedImageOrVideo = await pickMedia(MediaType.video);

            if (selectedImageOrVideo != null) {
              XFile? thumbnailPath = await VideoThumbnail.thumbnailFile(
                video: selectedImageOrVideo!.path,
                quality: 75,
              );
              thumbnailImage = thumbnailPath;
              thumbnailImageBytes = await thumbnailPath.readAsBytes();
              selectedImageOrVideoBytes = await thumbnailPath.readAsBytes();
              update();
            }
            update();
            NavigatorRoute.navigateBack(context: context);
          },
        );
      },
    );
  }

  Future<XFile?> pickMedia(MediaType mediaType) async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedFile;

    if (mediaType == MediaType.image) {
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    } else if (mediaType == MediaType.video) {
      pickedFile = await picker.pickVideo(source: ImageSource.camera);
    }

    if (pickedFile != null) {
      String filePath = pickedFile.path;
      log("${mediaType == MediaType.image ? 'Image' : 'Video'} selected: $filePath");

      return pickedFile;
    } else {
      log("No ${mediaType == MediaType.image ? 'image' : 'video'} selected.");
    }
    return null;
  }

  List<Categorie> generalCategory = [];

  Categorie? selectedCategory;
  SubCategory? selectedSubCategory;

  List<SubCategory> subCategoryList = [];

  List<String> selectedFilterCategoryList = [];
  getAllCategories({
    required BuildContext context,
  }) async {
    try {
      // loader.value = true;

      ResponseModel res = await ReactionAndCategoryRepository.getAllCategories(
          postType: 'general_category', context: context);
      if (res.status == true) {
        CategoriesModel categoriesModel =
            CategoriesModel.fromJson(res.toJson());
        generalCategory.clear();
        filterListBool.clear();
        selectedFilterCategoryList.clear();
        generalCategory.addAll(categoriesModel.body!);
        filterListBool = List.generate(
          generalCategory.length,
          (index) => false,
        );
        for (int i = 0; i < generalCategory.length; i++) {
          selectedFilterCategoryList.add(generalCategory[i].id ?? "");
        }

        update();
        log('All Categories :- $generalCategory');
      } else {
        log('Get All Categories :- ${res.message}');
      }
      // loader.value = false;
    } catch (e) {
      // loader.value = false;
      log('Get All Categories :- $e');
    }
  }

  generalPostPagination(BuildContext context) {
    paginationLoader.value = true;
    pageNumber++;
    generalSearchController.clear();
    getGeneralPostList(context: context);
    update();
  }

  setCreateGeneralData() {
    subCategoryList.clear();
    generalTitleController.text = selectedGeneral.title ?? '';
    generalDesController.text = selectedGeneral.description ?? '';

    generalHashController.text = selectedGeneral.hashTags
            ?.toString()
            .replaceAll('[', '')
            .replaceAll(']', '') ??
        '';

    generalAddressController.text = selectedGeneral.address ?? '';
    generalLatController.text = selectedGeneral.latitude?.toString() ?? '';
    generalLongController.text = selectedGeneral.longitude?.toString() ?? '';

    for (var element in generalCategory) {
      if (element.id == selectedGeneral.mainCategoryId) {
        selectedCategory = element;
      }
    }

    subCategoryList.addAll(selectedCategory?.subCategories ?? []);

    for (var element in subCategoryList) {
      if (element.id == selectedGeneral.subCategoryId) {
        selectedSubCategory = element;
      }
    }
    update();
  }

  clearGeneralData() {
    generalTitleController.clear();
    generalDesController.clear();
    generalLatController.clear();
    generalLongController.clear();
    generalHashController.clear();
    generalAddressController.clear();
    selectedCategory = null;
    selectedSubCategory = null;
    selectedImageOrVideo = null;
    selectedImageOrVideoBytes = null;
    selectedFile = null;

    thumbnailImage = null;
    thumbnailImageBytes = null;
    update();
  }

  int pageNumber = 1;
  RxBool paginationLoader = false.obs;
  GetFilterGeneralModel getFilterGeneralModel = GetFilterGeneralModel();
  List<FilterGeneral> filterGeneralList = [];
  FilterGeneral selectedGeneral = FilterGeneral();
  Future<void> getGeneralPostList(
      {required BuildContext context, String? status}) async {
    try {
      loader.value = paginationLoader.value == true ? false : true;

      DateTime utcDateTime = focusedDay.toUtc();

      String utcDate = utcDateTime.toIso8601String();

      double latitude = StorageService.getLatitude() ?? 0.0;
      double longitude = StorageService.getLongitude() ?? 0.0;

      ResponseModel res = await EventRepository.getFilterEventList(
          context: context,
          filterType: (selectedContainerValue == 0
              ? 'all'
              : selectedContainerValue == 1
                  ? 'Approved'
                  : 'Rejected'),
          page: pageNumber.toString(),
          postType: 'general_category',
          date: utcDate,
          isDate: true,
          longitude: longitude,
          latitude: latitude,
          isFilter: isFilter,
          distance: 500,
          search: generalSearchController.text,
          categoryList: jsonEncode(selectedFilterCategoryList));

      if (res.status == true) {
        getFilterGeneralModel = GetFilterGeneralModel.fromJson(res.toJson());

        filterGeneralList =
            filterGeneralList + (getFilterGeneralModel.body?.data ?? []);

        log('All general List:- $filterGeneralList');
        paginationLoader.value = false;
        loader.value = false;
      } else {
        filterGeneralList = filterGeneralList;
        log('Get All general :- $res');
        paginationLoader.value = false;
        loader.value = false;
      }
      update();
    } catch (e) {
      filterGeneralList = filterGeneralList;
      paginationLoader.value = false;
      loader.value = false;
      log('Get All general :- $e');
    }
  }

  RxBool draftLoader = false.obs;
  List<EventDraftData> draftList = [];
  EventDraftData selectedGeneralDraftData = EventDraftData();
  Future<void> getGeneralDraftList({
    required BuildContext context,
  }) async {
    try {
      draftLoader.value = true;

      ResponseModel res = await EventRepository.getEventDrafts(
          context: context, postType: 'general_category');

      if (res.status == true) {
        GetEventDraftsModel getEventDraftsModel =
            GetEventDraftsModel.fromJson(res.toJson());

        draftList = (getEventDraftsModel.body ?? []);

        log('All General Drafts List:- $draftList');

        draftLoader.value = false;
      } else {
        log('Get All General drafts :- $res');

        draftLoader.value = false;
      }
      update();
    } catch (e) {
      log('Get All General drafts :- $e');

      draftLoader.value = false;
    }
  }

  Future createDraftGeneral(
      BuildContext context, ProgressLoader pl, bool isUser) async {
    try {
      await pl.show();

      List hashTags = [];

      if (generalHashController.text.isNotEmpty) {
        hashTags = extractHashtags(generalHashController.text);
      }

      Uint8List? attachmentByte;

      if (selectedImageOrVideo != null) {
        attachmentByte = await selectedImageOrVideo!.readAsBytes();
      }

      var data = {
        'postType': 'general_category',
        if (generalLatController.text.isNotEmpty)
          'latitude': num.parse(generalLatController.text),
        if (generalLongController.text.isNotEmpty)
          'longitude': num.parse(generalLongController.text),
        if (generalTitleController.text.isNotEmpty)
          'title': generalTitleController.text,
        if (generalDesController.text.isNotEmpty)
          'description': generalDesController.text,
        'eventTime': DateTime.now().toUtc().toIso8601String(),
        if (generalAddressController.text.isNotEmpty)
          'address': generalAddressController.text,
        if (isUser == true) 'userId': selectedGeneral.userId ?? '',
        if (isUser == true) 'userRequestedEventId': selectedGeneral.id ?? '',
        'isSensitiveContent': isGeneralSensitive,
        if (selectedCategory?.id != null && selectedCategory!.id != '')
          'mainCategoryId': selectedCategory?.id ?? '',
        if (selectedSubCategory?.id != null && selectedSubCategory!.id != '')
          'subCategoryId': selectedSubCategory?.id ?? '',
        if (isUser == true) 'attachment': selectedGeneral.attachment ?? '',
        if (isUser == true) 'thumbnail': selectedGeneral.thumbnail ?? '',
        "isDirectAdminPost": isUser == true ? false : true,
        if (isUser == false && selectedImageOrVideo != null)
          'gallaryAttachment': test.MultipartFile.fromBytes(
            attachmentByte ?? Uint8List(0),
            filename: selectedImageOrVideo!.name,
          ),
        'hashTags[]': hashTags,
        if (isUser == false && thumbnailImage != null)
          'gallaryThumbnail': test.MultipartFile.fromBytes(
              thumbnailImageBytes ?? Uint8List(0),
              filename: 'thumbnail.png'),
      };

      log('Create Draft General Data :- $data');

      ResponseModel res = await GeneralPostRepository.createGeneralDraft(
          context: context, data: data);
      await pl.hide();
      if (res.status == true) {
        NavigatorRoute.navigateBack(context: context);
        showToast(
            context: context, title: 'Draft General', message: res.message);
      } else {
        showToast(
            context: context,
            title: 'Draft General',
            message: res.message,
            bgColor: AppColors.red);
      }
    } catch (e) {
      await pl.hide();
      log('Create Draft General :- $e');
    }
  }

  setDraftGeneralData() {
    subCategoryList.clear();
    generalTitleController.text = selectedGeneralDraftData.title ?? '';
    generalDesController.text = selectedGeneralDraftData.description ?? '';

    generalHashController.text = selectedGeneralDraftData.hashTags
            ?.toString()
            .replaceAll('[', '')
            .replaceAll(']', '') ??
        '';

    generalAddressController.text = selectedGeneralDraftData.address ?? '';
    generalLatController.text =
        selectedGeneralDraftData.latitude?.toString() ?? '';
    generalLongController.text =
        selectedGeneralDraftData.longitude?.toString() ?? '';

    for (var element in generalCategory) {
      if (element.id == selectedGeneralDraftData.mainCategoryId) {
        selectedCategory = element;
      }
    }

    subCategoryList.addAll(selectedCategory?.subCategories ?? []);

    for (var element in subCategoryList) {
      if (element.id == selectedGeneralDraftData.subCategoryId) {
        selectedSubCategory = element;
      }
    }
  }

  Future updateGeneralDraft(
      {required BuildContext context,
      required ProgressLoader pl,
      required String draftId}) async {
    if (selectedCategory == null) {
      showToast(
          context: context,
          title: 'General Post!',
          message: 'Please select post category',
          bgColor: AppColors.red);
      return;
    } else if (selectedSubCategory == null) {
      showToast(
          context: context,
          title: 'General Post!',
          message: 'Please select sub category',
          bgColor: AppColors.red);
      return;
    } else if (selectedImageOrVideo == null &&
        selectedGeneralDraftData.attachment == null) {
      showToast(
          context: context,
          title: 'General Post!',
          message: 'Please select attachment',
          bgColor: AppColors.red);
      return;
    } else if (formKey.currentState?.validate() == true) {
      try {
        await pl.show();

        List hashTags = [];
        bool sendThumbnail = true;

        if (generalHashController.text.isNotEmpty) {
          hashTags = extractHashtags(generalHashController.text);
        }

        if (thumbnailImage == null) {
          sendThumbnail = false;
        }

        DateTime postTime = selectedGeneralDraftData.eventTime != null &&
                selectedGeneralDraftData.eventTime!.isNotEmpty
            ? DateTime.parse(selectedGeneralDraftData.eventTime!).toLocal()
            : DateTime.now();

        var data = {
          'postType': 'general_category',
          'latitude': num.parse(generalLatController.text),
          'longitude': num.parse(generalLongController.text),
          'title': generalTitleController.text,
          if (generalDesController.text.isNotEmpty)
            'description': generalDesController.text,
          'eventTime': postTime.toUtc().toIso8601String(),
          if (generalAddressController.text.isNotEmpty)
            'address': generalAddressController.text,
          if (selectedGeneralDraftData.userId != null)
            'userId': selectedGeneralDraftData.userId ?? '',
          if (selectedGeneralDraftData.userRequestedEventId != null)
            'userRequestedEventId':
                selectedGeneralDraftData.userRequestedEventId ?? '',
          'mainCategoryId': selectedCategory?.id ?? '',
          'subCategoryId': selectedSubCategory?.id ?? '',
          if (selectedImageOrVideo == null)
            'attachment': selectedGeneralDraftData.attachment ?? '',
          if (sendThumbnail == false)
            'thumbnail': selectedGeneralDraftData.thumbnail ?? '',
          "isDirectAdminPost":
              selectedGeneralDraftData.isDirectAdminPost ?? false,
          'hashTags[]': hashTags,
          'adminPostDraftId': draftId,
          if (sendThumbnail == true)
            'gallaryThumbnail': test.MultipartFile.fromBytes(
                thumbnailImageBytes ?? Uint8List(0),
                filename: 'thumbnail.png'),
          if (selectedImageOrVideo != null)
            'gallaryAttachment': test.MultipartFile.fromBytes(
                selectedImageOrVideoBytes ?? Uint8List(0),
                filename: 'thumbnail.png'),
        };

        log('Create general post Data :- $data');

        ResponseModel res = await GeneralPostRepository.createGeneralPost(
          context: context,
          data: data,
        );
        await pl.hide();
        if (res.status == true) {
          NavigatorRoute.navigateBack(context: context);

          showToast(context: context, title: 'Success', message: res.message);
          selectedSubTab = 5.1;
          update();
          filterGeneralList.clear();
          pageNumber = 1;
          generalSearchController.clear();
          await getGeneralPostList(context: context);
        } else {
          showToast(
              context: context,
              title: 'General',
              message: res.message,
              bgColor: AppColors.red);
        }
      } catch (e) {
        await pl.hide();
        log('Create General :- $e');
      }
    }
  }

  Future<void> deleteDraft({
    required String draftId,
    required ProgressLoader pl,
    required BuildContext context,
  }) async {
    try {
      await pl.show();

      ResponseModel res = await EventRepository.deleteEventDraft(
          draftId: draftId, context: context);

      if (res.status == true) {
        await pl.hide();
        showToast(
            context: context, title: 'Delete Draft', message: res.message);
        await getGeneralDraftList(context: context);

        log('delete general drafts :- $res');
      } else {
        showToast(
            context: context,
            title: 'Delete Draft',
            message: res.message,
            bgColor: AppColors.red);
        log('delete general drafts :- $res');

        await pl.hide();
      }
      update();
    } catch (e) {
      showToast(
          context: context,
          title: 'Delete Draft',
          message: 'Something went wrong',
          bgColor: AppColors.red);

      log('delete  drafts :- $e');

      await pl.hide();
    }
  }


  Future<void> notifyUser({
    required  Map<String,dynamic> data,
    required BuildContext context,
  })
  async {
    try {




      ResponseModel res =
      await EventRepository.notifyUserAPI( context: context, data: data);

      if (res.status == true) {


        log('Notify user :- $res');
      } else {

        log('Notify user:- $res');


      }
      update();
    } catch (e) {


      log('Notify user :- $e');

    }
  }



  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }
}
