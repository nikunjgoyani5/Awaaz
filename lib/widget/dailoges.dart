import 'dart:convert';

import 'package:eagle_eye_admin/controller/event_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/model/get_filter_events.dart';
import 'package:eagle_eye_admin/page/event_screen/add_new_events.dart';
import 'package:eagle_eye_admin/route/app_route.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/service/storage/storage_service.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class RegistrationSuccessDailoge extends StatelessWidget {
  final String message;

  const RegistrationSuccessDailoge({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: AppColors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.all(10.sp),
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 1024
              ? MediaQuery.of(context).size.width * 0.33
              : MediaQuery.of(context).size.width > 600
                  ? MediaQuery.of(context).size.width * 0.25
                  : MediaQuery.of(context).size.width * 0.10,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 150,
                width: 150,
                child: Lottie.asset(
                  "assets/animation/sucess_animation.json",
                  repeat: false,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Registration Successful!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              (message != "") ? message : 'You have successfully registered.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w400,
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),
            SizedBox(
              height: 45,
              width: 200,
              child: CommonButton(
                color: AppColors.black,
                onPressed: () {
                  NavigatorRoute.navigateToRemoveUntil(
                      AppRoutes.login, context);
                },
                widget: const Text(
                  'Okay',
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            ),
            const Gap(10),
          ],
        ),
      ),
    );
  }
}

class AddEventAndAttachDailoge extends StatefulWidget {
  const AddEventAndAttachDailoge(
      {super.key, required this.isQuickApprove, this.draftId});

  final bool isQuickApprove;
  final String? draftId;

  @override
  State<AddEventAndAttachDailoge> createState() =>
      _AddEventAndAttachDailogeState();
}

class _AddEventAndAttachDailogeState extends State<AddEventAndAttachDailoge> {
  Color isHoverdAddEvent = AppColors.transparent;
  Color isHoverdAttachImage = AppColors.transparent;
  GlobalKey key = GlobalKey();

  openAddEventDialog() async {
    NavigatorRoute.navigateBack(context: context);
    EventController eventController = Get.put(EventController());

    showDialog(
      barrierDismissible: false,
      context: context,
      routeSettings: const RouteSettings(name: '/event/newEvent'),
      builder: (context) {
        return AddNewEvents(
          isUser: true,
          page: "Create",
          draftId: widget.draftId,
          selectedEvent: eventController.selectedEvent,
        );
      },
    );
  }

  EventController eventController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      key: key,
      alignment: Alignment.center,
      insetPadding: EdgeInsets.only(top: 40.h),
      backgroundColor: AppColors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 1536
              ? MediaQuery.of(context).size.width * 0.34
              : MediaQuery.of(context).size.width > 1024
                  ? MediaQuery.of(context).size.width * 0.30
                  : MediaQuery.of(context).size.width > 600
                      ? MediaQuery.of(context).size.width * 0.2
                      : MediaQuery.of(context).size.width * 0.1,
        ),
        decoration: BoxDecoration(
          color: AppColors.borderColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                // Image.asset(
                //   "assets/image/profile_pic.png",
                //   height: 38,
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16),
                //   child: Text(
                //     "Angel Gouse",
                //     style: Theme.of(context).textTheme.titleMedium!.copyWith(
                //         color: AppColors.white, fontWeight: FontWeight.w600),
                //   ),
                // ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    NavigatorRoute.navigateBack(context: context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            Gap(125.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MouseRegion(
                  onHover: (event) {
                    setState(() {
                      isHoverdAddEvent = AppColors.drawerBgColor;
                    });
                  },
                  onExit: (event) {
                    setState(
                      () {
                        isHoverdAddEvent = AppColors.transparent;
                      },
                    );
                  },
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10.r),
                    onTap: () async {
                      await openAddEventDialog();
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.22,
                      width: MediaQuery.of(context).size.width < 600
                          ? 550.w
                          : MediaQuery.of(context).size.width < 1024
                              ? 350.w
                              : 220.w,
                      decoration: BoxDecoration(
                        color: isHoverdAddEvent,
                        border: Border.all(
                          width: 1.6,
                          color: AppColors.textFeildBorderColor,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.r),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 38.r,
                            backgroundColor: AppColors.blue,
                            child: Assets.icons.icAdd.svg(
                              height: 32.h,
                              width: 32.w,
                            ),
                          ),
                          Gap(20.h),
                          Text(
                            'Create a new post',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Gap(30.w),
                MouseRegion(
                  onHover: (event) {
                    setState(() {
                      isHoverdAttachImage = AppColors.drawerBgColor;
                    });
                  },
                  onExit: (event) {
                    setState(
                      () {
                        isHoverdAttachImage = AppColors.transparent;
                      },
                    );
                  },
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10.r),
                    onTap: () async {
                      NavigatorRoute.navigateBack(context: context);

                      if (widget.draftId != null) {
                        eventController.selectedEvent = FilterEvents(
                            id: eventController
                                .selectedEventDraftData.userRequestedEventId,
                            userId:
                                eventController.selectedEventDraftData.userId,
                            name: eventController.selectedEventDraftData.name,
                            longitude: eventController
                                .selectedEventDraftData.longitude,
                            latitude:
                                eventController.selectedEventDraftData.latitude,
                            thumbnail: eventController
                                .selectedEventDraftData.thumbnail,
                            profilePicture: eventController
                                .selectedEventDraftData.profilePicture,
                            eventTime: eventController
                                .selectedEventDraftData.eventTime,
                            description: eventController
                                .selectedEventDraftData.description,
                            attachment: eventController
                                .selectedEventDraftData.attachment,
                            address:
                                eventController.selectedEventDraftData.address,
                            title: eventController.selectedEventDraftData.title,
                            attachmentFileType: eventController
                                .selectedEventDraftData.attachmentFileType,
                            hashTags:
                                eventController.selectedEventDraftData.hashTags,
                            isShareAnonymously: eventController
                                    .selectedEventDraftData
                                    .isShareAnonymously ??
                                false,
                            postCategoryId: eventController
                                .selectedEventDraftData.postCategoryId,
                            verifiedEventCounts: null,
                            status: 'Pending');
                      }

                      String eventJson =
                          jsonEncode(eventController.selectedEvent.toJson());

                      StorageService.saveUserPOst(eventJson);

                      await NavigatorRoute.navigateTo(
                          AppRoutes.attachEvent, context,
                          arguments: eventController.selectedEvent);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.22,
                      width: MediaQuery.of(context).size.width < 600
                          ? 550.w
                          : MediaQuery.of(context).size.width < 1024
                              ? 350.w
                              : 220.w,
                      decoration: BoxDecoration(
                        color: isHoverdAttachImage,
                        border: Border.all(
                          width: 1.6,
                          color: AppColors.textFeildBorderColor,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.r),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 38.r,
                            backgroundColor: AppColors.green,
                            child: Assets.icons.icAttachFile.svg(
                              height: 32.h,
                              width: 32.w,
                            ),
                          ),
                          Gap(20.h),
                          Text(
                            'Attach File',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                          Gap(2.h),
                          Text(
                            ' Photo / Video',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: AppColors.grey909090,
                                      fontWeight: FontWeight.w400,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Gap(30.h),
            widget.isQuickApprove == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '*Please fill all details!',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: AppColors.red,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ],
                  )
                : const SizedBox(),
            Gap(140.h),
          ],
        ),
      ),
    );
  }
}

class PhotoOrVideoOptionDailoge extends StatefulWidget {
  final void Function()? onPhotoTap;
  final void Function()? onVideoTap;
  final bool? isVideoHide;

  const PhotoOrVideoOptionDailoge(
      {super.key, this.onPhotoTap, this.onVideoTap, this.isVideoHide});

  @override
  State<PhotoOrVideoOptionDailoge> createState() =>
      _PhotoOrVideoOptionDailogeState();
}

class _PhotoOrVideoOptionDailogeState extends State<PhotoOrVideoOptionDailoge> {
  Color isHoverdAddEvent = AppColors.transparent;
  Color isHoverdAttachImage = AppColors.transparent;
  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      key: key,
      alignment: Alignment.center,
      insetPadding: EdgeInsets.only(top: 40.h),
      backgroundColor: AppColors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 1536
              ? MediaQuery.of(context).size.width * 0.34
              : MediaQuery.of(context).size.width > 1024
                  ? MediaQuery.of(context).size.width * 0.30
                  : MediaQuery.of(context).size.width > 600
                      ? MediaQuery.of(context).size.width * 0.2
                      : MediaQuery.of(context).size.width * 0.1,
        ),
        decoration: BoxDecoration(
          color: AppColors.borderColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Spacer(),
                IconButton(
                  onPressed: () {
                    NavigatorRoute.navigateBack(context: context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            Gap(50.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MouseRegion(
                  onHover: (event) {
                    setState(() {
                      isHoverdAddEvent = AppColors.drawerBgColor;
                    });
                  },
                  onExit: (event) {
                    setState(
                      () {
                        isHoverdAddEvent = AppColors.transparent;
                      },
                    );
                  },
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10.r),
                    onTap: widget.onPhotoTap,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.22,
                      width: MediaQuery.of(context).size.width < 600
                          ? 550.w
                          : MediaQuery.of(context).size.width < 1024
                              ? 350.w
                              : 220.w,
                      decoration: BoxDecoration(
                        color: isHoverdAddEvent,
                        border: Border.all(
                          width: 1.6,
                          color: AppColors.textFeildBorderColor,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.r),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 38.r,
                            child: Assets.icons.icCamera.image(
                              color: AppColors.white,
                              height: 32.h,
                              width: 32.w,
                            ),
                          ),
                          Gap(20.h),
                          Text(
                            'Photo',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                          Gap(2.h),
                          Text(
                            'jpg, jpeg',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: AppColors.grey909090,
                                      fontWeight: FontWeight.w400,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Gap(30.w),
                widget.isVideoHide == true
                    ? const SizedBox()
                    : MouseRegion(
                        onHover: (event) {
                          setState(() {
                            isHoverdAttachImage = AppColors.drawerBgColor;
                          });
                        },
                        onExit: (event) {
                          setState(
                            () {
                              isHoverdAttachImage = AppColors.transparent;
                            },
                          );
                        },
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.r),
                          onTap: widget.onVideoTap,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.22,
                            width: MediaQuery.of(context).size.width < 600
                                ? 550.w
                                : MediaQuery.of(context).size.width < 1024
                                    ? 350.w
                                    : 220.w,
                            decoration: BoxDecoration(
                              color: isHoverdAttachImage,
                              border: Border.all(
                                width: 1.6,
                                color: AppColors.textFeildBorderColor,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.r),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 38.r,
                                  child: Assets.icons.icVideo.image(
                                    color: AppColors.white,
                                    height: 32.h,
                                    width: 32.w,
                                  ),
                                ),
                                Gap(20.h),
                                Text(
                                  'Attach File',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                                Gap(2.h),
                                Text(
                                  'mp4, avi, mov',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: AppColors.grey909090,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ],
            ),
            Gap(50.h),
          ],
        ),
      ),
    );
  }
}
