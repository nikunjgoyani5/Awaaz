import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:eagle_eye_admin/controller/event_detail_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/model/get_attached_video_list.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/widget/app_network_image.dart';
import 'package:eagle_eye_admin/widget/button.dart';
import 'package:eagle_eye_admin/widget/hashtag_formatter.dart';
import 'package:eagle_eye_admin/widget/textfeild.dart';
import 'package:eagle_eye_admin/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EventAddTimelineDialog extends StatefulWidget {
  const EventAddTimelineDialog({super.key, required this.eventId});

  final String eventId;

  @override
  State<EventAddTimelineDialog> createState() => _EventAddTimelineDialogState();
}

class _EventAddTimelineDialogState extends State<EventAddTimelineDialog> {
  GlobalKey key = GlobalKey();
  EventDetailController eventDetailController = Get.find();

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    await eventDetailController.getVideoList(widget.eventId, context: context);
    // await  eventDetailController.getVideoList('67a20cd69a350f89269c8fb9');
  }

  @override
  Widget build(BuildContext context) {
    ProgressLoader pl = ProgressLoader(context, isDismissible: true);
    return GetBuilder<EventDetailController>(builder: (controller) {
      return Dialog(
        key: key,
        alignment: Alignment.topCenter,
        insetPadding: EdgeInsets.only(top: 40.h),
        backgroundColor: AppColors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 1536
                ? MediaQuery.of(context).size.width * 0.30
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
          child: Form(
            key: controller.timelineKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      "Add New Timeline",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        NavigatorRoute.navigateBack(context: context);
                      },
                    )
                  ],
                ),
                Gap(30.h),
                Text(
                  'Video Select',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.white, fontWeight: FontWeight.w500),
                ),
                const Gap(8),
                DropdownButtonHideUnderline(
                  child: GestureDetector(

                      onTap: () {
                        if (controller.allAttachedVideos.isEmpty) {
                          showToast(
                              context: context,
                              title: 'Videos',
                              message: 'Upload image or video first',
                              bgColor: AppColors.red

                          );
                        }
                      },

                    child: DropdownButton2<AllAttachedVideos>(
                      isExpanded: true,
                      hint: Text(
                        'Select Video',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                      items: controller.allAttachedVideos
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: ListTile(
                                minVerticalPadding: 0,
                                contentPadding: EdgeInsets.zero,
                                leading: Container(
                                  padding: EdgeInsets.zero,
                                  margin: EdgeInsets.zero,
                                  height: 100.h,
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: AppNetworkImageLoader(
                                    url: item.thumbnail ?? '',
                                    height: 100.h,
                                    width: 100.w,
                                    boxFit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  item.attachmentId ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      value:controller.selectedVideo != null &&
                          controller.allAttachedVideos.contains(controller.selectedVideo)
                          ? controller.selectedVideo
                          : null,
                      onChanged: (value) {
                        setState(() {
                          controller.selectedVideo = value;
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 55.h,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.textFeildBorderColor,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 300.h,
                        offset: const Offset(0, -5),
                        decoration: BoxDecoration(
                          color: const Color(0xff3D3D42),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        scrollbarTheme: ScrollbarThemeData(
                          thumbColor: WidgetStateProperty.all(
                              AppColors.white.withValues(alpha:0.5)),
                          radius: const Radius.circular(5),
                          thickness: WidgetStateProperty.all(4),
                        ),
                      ),
                      menuItemStyleData: MenuItemStyleData(
                        height: 100.h,
                      ),
                    ),
                  ),
                ),
                Gap(20.h),
                CommonTextField(
                  topLabel: "Description",
                  hintText: "Enter Description",
                  controller: controller.timelineDiscriptionController,
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return "Please enter event description";
                    }
                    return null;
                  },
                ),
                Gap(20.h),
                CommonTextField(
                  topLabel: "Hashtag",
                  hintText: "Enter #Hashtags Separated by Space",
                  controller: controller.timelineHashtagController,
                  inputFormatters: [HashtagInputFormatter()],
                  // validator: (p0) {
                  //   if (p0 == null || p0.isEmpty) {
                  //     return "Please enter event hashtag";
                  //   }
                  //   return null;
                  // },
                ),
                Gap(20.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Time",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      Gap(10.h),
                      InkWell(
                        onTap: () async {
                          controller.timeLineDate =
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
                                controller
                                    .formatDateData(controller.timeLineDate),
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
                  ),
                ),
                Gap(50.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    height: 50.h,
                    width: 150.w,
                    child: CommonButton(
                      color: AppColors.green,
                      radius: 5.r,
                      onPressed: () async {
                        if (controller.timelineKey.currentState?.validate() ==
                            true) {
                          controller.timeLineAddAPI(pl, context);
                        }
                      },
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Add",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Gap(15.h),
              ],
            ),
          ),
        ),
      );
    });
  }
}
