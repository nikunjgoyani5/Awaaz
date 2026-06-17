import 'package:country_picker/country_picker.dart';
import 'package:eagle_eye_admin/controller/rescue_detail_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/page/event_screen/component/event_image_preview_dialog.dart';
import 'package:eagle_eye_admin/page/event_screen/component/event_preview_dailoge.dart';
import 'package:eagle_eye_admin/page/user_profile_screen/user_profile_view.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/utils/app_functions.dart';
import 'package:eagle_eye_admin/widget/app_network_image.dart';
import 'package:eagle_eye_admin/widget/button.dart';
import 'package:eagle_eye_admin/widget/common_dialog.dart';
import 'package:eagle_eye_admin/widget/textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class RescueTimelineView extends StatefulWidget {
  final BuildContext? buildContext;
  const RescueTimelineView({super.key, this.buildContext});

  @override
  State<RescueTimelineView> createState() => _RescueTimelineViewState();
}

class _RescueTimelineViewState extends State<RescueTimelineView> {
  RescueDetailController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    ProgressLoader pl = ProgressLoader(context, isDismissible: true);
    return GetBuilder<RescueDetailController>(builder: (controller) {
      return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
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
                          showDialog(
                            context: context,
                            builder: (context) {
                              return UserProfileView(
                                userId: controller
                                        .getSingleRescueData
                                        .attachmentWithTimeline?[index]
                                        .userId ??
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
                                        .getSingleRescueData
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
                                controller.getSingleRescueData
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
                                commonDialog(
                                  context: context,
                                  subtitle:
                                      'Are you sure want to delete attachment?',
                                  title: 'Delete Attachment',
                                  onTap: () async {
                                    NavigatorRoute.navigateBack(
                                        context: context);
                                    await controller.deleteSinglePost(
                                      context: context,
                                      postId: controller
                                              .getSingleRescueData
                                              .attachmentWithTimeline?[index]
                                              .attachmentId ??
                                          '',
                                      eventId:
                                          controller.getSingleRescueData.id ??
                                              "",
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
                  controller.getSingleRescueData.attachmentWithTimeline?[index]
                              .thumbnail !=
                          null
                      ? Stack(
                          alignment: Alignment.topRight,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (controller
                                        .getSingleRescueData
                                        .attachmentWithTimeline?[index]
                                        .attachmentFileType ==
                                    'Video') {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return EventPreviewDailoge(
                                          videoPath: controller
                                                  .getSingleRescueData
                                                  .attachmentWithTimeline?[
                                                      index]
                                                  .attachment ??
                                              '');
                                    },
                                  );
                                } else if (controller
                                        .getSingleRescueData
                                        .attachmentWithTimeline?[index]
                                        .attachmentFileType ==
                                    'Image') {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return EventImagePreviewDialog(
                                        imageURL: controller
                                                .getSingleRescueData
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
                                              .getSingleRescueData
                                              .attachmentWithTimeline?[index]
                                              .thumbnail ??
                                          '',
                                      height: 150.h,
                                      width: 200.w,
                                      boxFit: BoxFit.cover,
                                    ),
                                  ),
                                  controller
                                              .getSingleRescueData
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
                                    .getSingleRescueData
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
                      : (controller.getSingleRescueData
                                  .attachmentWithTimeline?[index].videoBytes !=
                              null)
                          ? MouseRegion(
                              onHover: (_) => setState(() => controller
                                  .getSingleRescueData
                                  .attachmentWithTimeline?[index]
                                  .isHover = true),
                              onExit: (_) => setState(() => controller
                                  .getSingleRescueData
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
                                            .getSingleRescueData
                                            .attachmentWithTimeline![index]
                                            .videoBytes!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  if (controller
                                          .getSingleRescueData
                                          .attachmentWithTimeline?[index]
                                          .isHover ==
                                      true)
                                    Positioned.fill(
                                      child: InkWell(
                                        onTap: () {
                                          controller
                                              .getSingleRescueData
                                              .attachmentWithTimeline?[index]
                                              .videoBytes = null;
                                          controller
                                              .getSingleRescueData
                                              .attachmentWithTimeline?[index]
                                              .videoFile = null;
                                          controller
                                              .getSingleRescueData
                                              .attachmentWithTimeline?[index]
                                              .videoThumbnail = null;
                                          controller.update();
                                          setState(() {});
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
                          topLabel: "Provide Update & Approx. Time:",
                          hintText: "Enter Provide Update",
                          controller: controller.descriptionList[index],
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return "Please enter rescue provide update";
                            }
                            return null;
                          },
                        ),
                      ),
                      Gap(15.w),
                      Expanded(
                        child: CommonTextField(
                          topLabel: "Location",
                          hintText: "Enter Location",
                          controller: controller.locationList[index],
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return "Please enter rescue location";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  Gap(20.h),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date & Time",
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
                                // widget.rescueTimelineModel.dateTime =
                                //     await controller.pickDateTime(context,
                                //         initialDate: widget
                                //             .rescueTimelineModel.dateTime) ??
                                //         DateTime.now();
                                controller.dateTimeList[index] =
                                    await controller.pickDateTime(
                                            widget.buildContext ?? context) ??
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
                        ),
                      ),
                      Gap(15.h),
                      Expanded(
                        child: CommonTextField(
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
                                  controller.countryCodeList[index] =
                                      "+${country.phoneCode}";

                                  controller.mobileLengthList[index] =
                                      AppFunctions.getMobileNumberLength(
                                          controller.countryCodeList[index]);
                                  controller.update();
                                },
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Gap(10),
                                Text(
                                  controller.countryCodeList[index],
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(color: AppColors.white),
                                ),
                              ],
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(
                                controller.mobileLengthList[index]),
                          ],
                          topLabel: "Mobile Number",
                          hintText: "Enter Mobile Number",
                          controller: controller.mobileNumberList[index],
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return "Please enter mobile number";
                            }
                            return null;
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => Gap(15.h),
          itemCount:
              controller.getSingleRescueData.attachmentWithTimeline?.length ??
                  0);
    });
  }
}
