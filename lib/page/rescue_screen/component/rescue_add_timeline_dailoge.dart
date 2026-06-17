import 'package:country_picker/country_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:eagle_eye_admin/controller/rescue_detail_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/model/get_attached_video_list.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/utils/app_functions.dart';
import 'package:eagle_eye_admin/widget/app_network_image.dart';
import 'package:eagle_eye_admin/widget/button.dart';
import 'package:eagle_eye_admin/widget/hashtag_formatter.dart';
import 'package:eagle_eye_admin/widget/textfeild.dart';
import 'package:eagle_eye_admin/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../user_profile_screen/user_profile_view.dart';

class RescueAddTimelineDailoge extends StatefulWidget {
  final String page;
  final String eventId;

  const RescueAddTimelineDailoge(
      {super.key, required this.page, required this.eventId});

  @override
  State<RescueAddTimelineDailoge> createState() =>
      _RescueAddTimelineDailogeState();
}

class _RescueAddTimelineDailogeState extends State<RescueAddTimelineDailoge> {
  GlobalKey key = GlobalKey();
  bool isHovered = false;

  RescueDetailController rescueDetailController = Get.find();

  @override
  void initState() {
    rescueDetailController.getVideoList(widget.eventId, context: context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProgressLoader pl = ProgressLoader(context, isDismissible: true);

    return GetBuilder<RescueDetailController>(builder: (controller) {
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
                    (widget.page == "Timeline")
                        ? Text(
                            "Add New Timeline",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w700),
                          )
                        : InkWell(
                            radius: 0,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return UserProfileView(
                                    userId:
                                        controller.rescueTimeLineUserUserId ??
                                            "",
                                  );
                                },
                              );
                            },
                            child: Row(
                              children: [
                                AppNetworkImageLoader(
                                    url:
                                        controller.rescueTimeLineUserImageURL ??
                                            ''),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16 / 2),
                                  child: Text(
                                    controller.rescueTimeLineUserName ?? "",
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
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.white,
                      ),
                      onPressed: () {
                        NavigatorRoute.navigateBack(context: context);
                      },
                    )
                  ],
                ),
                Gap(30.h),
                (widget.page == "Timeline")
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Video Select',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w500),
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
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
                                              borderRadius:
                                                  BorderRadius.circular(5),
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
                                value: controller.selectedVideo != null &&
                                        controller.allAttachedVideos
                                            .contains(controller.selectedVideo)
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
                                        AppColors.white.withValues(alpha: 0.5)),
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
                        ],
                      )
                    : (controller.rescueTimeLineUserAttachment != null)
                        ? AppNetworkImageLoader(
                            height: 160.h,
                            width: MediaQuery.of(context).size.width,
                            url: controller.rescueTimeLineUserAttachment ?? "")
                        : (controller.selectedFile != null)
                            ? MouseRegion(
                                onHover: (_) =>
                                    setState(() => isHovered = true),
                                onExit: (_) =>
                                    setState(() => isHovered = false),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 160,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.memory(
                                          controller.selectedFile!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    if (isHovered)
                                      Positioned.fill(
                                        child: InkWell(
                                          onTap: () {
                                            controller.selectedFile = null;
                                            controller.update();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black
                                                  .withValues(alpha: 0.6),
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
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                  controller.selectedFile =
                                      await controller.pickFile();
                                  controller.update();
                                },
                                child: Container(
                                  height: 160.h,
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: AppColors.attachCardColor,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 20.h),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                              .bodyMedium!
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
                CommonTextField(
                  topLabel: "Provide Update & Approx. Time:",
                  hintText: "Enter Provide Update",
                  controller: controller.rescueTimelineUpdateController,
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return "Please enter rescue provide update";
                    }
                    return null;
                  },
                ),
                Gap(20.h),
                CommonTextField(
                  topLabel: "Address",
                  hintText: "Enter  Update",
                  controller: controller.rescueTimelineLocationController,
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return "Please enter rescue update";
                    }
                    return null;
                  },
                ),
                Gap(20.h),
                widget.page == 'Timeline'
                    ? const SizedBox()
                    : Column(
                        children: [
                          CommonTextField(
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(controller.mobileLengthTimeline),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            prefixIcon: GestureDetector(
                              onTap: () {
                                showCountryPicker(
                                  context: context,
                                  showPhoneCode: true,
                                  customFlagBuilder: (country) {
                                    return Image.network(
                                      'https://flagcdn.com/w40/${country.countryCode.toLowerCase()}.png',
                                      width: 30,
                                      height: 20,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.flag, size: 24),
                                    );
                                  },
                                  countryListTheme: CountryListThemeData(
                                    flagSize: 25,
                                    backgroundColor: Colors.white,
                                    textStyle: const TextStyle(
                                        fontSize: 16, color: Colors.blueGrey),
                                    borderRadius: BorderRadius.circular(20.0),
                                    inputDecoration: InputDecoration(
                                      labelText: 'Search',
                                      hintText: 'Start typing to search',
                                      prefixIcon: const Icon(Icons.search),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: const Color(0xFF8C98A8)
                                                .withValues(alpha: 0.2)),
                                      ),
                                    ),
                                  ),
                                  onSelect: (Country country) {
                                    controller.timelineCountryCode =
                                        "+${country.phoneCode}";
                                    controller.mobileLengthTimeline = AppFunctions.getMobileNumberLength( controller.timelineCountryCode);
                                    controller.update();
                                  },
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Gap(10),
                                  Text(
                                    controller.timelineCountryCode,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(color: AppColors.white),
                                  ),
                                ],
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            topLabel: "Mobile Number",
                            hintText: "Enter Mobile Number",
                            controller:
                                controller.rescueTimelineMobileNoController,
                            validator: (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return "Please enter mobile number";
                              }

                              return null;
                            },
                          ),
                          Gap(20.h),
                        ],
                      ),
                CommonTextField(
                  topLabel: "Hashtag",
                  hintText: "Enter Hashtag",
                  inputFormatters: [HashtagInputFormatter()],
                  controller: controller.rescueTimelineHashtagController,
                  // validator: (p0) {
                  //   if (p0 == null || p0.isEmpty) {
                  //     return "Please enter rescue hashtag";
                  //   }
                  //   return null;
                  // },
                ),
                Gap(20.h),
                Text(
                  "Date & Time",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.white, fontWeight: FontWeight.w500),
                ),
                Gap(10.h),
                InkWell(
                  onTap: () async {
                    controller.rescueTimelineSelectedDate =
                        await controller.pickDateTime(context,
                                initialDate:
                                    controller.rescueTimelineSelectedDate) ??
                            DateTime.now();
                    controller.update();
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
                          DateFormat('d MMM, y, h:mm a')
                              .format(controller.rescueTimelineSelectedDate),
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
                        if (controller.isRecueUpdate) {
                          controller.rescueUpdatePost(pl, context);
                        } else {
                          if (controller.timelineKey.currentState?.validate() ==
                              true) {
                            controller.timeLineAddAPI(pl, context);
                          }
                        }
                      },
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.isRecueUpdate ? "Update" : "Add",
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
