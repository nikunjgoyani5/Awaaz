import 'package:eagle_eye_admin/controller/rescue_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/model/get_filter_rescue_model.dart';
import 'package:eagle_eye_admin/page/event_screen/component/event_image_preview_dialog.dart';
import 'package:eagle_eye_admin/page/event_screen/component/event_preview_dailoge.dart';
import 'package:eagle_eye_admin/route/app_route.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/service/storage/storage_service.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/utils/app_image_viewer.dart';
import 'package:eagle_eye_admin/widget/app_network_image.dart';
import 'package:eagle_eye_admin/widget/button.dart';
import 'package:eagle_eye_admin/widget/common_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RescuePostCardView extends StatefulWidget {
  const RescuePostCardView(
      {super.key, required this.filterRescue, required this.index});
  final FilterRescue filterRescue;
  final int index;
  @override
  State<RescuePostCardView> createState() => _RescuePostCardViewState();
}

class _RescuePostCardViewState extends State<RescuePostCardView> {
  RescueController controller = Get.put(RescueController());
  String convertTime(String utcDate) {
    DateTime utcDateTime = DateTime.parse(utcDate);

    DateTime localDateTime = utcDateTime.toLocal();

    String formattedTime =
        DateFormat("dd/MM/yyyy hh:mm a").format(localDateTime);

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RescueController>(builder: (controller) {
      return InkWell(
        focusColor: AppColors.transparent,
        overlayColor: WidgetStateProperty.all(AppColors.transparent),
        radius: 0,
        onTap: () async {
          if (widget.filterRescue.status == 'Pending') {
          } else if (widget.filterRescue.status == 'Approved') {
            controller.selectedCategory = null;
            StorageService.saveEventId(widget.filterRescue.id ?? "");
            await NavigatorRoute.navigateTo(AppRoutes.rescueDetails, context,
                arguments: widget.filterRescue.id);
          } else if (widget.filterRescue.status == 'Rejected') {}
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        radius: 0,
                        onTap: () {
                          controller.openUserProfileView(
                              context: context,
                              userId: widget.filterRescue.userId ?? '');
                        },
                        child: Row(
                          children: [
                            ClipOval(
                              child: AppNetworkImageLoader(
                                url: widget.filterRescue.profilePicture ?? "",
                                height: 40,
                                width: 40,
                                boxFit: BoxFit.cover,
                              ),
                            ),
                            // Image.network( widget.filterRescue.profilePicture
                            // , height: 50,width: 50,
                            //   fit: BoxFit.contain,
                            // ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16 / 2),
                                child: Text(
                                  widget.filterRescue.name ??
                                      (StorageService.getName() ?? ''),
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
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
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                child: Text(
                                  widget.filterRescue.verifiedEventCounts ??
                                      0.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w500),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Gap(20.w),
                    Row(
                      children: [
                        Assets.icons.icWatch.svg(),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16 / 2),
                          child: Text(
                            (widget.filterRescue.eventTime?.isNotEmpty ?? false)
                                ? convertTime(
                                    widget.filterRescue.eventTime ?? "")
                                : '',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: AppColors.grey929da9,
                                    fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Gap(20),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (widget.filterRescue.attachmentFileType == 'Video') {
                          showDialog(
                            context: context,
                            routeSettings: const RouteSettings(
                                name: '/event/eventPreview'),
                            builder: (context) {
                              return EventPreviewDailoge(
                                  videoPath:
                                      widget.filterRescue.attachment ?? '');
                            },
                          );
                        } else if (widget.filterRescue.attachmentFileType ==
                            'Image') {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return EventImagePreviewDialog(
                                imageURL: widget.filterRescue.attachment ?? '',
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
                                border: widget.filterRescue.thumbnail == null
                                    ? Border.all(
                                        color: AppColors.white, width: 1)
                                    : null,
                              ),
                              child: Image.network(
                                  widget.filterRescue.thumbnail ?? "",
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
                          widget.filterRescue.attachmentFileType == 'Video'
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
                        Text(
                          widget.filterRescue.lostItemName ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w700),
                        ),
                        const Gap(10),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.filterRescue.description ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w500),
                              ),
                            ),
                            (widget.filterRescue.status == 'Pending')
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
                                                          rescueId: widget
                                                                  .filterRescue
                                                                  .id ??
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
                                              controller.selectedRescue =
                                                  widget.filterRescue;
                                              await controller
                                                  .openAddRescueDialog(
                                                      'Create', context,
                                                      isUser: true);
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
                            widget.filterRescue.address != null &&
                                    widget.filterRescue.address!.isNotEmpty
                                ? Assets.icons.icLocation.svg()
                                : const SizedBox(),
                            Expanded(
                              child: Text(
                                widget.filterRescue.address ?? "",
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
                            /*   widget.filterRescue.status == 'Pending'
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
                                        // controller.selectedEvent =
                                        //     widget.filterRescue;
                                        // controller.setCreateEventData();
                                        //
                                        // await controller.createQuickEvent(
                                        //     context, pl, true);
                                      }),
                                )

                                    :*/
                            (widget.filterRescue.status == 'Approved')
                                ? SizedBox(
                                    width: 120.w,
                                    height: 35.h,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: AppColors.green
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        'Approved',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: AppColors.green,
                                                fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  )
                                : (widget.filterRescue.status == 'Rejected')
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
                                              await controller.statusUpdateAPI(
                                                  status: 'Pending',
                                                  context: context,
                                                  rescueId: controller
                                                          .filterRescue[
                                                              widget.index]
                                                          .id ??
                                                      '',
                                                  isNotify: false);
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: 35.h,
                                          padding: const EdgeInsets.symmetric(
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
