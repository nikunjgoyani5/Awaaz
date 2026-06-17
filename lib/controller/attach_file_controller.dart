import 'dart:developer';
import 'dart:typed_data';

import 'package:eagle_eye_admin/api/repository/event_repository.dart';
import 'package:eagle_eye_admin/controller/event_controller.dart';
import 'package:eagle_eye_admin/model/get_filter_events.dart';
import 'package:eagle_eye_admin/model/response_model.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

class AttachFileController extends GetxController {
  ScrollController eventAttachScrollController = ScrollController();
  bool isSelectAttachPost = false;
  Uint8List? selectedAttachEventFile;
  TextEditingController eventDescriptionController = TextEditingController();
  TextEditingController eventHashtagController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  TimePickerEntryMode entryMode = TimePickerEntryMode.dial;

  String timeDataInString = '';

  bool isSensitive = false
  ; bool isShareAnonymously = false
  ;

  TimeOfDay selectedTime = TimeOfDay.now();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextDirection textDirection = TextDirection.ltr;
  MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;
  DateTime selectedDateTime = DateTime.now();

  RxBool loader = false.obs;

  GetFilterEventModel getFilterEventModel = GetFilterEventModel();

  FilterEvents? selectedEvent;
  List<FilterEvents> approvedEventList = [];
  List<FilterEvents> filteredApprovedEventList = [];



  String convertTime(String utcDate) {
    DateTime utcDateTime = DateTime.parse(utcDate);

    DateTime localDateTime = utcDateTime.toLocal();

    String formattedTime = intl.DateFormat("hh:mm a").format(localDateTime);

    return formattedTime;
  }

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
                    WidgetStateProperty.all(Colors.blue.withValues(alpha:0.1)),
              ),
            ),
            materialTapTargetSize: tapTargetSize,
          ),
          child: Directionality(
            textDirection: textDirection,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: false,
              ),
              child: child!,
            ),
          ),
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDateTime) {
      pickTime(context, pickedDate);
    }
  }

  Future<void> pickTime(BuildContext context, DateTime selectedDate) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: entryMode,

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
                    WidgetStateProperty.all(Colors.blue.withValues(alpha:0.1)),
              ),
            ),
            materialTapTargetSize: tapTargetSize,
          ),
          child: Directionality(
            textDirection: textDirection,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: false,
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
  List<String> extractHashtags(String input) {
    final RegExp hashtagRegExp = RegExp(r'#\w+');
    return hashtagRegExp
        .allMatches(input)
        .map((match) => match.group(0)!)
        .toList();
  }
  Future<void> attachPostEventAPI(
      {required ProgressLoader pl,
      required BuildContext context,
      required FilterEvents userPostData}) async {
    try {
      EventController eventController = Get.find<EventController>();
      await pl.show();
      List hashTags = [];

      if (eventHashtagController.text.isNotEmpty) {
        hashTags = extractHashtags(eventHashtagController.text);
      }

      var data = {
        'postType': 'incident',
        'eventPostId': selectedEvent?.id,
        'eventTime': selectedDateTime.toUtc().toIso8601String(),
        'userId': userPostData.userId,
        'description': eventDescriptionController.text,
        'isShareAnonymously': isShareAnonymously,
        'isSensitiveContent': isSensitive,
        'userRequestedEventId': userPostData.id,
        'attachment': userPostData.attachment ?? '',
        'thumbnail': userPostData.thumbnail ?? '',
        'hashTags[]': hashTags,
      };

      log('Upload File Data :- $data');

      ResponseModel res =
          await EventRepository.attachPostEvent(context: context, data: data);

      await pl.hide();
      if (res.status == true) {
        NavigatorRoute.navigateBack(context:  context);

        showToast(context: context, title: 'Success', message: res.message);

        eventController.filterEvents.clear();
        eventController.pageNumber = 1;
        eventController.eventSearchController.clear();
        await eventController.getEventsList(context: context);
      } else {
        showToast(
            context: context,
            title: 'Error',
            message: res.message,
            bgColor: AppColors.red);
      }
    } catch (e) {
      await pl.hide();
      log('Attach file :- $e');
    }
  }





  int pageNumber = 1;
  RxBool paginationLoader = false.obs;

  eventPagination({required double lat, required double long, required BuildContext context}) {
    paginationLoader.value = true;
    pageNumber++;
    getEventsList(lat: lat, long: long,context: context);
    update();
  }

  Future<void> getEventsList(
      {required double lat, required double long, required BuildContext context}) async
  {
    try {
      loader.value = paginationLoader.value == true ? false : true;

      String utcDate = DateTime.now().toUtc().toIso8601String();

      ResponseModel res = await EventRepository.getFilterEventList(
        context: context,
        filterType: 'Approved',
        page: pageNumber.toString(),
        postType: 'incident',
        date: utcDate,
        isDate: false,
        latitude: lat,
        longitude: long,
        distance: 2,
        isFilter: true,
        search: searchController.text
      );

      if (res.status == true) {
        getFilterEventModel = GetFilterEventModel.fromJson(res.toJson());

        approvedEventList =
            approvedEventList + (getFilterEventModel.body?.data ?? []);

        log('Approved Events List:- $approvedEventList');

        paginationLoader.value = false;
        loader.value = false;
      } else {
        approvedEventList = approvedEventList;
        log('Get Approved Events :- $res');
        paginationLoader.value = false;
        loader.value = false;
      }
      update();
    } catch (e) {
      approvedEventList = approvedEventList;
      paginationLoader.value = false;
      loader.value = false;
      log('Get Approved Event :- $e');
    }
  }

  void filterItems(String query) {
    filteredApprovedEventList = approvedEventList.where((item) {
      return (item.title?.toLowerCase() ?? '').contains(query.toLowerCase()) ||  (item.description?.toLowerCase() ?? '').contains(query.toLowerCase());
    }).toList();
    update();
  }


  onSelectEvent(FilterEvents userPost) {


    eventDescriptionController.text = userPost.description ?? '';
    eventHashtagController.text =
        userPost.hashTags?.toString().replaceAll('[', '').replaceAll(']', '') ??
            '';
    isShareAnonymously = userPost.isShareAnonymously;
    timeDataInString = intl.DateFormat('dd/MM/yyyy hh:mm a').format(
        userPost.eventTime != null && userPost.eventTime!.isNotEmpty
            ? DateTime.parse(userPost.eventTime!).toLocal()
            : DateTime.now().toLocal());
    selectedDateTime = userPost.eventTime != null && userPost.eventTime!.isNotEmpty
        ? DateTime.parse(userPost.eventTime!).toLocal()
        : DateTime.now();

    update();
  }



}
