import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:country_picker/country_picker.dart';
import 'package:eagle_eye_admin/api/repository/rescue_repository.dart';
import 'package:eagle_eye_admin/model/get_all_rescue_updates.dart';
import 'package:intl/intl.dart' as intl;
import 'package:dio/dio.dart' as test;
import 'package:eagle_eye_admin/api/repository/event_repository.dart';
import 'package:eagle_eye_admin/api/repository/reaction_and_category_repository.dart';
import 'package:eagle_eye_admin/controller/dashboard_controller.dart';
import 'package:eagle_eye_admin/controller/event_controller.dart';
import 'package:eagle_eye_admin/controller/rescue_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/model/categories_model.dart';
import 'package:eagle_eye_admin/model/event_rescue_timeline_model.dart';
import 'package:eagle_eye_admin/model/get_attached_video_list.dart';
import 'package:eagle_eye_admin/model/get_single_rescue_model.dart';
import 'package:eagle_eye_admin/model/response_model.dart';
import 'package:eagle_eye_admin/page/comment_screen/comment_dailoge.dart';
import 'package:eagle_eye_admin/page/rescue_screen/component/rescue_add_timeline_dailoge.dart';
import 'package:eagle_eye_admin/page/rescue_screen/component/rescue_attach_file_dailoge.dart';
import 'package:eagle_eye_admin/page/user_profile_screen/user_profile_view.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/service/storage/storage_service.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/widget/dailoges.dart';
import 'package:eagle_eye_admin/widget/toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:libphonenumber/libphonenumber.dart';

class RescueDetailController extends GetxController {
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

  ScrollController rescueDetailsScrollController = ScrollController();

  DateTime selectedRescueDate = DateTime.now();
  MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;

  XFile? uploadedFile;

  XFile? uploadedFileThumbnail;

  Uint8List? uploadedFileBytes;

  List<AllAttachedVideos> allAttachedVideos = [];

  AllAttachedVideos? selectedVideo;

  Uint8List? selectedFile;

  XFile? postFirstFile;

  XFile? postFirstFileThumbnail;

  Uint8List? postFirstFileBytes;
  String updateStatus = 'Pending';

  int mobileLengthTimeline = 10;
  int mobileLength = 10;

  TextEditingController rescueTimelineUpdateController =
      TextEditingController();
  TextEditingController rescueTimelineMobileNoController =
      TextEditingController();
  TextEditingController rescueTimelineLocationController =
      TextEditingController();
  TextEditingController rescueTimelineHashtagController =
      TextEditingController();
  DateTime rescueTimelineSelectedDate = DateTime.now();
  GlobalKey<FormState> timelineKey = GlobalKey<FormState>();
  String? rescueTimeLineUserName;
  String? rescueTimeLineUserImageURL;
  String? rescueTimeLineUserUserId;
  String? rescueTimeLineUserAttachment;
  String? rescueTimeLineUserPostId;
  bool isRecueUpdate = false;

  fillData(RescueUpdateData rescueUpdateData) {
    rescueTimelineUpdateController.text = rescueUpdateData.description ?? '';
    rescueTimelineLocationController.text = rescueUpdateData.address ?? '';
    rescueTimelineMobileNoController.text = rescueUpdateData.mobileNumber ?? '';
    timelineCountryCode = rescueUpdateData.countryCode ?? '';
    rescueTimelineSelectedDate =
        DateTime.parse(rescueUpdateData.eventTime ?? '');
    rescueTimeLineUserName = rescueUpdateData.name ?? '';
    rescueTimeLineUserImageURL = rescueUpdateData.thumbnail ?? '';
    rescueTimeLineUserAttachment = rescueUpdateData.attachment ?? '';
    rescueTimeLineUserUserId = rescueUpdateData.userId ?? '';
    rescueTimeLineUserPostId = rescueUpdateData.id ?? '';
    isRecueUpdate = true;
    update();
  }

  List<String> has = [];
  rescueUpdatePost(ProgressLoader pl, BuildContext context) async {
    List<String>? hashTags;
    if (rescueTimelineHashtagController.text.isNotEmpty) {
      hashTags = extractHashtags(rescueTimelineHashtagController.text);
    }
    log(hashTags.toString());

    Map<String, dynamic> data = {
      'postType': 'rescue',
      'eventPostId': getSingleRescueData.id,
      'eventTime': rescueTimelineSelectedDate.toString(),
      'userId': rescueTimeLineUserUserId,
      'description': rescueTimelineUpdateController.text,
      // 'userRequestedEventId': rescueTimeLineUserPostId,
      'attachment': rescueTimeLineUserAttachment,
      'thumbnail': rescueTimeLineUserImageURL,
      'address': rescueTimelineLocationController.text,
      'countryCode': timelineCountryCode,
      'mobileNumber': rescueTimelineMobileNoController.text,
      'rescueUpdateId': rescueTimeLineUserPostId,
      'hashTags[]': hashTags ?? [],
    };
    await pl.show();

    try {
      ResponseModel res = await RescueRepository.updateRescueUpdatePost(
          context: context, postData: data);
      await pl.hide();
      if (res.status == true) {
        NavigatorRoute.navigateBack(context: context);
        NavigatorRoute.navigateBack(context: context);
        showToast(context: context, title: 'Success', message: res.message);
        clearTimelineData();
        clearData();
        await getSingleEventList(getSingleRescueData.id ?? '',
            context: context);
      } else {
        showToast(
            context: context,
            title: 'Error',
            message: res.message,
            bgColor: AppColors.red);
      }
    } catch (e) {
      await pl.hide();
      log('Upload file :- $e');
    }
    isRecueUpdate = false;
    update();
  }

  // List<String> extractHashtags(String input) {
  //   final RegExp hashtagRegExp = RegExp(r'#[\w]+');
  //   return hashtagRegExp
  //       .allMatches(input)
  //       .map((match) => match.group(0)!)
  //       .toList();
  // }

  clearData() {
    rescueTimelineUpdateController.clear();
    rescueTimelineLocationController.clear();
    rescueTimelineMobileNoController.clear();
    rescueTimelineHashtagController.clear();
    timelineCountryCode = '';
    rescueTimelineSelectedDate = DateTime.now();
    rescueTimeLineUserName = '';
    rescueTimeLineUserImageURL = '';
    rescueTimeLineUserAttachment = '';
    rescueTimeLineUserUserId = '';
    rescueTimeLineUserPostId = "";
  }

  List<String> extractHashtags(String input) {
    final RegExp hashtagRegExp = RegExp(r'#[\w]+');
    return hashtagRegExp
        .allMatches(input)
        .map((match) => match.group(0)!)
        .toList();
  }

  timeLineAddAPI(ProgressLoader pl, BuildContext context) async {
    List? hashTags;
    if (rescueTimelineHashtagController.text.isNotEmpty) {
      hashTags = extractHashtags(rescueTimelineHashtagController.text);
    }

    try {
      await pl.show();

      var data = {
        "postType": "rescue",
        "eventPostId": getSingleRescueData.id,
        "attachmentId": selectedVideo?.attachmentId ?? '',
        "description": rescueTimelineUpdateController.text,
        "eventTime": rescueTimelineSelectedDate.toUtc().toIso8601String(),
        'address': rescueTimelineLocationController.text,
        "hashTags": hashTags ?? [],
      };

      log('Add Timeline Data :- $data');

      ResponseModel res =
          await EventRepository.addTimeLineAPI(context: context, data: data);

      await pl.hide();
      if (res.status == true) {
        NavigatorRoute.navigateBack(context: context);
        showToast(context: context, title: 'Success', message: res.message);
        clearTimelineData();
        await getSingleEventList(getSingleRescueData.id ?? '',
            context: context);
      } else {
        showToast(
            context: context,
            title: 'Error',
            message: res.message,
            bgColor: AppColors.red);
      }
    } catch (e) {
      await pl.hide();
      log('Upload file :- $e');
    }
  }

  clearTimelineData() {
    rescueTimelineUpdateController.clear();
    rescueTimelineHashtagController.clear();
    rescueTimelineSelectedDate = DateTime.now();
    rescueTimelineLocationController.clear();
    selectedVideo = null;
    update();
  }

  String formatDateData(DateTime date) {
    return intl.DateFormat('dd/MM/yyyy hh:mm a').format(date);
  }

  Future<DateTime?> pickDateTime(BuildContext context,
      {DateTime? initialDate}) async {
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

  openCommentDailoge(BuildContext context) async {
    showDialog(
      context: context,
      routeSettings: const RouteSettings(name: '/rescue/rescueComment'),
      builder: (context) {
        return const CommentDailoge();
      },
    );
  }

  openAttachFileDailoge(BuildContext context) async {
    showDialog(
      context: context,
      routeSettings:
          const RouteSettings(name: '/rescue/rescueDetail/attachFile'),
      builder: (context) {
        return const RescueAttachFileDailoge();
      },
    );
  }

  openAddTimeLineDailoge(
      BuildContext context, String page, String eventId) async {
    if (page != "Update") clearData();
    showDialog(
      context: context,
      routeSettings:
          const RouteSettings(name: '/rescue/rescueDetail/addTimeLine'),
      builder: (context) {
        return RescueAddTimelineDailoge(
          page: page,
          eventId: eventId,
        );
      },
    );
  }

  openUserProfileView(
      {required BuildContext context, required String userId}) async {
    showDialog(
      context: context,
      routeSettings: const RouteSettings(name: '/rescue/userProfile'),
      builder: (context) {
        return UserProfileView(
          userId: userId,
        );
      },
    );
  }

  ScrollController rescueUpdateScrollController = ScrollController();

  openAttachFileDialogBox(BuildContext context) async {
    showDialog(
      context: context,
      routeSettings: const RouteSettings(name: '/event/videoOrImage'),
      builder: (context) {
        return PhotoOrVideoOptionDailoge(
          onPhotoTap: () async {
            uploadedFile = await pickMedia(MediaType.image);
            uploadedFileBytes = await uploadedFile!.readAsBytes();
            uploadedFileThumbnail = uploadedFile;
            log('uploaded: $uploadedFile');
            update();
            NavigatorRoute.navigateBack(context: context);
          },
          onVideoTap: () async {
            uploadedFile = await pickMedia(MediaType.video);

            XFile? thumbnailPath = await VideoThumbnail.thumbnailFile(
              video: uploadedFile!.path,
              quality: 75,
            );
            uploadedFileThumbnail = thumbnailPath;
            uploadedFileBytes = await thumbnailPath.readAsBytes();

            log('uploaded: $uploadedFile');
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
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    } else if (mediaType == MediaType.video) {
      pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    }

    if (pickedFile != null) {
      String filePath = pickedFile.path;
      log("${mediaType == MediaType.image ? 'Image' : 'Video'} selected: $filePath");

      if (mediaType == MediaType.video) {
        try {
          XFile? thumbnailPath = await VideoThumbnail.thumbnailFile(
            video: filePath,
            quality: 75,
          );
          update();
          log("Thumbnail generated: $thumbnailPath");
        } catch (e) {
          log("Error generating thumbnail: $e");
        }
      } else if (mediaType == MediaType.image) {
        log("Image picked successfully.");
      }
      return pickedFile;
    } else {
      log("No ${mediaType == MediaType.image ? 'image' : 'video'} selected.");
    }
    return null;
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

  Future getVideoList(String eventId, {required BuildContext context}) async {
    try {
      ResponseModel res = await EventRepository.getAttachedVideosList(
          id: eventId, context: context);

      if (res.status == true) {
        GetAttachedVideoListModel getAttachedVideoListModel =
            GetAttachedVideoListModel.fromJson(res.toJson());

        allAttachedVideos = getAttachedVideoListModel.body ?? [];
      } else {
        log('Get attachment videos:- $res');
      }
      update();
    } catch (e) {
      log('Get attachment videos :- $e');
    }
  }

  uploadPostFilesAPI(ProgressLoader pl, BuildContext context) async {
    try {
      if (uploadedFile == null) {
        showToast(
            context: context,
            title: 'Error',
            message: 'Please select file!',
            bgColor: AppColors.red);
        return;
      }

      EventController eventController = Get.find();
      await pl.show();

      Uint8List? attachmentByte;

      if (uploadedFile != null) {
        attachmentByte = await uploadedFile!.readAsBytes();
      }

      var data = {
        'eventPostId': getSingleRescueData.id,
        'gallaryAttachment': test.MultipartFile.fromBytes(
          attachmentByte!,
          filename: uploadedFile?.name ?? 'file',
        ),
        'thumbnailAttachment': test.MultipartFile.fromBytes(
          uploadedFileBytes!,
          filename: 'thumbnail.png',
        ),
        'isSensitiveContent': false,
      };

      log('Upload File Data :- $data');

      ResponseModel res = await EventRepository.uploadFilesAPi(
        context: context,
        data: data,
      );

      await pl.hide();
      if (res.status == true) {
        NavigatorRoute.navigateBack(context: context);
        showToast(context: context, title: 'Success', message: res.message);
        await getSingleEventList(getSingleRescueData.id ?? '',
            context: context);
        clearUploadFileData();
        eventController.filterEvents.clear();
        eventController.pageNumber = 1;
        eventController.eventSearchController.clear();
        await eventController.getEventsList(context: context);
      } else {
        showToast(
          context: context,
          title: 'Error',
          message: res.message,
          bgColor: AppColors.red,
        );
      }
    } catch (e) {
      await pl.hide();
      log('Upload file :- $e');
    }
  }

  clearUploadFileData() {
    uploadedFile = null;
    uploadedFileBytes = null;
    update();
  }

  RxBool detailLoader = false.obs;
  List<Categorie> rescueCategory = [];

  Categorie? selectedCategory;

  getAllCategories({
    required BuildContext context,
  }) async {
    try {
      detailLoader.value = true;
      ResponseModel res = await ReactionAndCategoryRepository.getAllCategories(
          postType: 'rescue', context: context);
      if (res.status == true) {
        CategoriesModel categoriesModel =
            CategoriesModel.fromJson(res.toJson());
        rescueCategory.clear();
        rescueCategory.addAll(categoriesModel.body!);
        update();
        log('All Categories :- $rescueCategory');
      } else {
        log('Get All Categories :- ${res.message}');
      }
      detailLoader.value = false;
    } catch (e) {
      detailLoader.value = false;
      log('Get All Categories :- $e');
    }
  }

  onPickFirstPostVideo() async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      XFile? thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: pickedFile.path,
        quality: 75,
      );
      postFirstFile = pickedFile;
      postFirstFileThumbnail = thumbnailPath;
      postFirstFileBytes = await thumbnailPath.readAsBytes();
    }
    update();
  }

  onPickOtherPostVideo(
      int index, BuildContext context, ProgressLoader pl) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    // html.File? file = await ImagePickerWeb.getVideoAsFile();

    if (pickedFile != null) {
      XFile? thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: pickedFile.path,
        quality: 75,
      );

      getSingleRescueData.attachmentWithTimeline![index].videoFile = pickedFile;
      getSingleRescueData.attachmentWithTimeline![index].videoThumbnail =
          thumbnailPath;
      getSingleRescueData.attachmentWithTimeline![index].videoBytes =
          await thumbnailPath.readAsBytes();

      await updateTimelineVideo(
          context: context,
          index: index,
          pl: pl,
          videoFile: pickedFile,
          videoFileThumbnail: thumbnailPath);
    }
    update();
  }

  Future updateTimelineVideo({
    required int index,
    required BuildContext context,
    required ProgressLoader pl,
    XFile? videoFile,
    XFile? videoFileThumbnail,
  }) async {
    try {
      await pl.show();

      Uint8List? videoBytes;
      Uint8List? videoThumbBytes;
      if (videoFile != null) {
        videoBytes = await videoFile.readAsBytes();
      }

      videoThumbBytes =
          getSingleRescueData.attachmentWithTimeline?[index].videoBytes ??
              Uint8List(0);

      Map<String, dynamic> data = {
        'eventPostId': getSingleRescueData.id,
        'attachmentId':
            getSingleRescueData.attachmentWithTimeline?[index].attachmentId ??
                '',
        if (videoFile != null)
          'gallaryAttachment': test.MultipartFile.fromBytes(
              videoBytes ?? Uint8List(0),
              filename: videoFile.name),
        if (videoFileThumbnail != null)
          'gallaryThumbnail': test.MultipartFile.fromBytes(videoThumbBytes,
              filename: 'thumbnail.png'),
      };

      ResponseModel res = await EventRepository.updateTimeLineVideo(
          data: data, context: context);

      if (res.status == true) {
        showToast(context: context, title: 'Success', message: res.message);
        GetSingleRescueData data = GetSingleRescueData.fromJson(res.body);
        // eventAttachmentList = getSingleEventData.attachmentWithTimeline ?? [];
        getSingleRescueData.attachmentWithTimeline?[index].thumbnail =
            data.attachmentWithTimeline?[index].thumbnail;
        getSingleRescueData.attachmentWithTimeline?[index].attachment =
            data.attachmentWithTimeline?[index].attachment;
        getSingleRescueData.attachmentWithTimeline?[index].attachmentFileType =
            data.attachmentWithTimeline?[index].attachmentFileType;
        update();
      } else {
        showToast(
            context: context,
            title: 'Error',
            message: res.message,
            bgColor: AppColors.red);
        log('update attachment videos:- $res');
      }
      await pl.hide();
      update();
    } catch (e) {
      await pl.hide();
      log('update attachment videos :- $e');
    }
  }

  Future<void> deleteSinglePost({
    required String eventId,
    required String postId,
    required BuildContext context,
  }) async {
    try {
      detailLoader.value = true;
      ResponseModel res = await EventRepository.deleteSinglePost(
          context: context, eventId: eventId, postId: postId);

      if (res.status == true) {
        showToast(context: context, title: 'Attachment', message: res.message);

        await getSingleEventList(getSingleRescueData.id ?? '',
            context: context);
      } else {
        showToast(
            context: context,
            title: 'Attachment',
            message: res.message,
            bgColor: AppColors.red);
        log(' Attachment delete  :- $res');
      }
      update();
      detailLoader.value = false;
    } catch (e) {
      detailLoader.value = false;
      log(' Attachment delete :- $e');
    }
  }

  Future<void> deleteEventApiCalling(
      String eventId, BuildContext context) async {
    try {
      RescueController rescueController = Get.find();
      detailLoader.value = true;
      ResponseModel res =
          await EventRepository.deleteEvent(id: eventId, context: context);

      if (res.status == true) {
        NavigatorRoute.navigateBack(context: context);
        showToast(context: context, title: 'Rescue', message: res.message);
        rescueController.filterRescue.clear();
        rescueController.pageNumber = 1;
        rescueController.rescueSearchController.clear();
        await rescueController.getRescueList(context: context);
      } else {
        showToast(
            context: context,
            title: 'Rescue',
            message: res.message,
            bgColor: AppColors.red);
        log(' Rescue delete  :- $res');
      }
      update();
      detailLoader.value = false;
    } catch (e) {
      detailLoader.value = false;
      log(' Rescue delete :- $e');
    }
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  updateRescueApiCalling(BuildContext context, ProgressLoader pl) async {
    RescueController rescueController = Get.find();
    if (selectedCategory == null) {
      showToast(
          context: context,
          title: 'Rescue!',
          message: 'Please select rescue category',
          bgColor: AppColors.red);
      return;
    }
    // else if (await getPhoneLengthFromIso(rescueMobileNoController.text,selectedCountry!.countryCode) == false) {
    //   showToast(
    //       context: context,
    //       title: 'Rescue!',
    //       message: 'Phone number not valid!',
    //       bgColor: AppColors.red);
    //   return;
    // }

    else if (formKey.currentState?.validate() == true) {
      try {
        List hashTags = [];
        if (rescueHashtagController.text.isNotEmpty) {
          hashTags = extractHashtags(rescueHashtagController.text);
        }

        await pl.show();

        List<RescueAttachmentWithTimeline> timeLineAttachmentsList = [];

        if (getSingleRescueData.attachmentWithTimeline != null) {
          for (int i = 0;
              i < getSingleRescueData.attachmentWithTimeline!.length;
              i++) {
            timeLineAttachmentsList.add(
              RescueAttachmentWithTimeline(
                userId: getSingleRescueData.attachmentWithTimeline![i].userId,
                address: locationList[i].text,
                attachment:
                    getSingleRescueData.attachmentWithTimeline![i].attachment,
                isHover: getSingleRescueData.attachmentWithTimeline![i].isHover,
                attachmentId:
                    getSingleRescueData.attachmentWithTimeline![i].attachmentId,
                description: descriptionList[i].text,
                eventTime: dateTimeList[i].toUtc().toIso8601String(),
                name: getSingleRescueData.attachmentWithTimeline![i].name,
                profilePicture: getSingleRescueData
                    .attachmentWithTimeline![i].profilePicture,
                thumbnail:
                    getSingleRescueData.attachmentWithTimeline![i].thumbnail,
                type: getSingleRescueData.attachmentWithTimeline![i].type,
                mobileNumber: mobileNumberList[i].text,
                countryCode: countryCodeList[i],
              ),
            );
          }
        }
        Uint8List? attachmentByte;

        if (postFirstFile != null) {
          attachmentByte = await postFirstFile!.readAsBytes();
        }

        var data = {
          'eventPostId': getSingleRescueData.id,
          'postType': 'rescue',
          'latitude': num.parse(rescueLatitudeController.text),
          'longitude': num.parse(rescueLongitudeController.text),
          'title': rescueTitleController.text,
          if (rescueDescriptionController.text.isNotEmpty)
            'description': rescueDescriptionController.text,
          'eventTime': selectedRescueDate.toUtc().toIso8601String(),
          if (rescueLocationController.text.isNotEmpty)
            'address': rescueLocationController.text,
          if (rescueMobileNoController.text.isNotEmpty)
            'mobileNumber': rescueMobileNoController.text,
          'countryCode': '+91',
          'lostItemName': rescueNameController.text,
          'commentCounts': rescueCommentController.text,
          'reactionCounts': rescueLikeController.text,
          'viewCounts': rescueViewController.text,
          'sharedCount': rescueShareController.text,
          'postCategoryId': selectedCategory?.id ?? '',
          'hashTags[]': hashTags,
          'timeLineAttachments': jsonEncode(
              timeLineAttachmentsList.map((e) => e.toJson()).toList()),
          if (postFirstFile != null)
            'gallaryAttachment': test.MultipartFile.fromBytes(
                attachmentByte ?? Uint8List(0),
                filename: postFirstFile!.name),
          if (postFirstFileThumbnail != null)
            'gallaryThumbnail': test.MultipartFile.fromBytes(
                postFirstFileBytes ?? Uint8List(0),
                filename: 'thumbnail.png'),
        };

        ResponseModel res =
            await EventRepository.updateEvent(context: context, data: data);
        await pl.hide();
        if (res.status == true) {
          NavigatorRoute.navigateBack(context: context);
          rescueController.filterRescue.clear();
          rescueController.pageNumber = 1;
          rescueController.rescueSearchController.clear();
          await rescueController.getRescueList(context: context);
          showToast(context: context, title: 'Success', message: res.message);
        } else {
          showToast(
              context: context,
              title: 'Error',
              message: res.message,
              bgColor: AppColors.red);
        }
      } catch (e) {
        await pl.hide();
        log(' $e');
      }
    }
  }

  updateRescueStatusApiCalling(BuildContext context, ProgressLoader pl) async {
    RescueController rescueController = Get.find();
    try {
      await pl.show();

      var data = {
        'eventPostId': getSingleRescueData.id,
        // 'status': updateStatus == 'Pending'? "Resolved" : "Pending",
        'status':
            getSingleRescueData.status == 'Pending' ? "Resolved" : "Pending",
      };

      ResponseModel res =
          await EventRepository.updateEventStatus(context: context, data: data);
      await pl.hide();
      if (res.status == true) {
        getSingleEventList(getSingleRescueData.id ?? '', context: context);
        rescueController.filterRescue.clear();
        rescueController.pageNumber = 1;
        rescueController.rescueSearchController.clear();
        await rescueController.getRescueList(context: context);
        showToast(context: context, title: 'Success', message: res.message);
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
      log(' $e');
    }
  }

  int singleRescueUpdateCount = 0;
  RxBool rescueUpdateLoader = false.obs;

  List<RescueUpdateData> rescueUpdatesList = [];

  Future getRescueUpdatesList(
      {required BuildContext context, required String status}) async {
    try {
      rescueUpdateLoader.value = true;
      ResponseModel res = await RescueRepository.getAllRescueUpdatesList(
        context: context,
        status: status,
        id: getSingleRescueData.id ?? '',
      );
      if (res.status == true) {
        GetAllRescueUpdatesModel getAllRescueUpdatesModel =
            GetAllRescueUpdatesModel.fromJson(res.toJson());
        rescueUpdatesList = (getAllRescueUpdatesModel.body ?? []);
        update();
        log('All  rescue update :- $rescueUpdatesList');

        if (status == 'Pending') {
          singleRescueUpdateCount = rescueUpdatesList.length;
        }
      } else {
        log('All  rescue update :- ${res.message}');
      }
      rescueUpdateLoader.value = false;
    } catch (e) {
      rescueUpdateLoader.value = false;

      log('rescue updates  :- $e');
    }
  }

  Future<void> updateRescueUpdateStatus(
      {required String eventId,
      required String status,
      required String rescueUpdateId,
      required BuildContext context}) async {
    try {
      rescueUpdateLoader.value = true;
      ResponseModel res = await RescueRepository.updateRescueUpdateStatus(
          status: status,
          context: context,
          eventPostId: eventId,
          rescueUpdateId: rescueUpdateId);

      if (res.status == true) {
        showToast(title: 'Rescue', message: res.message, context: context);
      } else {
        showToast(
            title: 'Rescue ',
            message: res.message,
            bgColor: AppColors.red,
            context: context);
        log('rescue reject  :- $res');
      }
      update();
      rescueUpdateLoader.value = false;
    } catch (e) {
      rescueUpdateLoader.value = false;
      log(' rescue reject :- $e');
    }
  }

  onRefresh({
    required BuildContext context,
  }) async {
    Get.put(RescueController());
    DashboardController dashboardController = Get.put(DashboardController());
    dashboardController.selectedTab = 1;
    StorageService.saveSelectedTab(1);
    await getAllCategories(context: context);

    await getSingleEventList(StorageService.getEventId() ?? '',
        context: context);
  }

  GetSingleRescueData getSingleRescueData = GetSingleRescueData();
  List<RescueAttachmentWithTimeline> rescueAttachmentList = [];

  Future<void> getSingleEventList(String eventId,
      {required BuildContext context}) async {
    try {
      detailLoader.value = true;
      ResponseModel res = await EventRepository.getSingleEvent(
          context: context, postType: 'rescue', id: eventId);

      if (res.status == true) {
        GetSingleRescueModel getSingleRescueModel =
            GetSingleRescueModel.fromJson(res.toJson());

        getSingleRescueData =
            getSingleRescueModel.body ?? GetSingleRescueData();
        rescueAttachmentList = getSingleRescueData.attachmentWithTimeline ?? [];

        setSingleEventData();
        getRescueUpdatesList(context: context, status: 'Pending');
      } else {
        log('Get single rescue :- $res');
      }
      update();
      detailLoader.value = false;
    } catch (e) {
      detailLoader.value = false;
      log('Get single rescue :- $e');
    }
  }

  List<TextEditingController> descriptionList = [];
  List<TextEditingController> locationList = [];
  List<TextEditingController> mobileNumberList = [];
  List<String> countryCodeList = [];
  List<int> mobileLengthList = [];

  List<DateTime> dateTimeList = [];

  String countryCode = '+91';
  String timelineCountryCode = '+91';
  Country? selectedCountry;

  setSingleEventData() {
    descriptionList.clear();
    dateTimeList.clear();
    locationList.clear();
    mobileNumberList.clear();
    countryCodeList.clear();
    mobileLengthList.clear();
    rescueNameController.text = getSingleRescueData.lostItemName ?? '';
    rescueMobileNoController.text = getSingleRescueData.mobileNumber ?? '';
    countryCode = getSingleRescueData.countryCode ?? '+91';
    rescueTitleController.text = getSingleRescueData.title ?? '';
    updateStatus = getSingleRescueData.status ?? '';
    rescueDescriptionController.text = getSingleRescueData.description ?? '';
    rescueLocationController.text = getSingleRescueData.address ?? '';
    rescueLikeController.text =
        getSingleRescueData.reactionCounts?.toString() ?? '';
    rescueShareController.text =
        getSingleRescueData.sharedCount?.toString() ?? '';
    rescueViewController.text =
        getSingleRescueData.viewCounts?.toString() ?? '';
    rescueCommentController.text =
        getSingleRescueData.commentCounts?.toString() ?? '';
    rescueLatitudeController.text =
        getSingleRescueData.latitude?.toString() ?? '';
    rescueLongitudeController.text =
        getSingleRescueData.longitude?.toString() ?? '';
    rescueHashtagController.text = getSingleRescueData.hashTags
            ?.toString()
            .replaceAll('[', '')
            .replaceAll(']', '') ??
        '';

    selectedRescueDate = getSingleRescueData.eventTime != null &&
            getSingleRescueData.eventTime!.isNotEmpty
        ? DateTime.parse(getSingleRescueData.eventTime!).toLocal()
        : DateTime.now();

    for (var element in rescueCategory) {
      if (element.id == getSingleRescueData.postCategoryId) {
        selectedCategory = element;
      }
    }

    for (var element in getSingleRescueData.attachmentWithTimeline ?? []) {
      descriptionList
          .add(TextEditingController(text: element.description ?? ""));
    }
    for (var element in getSingleRescueData.attachmentWithTimeline ?? []) {
      locationList.add(TextEditingController(text: element.address ?? ""));
    }
    for (var element in getSingleRescueData.attachmentWithTimeline ?? []) {
      mobileNumberList
          .add(TextEditingController(text: element.mobileNumber ?? ""));
    }
    for (var element in getSingleRescueData.attachmentWithTimeline ?? []) {
      countryCodeList.add(element.countryCode ?? "+91");
      mobileLengthList.add(10);
    }
    for (var element in getSingleRescueData.attachmentWithTimeline ?? []) {
      dateTimeList.add(
          element.eventTime != null && element.eventTime!.isNotEmpty
              ? DateTime.parse(element.eventTime!).toLocal()
              : DateTime.now());
    }

    update();
  }

  /// no need

  final List<RescueTimelineModel> rescueTimeLineList = [
    RescueTimelineModel(
      location: TextEditingController(text: 'Mumbai, Maharashtra, India'),
      update: TextEditingController(
          text: 'I was walking on the road, and this girl was'),
      mobileNumber: TextEditingController(text: '9985456595'),
      image: Assets.image.rescuePost.path,
    ),
    RescueTimelineModel(
      location: TextEditingController(text: 'Mumbai, Maharashtra, India'),
      update: TextEditingController(
          text: 'I was walking on the road, and this girl was'),
      mobileNumber: TextEditingController(text: '9985456595'),
      image: Assets.image.rescuePost.path,
    ),
    RescueTimelineModel(
      location: TextEditingController(text: 'Mumbai, Maharashtra, India'),
      update: TextEditingController(
          text: 'I was walking on the road, and this girl was'),
      mobileNumber: TextEditingController(text: '9985456595'),
      image: Assets.image.rescuePost.path,
    ),
  ];

  final List<Map<String, String>> rescueReaction = [
    {
      'icon': Assets.image.fire.path,
      "category": "Fire",
    },
    {
      'icon': Assets.image.traffic.path,
      "category": "Traffic",
    },
    {
      'icon': Assets.image.hospital.path,
      "category": "Health",
    },
    {
      'icon': Assets.image.policeCar.path,
      "category": "Crime",
    },
    {
      'icon': Assets.image.airReport.path,
      "category": "Air Quality",
    },
  ];
  Map<String, String>? selectedRescueReaction;

  Future<bool> getPhoneLengthFromIso(String phoneNumber, String isoCode) async {
    try {
      bool isValid = await PhoneNumberUtil.isValidPhoneNumber(
              phoneNumber: phoneNumber, isoCode: isoCode) ??
          false;
      return isValid;
    } catch (_) {
      return false; // fallback
    }
  }
}
