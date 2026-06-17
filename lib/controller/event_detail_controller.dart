import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart' as test;
import 'package:eagle_eye_admin/api/repository/event_repository.dart';
import 'package:eagle_eye_admin/api/repository/reaction_and_category_repository.dart';
import 'package:eagle_eye_admin/controller/event_controller.dart';
import 'package:eagle_eye_admin/model/categories_model.dart';
import 'package:eagle_eye_admin/model/get_attached_video_list.dart';
import 'package:eagle_eye_admin/model/reactions_model.dart';
import 'package:eagle_eye_admin/model/response_model.dart';
import 'package:eagle_eye_admin/model/single_event_model.dart';
import 'package:eagle_eye_admin/page/comment_screen/comment_dailoge.dart';
import 'package:eagle_eye_admin/page/event_screen/component/event_add_timeline_dailoge.dart';
import 'package:eagle_eye_admin/page/event_screen/component/event_attach_file_dailoge.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/service/storage/storage_service.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/widget/dailoges.dart';
import 'package:eagle_eye_admin/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;

class EventDetailController extends GetxController {
  RxBool detailLoader = false.obs;
  GetSingleEventData getSingleEventData = GetSingleEventData();
  List<EventAttachmentWithTimeline> eventAttachmentList = [];
  TextEditingController eventDescriptionController = TextEditingController();
  TextEditingController eventTitleController = TextEditingController();
  TextEditingController eventLocationController = TextEditingController();
  TextEditingController eventLikeController = TextEditingController();
  TextEditingController eventShareController = TextEditingController();
  TextEditingController eventViewController = TextEditingController();
  TextEditingController eventCommentController = TextEditingController();
  TextEditingController eventHashtagController = TextEditingController();
  TextEditingController eventCategoryController = TextEditingController();
  TextEditingController timelineDiscriptionController = TextEditingController();
  TextEditingController timelineHashtagController = TextEditingController();
  TextEditingController eventLatController = TextEditingController();
  TextEditingController eventLongController = TextEditingController();

  ScrollController eventDetailsScrollController = ScrollController();
  ScrollController eventAttachScrollController = ScrollController();

  GlobalKey<FormState> timelineKey = GlobalKey<FormState>();

  DateTime timeLineDate = DateTime.now();

  String firstPostDate = '';

  List<TextEditingController> descriptionList = [];

  List<DateTime> dateTimeList = [];
  Categorie? selectedValue;
  Reaction? selectedEventReaction;

  final List<Categorie> eventCategory = [];
  final List<Reaction> eventReaction = [];

  AllAttachedVideos? selectedVideo;

  XFile? uploadedFile;

  XFile? uploadedFileThumbnail;

  Uint8List? uploadedFileBytes;

  XFile? postFirstFile;

  XFile? postFirstFileThumbnail;

  Uint8List? postFirstFileBytes;

  bool uploadFileCheckBox = false;
  List<AllAttachedVideos> allAttachedVideos = [];
  TimePickerEntryMode entryMode = TimePickerEntryMode.dial;

  String timeDataInString = '';
  bool isSensitive = true;

  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay selectedTimeLineTime = TimeOfDay.now();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextDirection textDirection = TextDirection.ltr;
  MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;
  DateTime selectedDateTime = DateTime.now();

  openAttachFile(BuildContext context) async {
    showDialog(
      context: context,
      routeSettings: const RouteSettings(name: '/event/eventDetail/attachFile'),
      builder: (context) {
        return const EventAttachFileDailoge();
      },
    );
  }

  openAddTimeLineDialogBox(BuildContext context, String eventId) async {
    showDialog(
      context: context,
      routeSettings:
          const RouteSettings(name: '/event/eventDetail/addTimeLine'),
      builder: (context) {
        return EventAddTimelineDialog(
          eventId: eventId,
        );
      },
    );
  }

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

      getSingleEventData.attachmentWithTimeline![index].videoFile = pickedFile;
      getSingleEventData.attachmentWithTimeline![index].videoThumbnail =
          thumbnailPath;
      getSingleEventData.attachmentWithTimeline![index].videoBytes =
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

  uploadPostFilesAPI(ProgressLoader pl, BuildContext context) async {
    try {
      EventController eventController = Get.find();
      await pl.show();

      Uint8List? attachmentByte;

      if (uploadedFile != null) {
        attachmentByte = await uploadedFile!.readAsBytes();
      }

      var data = {
        'eventPostId': getSingleEventData.id,
        'gallaryAttachment': test.MultipartFile.fromBytes(
          attachmentByte!,
          filename: uploadedFile?.name ?? 'file',
        ),
        'thumbnailAttachment': test.MultipartFile.fromBytes(
          uploadedFileBytes!,
          filename: 'thumbnail.png',
        ),
        'isSensitiveContent': uploadFileCheckBox,
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
        await getSingleEventList(getSingleEventData.id ?? '', context: context);
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
    uploadFileCheckBox = false;
    uploadedFile = null;
    uploadedFileBytes = null;
    update();
  }

  clearTimelineData() {
    timelineDiscriptionController.clear();
    timelineHashtagController.clear();
    timeLineDate = DateTime.now();
    update();
  }

  List<String> extractHashtags(String input) {
    final RegExp hashtagRegExp = RegExp(r'#[\w]+');
    return hashtagRegExp
        .allMatches(input)
        .map((match) => match.group(0)!)
        .toList();
  }

  timeLineAddAPI(ProgressLoader pl, BuildContext context) async {
    if (selectedVideo == null) {
      showToast(
          context: context,
          title: 'Error',
          message: 'Please select Attachment!',
          bgColor: AppColors.red);
    } else {
      List? hashTags;
      if (timelineHashtagController.text.isNotEmpty) {
        hashTags = extractHashtags(timelineHashtagController.text);
      }

      try {
        await pl.show();

        var data = {
          "postType": "incident",
          "eventPostId": getSingleEventData.id,
          "attachmentId": selectedVideo?.attachmentId ?? '',
          "description": timelineDiscriptionController.text,
          "eventTime": timeLineDate.toUtc().toIso8601String(),
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
          await getSingleEventList(getSingleEventData.id ?? '',
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
  }

  String convertTime(String utcDate) {
    DateTime utcDateTime = DateTime.parse(utcDate);

    DateTime localDateTime = utcDateTime.toLocal();

    String formattedTime = intl.DateFormat("hh:mm a").format(localDateTime);

    return formattedTime;
  }

  String formatDateData(DateTime date) {
    return intl.DateFormat('dd/MM/yyyy hh:mm a').format(date);
  }

  Future<DateTime> pickDate(BuildContext context, {DateTime? dateTime}) async {
    DateTime initialDate = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      // builder: (BuildContext context, Widget? child) {
      //   return Theme(
      //     data: Theme.of(context).copyWith(
      //       datePickerTheme: const DatePickerThemeData(
      //         backgroundColor: AppColors.borderColor,
      //         dividerColor: AppColors.blue,
      //       ),
      //       textButtonTheme: TextButtonThemeData(
      //         style: ButtonStyle(
      //           foregroundColor: WidgetStateProperty.resolveWith((states) {
      //             return AppColors.white;
      //           }),
      //           overlayColor:
      //               WidgetStateProperty.all(Colors.blue.withValues(alpha:0.1)),
      //         ),
      //       ),
      //       materialTapTargetSize: tapTargetSize,
      //     ),
      //     child: Directionality(
      //       textDirection: textDirection,
      //       child: MediaQuery(
      //         data: MediaQuery.of(context).copyWith(
      //           alwaysUse24HourFormat: false,
      //         ),
      //         child: child!,
      //       ),
      //     ),
      //   );
      // },
    );

    if (pickedDate != null) {
      DateTime pickedFinalDateTime = await pickTime(context, pickedDate);

      // return  intl.DateFormat('dd/MM/yyyy hh:mm a').format(pickedFinalDateTime);
      return pickedFinalDateTime;
    } else {
      if (dateTime != null) {
        return dateTime;
      } else {
        return DateTime.now();
      }
    }
  }

  Future<DateTime> pickTime(BuildContext context, DateTime selectedDate) async {
    DateTime? finalDateTime;
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: entryMode,
      // builder: (BuildContext context, Widget? child) {
      //   return Theme(
      //     data: Theme.of(context).copyWith(
      //       timePickerTheme: TimePickerThemeData(
      //         backgroundColor: AppColors.borderColor,
      //         hourMinuteColor: WidgetStateColor.resolveWith(
      //           (states) => AppColors.drawerBgColor,
      //         ),
      //         dialHandColor: AppColors.blue,
      //         dialBackgroundColor: AppColors.drawerBgColor,
      //         entryModeIconColor: AppColors.white,
      //       ),
      //       textButtonTheme: TextButtonThemeData(
      //         style: ButtonStyle(
      //           foregroundColor: WidgetStateProperty.resolveWith((states) {
      //             return AppColors.white;
      //           }),
      //           overlayColor:
      //               WidgetStateProperty.all(Colors.blue.withValues(alpha:0.1)),
      //         ),
      //       ),
      //       materialTapTargetSize: tapTargetSize,
      //     ),
      //     child: Directionality(
      //       textDirection: textDirection,
      //       child: MediaQuery(
      //         data: MediaQuery.of(context).copyWith(
      //           alwaysUse24HourFormat: false,
      //         ),
      //         child: child!,
      //       ),
      //     ),
      //   );
      // },
    );

    if (pickedTime != null) {
      finalDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    }
    update();
    return finalDateTime ?? DateTime.now();
  }

  openCommentBox(BuildContext context) async {
    showDialog(
      context: context,
      routeSettings: const RouteSettings(name: '/event/eventComment'),
      builder: (context) {
        return const CommentDailoge();
      },
    );
  }

  Future<void> deleteEventApiCalling(
      String eventId, BuildContext context) async {
    try {
      EventController eventController = Get.find();
      detailLoader.value = true;
      ResponseModel res =
          await EventRepository.deleteEvent(id: eventId, context: context);

      if (res.status == true) {
        NavigatorRoute.navigateBack(context: context);
        showToast(context: context, title: 'Event', message: res.message);
        eventController.filterEvents.clear();
        eventController.pageNumber = 1;
        eventController.eventSearchController.clear();
        await eventController.getEventsList(context: context);
      } else {
        showToast(
            context: context,
            title: 'Event',
            message: res.message,
            bgColor: AppColors.red);
        log(' Events delete  :- $res');
      }
      update();
      detailLoader.value = false;
    } catch (e) {
      detailLoader.value = false;
      log(' Events delete :- $e');
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

        await getSingleEventList(getSingleEventData.id ?? '', context: context);
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

  getAllReactions({
    required BuildContext context,
  }) async {
    try {
      detailLoader.value = true;
      ResponseModel? res =
          await ReactionAndCategoryRepository.getAllReactions(context: context);
      if (res.status == true) {
        ReactionsModel reactionsModel = ReactionsModel.fromJson(res.toJson());
        eventReaction.clear();
        eventReaction.addAll(reactionsModel.body!);
        update();
        log('All Reactions :- $eventReaction');
      } else {
        log('Get All Reactions :- ${res.message}');
      }
      detailLoader.value = false;
    } catch (e) {
      detailLoader.value = false;
      log('Get All Reactions :- $e');
    }
  }

  getAllCategories({
    required BuildContext context,
  }) async {
    try {
      detailLoader.value = true;
      ResponseModel res = await ReactionAndCategoryRepository.getAllCategories(
          context: context, postType: 'incident');
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
      detailLoader.value = false;
    } catch (e) {
      detailLoader.value = false;
      log('Get All Categories :- $e');
    }
  }

  Future<void> getSingleEventList(String eventId,
      {required BuildContext context}) async {
    try {
      detailLoader.value = true;
      ResponseModel res = await EventRepository.getSingleEvent(
          context: context, postType: 'incident', id: eventId);

      if (res.status == true) {
        GetSingleEventModel getSingleEventModel =
            GetSingleEventModel.fromJson(res.toJson());

        getSingleEventData = getSingleEventModel.body ?? GetSingleEventData();
        eventAttachmentList = getSingleEventData.attachmentWithTimeline ?? [];

        setSingleEventData();
      } else {
        log('Get single Events :- $res');
      }
      update();
      detailLoader.value = false;
    } catch (e) {
      detailLoader.value = false;
      log('Get single Event :- $e');
    }
  }

  setSingleEventData() {
    descriptionList.clear();
    dateTimeList.clear();
    eventTitleController.text = getSingleEventData.title ?? '';
    eventDescriptionController.text = getSingleEventData.description ?? '';
    eventLocationController.text = getSingleEventData.address ?? '';
    eventLikeController.text =
        getSingleEventData.reactionCounts?.toString() ?? '';
    eventShareController.text =
        getSingleEventData.sharedCount?.toString() ?? '';
    eventViewController.text = getSingleEventData.viewCounts?.toString() ?? '';
    eventCommentController.text =
        getSingleEventData.commentCounts?.toString() ?? '';
    eventLatController.text = getSingleEventData.latitude?.toString() ?? '';
    eventLongController.text = getSingleEventData.longitude?.toString() ?? '';
    eventHashtagController.text = getSingleEventData.hashTags
            ?.toString()
            .replaceAll('[', '')
            .replaceAll(']', '') ??
        '';

    // firstPostDate = intl.DateFormat('dd/MM/yyyy hh:mm a').format(
    //     getSingleEventData.eventTime != null && getSingleEventData.eventTime!.isNotEmpty
    //         ? DateTime.parse(getSingleEventData.eventTime!).toLocal()
    //         : DateTime.now().toLocal());
    selectedDateTime = getSingleEventData.eventTime != null &&
            getSingleEventData.eventTime!.isNotEmpty
        ? DateTime.parse(getSingleEventData.eventTime!).toLocal()
        : DateTime.now();

    for (var element in eventCategory) {
      if (element.id == getSingleEventData.postCategoryId) {
        selectedValue = element;
      }
    }

    for (var element in eventReaction) {
      if (element.id == getSingleEventData.reactionId) {
        selectedEventReaction = element;
      }
    }

    for (var element in getSingleEventData.attachmentWithTimeline ?? []) {
      descriptionList
          .add(TextEditingController(text: element.description ?? ""));
    }
    for (var element in getSingleEventData.attachmentWithTimeline ?? []) {
      dateTimeList.add(
          element.eventTime != null && element.eventTime!.isNotEmpty
              ? DateTime.parse(element.eventTime!).toLocal()
              : DateTime.now());
    }

    update();
  }

  updateEvent(BuildContext context, ProgressLoader pl) async {
    EventController eventController = Get.find();
    if (selectedValue == null) {
      showToast(
          context: context,
          title: 'Event!',
          message: 'Please select event category',
          bgColor: AppColors.red);
      return;
    } /* else if (selectedEventReaction == null) {
      showToast(
          context: context,
          title: 'Event!',
          message: 'Please select event reaction',
          bgColor: AppColors.red);
      return;
    }*/
    else if (formKey.currentState?.validate() == true) {
      try {
        List hashTags = [];

        if (eventHashtagController.text.isNotEmpty) {
          hashTags = extractHashtags(eventHashtagController.text);
        }

        await pl.show();

        List<EventAttachmentWithTimeline> timeLineAttachmentsList = [];

        if (getSingleEventData.attachmentWithTimeline != null) {
          for (int i = 0;
              i < getSingleEventData.attachmentWithTimeline!.length;
              i++) {
            timeLineAttachmentsList.add(
              EventAttachmentWithTimeline(
                userId: getSingleEventData.attachmentWithTimeline![i].userId,
                address: getSingleEventData.attachmentWithTimeline![i].address,
                attachment:
                    getSingleEventData.attachmentWithTimeline![i].attachment,
                isHover: getSingleEventData.attachmentWithTimeline![i].isHover,
                attachmentId:
                    getSingleEventData.attachmentWithTimeline![i].attachmentId,
                description: descriptionList[i].text,
                eventTime: dateTimeList[i].toUtc().toIso8601String(),
                name: getSingleEventData.attachmentWithTimeline![i].name,
                profilePicture: getSingleEventData
                    .attachmentWithTimeline![i].profilePicture,
                thumbnail:
                    getSingleEventData.attachmentWithTimeline![i].thumbnail,
                type: getSingleEventData.attachmentWithTimeline![i].type,
              ),
            );
          }
        }
        Uint8List? attachmentByte;

        if (postFirstFile != null) {
          attachmentByte = await postFirstFile!.readAsBytes();
        }

        var data = {
          'eventPostId': getSingleEventData.id,
          'postType': 'incident',
          'latitude': num.parse(eventLatController.text),
          'longitude': num.parse(eventLongController.text),
          'title': eventTitleController.text,
          if (eventDescriptionController.text.isNotEmpty)
            'description': eventDescriptionController.text,
          'eventTime': selectedDateTime.toUtc().toIso8601String(),
          if (selectedEventReaction != null)
            'reactionId': selectedEventReaction?.id ?? '',
          if (eventLocationController.text.isNotEmpty)
            'address': eventLocationController.text,
          'commentCounts': eventCommentController.text,
          'reactionCounts': eventLikeController.text,
          'viewCounts': eventViewController.text,
          'sharedCount': eventShareController.text,
          'postCategoryId': selectedValue?.id ?? '',
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
          eventController.filterEvents.clear();
          eventController.pageNumber = 1;
          eventController.eventSearchController.clear();
          await eventController.getEventsList(context: context);
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
        log('Create Event :- $e');
      }
    }
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
          getSingleEventData.attachmentWithTimeline?[index].videoBytes ??
              Uint8List(0);

      Map<String, dynamic> data = {
        'eventPostId': getSingleEventData.id,
        'attachmentId':
            getSingleEventData.attachmentWithTimeline?[index].attachmentId ??
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
        GetSingleEventData data = GetSingleEventData.fromJson(res.body);
        // eventAttachmentList = getSingleEventData.attachmentWithTimeline ?? [];
        getSingleEventData.attachmentWithTimeline?[index].thumbnail =
            data.attachmentWithTimeline?[index].thumbnail;
        getSingleEventData.attachmentWithTimeline?[index].attachment =
            data.attachmentWithTimeline?[index].attachment;
        getSingleEventData.attachmentWithTimeline?[index].attachmentFileType =
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

  onRefresh({
    required BuildContext context,
  }) async {
    Get.put(EventController());
    await getAllCategories(context: context);
    await getAllReactions(context: context);
    await getSingleEventList(StorageService.getEventId() ?? '',
        context: context);
  }

  @override
  void onReady() {
    // onRefresh();
    super.onReady();
  }
}
