import 'dart:async';
import 'dart:developer';


import 'package:dio/dio.dart' as test;
import 'package:eagle_eye_admin/api/repository/event_repository.dart';
import 'package:eagle_eye_admin/api/repository/reaction_and_category_repository.dart';
import 'package:eagle_eye_admin/api/repository/rescue_repository.dart';
import 'package:eagle_eye_admin/controller/event_controller.dart';

import 'package:eagle_eye_admin/model/categories_model.dart';

import 'package:eagle_eye_admin/model/get_event_drafts_model.dart';
import 'package:eagle_eye_admin/model/get_filter_rescue_model.dart';
import 'package:eagle_eye_admin/model/response_model.dart';
import 'package:eagle_eye_admin/page/comment_screen/comment_dailoge.dart';
import 'package:eagle_eye_admin/page/dashboard_screen/components/location_dailoge.dart';
import 'package:eagle_eye_admin/page/rescue_screen/add_new_rescue.dart';
import 'package:eagle_eye_admin/page/rescue_screen/component/rescue_location_and_calender_view.dart';
import 'package:eagle_eye_admin/page/user_profile_screen/user_profile_view.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/service/storage/storage_service.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/widget/dailoges.dart';
import 'package:eagle_eye_admin/widget/toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;

class RescueController extends GetxController {
  TextEditingController rescueCategoryController = TextEditingController();
  TextEditingController rescueNameController = TextEditingController();
  TextEditingController rescueTitleController = TextEditingController();
  TextEditingController rescueDescriptionController = TextEditingController();
  TextEditingController rescueMobileNoController = TextEditingController();
  TextEditingController rescueLocationController = TextEditingController();
  TextEditingController rescueHashtagController = TextEditingController();
  TextEditingController rescueLikeController = TextEditingController();
  TextEditingController rescueShareController = TextEditingController();
  TextEditingController rescueViewController = TextEditingController();
  TextEditingController rescueCommentController = TextEditingController();
  TextEditingController rescueLatitudeController = TextEditingController();
  TextEditingController rescueLongitudeController = TextEditingController();

  ScrollController dashboardRescueScrollController = ScrollController();


  ScrollController addRescueScrollController = ScrollController();
  TimePickerEntryMode entryMode = TimePickerEntryMode.dial;
  Orientation? orientation;
  TextDirection textDirection = TextDirection.ltr;
  MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;
  bool use24HourTime = false;
  DateTime focusedDay = DateTime.now();
  DateTime selectedRescueDate = DateTime.now();
  DateTime rescueTimelineselectedDate = DateTime.now();
  int selectedContainerValue = 0;
  Uint8List? selectedFile;
  Uint8List? selectedAttachRescueFile;
  final formKey = GlobalKey<FormState>();

  String? fileName;
  TimeOfDay? selectedTime;
  Map<String, String>? selectedValue;
  Map<String, String>? selectedRescueReaction;
  Color finalTotalRescueContainerColor = AppColors.drawerBgColor;
  Color totalRescueApproveContainerColor = AppColors.drawerBgColor;
  Color totalRescueDisApproveContainerColor = AppColors.drawerBgColor;

  Categorie? selectedCategory;
  XFile? selectedImageOrVideo;
  Uint8List? selectedImageOrVideoBytes;

  XFile? thumbnailImage;
  Uint8List? thumbnailImageBytes;
  String countryCode = '+91';

  int mobileLength = 10;

  bool  isFilter = false;

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
              log("Thumbnail generated: $thumbnailPath");
            }

            update();
            NavigatorRoute.navigateBack(context: context);
          },
        );
      },
    );
  }




  final List<CalendarDatum> staticCalendarData = [
    CalendarDatum(date: DateTime(2024, 12, 1), approve: true, update: true),
    CalendarDatum(date: DateTime(2024, 12, 12), approve: true, update: true),
    CalendarDatum(date: DateTime(2024, 12, 22), approve: true, update: true),
  ];

  openLocationDailoge(BuildContext context) async {
    showDialog<bool>(
      context: context,
      routeSettings: const RouteSettings(name: '/rescue/location'),
      builder: (context) {
        return const LocationDailoge();
      },
    ).then((value) async {
      if(value== true ){
        filterRescue.clear();
        pageNumber = 1;
        rescueSearchController.clear();
        await getRescueList(context: context);
      }

    },);
  }

  openUserProfileView({required BuildContext context, required String userId}) async {
    showDialog(
      context: context,
      routeSettings: const RouteSettings(name: '/rescue/userProfile'),
      builder: (context) {
        return  UserProfileView(
          userId: userId,
        );
      },
    );
  }

  RxBool loader = false.obs;
  List<Categorie> eventCategory = [];

  getAllCategories({
    required BuildContext context,
  }) async
  {
    try {
      loader.value = true;
      ResponseModel res = await ReactionAndCategoryRepository.getAllCategories(
       postType: 'rescue',
          context: context);
      if (res.status == true) {
        CategoriesModel categoriesModel =
            CategoriesModel.fromJson(res.toJson());
        eventCategory.clear();
        eventCategory.addAll(categoriesModel.body!);
        update();
        log('All Categories :- $eventCategory');
      } else {
        log('Get All Categories :- ${res.message}');
      }
      loader.value = false;
    } catch (e) {
      loader.value = false;
      log('Get All Categories :- $e');
    }
  }



  openAddRescueDialog(String page, BuildContext context, {bool? isUser}) async {
    showDialog(
      barrierDismissible:  false,
      context: context,
      routeSettings: const RouteSettings(name: '/rescue/addRescue'),
      builder: (context) {
        return AddNewRescue(
          isUser: isUser ?? false,
          page: page,

        );
      },
    );
  }


  // openAttachFileDailoge(BuildContext context) async {
  //   showDialog(
  //     context: context,
  //     routeSettings:
  //         const RouteSettings(name: '/rescue/rescueDetail/attachFile'),
  //     builder: (context) {
  //       return const RescueAttachFileDailoge();
  //     },
  //   );
  // }

  // openAddTimeLineDailoge(BuildContext context, String page) async {
  //   showDialog(
  //     context: context,
  //     routeSettings:
  //         const RouteSettings(name: '/rescue/rescueDetail/addTimeLine'),
  //     builder: (context) {
  //       return RescueAddTimelineDailoge(
  //         page: page,
  //       );
  //     },
  //   );
  // }

  // openRescueUpdateDailoge(BuildContext context) async {
  //   showDialog(
  //     context: context,
  //     routeSettings:
  //         const RouteSettings(name: '/rescue/rescueDetail/rescueUpdate'),
  //     builder: (context) {
  //       return const RescueUpdateDailoge();
  //     },
  //   );
  // }

  openCommentDailoge(BuildContext context) async {
    showDialog(
      context: context,
      routeSettings: const RouteSettings(name: '/rescue/rescueComment'),
      builder: (context) {
        return const CommentDailoge();
      },
    );
  }
  Future<void> statusUpdateAPI(
      {required String rescueId,
        required bool isNotify,
        required String status,
        required BuildContext context}) async {
    try {
      loader.value = true;
      ResponseModel res = await EventRepository.eventStatusChange(

          context: context,
          eventPostId: rescueId, isSendNotification: isNotify, status: status);

      if (res.status == true) {
        filterRescue.clear();
        pageNumber = 1;

        rescueSearchController.clear();
      await  getRescueList(context: context);

        showToast(
            title: 'Rescue Status',
            message: 'Status updated successfully',
            context: context);
      } else {
        showToast(
            title: 'Rescue Status',
            message: res.message,
            bgColor: AppColors.red,
            context: context);
        log('Rescue status :- $res');
      }
      update();
      loader.value = false;
    } catch (e) {
      loader.value = false;
      log(' Rescue Status :- $e');
    }
  }


  setDraftRescueData() {
    rescueTitleController.text = selectedRescueDraftData.title ?? '';
    rescueDescriptionController.text = selectedRescueDraftData.description ?? '';
    rescueMobileNoController.text = selectedRescueDraftData.mobileNumber ?? '';
 countryCode = selectedRescueDraftData.countryCode??'+91';
 rescueNameController.text = selectedRescueDraftData.lostItemName??'';
    rescueHashtagController.text = selectedRescueDraftData.hashTags
        ?.toString()
        .replaceAll('[', '')
        .replaceAll(']', '') ??
        '';

    rescueLocationController.text = selectedRescueDraftData.address ?? '';
    rescueLatitudeController.text =
        selectedRescueDraftData.latitude?.toString() ?? '';
 rescueLongitudeController.text =
        selectedRescueDraftData.longitude?.toString() ?? '';

    timeDataInString = intl.DateFormat('dd/MM/yyyy hh:mm a').format(
        selectedRescueDraftData.eventTime != null &&
            selectedRescueDraftData.eventTime!.isNotEmpty
            ? DateTime.parse(selectedRescueDraftData.eventTime!).toLocal()
            : DateTime.now().toLocal());
    selectedRescueDate = selectedRescueDraftData.eventTime != null &&
        selectedRescueDraftData.eventTime!.isNotEmpty
        ? DateTime.parse(selectedRescueDraftData.eventTime!).toLocal()
        : DateTime.now();
    for (var element in eventCategory) {
      if (element.id == selectedRescueDraftData.postCategoryId) {
        selectedCategory = element;
      }
    }
    // update();
  }

  String rescueUpdateCount ='0';

  Future getPendingRescueCount({required BuildContext context}) async {
    try {
      loader.value = false;
      ResponseModel res = await RescueRepository.getAllPendingRescueUpdateCount(
        context: context,


      );
      if (res.status == true) {
        rescueUpdateCount = res.body['pendingCount']?.toString()??'0';
        log('All pending  rescue update count:- ${res.body['pendingCount']}');
        update();

      } else {

        log('All pending  rescue update count:- ${res.message}');
      }
      loader.value = false;

    } catch (e) {


      loader.value = false;

      log('All pending  rescue update count :- $e');
    }
  }



  clearResuceData() {
    rescueCategoryController.clear();
    rescueNameController.clear();
    rescueTitleController.clear();
    rescueDescriptionController.clear();
    rescueMobileNoController.clear();
    rescueLocationController.clear();
    selectedRescueDate = DateTime.now();
    selectedFile = null;
    selectedRescueReaction = null;
    update();
  }



  Future<DateTime?> pickDateTime(BuildContext context,
      {DateTime? initialDate})
  async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppColors.borderColor,
              hourMinuteColor: WidgetStateColor.resolveWith(
                (states) => AppColors.drawerBgColor,
              ),
              dialHandColor: AppColors.blue,
              dialBackgroundColor: AppColors.drawerBgColor,
              entryModeIconColor: AppColors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  return AppColors.white;
                }),
                overlayColor:
                    WidgetStateProperty.all(Colors.blue.withValues(alpha: 0.1)),
              ),
            ),
            materialTapTargetSize: tapTargetSize,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return null;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppColors.borderColor,
              hourMinuteColor: WidgetStateColor.resolveWith(
                (states) => AppColors.drawerBgColor,
              ),
              dialHandColor: AppColors.blue,
              dialBackgroundColor: AppColors.drawerBgColor,
              entryModeIconColor: AppColors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  return AppColors.white;
                }),
                overlayColor:
                    WidgetStateProperty.all(Colors.blue.withValues(alpha: 0.1)),
              ),
            ),
            materialTapTargetSize: tapTargetSize,
          ),
          child: child!,
        );
      },
    );
    if (pickedTime == null) return null;
    selectedRescueDate = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    update();
    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }

  Future<Uint8List?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'avi', 'mov'],
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.single.bytes;
      String? fileName = result.files.single.name;
      log("File selected: $fileName");
      update();
      return fileBytes;
    } else {
      log("No file selected.");
    }
    return null;
  }

  FilterRescue selectedRescue  = FilterRescue();
  String timeDataInString ='';
  List<String> extractHashtags(String input) {
    final RegExp hashtagRegExp = RegExp(r'#[\w]+');
    return hashtagRegExp
        .allMatches(input)
        .map((match) => match.group(0)!)
        .toList();
  }

  setCreateRescueData() {
    rescueTitleController.text = selectedRescue.title ?? '';
    rescueDescriptionController.text = selectedRescue.description ?? '';
rescueNameController.text = selectedRescue.lostItemName??'';
rescueMobileNoController.text = selectedRescue.mobileNumber??'';
    rescueHashtagController.text = selectedRescue.hashTags
        ?.toString()
        .replaceAll('[', '')
        .replaceAll(']', '') ??
        '';

    rescueLocationController.text = selectedRescue.address ?? '';
    rescueLatitudeController.text = selectedRescue.latitude?.toString() ?? '';
    rescueLongitudeController.text = selectedRescue.longitude?.toString() ?? '';

    timeDataInString = intl.DateFormat('dd/MM/yyyy hh:mm a').format(
        selectedRescue.eventTime != null && selectedRescue.eventTime!.isNotEmpty
            ? DateTime.parse(selectedRescue.eventTime!).toLocal()
            : DateTime.now().toLocal());
    selectedRescueDate =
    selectedRescue.eventTime != null && selectedRescue.eventTime!.isNotEmpty
        ? DateTime.parse(selectedRescue.eventTime!).toLocal()
        : DateTime.now();
    for (var element in eventCategory) {
      if (element.id == selectedRescue.postCategoryId) {
        selectedCategory = element;
      }
    }
    // update();
  }




  createRescue(BuildContext context, ProgressLoader pl, bool isUser) async {
    if (selectedCategory == null) {
      showToast(
          context: context,
          title: 'Rescue!',
          message: 'Please select rescue category',
          bgColor: AppColors.red);
      return;
    } else if (isUser == false && selectedImageOrVideo == null) {
      showToast(
          context: context,
          title: 'Rescue!',
          message: 'Please select attachment',
          bgColor: AppColors.red);
      return;
    } else if (formKey.currentState?.validate() == true) {
      try {
        await pl.show();

        List hashTags = [];

        if (rescueHashtagController.text.isNotEmpty) {
          hashTags = extractHashtags(rescueHashtagController.text);
        }

        Uint8List? attachmentByte;

        if (selectedImageOrVideo != null) {
          attachmentByte = await selectedImageOrVideo!.readAsBytes();
        }

        // if (customThumbnailFile == null && thumbnailImage == null) {
        //   sendThumbnail = false;
        // }
        // if (customThumbnailFile != null) {
        //   thumbnailByte = customThumbnailBytes;
        // } else {
        //   thumbnailByte = thumbnailImageBytes;
        // }

        var data = {
          'postType': 'rescue',
          'latitude': num.parse(rescueLatitudeController.text),
          'longitude': num.parse(rescueLongitudeController.text),
          'title': rescueTitleController.text,
          if (rescueDescriptionController.text.isNotEmpty)
            'description': rescueDescriptionController.text,
          'eventTime': selectedRescueDate.toUtc().toIso8601String(),

          if (rescueLocationController.text.isNotEmpty)
            'address': rescueLocationController.text,
          if (isUser == true) 'userId': selectedRescue.userId ?? '',
          if (isUser == true) 'userRequestedEventId': selectedRescue.id ?? '',

          'postCategoryId': selectedCategory?.id ?? '',
          if (isUser == true) 'attachment': selectedRescue.attachment ?? '',
          if (isUser == true )
            'thumbnail': selectedRescue.thumbnail ?? '',
          "isDirectAdminPost": isUser == true ? false : true,
          'lostItemName': rescueNameController.text,
          'countryCode': countryCode,
          'mobileNumber': rescueMobileNoController.text,
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

        log('Create Rescue Data :- $data');

        ResponseModel res =
            await EventRepository.createEventPost(context: context, data: data);
        await pl.hide();
        if (res.status == true) {
          NavigatorRoute.navigateBack(context: context);
          showToast(context: context, title: 'Success', message: res.message);
          filterRescue.clear();
          pageNumber = 1;
          rescueSearchController.clear();
          await getRescueList(context: context);

          notifyUser(data: {
            "_id": res.body['_id']??"",
            "latitude": res.body['latitude']??"",
            "longitude": res.body["longitude"]??"",
            "title": res.body['title']??"",
            "description": res.body['description']??"",
            "eventTypeId": res.body['postCategoryId']??"",
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
        log('Create Rescue :- $e');
      }
    }
  }

  int pageNumber = 1;
  RxBool paginationLoader = false.obs;
  TextEditingController rescueSearchController =TextEditingController();
  GetFilterRescueModel getFilterRescueModel = GetFilterRescueModel();
  List<FilterRescue> filterRescue =[];
  Timer? debounce;
  String? filterType;

  rescuePagination(BuildContext context) {
    paginationLoader.value = true;
    pageNumber++;
    rescueSearchController.clear();
    getRescueList(context: context);
    update();
  }

  Future<void> getRescueList({String? filterType, required BuildContext context, String? status}) async {

    try {
      loader.value = paginationLoader.value == true ? false : true;

      DateTime utcDateTime = focusedDay.toUtc();

      String utcDate = utcDateTime.toIso8601String();

      double latitude = StorageService.getLatitude() ?? 0.0;
      double longitude = StorageService.getLongitude() ?? 0.0;

      ResponseModel res = await EventRepository.getFilterEventList(
          context: context,
          filterType: /*filterType ??*/
              (selectedContainerValue == 0
                  ? 'all'
                  : selectedContainerValue == 1
                  ? 'Approved':selectedContainerValue==2 ?
                   'Rejected': "Pending"),
          page: pageNumber.toString(),
          postType: 'rescue',
          date: utcDate,
          isDate: true,
          longitude: longitude,
          latitude: latitude,
          isFilter: isFilter,
          distance: 500,
          search: rescueSearchController.text,
        status:  status

      );

      if (res.status == true) {
        getFilterRescueModel = GetFilterRescueModel.fromJson(res.toJson());

        filterRescue = filterRescue + (getFilterRescueModel.body?.data ?? []);

        log('All Rescue List:- $filterRescue');
        paginationLoader.value = false;
        loader.value = false;
      } else {
        filterRescue = filterRescue;
        log('Get All Rescue :- $res');
        paginationLoader.value = false;
        loader.value = false;
      }
      update();
    } catch (e) {
      filterRescue = filterRescue;
      paginationLoader.value = false;
      loader.value = false;
      log('Get All Rescue :- $e');
    }
  }

  clearRescueData() {
    selectedRescue = FilterRescue();
    selectedCategory = null;

    rescueTitleController.clear();
    rescueDescriptionController.clear();
    rescueLocationController.clear();
    rescueLongitudeController.clear();
    rescueLatitudeController.clear();
    rescueHashtagController.clear();
    timeDataInString = '';
    selectedImageOrVideo = null;
    thumbnailImageBytes= null;
    thumbnailImage= null;
    selectedImageOrVideoBytes= null;
    selectedRescueDate = DateTime.now();
    rescueMobileNoController.clear();
    countryCode ='+91';
    rescueNameController.clear();

  }

  Future updateRescueDraft(
      {required BuildContext context,
        required ProgressLoader pl,
        required bool isUser,
        required String draftId})
  async {
    if (selectedCategory == null) {
      showToast(
          context: context,
          title: 'Rescue!',
          message: 'Please select event category',
          bgColor: AppColors.red);
      return;
    } else if (

    selectedImageOrVideo == null && selectedRescueDraftData.attachment == null ) {
      showToast(
          context: context,
          title: 'Rescue!',
          message: 'Please select attachment',
          bgColor: AppColors.red);
      return;
    } else if (formKey.currentState?.validate() == true) {
      try {
        await pl.show();

        List hashTags = [];
        bool sendThumbnail = true;

        if (rescueHashtagController.text.isNotEmpty) {
          hashTags = extractHashtags(rescueHashtagController.text);
        }





        if ( thumbnailImage == null) {
          sendThumbnail = false;
        }
        // if (customThumbnailFile != null) {
        //   thumbnailByte = customThumbnailBytes;
        // } else {
        //   thumbnailByte = thumbnailImageBytes;
        // }

        var data = {
          'lostItemName': rescueNameController.text,
          'countryCode': countryCode,
          'mobileNumber': rescueMobileNoController.text,
          'postType': 'rescue',
          'latitude': num.parse(rescueLatitudeController.text),
          'longitude': num.parse(rescueLongitudeController.text),
          'title': rescueTitleController.text,
          if (rescueDescriptionController.text.isNotEmpty)
            'description': rescueDescriptionController.text,
          'eventTime': selectedRescueDate.toUtc().toIso8601String(),

          if (rescueLocationController.text.isNotEmpty)
            'address': rescueLocationController.text,
          if (selectedRescueDraftData.userId != null)
            'userId': selectedRescueDraftData.userId ?? '',

          if (selectedRescueDraftData.userRequestedEventId != null)
            'userRequestedEventId': selectedRescueDraftData.userRequestedEventId ?? '',

          'postCategoryId': selectedCategory?.id ?? '',
          if(selectedImageOrVideo==null)
          'attachment': selectedRescueDraftData.attachment ?? '',
          if (sendThumbnail == false)
            'thumbnail': selectedRescueDraftData.thumbnail ?? '',
          "isDirectAdminPost": selectedRescueDraftData.isDirectAdminPost?? false,
          'hashTags[]': hashTags,
          'adminPostDraftId': draftId,




          if (sendThumbnail == true)
            'gallaryThumbnail': test.MultipartFile.fromBytes(
                thumbnailImageBytes ?? Uint8List(0),
                filename: 'thumbnail.png'),

          if (selectedImageOrVideo!= null)
            'gallaryAttachment': test.MultipartFile.fromBytes(
                selectedImageOrVideoBytes ?? Uint8List(0),
                filename: 'thumbnail.png'),

        };

        log('Create rescue Data :- $data');

        ResponseModel res =
        await EventRepository.createEventPost(context: context, data: data);
        await pl.hide();
        if (res.status == true) {
          NavigatorRoute.navigateBack(context: context);

          showToast(context: context, title: 'Success', message: res.message);
          selectedSubTab=2.1;
          update();
          filterRescue.clear();
          pageNumber = 1;
          rescueSearchController.clear();
          await getRescueList(context: context);
        } else {
          showToast(
              context: context,
              title: 'Error',
              message: res.message,
              bgColor: AppColors.red
          );
        }
      } catch (e) {
        await pl.hide();
        log('Create rescue :- $e');
      }
    }
  }

  Future createDraftEvent(
      BuildContext context, ProgressLoader pl, bool isUser) async {
    try {
      await pl.show();

      List hashTags = [];
      bool sendThumbnail = true;

      if (rescueHashtagController.text.isNotEmpty) {
        hashTags = extractHashtags(rescueHashtagController.text);
      }

      Uint8List? attachmentByte;


      if (selectedImageOrVideo != null) {
        attachmentByte = await selectedImageOrVideo!.readAsBytes();
      }

      // if (customThumbnailFile == null && thumbnailImage == null) {
      //   sendThumbnail = false;
      // }
      // if (customThumbnailFile != null) {
      //   thumbnailByte = customThumbnailBytes;
      // } else {
      //   thumbnailByte = thumbnailImageBytes;
      // }

      var data = {
        'postType': 'rescue',
        if (rescueLatitudeController.text.isNotEmpty)
          'latitude': num.parse(rescueLatitudeController.text),
        if (rescueLongitudeController.text.isNotEmpty)
          'longitude': num.parse(rescueLongitudeController.text),
        if (rescueTitleController.text.isNotEmpty)
          'title': rescueTitleController.text,
        if (rescueDescriptionController.text.isNotEmpty)
          'description': rescueDescriptionController.text,
        if (rescueNameController.text.isNotEmpty)
          'lostItemName': rescueNameController.text,
        if (rescueMobileNoController.text.isNotEmpty)
          'mobileNumber': rescueMobileNoController.text,
        'countryCode': countryCode,

        'eventTime': selectedRescueDate.toUtc().toIso8601String(),

        if (rescueLocationController.text.isNotEmpty)
          'address': rescueLocationController.text,
        if (isUser == true) 'userId': selectedRescue.userId ?? '',
        if (isUser == true) 'userRequestedEventId': selectedRescue.id ?? '',




        if (selectedCategory?.id != null && selectedCategory!.id != '')
          'postCategoryId': selectedCategory?.id ?? '',
        if (isUser == true) 'attachment': selectedRescue.attachment ?? '',
        if (isUser == true && sendThumbnail == false)
          'thumbnail': selectedRescue.thumbnail ?? '',
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

        // if (isUser == false && thumbnailImage != null)
        //   'gallaryThumbnail': test.MultipartFile.fromBytes(
        //       thumbnailImageBytes ?? Uint8List(0),
        //       filename: 'thumbnail.png'),
      };

      log('Create Draft rescue Data :- $data');

      ResponseModel res =
      await EventRepository.createEventDraft(context: context, data: data);
      await pl.hide();
      if (res.status == true) {
        NavigatorRoute.navigateBack(context: context);
        showToast(context: context, title: 'Draft rescue', message: res.message);
      } else {
        showToast(
            context: context,
            title: 'Draft rescue',
            message: res.message,
            bgColor: AppColors.red);
      }
    } catch (e) {
      await pl.hide();
      log('Create Draft rescue :- $e');
    }
  }
  RxBool draftLoader = false.obs;

  List<EventDraftData> draftList = [];
  EventDraftData  selectedRescueDraftData = EventDraftData();
  double selectedSubTab = 2.1;
  Future<void> getRescueDraftList({  required BuildContext context,}) async {
    // log('=====Latitude $latitude=========Longitude $longitude');
    try {
      draftLoader.value = true;

      ResponseModel res = await EventRepository.getEventDrafts(context: context, postType: 'rescue');

      if (res.status == true) {
        GetEventDraftsModel getEventDraftsModel =
        GetEventDraftsModel.fromJson(res.toJson());

        draftList = (getEventDraftsModel.body ?? []);

        log('All  Drafts List:- $draftList');

        draftLoader.value = false;
      } else {
        log('Get All Event drafts :- $res');

        draftLoader.value = false;
      }
      update();
    } catch (e) {
      log('Get All Event drafts :- $e');

      draftLoader.value = false;
    }
  }

  Future<void> deleteDraft({
    required String draftId,
    required ProgressLoader pl,
    required BuildContext context,
  })
  async {
    try {
      await pl.show();

      ResponseModel res =
      await EventRepository.deleteEventDraft(draftId: draftId, context: context);

      if (res.status == true) {
        await pl.hide();
        showToast(
            context: context, title: 'Delete Draft', message: res.message);
        await getRescueDraftList(
            context: context
        );

        log('delete Event drafts :- $res');
      } else {
        showToast(
            context: context,
            title: 'Delete Draft',
            message: res.message,
            bgColor: AppColors.red);
        log('delete Event drafts :- $res');

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
