import 'package:eagle_eye_admin/controller/event_detail_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/page/event_screen/component/event_image_preview_dialog.dart';
import 'package:eagle_eye_admin/page/event_screen/component/event_preview_dailoge.dart';
import 'package:eagle_eye_admin/page/user_profile_screen/user_profile_view.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/widget/app_network_image.dart';
import 'package:eagle_eye_admin/widget/button.dart';
import 'package:eagle_eye_admin/widget/textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../widget/common_dialog.dart';

class EventTimelineView extends StatefulWidget {
  const EventTimelineView({super.key});

  @override
  State<EventTimelineView> createState() => _EventTimelineViewState();
}

class _EventTimelineViewState extends State<EventTimelineView> {
  EventDetailController controller = Get.find();

  TextEditingController desController = TextEditingController();

  DateTime postDateTime = DateTime.now();

  // List<TextEditingController> descriptionList =[];

  // List<DateTime> dateTimeList =[];

  @override
  void initState() {
    // descriptionList = List.generate(controller.getSingleEventData.attachmentWithTimeline?.length??0, (index) {
    //   return descriptionList[index] = TextEditingController(text: controller.getSingleEventData.attachmentWithTimeline?[index].description??"");
    // },);
    //
    //
    //
    //
    //
    // dateTimeList = List.generate(controller.getSingleEventData.attachmentWithTimeline?.length??0, (index) {
    //   return dateTimeList[index] =      controller.getSingleEventData.attachmentWithTimeline?[index].eventTime != null &&   controller.getSingleEventData.attachmentWithTimeline![index].eventTime!.isNotEmpty
    //       ? DateTime.parse(  controller.getSingleEventData.attachmentWithTimeline![index].eventTime!).toLocal()
    //       : DateTime.now();
    // },);

    setState(() {});
    // desController.text = widget.attachments?.description??'';
    //
    // postDateTime =
    // widget.attachments?.eventTime != null && widget.attachments!.eventTime!.isNotEmpty
    //     ? DateTime.parse(widget.attachments!.eventTime!).toLocal()
    //     : DateTime.now();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProgressLoader pl = ProgressLoader(context, isDismissible: true);
    return GetBuilder<EventDetailController>(builder: (controller) {
      return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (c, index) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.sp),
              margin: EdgeInsets.only(right: 20.w),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderColor, width: 1.5),
                color: AppColors.attachEventListBarColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        radius: 0,
                        onTap: () async {
                          // controller.openUserProfileView(userId: '');



                          showDialog(
                            context: context,

                            builder: (context) {
                              return UserProfileView(
                                userId: controller.getSingleEventData
                                    .attachmentWithTimeline?[index].userId ??
                                    "",
                              );
                            },
                          );



                        },
                        child: Row(
                          children: [
                            ClipOval(
                              child: AppNetworkImageLoader(
                                url: controller
                                        .getSingleEventData
                                        .attachmentWithTimeline?[index]
                                        .profilePicture ??
                                    '',
                                height: 40,
                                width: 40,
                                boxFit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16 / 2),
                              child: Text(
                                controller.getSingleEventData
                                        .attachmentWithTimeline?[index].name ??
                                    '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                          height: 30.h,
                          width: 100.w,
                          child: CommonButton(
                              color: AppColors.transparent,
                              onPressed: () {
                                // controller
                                //     .getSingleEventData.attachmentWithTimeline
                                //     ?.removeAt(index);
                                // controller.dateTimeList.removeAt(index);
                                // controller.descriptionList.removeAt(index);
                                // controller.update();
                                // setState(() {});

                                commonDialog(
                                  context: context,
                                  subtitle: 'Are you sure want to delete attachment?',
                                  title: 'Delete Attachment',
                                  onTap: () async {
                                    NavigatorRoute.navigateBack(context:  context);
                                    await controller.deleteSinglePost(

                                        context: context,
                                     postId  : controller.getSingleEventData
                                         .attachmentWithTimeline?[index].attachmentId ??
                                         '',
                                    eventId: controller.getSingleEventData.id??"",
                                       );

                                  },
                                );

                                controller.update();
                                setState(() {});

                              },
                              widget: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.delete,
                                    color: AppColors.red,
                                    size: 15,
                                  ),
                                  Gap(5.w),
                                  Text(
                                    "Delete",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: AppColors.red),
                                  ),
                                ],
                              ))),
                    ],
                  ),
                  Gap(15.h),
                  controller.getSingleEventData.attachmentWithTimeline?[index]
                              .thumbnail !=
                          null
                      ? Stack(
                          alignment: Alignment.topRight,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (controller
                                        .getSingleEventData
                                        .attachmentWithTimeline?[index]
                                        .attachmentFileType ==
                                    'Video') {


                                  showDialog(
                                    context: context,

                                    builder: (context) {
                                      return EventPreviewDailoge(
                                          videoPath: controller
                                              .getSingleEventData
                                              .attachmentWithTimeline?[index]
                                              .attachment ??
                                              '');
                                    },
                                  );




                                } else if (controller
                                        .getSingleEventData
                                        .attachmentWithTimeline?[index]
                                        .attachmentFileType ==
                                    'Image') {

                                  showDialog(
                                    context: context,

                                    builder: (context) {
                                      return EventImagePreviewDialog(
                                        imageURL: controller
                                            .getSingleEventData
                                            .attachmentWithTimeline?[index]
                                            .attachment ??
                                            '',
                                      );
                                    },
                                  );




                                } else {}
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 150.h,
                                    width: 200.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: AppNetworkImageLoader(
                                      url: controller
                                              .getSingleEventData
                                              .attachmentWithTimeline?[index]
                                              .thumbnail ??
                                          '',
                                      height: 150.h,
                                      width: 200.w,
                                      boxFit: BoxFit.cover,
                                    ),
                                  ),
                                  controller
                                              .getSingleEventData
                                              .attachmentWithTimeline?[index]
                                              .attachmentFileType ==
                                          'Video'
                                      ? Assets.icons.icPlay.svg()
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                controller
                                    .getSingleEventData
                                    .attachmentWithTimeline?[index]
                                    .thumbnail = null;
                                controller.update();
                                setState(() {});
                              },
                              icon: const Icon(Icons.close),
                              color: AppColors.white,
                            )
                          ],
                        )
                      : (controller.getSingleEventData
                                  .attachmentWithTimeline?[index].videoBytes !=
                              null)
                          ? MouseRegion(
                              onHover: (_) => setState(() => controller
                                  .getSingleEventData
                                  .attachmentWithTimeline?[index]
                                  .isHover = true),
                              onExit: (_) => setState(() => controller
                                  .getSingleEventData
                                  .attachmentWithTimeline?[index]
                                  .isHover = false),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 150.h,
                                    width: 200.w,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.memory(
                                        controller
                                            .getSingleEventData
                                            .attachmentWithTimeline![index]
                                            .videoBytes!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  if (controller
                                          .getSingleEventData
                                          .attachmentWithTimeline?[index]
                                          .isHover ==
                                      true)
                                    Positioned.fill(
                                      child: InkWell(
                                        onTap: () {
                                          controller
                                              .getSingleEventData
                                              .attachmentWithTimeline?[index]
                                              .videoBytes = null;
                                          controller
                                              .getSingleEventData
                                              .attachmentWithTimeline?[index]
                                              .videoFile = null;
                                          controller
                                              .getSingleEventData
                                              .attachmentWithTimeline?[index]
                                              .videoThumbnail = null;
                                          controller.update();
                                          setState(() {});
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withValues(alpha:0.6),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.delete,
                                                    color: Colors.red),
                                                Gap(5.w),
                                                const Text(
                                                  'Remove File',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            )
                          : InkWell(
                              borderRadius: BorderRadius.circular(8.r),
                              onTap: () async {
                                controller.onPickOtherPostVideo(
                                    index, context, pl);
                                setState(() {});
                              },
                              child: Container(
                                height: 150.h,
                                width: 200.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.attachCardColor,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 20.h),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Assets.icons.icAttachFile.svg(
                                        height: 45.h,
                                        width: 45.w,
                                      ),
                                      Gap(10.w),
                                      Text(
                                        'Attach File',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                color: AppColors.white,
                                                fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                  Gap(20.h),
                  Row(
                    children: [
                      Expanded(
                        child: CommonTextField(
                          topLabel: "Description",
                          hintText: "Enter Description",
                          controller: controller.descriptionList[index],
                          // validator: (p0) {
                          //   if (p0 == null || p0.isEmpty) {
                          //     return "Please enter event description";
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                      Gap(15.w),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Start Date",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w500),
                          ),
                          Gap(10.h),
                          InkWell(
                            onTap: () async {
                              controller.dateTimeList[index] =
                                  await controller.pickDate(context);

                              setState(() {});
                            },
                            child: Container(
                              height: 55.h,
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.textFeildBorderColor,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    controller.formatDateData(
                                        controller.dateTimeList[index]),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w500),
                                  ),
                                  const Spacer(),
                                  Assets.icons.icWatch.svg(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => Gap(15.h),
          itemCount:
              controller.getSingleEventData.attachmentWithTimeline?.length ??
                  0);
    });
  }
}
