import 'package:eagle_eye_admin/controller/event_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/model/get_filter_events.dart';
import 'package:eagle_eye_admin/page/event_screen/component/event_image_preview_dialog.dart';
import 'package:eagle_eye_admin/route/app_route.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/service/storage/storage_service.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/utils/app_image_viewer.dart';
import 'package:eagle_eye_admin/widget/app_network_image.dart';
import 'package:eagle_eye_admin/widget/button.dart';
import 'package:eagle_eye_admin/widget/common_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EventPostCardView extends StatefulWidget {
  const EventPostCardView(
      {super.key, required this.index, required this.event});

  final int index;
  final FilterEvents event;

  @override
  State<EventPostCardView> createState() => _EventPostCardViewState();
}

class _EventPostCardViewState extends State<EventPostCardView> {
  String convertTime(String utcDate) {
    DateTime utcDateTime = DateTime.parse(utcDate);

    DateTime localDateTime = utcDateTime.toLocal();

    String formattedTime =
        DateFormat("dd/MM/yyyy hh:mm a").format(localDateTime);

    return formattedTime;
  }

  EventController eventController = Get.find();

  @override
  Widget build(BuildContext context) {
    ProgressLoader pl = ProgressLoader(context, isDismissible: true);

    return GetBuilder<EventController>(builder: (controller) {
      return InkWell(
        focusColor: AppColors.transparent,
        overlayColor: WidgetStateProperty.all(AppColors.transparent),
        radius: 0,
        onTap: () async {
          if (widget.event.status == 'Pending') {
          } else if (widget.event.status == 'Approved') {
            eventController.selectedEventReaction = null;
            eventController.selectedValue = null;

            // Get.to(()=> EventDetailsScreen(),arguments:widget.event.id);
            StorageService.saveEventId(widget.event.id ?? "");
            // await NavigatorRoute.navigateTo("${AppRoutes.eventDetails}/${widget.event.id}",
            //     arguments: widget.event.id);
            await NavigatorRoute.navigateTo(AppRoutes.eventDetails, context,
                arguments: widget.event.id);
          } else if (widget.event.status == 'Rejected') {}
          controller.update();
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: AppColors.eventCardBgColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    /// Name & Verified Badge Section
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          controller.openUserProfileView(
                            context: context,
                            userId: widget.event.userId ?? '',
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipOval(
                              child: AppNetworkImageLoader(
                                url: widget.event.profilePicture ?? "",
                                height: 40,
                                width: 40,
                                boxFit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(
                                width: 8), // Space between image & text

                            Flexible(
                              fit: FlexFit.loose,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  widget.event.name ??
                                      (StorageService.getName() ?? ''),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w500),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),

                            /// Verified Count Badge
                            const SizedBox(width: 8), // Space before badge
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xff1FA9FF),
                                    Color(0xff1C7EFF),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              child: Text(
                                widget.event.verifiedEventCounts ?? '0',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// Watch Icon & Time (Always at End)
                    const Gap(10),
                    Assets.icons.icWatch.svg(),
                    const SizedBox(width: 4), // Space between icon & text
                    Text(
                      (widget.event.eventTime?.isNotEmpty ?? false)
                          ? convertTime(widget.event.eventTime ?? "")
                          : '',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.grey929da9,
                          fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const Gap(20),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (widget.event.attachmentFileType == 'Video') {
                          await controller.openEventPreview(
                              context, widget.event.attachment ?? '');
                        } else if (widget.event.attachmentFileType == 'Image') {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return EventImagePreviewDialog(
                                imageURL: widget.event.attachment ?? '',
                              );
                            },
                          );
                        } else {}
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: widget.event.thumbnail == null
                                    ? Border.all(
                                        color: AppColors.white, width: 1)
                                    : null,
                              ),
                              child: Image.network(widget.event.thumbnail ?? "",
                                  height: MediaQuery.of(context).size.height *
                                      0.098,
                                  width: MediaQuery.of(context).size.height *
                                      0.098,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                return AppImageViewer.showAssetImage(
                                  path: Assets.image.noDataSelected.path,
                                  height: MediaQuery.of(context).size.height *
                                      0.098,
                                  width: MediaQuery.of(context).size.height *
                                      0.098,
                                  boxFit: BoxFit.cover,
                                );
                              }),
                            ),
                          ),
                          widget.event.attachmentFileType == 'Video'
                              ? Container(
                                  padding: EdgeInsets.all(25.sp),
                                  child: Assets.icons.icPlay.svg(
                                    colorFilter: const ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.event.title ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        const Gap(10),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.event.description ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w500),
                              ),
                            ),
                            (widget.event.status == 'Pending')
                                ? Row(
                                    children: [
                                      SizedBox(
                                        width: 120.w,
                                        height: 35.h,
                                        child: CommonButton(
                                            color: AppColors.borderColor,
                                            radius: 5,
                                            widget: Text(
                                              'Disapprove',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color:
                                                          AppColors.grey929da9,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                            onPressed: () async {
                                              commonDialog(
                                                context: context,
                                                subtitle:
                                                    'Are you sure want to reject?',
                                                title: 'Disapprove',
                                                onTap: () async {
                                                  NavigatorRoute.navigateBack(
                                                      context: context);
                                                  await controller
                                                      .statusUpdateAPI(
                                                          status: 'Rejected',
                                                          context: context,
                                                          eventId:
                                                              widget.event.id ??
                                                                  '',
                                                          isNotify: true);
                                                },
                                              );
                                            }),
                                      ),
                                      const Gap(20),
                                      SizedBox(
                                        width: 120.w,
                                        height: 35.h,
                                        child: CommonButton(
                                            color: AppColors.white,
                                            radius: 5,
                                            widget: Text(
                                              'Approve',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                            onPressed: () async {
                                              controller.clearEventData();
                                              controller.selectedEvent =
                                                  widget.event;
                                              await controller
                                                  .openAddEventAndAttachImgDialog(
                                                      context: context);
                                            }),
                                      )
                                    ],
                                  )
                                : const SizedBox()
                          ],
                        ),
                        const Gap(10),
                        Row(
                          children: [
                            widget.event.address != null &&
                                    widget.event.address!.isNotEmpty
                                ? Assets.icons.icLocation.svg()
                                : const SizedBox(),
                            Expanded(
                              child: Text(
                                widget.event.address ?? "",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: AppColors.grey929da9,
                                        fontWeight: FontWeight.w400),
                              ),
                            ),
                            Gap(10.w),
                            (widget.event.status == 'Pending')
                                ? widget.event.status == 'Pending'
                                    ? SizedBox(
                                        width: 180.w,
                                        height: 40.h,
                                        child: CommonButton(
                                            color: AppColors.borderColor,
                                            radius: 5,
                                            widget: Text(
                                              'Quick approve',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color: AppColors.golden,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                            onPressed: () async {
                                              controller.selectedEvent =
                                                  widget.event;
                                              controller.setCreateEventData();

                                              await controller.createQuickEvent(
                                                  context, pl, true);
                                            }),
                                      )
                                    : const SizedBox()
                                : (widget.event.status == 'Approved')
                                    ? SizedBox(
                                        width: 120.w,
                                        height: 35.h,
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: AppColors.green
                                                .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            'Approved',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: AppColors.green,
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ),
                                        ),
                                      )
                                    : (widget.event.status == 'Rejected')
                                        ? GestureDetector(
                                            onTap: () async {
                                              commonDialog(
                                                context: context,
                                                subtitle:
                                                    'Are you sure want to roll back disapproved event?',
                                                title: 'Roll back event',
                                                onTap: () async {
                                                  NavigatorRoute.navigateBack(
                                                      context: context);
                                                  await controller
                                                      .statusUpdateAPI(
                                                          status: 'Pending',
                                                          context: context,
                                                          eventId: controller
                                                                  .filterEvents[
                                                                      widget
                                                                          .index]
                                                                  .id ??
                                                              '',
                                                          isNotify: false);
                                                },
                                              );
                                            },
                                            child: Container(
                                              height: 35.h,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: AppColors.red
                                                    .withValues(alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                'Disapproved',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: AppColors.red,
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                          ],
                        ),
                      ],
                    ))
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
