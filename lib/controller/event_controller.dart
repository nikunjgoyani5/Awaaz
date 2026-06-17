import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart' as test;
import 'package:eagle_eye_admin/api/repository/event_repository.dart';
import 'package:eagle_eye_admin/api/repository/reaction_and_category_repository.dart';
import 'package:eagle_eye_admin/api/repository/user_repository.dart';
import 'package:eagle_eye_admin/model/categories_model.dart';
import 'package:eagle_eye_admin/model/get_event_drafts_model.dart';
import 'package:eagle_eye_admin/model/get_filter_events.dart';
import 'package:eagle_eye_admin/model/reactions_model.dart';
import 'package:eagle_eye_admin/model/response_model.dart';
import 'package:eagle_eye_admin/model/search_location_model.dart';
import 'package:eagle_eye_admin/model/single_event_model.dart';
import 'package:eagle_eye_admin/page/dashboard_screen/components/location_dailoge.dart';
import 'package:eagle_eye_admin/page/event_screen/add_new_events.dart';
import 'package:eagle_eye_admin/page/event_screen/component/event_preview_dailoge.dart';
import 'package:eagle_eye_admin/page/user_profile_screen/user_profile_view.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/service/storage/storage_service.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/widget/dailoges.dart';
import 'package:eagle_eye_admin/widget/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;

enum MediaType { image, video }

class EventController extends GetxController {
  TextEditingController eventCategoryController = TextEditingController();
  TextEditingController eventSubCategoryController = TextEditingController();

  TextEditingController eventTitleController = TextEditingController();
  TextEditingController eventDescriptionController = TextEditingController();
  TextEditingController eventTimeController = TextEditingController();
  TextEditingController eventLocationController = TextEditingController();
  TextEditingController eventAddressController = TextEditingController();
  TextEditingController eventLatitudeController = TextEditingController();
  TextEditingController eventLongitudeController = TextEditingController();
  TextEditingController eventLikeController = TextEditingController();
  TextEditingController eventShareController = TextEditingController();
  TextEditingController eventViewController = TextEditingController();
  TextEditingController eventCommentController = TextEditingController();
  TextEditingController eventHashtagController = TextEditingController();
  ScrollController eventDetailsScrollController = ScrollController();
  ScrollController eventAttachScrollController = ScrollController();
  ScrollController dashboardEventScrollController = ScrollController();
  ScrollController createEventScrollController = ScrollController();
  TextEditingController eventSearchController = TextEditingController();
  TextEditingController distanceController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final categoryFormKey = GlobalKey<FormState>();
  DateTime focusedDay = DateTime.now();
  int selectedContainerValue = 0;
  bool isSharePublically = true;
  bool isEventPrivate = false;
  TimeOfDay? selectedTime;
  TimeOfDay? selectedTimeLineTime;
  TimePickerEntryMode entryMode = TimePickerEntryMode.dial;
  Orientation? orientation;
  TextDirection textDirection = TextDirection.ltr;
  MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;
  bool use24HourTime = false;
  Categorie? selectedValue;
  Categorie? selectedSubcategory;
  Reaction? selectedEventReaction;
  XFile? selectedImageOrVideo;
  XFile? selectedFile;
  Uint8List? selectedImageOrVideoBytes;
  XFile? selectedAttachEventFile;

  XFile? thumbnailImage;
  Uint8List? thumbnailImageBytes;

  XFile? customThumbnailFile;
  Uint8List? customThumbnailBytes;

  String? fileName;
  bool isSelectAttachPost = false;
  Color finalTotalEventContainerColor = AppColors.drawerBgColor;
  Color totalEventApproveContainerColor = AppColors.drawerBgColor;
  Color totalEventDisApproveContainerColor = AppColors.drawerBgColor;

  String timeDataInString = '';

  bool isClearFilter = false;

  bool isHoverFilter = false;

  double radiusValue = 50.00;
  double selectedRadiusValue = 50.00;
  double selectedSubTab = 1.1;

  List<FilterEvents> filterEvents = [];
  List<FilterEvents> searchedEvents = [];

  GetFilterEventModel getFilterEventModel = GetFilterEventModel();

  RxBool loader = false.obs;

  RxBool detailLoader = false.obs;
  RxBool draftLoader = false.obs;

  List<EventDraftData> draftList = [];

  List<Categorie> eventCategory = [];
  List<Reaction> eventReaction = [];

  int pageNumber = 1;
  RxBool paginationLoader = false.obs;

  GetSingleEventData getSingleEventData = GetSingleEventData();

  FilterEvents selectedEvent = FilterEvents();
  EventDraftData selectedEventDraftData = EventDraftData();

  SearchedAddress? selectedLocation;

  double latitude = 0.0;
  double longitude = 0.0;

  Timer? debounce;

  Future<TimeOfDay> pickTime(BuildContext context,
      {TimeOfDay? selectedTime}) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      initialEntryMode: entryMode,
      orientation: orientation,
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
          child: Directionality(
            textDirection: textDirection,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: use24HourTime,
              ),
              child: child!,
            ),
          ),
        );
      },
    );

    return time ?? TimeOfDay.now();
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

  openVideoOrImageDailoge({required BuildContext context}) async {
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

  clearAllData() {
    eventCategoryController.clear();
    eventTitleController.clear();
    eventDescriptionController.clear();
    eventTimeController.clear();
    eventLocationController.clear();
    isSharePublically = true;
    isEventPrivate = false;
    selectedTime = null;
    selectedValue = null;
    selectedEventReaction = null;
    selectedFile = null;
    fileName = null;
    update();
  }

  openAddEventDialog(
    String page,
    BuildContext context,
  ) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      routeSettings: const RouteSettings(name: '/event/addEvent'),
      builder: (context) {
        return AddNewEvents(
          isUser: false,
          page: page,
          selectedEvent: null,
        );
      },
    );
  }

  openUserProfileView(
      {required String userId, required BuildContext context}) async {
    showDialog(
      context: context,
      routeSettings: const RouteSettings(name: '/event/userProfile'),
      builder: (context) {
        return UserProfileView(
          userId: userId,
        );
      },
    );
  }

  openAddEventAndAttachImgDialog(
      {bool? isQuickEvent,
      required BuildContext context,
      String? draftId}) async {
    // await Get.dialog( AddEventAndAttachDailoge(isQuickApprove: isQuickEvent ?? false),
    //     routeSettings: const RouteSettings(name: '/event/addEventAndAttach'));

    showDialog(
      context: context,
      routeSettings: const RouteSettings(name: '/event/addEventAndAttach'),
      builder: (context) {
        return AddEventAndAttachDailoge(
          isQuickApprove: isQuickEvent ?? false,
          draftId: draftId,
        );
      },
    );
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
          filterEvents.clear();
          pageNumber = 1;
          eventSearchController.clear();
          await getEventsList(context: context);
        }
      },
    );

    // await Get.dialog(const LocationDailoge(),
    //     routeSettings: const RouteSettings(name: '/event/location'));
  }

  openEventPreview(BuildContext context, String mediaPath) async {
    showDialog(
      context: context,
      routeSettings: const RouteSettings(name: '/event/eventPreview'),
      builder: (context) {
        return EventPreviewDailoge(
          videoPath: mediaPath,
        );
      },
    );
  }

  getAllReactions({required BuildContext context}) async {
    try {
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
    } catch (e) {
      log('Get All Reactions :- $e');
    }
  }

  getAllCategories({
    required BuildContext context,
  }) async {
    try {
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
    } catch (e) {
      log('Get All Categories :- $e');
    }
  }

  List<String> extractHashtags(String input) {
    final RegExp hashtagRegExp = RegExp(r'#[\w]+');
    return hashtagRegExp
        .allMatches(input)
        .map((match) => match.group(0)!)
        .toList();
  }

  createEvent(BuildContext context, ProgressLoader pl, bool isUser) async {
    if (selectedValue == null) {
      showToast(
          context: context,
          title: 'Event!',
          message: 'Please select event category',
          bgColor: AppColors.red);
      return;
    }
    /*else if (selectedEventReaction == null) {
      showToast(
          context: context,
          title: 'Event!',
          message: 'Please select event reaction',
          bgColor: AppColors.red);
      return;
    }*/
    else if (isUser == false && selectedImageOrVideo == null) {
      showToast(
          context: context,
          title: 'Event!',
          message: 'Please select attachment',
          bgColor: AppColors.red);
      return;
    } else if (formKey.currentState?.validate() == true) {
      try {
        await pl.show();

        List hashTags = [];
        bool sendThumbnail = true;

        if (eventHashtagController.text.isNotEmpty) {
          hashTags = extractHashtags(eventHashtagController.text);
        }

        Uint8List? attachmentByte;
        Uint8List? thumbnailByte;

        if (selectedImageOrVideo != null) {
          attachmentByte = await selectedImageOrVideo!.readAsBytes();
        }

        if (customThumbnailFile == null && thumbnailImage == null) {
          sendThumbnail = false;
        }
        if (customThumbnailFile != null) {
          thumbnailByte = customThumbnailBytes;
        } else {
          thumbnailByte = thumbnailImageBytes;
        }

        var data = {
          'postType': 'incident',
          'latitude': num.parse(eventLatitudeController.text),
          'longitude': num.parse(eventLongitudeController.text),
          'title': eventTitleController.text,
          if (eventDescriptionController.text.isNotEmpty)
            'description': eventDescriptionController.text,
          'eventTime': selectedDateTime.toUtc().toIso8601String(),
          if (selectedEventReaction != null)
            'reactionId': selectedEventReaction?.id ?? '',
          if (eventAddressController.text.isNotEmpty)
            'address': eventAddressController.text,
          if (isUser == true) 'userId': selectedEvent.userId ?? '',
          if (isUser == true) 'userRequestedEventId': selectedEvent.id ?? '',

          // 'isThumbnail': true,
          'isShareAnonymously': selectedEvent.isShareAnonymously,
          'isSensitiveContent': isEventPrivate,
          'postCategoryId': selectedValue?.id ?? '',
          if (isUser == true) 'attachment': selectedEvent.attachment ?? '',
          if (isUser == true && sendThumbnail == false)
            'thumbnail': selectedEvent.thumbnail ?? '',
          "isDirectAdminPost": isUser == true ? false : true,
          if (isUser == false && selectedImageOrVideo != null)
            'gallaryAttachment': test.MultipartFile.fromBytes(
              attachmentByte ?? Uint8List(0),
              filename: selectedImageOrVideo!.name,
            ),
          'hashTags[]': hashTags,

          if (sendThumbnail == true)
            'gallaryThumbnail': test.MultipartFile.fromBytes(
                thumbnailByte ?? Uint8List(0),
                filename: 'thumbnail.png'),

          // if (isUser == false && thumbnailImage != null)
          //   'gallaryThumbnail': test.MultipartFile.fromBytes(
          //       thumbnailImageBytes ?? Uint8List(0),
          //       filename: 'thumbnail.png'),
        };

        log('Create Event Data :- $data');

        ResponseModel res =
            await EventRepository.createEventPost(context: context, data: data);
        await pl.hide();
        if (res.status == true) {
          NavigatorRoute.navigateBack(context: context);
          showToast(context: context, title: 'Success', message: res.message);
          filterEvents.clear();
          pageNumber = 1;
          eventSearchController.clear();
          await getEventsList(context: context);

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
        log('Create Event :- $e');
      }
    }
  }

  createQuickEvent(BuildContext context, ProgressLoader pl, bool isUser) async {
    try {
      await pl.show();

      List hashTags = [];

      if (eventHashtagController.text.isNotEmpty) {
        hashTags = extractHashtags(eventHashtagController.text);
      }

      var data = {
        'postType': 'incident',
        'latitude': num.parse(eventLatitudeController.text),
        'longitude': num.parse(eventLongitudeController.text),
        'title': eventTitleController.text,
        if (eventDescriptionController.text.isNotEmpty)
          'description': eventDescriptionController.text,
        'eventTime': selectedDateTime.toUtc().toIso8601String(),
        if (selectedEventReaction != null)
          'reactionId': selectedEventReaction?.id ?? '',
        if (eventAddressController.text.isNotEmpty)
          'address': eventAddressController.text,
        'userId': selectedEvent.userId ?? '',
        'userRequestedEventId': selectedEvent.id ?? '',
        // 'isThumbnail': true,
        'thumbnail': selectedEvent.thumbnail ?? '',
        'isShareAnonymously': selectedEvent.isShareAnonymously,
        'isSensitiveContent': isEventPrivate,
        'postCategoryId': selectedValue?.id ?? '',
        'attachment': selectedEvent.attachment ?? '',
        "isDirectAdminPost": false,
        'hashTags[]': hashTags,
      };

      log('Create Event Data :- $data');

      ResponseModel res =
          await EventRepository.createEventPost(context: context, data: data);
      await pl.hide();
      if (res.status == true) {
        NavigatorRoute.navigateBack(context: context);
        showToast(context: context, title: 'Success', message: res.message);
        filterEvents.clear();
        pageNumber = 1;
        eventSearchController.clear();
        await getEventsList(context: context);
      } else {
        showToast(
            context: context,
            title: 'Error',
            message: res.message,
            bgColor: AppColors.red);
        await openAddEventAndAttachImgDialog(
            isQuickEvent: true, context: context);
      }
    } catch (e) {
      showToast(
          context: context,
          title: 'Error',
          message: 'Something went wrong !',
          bgColor: AppColors.red);

      await pl.hide();
      log('Create Event :- ${e.toString()}');
    }
  }

  void filterItems(String query) {
    searchedEvents = filterEvents.where((item) {
      return (item.title?.toLowerCase() ?? '').contains(query.toLowerCase()) ||
          (item.description?.toLowerCase() ?? '').contains(query.toLowerCase());
    }).toList();
    update();
  }

  void filterCategoryId(String query) {
    eventCategory = eventCategory.where((item) {
      return (item.eventName?.toLowerCase() ?? '')
          .contains(query.toLowerCase());
    }).toList();

    update();
  }

  Future createDraftEvent(
      BuildContext context, ProgressLoader pl, bool isUser) async {
    try {
      await pl.show();

      List hashTags = [];
      bool sendThumbnail = true;

      if (eventHashtagController.text.isNotEmpty) {
        hashTags = extractHashtags(eventHashtagController.text);
      }

      Uint8List? attachmentByte;
      Uint8List? thumbnailByte;

      if (selectedImageOrVideo != null) {
        attachmentByte = await selectedImageOrVideo!.readAsBytes();
      }

      if (customThumbnailFile == null && thumbnailImage == null) {
        sendThumbnail = false;
      }
      if (customThumbnailFile != null) {
        thumbnailByte = customThumbnailBytes;
      } else {
        thumbnailByte = thumbnailImageBytes;
      }

      var data = {
        'postType': 'incident',
        if (eventLatitudeController.text.isNotEmpty)
          'latitude': num.parse(eventLatitudeController.text),
        if (eventLongitudeController.text.isNotEmpty)
          'longitude': num.parse(eventLongitudeController.text),
        if (eventTitleController.text.isNotEmpty)
          'title': eventTitleController.text,
        if (eventDescriptionController.text.isNotEmpty)
          'description': eventDescriptionController.text,
        'eventTime': selectedDateTime.toUtc().toIso8601String(),
        if (selectedEventReaction != null)
          'reactionId': selectedEventReaction?.id ?? '',
        if (eventAddressController.text.isNotEmpty)
          'address': eventAddressController.text,
        if (isUser == true) 'userId': selectedEvent.userId ?? '',
        if (isUser == true) 'userRequestedEventId': selectedEvent.id ?? '',

        // 'isThumbnail': true,
        'isShareAnonymously': selectedEvent.isShareAnonymously,

        'isSensitiveContent': isEventPrivate,
        if (selectedValue?.id != null && selectedValue!.id != '')
          'postCategoryId': selectedValue?.id ?? '',
        if (isUser == true) 'attachment': selectedEvent.attachment ?? '',
        if (isUser == true && sendThumbnail == false)
          'thumbnail': selectedEvent.thumbnail ?? '',
        "isDirectAdminPost": isUser == true ? false : true,

        if (isUser == false && selectedImageOrVideo != null)
          'gallaryAttachment': test.MultipartFile.fromBytes(
            attachmentByte ?? Uint8List(0),
            filename: selectedImageOrVideo!.name,
          ),
        'hashTags[]': hashTags,

        if (sendThumbnail == true)
          'gallaryThumbnail': test.MultipartFile.fromBytes(
              thumbnailByte ?? Uint8List(0),
              filename: 'thumbnail.png'),

        // if (isUser == false && thumbnailImage != null)
        //   'gallaryThumbnail': test.MultipartFile.fromBytes(
        //       thumbnailImageBytes ?? Uint8List(0),
        //       filename: 'thumbnail.png'),
      };

      log('Create Draft Event Data :- $data');

      ResponseModel res =
          await EventRepository.createEventDraft(context: context, data: data);
      await pl.hide();
      if (res.status == true) {
        NavigatorRoute.navigateBack(context: context);
        showToast(context: context, title: 'Draft Event', message: res.message);
      } else {
        showToast(
            context: context,
            title: 'Draft Event',
            message: res.message,
            bgColor: AppColors.red);
      }
    } catch (e) {
      await pl.hide();
      log('Create Draft Event :- $e');
    }
  }

  Future<void> getEventDraftList({
    required BuildContext context,
  }) async {
    // log('=====Latitude $latitude=========Longitude $longitude');
    try {
      draftLoader.value = true;

      ResponseModel res = await EventRepository.getEventDrafts(
          context: context, postType: 'incident');

      if (res.status == true) {
        GetEventDraftsModel getEventDraftsModel =
            GetEventDraftsModel.fromJson(res.toJson());

        draftList = (getEventDraftsModel.body ?? []);

        log('All Event Drafts List:- $draftList');

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
  }) async {
    try {
      await pl.show();

      ResponseModel res = await EventRepository.deleteEventDraft(
          draftId: draftId, context: context);

      if (res.status == true) {
        await pl.hide();
        showToast(
            context: context, title: 'Delete Draft', message: res.message);
        await getEventDraftList(context: context);

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

      log('delete Event drafts :- $e');

      await pl.hide();
    }
  }

  Future updateEventDraft(
      {required BuildContext context,
      required ProgressLoader pl,
      required bool isUser,
      required String draftId}) async {
    if (selectedValue == null) {
      showToast(
          context: context,
          title: 'Event!',
          message: 'Please select event category',
          bgColor: AppColors.red);
      return;
    } else if (selectedImageOrVideo == null &&
        selectedEventDraftData.attachment == null) {
      showToast(
          context: context,
          title: 'Event!',
          message: 'Please select attachment',
          bgColor: AppColors.red);
      return;
    } else if (formKey.currentState?.validate() == true) {
      try {
        await pl.show();

        List hashTags = [];
        bool sendThumbnail = true;

        if (eventHashtagController.text.isNotEmpty) {
          hashTags = extractHashtags(eventHashtagController.text);
        }

        Uint8List? thumbnailByte;

        if (customThumbnailFile == null && thumbnailImage == null) {
          sendThumbnail = false;
        }
        if (customThumbnailFile != null) {
          thumbnailByte = customThumbnailBytes;
        } else {
          thumbnailByte = thumbnailImageBytes;
        }

        var data = {
          'postType': 'incident',
          'latitude': num.parse(eventLatitudeController.text),
          'longitude': num.parse(eventLongitudeController.text),
          'title': eventTitleController.text,
          if (eventDescriptionController.text.isNotEmpty)
            'description': eventDescriptionController.text,
          'eventTime': selectedDateTime.toUtc().toIso8601String(),
          if (selectedEventReaction != null)
            'reactionId': selectedEventReaction?.id ?? '',
          if (eventAddressController.text.isNotEmpty)
            'address': eventAddressController.text,
          if (selectedEventDraftData.userId != null)
            'userId': selectedEventDraftData.userId ?? '',

          if (selectedEventDraftData.userRequestedEventId != null)
            'userRequestedEventId':
                selectedEventDraftData.userRequestedEventId ?? '',

          // 'isThumbnail': true,
          'isShareAnonymously':
              selectedEventDraftData.isShareAnonymously ?? false,
          'isSensitiveContent': isEventPrivate,
          'postCategoryId': selectedValue?.id ?? '',
          'attachment': selectedEventDraftData.attachment ?? '',
          if (sendThumbnail == false)
            'thumbnail': selectedEventDraftData.thumbnail ?? '',
          "isDirectAdminPost":
              selectedEventDraftData.isDirectAdminPost ?? false,
          'hashTags[]': hashTags,
          'adminPostDraftId': draftId,

          if (sendThumbnail == true)
            'gallaryThumbnail': test.MultipartFile.fromBytes(
                thumbnailByte ?? Uint8List(0),
                filename: 'thumbnail.png'),
        };

        log('Create Event Data :- $data');

        ResponseModel res =
            await EventRepository.createEventPost(context: context, data: data);
        await pl.hide();
        if (res.status == true) {
          NavigatorRoute.navigateBack(context: context);
          showToast(context: context, title: 'Success', message: res.message);
          selectedSubTab = 1.1;
          update();
          filterEvents.clear();
          pageNumber = 1;
          eventSearchController.clear();
          await getEventsList(context: context);
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

  eventPagination(BuildContext context) {
    paginationLoader.value = true;
    pageNumber++;
    eventSearchController.clear();
    getEventsList(context: context);
    update();
  }

  String? filterType;

  Future<void> getEventsList(
      {String? filterType, required BuildContext context}) async {
    // log('=====Latitude $latitude=========Longitude $longitude');
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
                      ? 'Approved'
                      : selectedContainerValue == 2
                          ? "Rejected"
                          : 'Pending'),
          page: pageNumber.toString(),
          postType: 'incident',
          date: utcDate,
          isDate: true,
          longitude: longitude,
          latitude: latitude,
          isFilter: isClearFilter,
          distance: double.parse(selectedRadiusValue.toStringAsFixed(2)),
          search: eventSearchController.text);

      if (res.status == true) {
        getFilterEventModel = GetFilterEventModel.fromJson(res.toJson());

        filterEvents = filterEvents + (getFilterEventModel.body?.data ?? []);

        log('All Events List:- $filterEvents');
        paginationLoader.value = false;
        loader.value = false;
      } else {
        filterEvents = filterEvents;
        log('Get All Events :- $res');
        paginationLoader.value = false;
        loader.value = false;
      }
      update();
    } catch (e) {
      filterEvents = filterEvents;
      paginationLoader.value = false;
      loader.value = false;
      log('Get All Event :- $e');
    }
  }

  setDraftEventData() {
    eventTitleController.text = selectedEventDraftData.title ?? '';
    eventDescriptionController.text = selectedEventDraftData.description ?? '';

    eventHashtagController.text = selectedEventDraftData.hashTags
            ?.toString()
            .replaceAll('[', '')
            .replaceAll(']', '') ??
        '';

    eventAddressController.text = selectedEventDraftData.address ?? '';
    eventLatitudeController.text =
        selectedEventDraftData.latitude?.toString() ?? '';
    eventLongitudeController.text =
        selectedEventDraftData.longitude?.toString() ?? '';

    timeDataInString = intl.DateFormat('dd/MM/yyyy hh:mm a').format(
        selectedEventDraftData.eventTime != null &&
                selectedEventDraftData.eventTime!.isNotEmpty
            ? DateTime.parse(selectedEventDraftData.eventTime!).toLocal()
            : DateTime.now().toLocal());
    selectedDateTime = selectedEventDraftData.eventTime != null &&
            selectedEventDraftData.eventTime!.isNotEmpty
        ? DateTime.parse(selectedEventDraftData.eventTime!).toLocal()
        : DateTime.now();
    for (var element in eventCategory) {
      if (element.id == selectedEventDraftData.postCategoryId) {
        selectedValue = element;
      }
    }
    // update();
  }

  setCreateEventData() {
    eventTitleController.text = selectedEvent.title ?? '';
    eventDescriptionController.text = selectedEvent.description ?? '';

    eventHashtagController.text = selectedEvent.hashTags
            ?.toString()
            .replaceAll('[', '')
            .replaceAll(']', '') ??
        '';

    eventAddressController.text = selectedEvent.address ?? '';
    eventLatitudeController.text = selectedEvent.latitude?.toString() ?? '';
    eventLongitudeController.text = selectedEvent.longitude?.toString() ?? '';

    timeDataInString = intl.DateFormat('dd/MM/yyyy hh:mm a').format(
        selectedEvent.eventTime != null && selectedEvent.eventTime!.isNotEmpty
            ? DateTime.parse(selectedEvent.eventTime!).toLocal()
            : DateTime.now().toLocal());
    selectedDateTime =
        selectedEvent.eventTime != null && selectedEvent.eventTime!.isNotEmpty
            ? DateTime.parse(selectedEvent.eventTime!).toLocal()
            : DateTime.now();
    for (var element in eventCategory) {
      if (element.id == selectedEvent.postCategoryId) {
        selectedValue = element;
      }
    }
    // update();
  }

  String formatDateData(DateTime date) {
    return intl.DateFormat('dd/MM/yyyy hh:mm a').format(date);
  }

  Future<void> statusUpdateAPI(
      {required String eventId,
      required bool isNotify,
      required String status,
      required BuildContext context}) async {
    try {
      loader.value = true;
      ResponseModel res = await EventRepository.eventStatusChange(
          context: context,
          eventPostId: eventId,
          isSendNotification: isNotify,
          status: status);

      if (res.status == true) {
        filterEvents.clear();
        pageNumber = 1;

        eventSearchController.clear();
        await getEventsList(context: context);

        showToast(
            title: 'Event Status',
            message: 'Status updated successfully',
            context: context);
      } else {
        showToast(
            title: 'Event Status',
            message: res.message,
            bgColor: AppColors.red,
            context: context);
        log('Event status :- $res');
      }
      update();
      loader.value = false;
    } catch (e) {
      loader.value = false;
      log(' Event Status :- $e');
    }
  }

  DateTime selectedDateTime = DateTime.now();

  Future<void> pickDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: const DatePickerThemeData(
              backgroundColor: AppColors.borderColor,
              dividerColor: AppColors.blue,
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
          child: Directionality(
            textDirection: textDirection,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: use24HourTime,
              ),
              child: child!,
            ),
          ),
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDateTime) {
      _pickTime(context, pickedDate);
    }
  }

  Future<void> _pickTime(BuildContext context, DateTime selectedDate) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      initialEntryMode: entryMode,
      orientation: orientation,
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
          child: Directionality(
            textDirection: textDirection,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: use24HourTime,
              ),
              child: child!,
            ),
          ),
        );
      },
    );

    if (pickedTime != null) {
      selectedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    }

    timeDataInString =
        intl.DateFormat('dd/MM/yyyy hh:mm a').format(selectedDateTime);

    update();
  }

  clearEventData() {
    selectedEvent = FilterEvents();
    selectedValue = null;
    selectedEventReaction = null;
    eventTitleController.clear();
    eventDescriptionController.clear();
    eventAddressController.clear();
    eventLongitudeController.clear();
    eventLatitudeController.clear();
    eventHashtagController.clear();
    timeDataInString = '';
    selectedImageOrVideo = null;
    customThumbnailFile = null;
    thumbnailImage = null;
    thumbnailImageBytes = null;
    selectedImageOrVideoBytes = null;
    customThumbnailBytes = null;
    isEventPrivate = false;
    selectedDateTime = DateTime.now();
  }

  Future updateRadiusAPI({
    required double radius,
    required ProgressLoader pl,
    required BuildContext context,
  }) async {
    try {
      await pl.show();
      ResponseModel res = await UserRepository.updateRadius(
          context: context, radius: double.parse(radius.toStringAsFixed(2)));
      if (res.status == true) {
        log('== Radius Updated === :- ${res.body}');
        selectedRadiusValue = radius;
        await pl.hide();
      } else {
        log('===== Error Radius Updated ===== :- ${res.body}');
        await pl.hide();
      }
      update();
    } catch (e) {
      log('==== Error Radius Updated ====:- ${e.toString()}');
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
