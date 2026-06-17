import 'package:country_picker/country_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:eagle_eye_admin/controller/rescue_detail_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/model/categories_model.dart';
import 'package:eagle_eye_admin/page/event_screen/component/event_image_preview_dialog.dart';
import 'package:eagle_eye_admin/page/event_screen/component/event_preview_dailoge.dart';
import 'package:eagle_eye_admin/page/rescue_screen/component/rescue_timeline_view.dart';
import 'package:eagle_eye_admin/page/rescue_screen/component/rescue_update_dailoge.dart';
import 'package:eagle_eye_admin/page/user_profile_screen/user_profile_view.dart';
import 'package:eagle_eye_admin/route/app_route.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/service/storage/storage_service.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/utils/app_functions.dart';
import 'package:eagle_eye_admin/utils/app_image_viewer.dart';
import 'package:eagle_eye_admin/utils/responsive_utils.dart';
import 'package:eagle_eye_admin/widget/app_network_image.dart';
import 'package:eagle_eye_admin/widget/button.dart';
import 'package:eagle_eye_admin/widget/common_dialog.dart';
import 'package:eagle_eye_admin/widget/drawer.dart';
import 'package:eagle_eye_admin/widget/textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RescueDetailsScreen extends StatefulWidget {
  const RescueDetailsScreen({super.key});

  @override
  State<RescueDetailsScreen> createState() => _RescueDetailsScreenState();
}

class _RescueDetailsScreenState extends State<RescueDetailsScreen> {
  // DashboardController dashboardController = Get.put(DashboardController());
  RescueDetailController rescueDetailController =
      Get.put(RescueDetailController());
  bool isHovered = false;

  @override
  void initState() {
    rescueDetailController.onRefresh(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProgressLoader pl = ProgressLoader(context, isDismissible: true);
    return Scaffold(
      drawer: const DrawerWidget(),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isDesktop(context))
                const Expanded(
                  child: DrawerWidget(),
                ),
              Expanded(
                flex: 5,
                child: Form(
                  key: rescueDetailController.formKey,
                  child: Column(
                    children: [
                      // const Header(),
                      GetBuilder<RescueDetailController>(builder: (controller) {
                        return Expanded(
                            child: Stack(
                          children: [
                            Image.asset(Assets.image.mapBg.path),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // NavigatorRoute.navigateBack(context:  context);
                                        NavigatorRoute.navigateToSpecificPage(
                                            AppRoutes.event, context);
                                      },
                                      child: ClipOval(
                                        child: Container(
                                          color: Colors.white24,
                                          height: 45,
                                          width: 45,
                                          alignment: Alignment.center,
                                          child: const Icon(
                                            Icons.arrow_back_ios_new,
                                            color: AppColors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Gap(25.w),
                                    Text(
                                      "Rescue",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .copyWith(
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w700),
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      width: 180.w,
                                      height: 40,
                                      child: CommonButton(
                                        color: AppColors.green,
                                        radius: 5,
                                        widget: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Assets.icons.icAdd.svg(
                                              height: 18.h,
                                              width: 18.w,
                                            ),
                                            Gap(10.w),
                                            Text(
                                              'Upload Media',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color: AppColors.white,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        onPressed: () async {
                                          await controller
                                              .openAttachFileDailoge(context);
                                        },
                                      ),
                                    ),
                                    Gap(10.w),
                                    SizedBox(
                                      width: 180.w,
                                      height: 40,
                                      child: CommonButton(
                                        color: AppColors.blue,
                                        radius: 5,
                                        widget: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Assets.icons.icAdd.svg(
                                              height: 18.h,
                                              width: 18.w,
                                            ),
                                            Gap(10.w),
                                            Text(
                                              'Add Timeline',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color: AppColors.white,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        onPressed: () async {
                                          await controller
                                              .openAddTimeLineDailoge(
                                                  context,
                                                  'Timeline',
                                                  StorageService.getEventId() ??
                                                      '');
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                Gap(20.h),
                                Row(
                                  children: [
                                    InkWell(
                                      overlayColor: WidgetStateProperty.all(
                                          Colors.transparent),
                                      radius: 0,
                                      onTap: () {
                                        NavigatorRoute.navigateBack(
                                            context: context);
                                      },
                                      child: Text(
                                        "Rescue",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: AppColors.white,
                                                fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Gap(15.w),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14.sp,
                                    ),
                                    Gap(15.w),
                                    Expanded(
                                      child: Text(
                                        rescueDetailController
                                                .getSingleRescueData.title ??
                                            '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: AppColors.blue,
                                                fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ],
                                ),
                                Gap(30.h),
                                Expanded(
                                  child: Theme(
                                    data: ThemeData(
                                      scrollbarTheme: ScrollbarThemeData(
                                        trackColor: WidgetStateProperty.all(
                                            AppColors.textFeildBorderColor
                                                .withValues(alpha: 0.5)),
                                        thumbColor: WidgetStateProperty.all(
                                            AppColors.white
                                                .withValues(alpha: 0.2)),
                                      ),
                                    ),
                                    child: Scrollbar(
                                      radius: const Radius.circular(0),
                                      trackVisibility: true,
                                      scrollbarOrientation:
                                          ScrollbarOrientation.right,
                                      thumbVisibility: true,
                                      interactive: true,
                                      controller: controller
                                          .rescueDetailsScrollController,
                                      child: SingleChildScrollView(
                                        controller: controller
                                            .rescueDetailsScrollController,
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              margin:
                                                  EdgeInsets.only(right: 20.w),
                                              padding: EdgeInsets.all(20.sp),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        AppColors.borderColor,
                                                    width: 1.5),
                                                color: AppColors
                                                    .attachEventListBarColor,
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        radius: 0,
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return UserProfileView(
                                                                userId: rescueDetailController
                                                                        .getSingleRescueData
                                                                        .userId ??
                                                                    "",
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: Row(
                                                          children: [
                                                            ClipOval(
                                                              child: Image.network(
                                                                  rescueDetailController
                                                                          .getSingleRescueData
                                                                          .profilePicture ??
                                                                      "",
                                                                  height: 40,
                                                                  width: 40,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  errorBuilder:
                                                                      (context,
                                                                          error,
                                                                          stackTrace) {
                                                                return AppImageViewer
                                                                    .showAssetImage(
                                                                  path: Assets
                                                                      .image
                                                                      .noDataSelected
                                                                      .path,
                                                                  height: 40,
                                                                  width: 40,
                                                                  boxFit: BoxFit
                                                                      .cover,
                                                                );
                                                              }),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          16 /
                                                                              2),
                                                              child: Text(
                                                                rescueDetailController
                                                                        .getSingleRescueData
                                                                        .name ??
                                                                    "",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium!
                                                                    .copyWith(
                                                                        color: AppColors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      InkWell(
                                                        onTap: () async {
                                                          await showDialog(
                                                            context: context,
                                                            routeSettings:
                                                                const RouteSettings(
                                                                    name:
                                                                        '/rescue/rescueDetail/rescueUpdate'),
                                                            builder: (context) {
                                                              return const RescueUpdateDailoge();
                                                            },
                                                          );
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              controller
                                                                      .getSingleRescueData
                                                                      .status ??
                                                                  'Pending',
                                                              style: TextStyle(
                                                                  color: controller
                                                                              .getSingleRescueData.status ==
                                                                          'Timeout'
                                                                      ? AppColors
                                                                          .red
                                                                      : AppColors
                                                                          .green,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            const Gap(10),
                                                            Assets.icons.icDot
                                                                .svg(),
                                                            const Gap(5),
                                                            Text(
                                                              'Update (${controller.singleRescueUpdateCount})',
                                                              style: const TextStyle(
                                                                  color:
                                                                      AppColors
                                                                          .green,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Gap(15.h),
                                                  rescueDetailController
                                                              .getSingleRescueData
                                                              .thumbnail !=
                                                          null
                                                      ? Stack(
                                                          alignment: Alignment
                                                              .topRight,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () async {
                                                                if (rescueDetailController
                                                                        .getSingleRescueData
                                                                        .attachmentFileType ==
                                                                    'Video') {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return EventPreviewDailoge(
                                                                          videoPath:
                                                                              rescueDetailController.getSingleRescueData.attachment ?? '');
                                                                    },
                                                                  );
                                                                } else if (rescueDetailController
                                                                        .getSingleRescueData
                                                                        .attachmentFileType ==
                                                                    'Image') {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return EventImagePreviewDialog(
                                                                        imageURL:
                                                                            rescueDetailController.getSingleRescueData.attachment ??
                                                                                '',
                                                                      );
                                                                    },
                                                                  );
                                                                } else {}
                                                              },
                                                              child: Stack(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                children: [
                                                                  Container(
                                                                    height:
                                                                        150.h,
                                                                    width:
                                                                        200.w,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.r),
                                                                    ),
                                                                    child:
                                                                        AppNetworkImageLoader(
                                                                      url: rescueDetailController
                                                                              .getSingleRescueData
                                                                              .thumbnail ??
                                                                          "",
                                                                      height:
                                                                          150.h,
                                                                      width:
                                                                          200.w,
                                                                      boxFit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                  rescueDetailController
                                                                              .getSingleRescueData
                                                                              .attachmentFileType ==
                                                                          'Video'
                                                                      ? Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                            color:
                                                                                AppColors.black.withValues(alpha: 0.3),
                                                                          ),
                                                                          child: Assets
                                                                              .icons
                                                                              .icPlay
                                                                              .svg(),
                                                                        )
                                                                      : const SizedBox(),
                                                                ],
                                                              ),
                                                            ),
                                                            IconButton(
                                                              onPressed: () {
                                                                rescueDetailController
                                                                    .getSingleRescueData
                                                                    .thumbnail = null;
                                                                rescueDetailController
                                                                    .update();
                                                                setState(() {});
                                                              },
                                                              icon: const Icon(
                                                                  Icons.close),
                                                              color: AppColors
                                                                  .white,
                                                            ),
                                                          ],
                                                        )
                                                      : (rescueDetailController
                                                                  .postFirstFileBytes !=
                                                              null)
                                                          ? MouseRegion(
                                                              onHover: (_) =>
                                                                  setState(() =>
                                                                      isHovered =
                                                                          true),
                                                              onExit: (_) =>
                                                                  setState(() =>
                                                                      isHovered =
                                                                          false),
                                                              child: Stack(
                                                                children: [
                                                                  Container(
                                                                    height:
                                                                        150.h,
                                                                    width:
                                                                        200.w,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .black,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                    ),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                      child: Image
                                                                          .memory(
                                                                        rescueDetailController
                                                                            .postFirstFileBytes!,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  if (isHovered)
                                                                    Positioned
                                                                        .fill(
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () {
                                                                          rescueDetailController.postFirstFile =
                                                                              null;
                                                                          rescueDetailController.postFirstFileBytes =
                                                                              null;
                                                                          rescueDetailController
                                                                              .update();
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.black.withValues(alpha: 0.6),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                const Icon(Icons.delete, color: Colors.red),
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
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.r),
                                                              onTap: () async {
                                                                rescueDetailController
                                                                    .onPickFirstPostVideo();
                                                                setState(() {});
                                                              },
                                                              child: Container(
                                                                height: 150.h,
                                                                width: 200.w,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: AppColors
                                                                      .attachCardColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.r),
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          20.w,
                                                                      vertical:
                                                                          20.h),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Assets
                                                                          .icons
                                                                          .icAttachFile
                                                                          .svg(
                                                                        height:
                                                                            45.h,
                                                                        width:
                                                                            45.w,
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
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            CommonTextField(
                                                              topLabel: "Title",
                                                              hintText:
                                                                  "Enter Title",
                                                              controller: controller
                                                                  .rescueTitleController,
                                                              validator: (p0) {
                                                                if (p0 ==
                                                                        null ||
                                                                    p0.isEmpty) {
                                                                  return "Please enter rescue title";
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                            Gap(20.h),
                                                            CommonTextField(
                                                              topLabel:
                                                                  "Description",
                                                              hintText:
                                                                  "Enter Description",
                                                              controller: controller
                                                                  .rescueDescriptionController,
                                                              validator: (p0) {
                                                                if (p0 ==
                                                                        null ||
                                                                    p0.isEmpty) {
                                                                  return "Please enter rescue Description";
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                            Gap(20.h),
                                                            CommonTextField(
                                                              prefixIcon:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  showCountryPicker(
                                                                    context:
                                                                        context,
                                                                    showPhoneCode:
                                                                        true,
                                                                    customFlagBuilder:
                                                                        (country) {
                                                                      return Image
                                                                          .network(
                                                                        'https://flagcdn.com/w40/${country.countryCode.toLowerCase()}.png',
                                                                        width:
                                                                            30,
                                                                        height:
                                                                            20,
                                                                        errorBuilder: (context, error, stackTrace) => const Icon(
                                                                            Icons
                                                                                .flag,
                                                                            size:
                                                                                24),
                                                                      );
                                                                    },
                                                                    countryListTheme:
                                                                        CountryListThemeData(
                                                                      flagSize:
                                                                          25,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      textStyle: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.blueGrey),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20.0),
                                                                      inputDecoration:
                                                                          InputDecoration(
                                                                        labelText:
                                                                            'Search',
                                                                        hintText:
                                                                            'Start typing to search',
                                                                        prefixIcon:
                                                                            const Icon(Icons.search),
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(color: const Color(0xFF8C98A8).withValues(alpha: 0.2)),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    onSelect:
                                                                        (Country
                                                                            country) {
                                                                      controller
                                                                              .selectedCountry =
                                                                          country;
                                                                      controller
                                                                              .countryCode =
                                                                          "+${country.phoneCode}";
                                                                      controller
                                                                              .mobileLength =
                                                                          AppFunctions.getMobileNumberLength(
                                                                              controller.countryCode);

                                                                      controller
                                                                          .update();
                                                                    },
                                                                  );
                                                                },
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    const Gap(
                                                                        10),
                                                                    Text(
                                                                      controller
                                                                          .countryCode,
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .labelMedium!
                                                                          .copyWith(
                                                                              color: AppColors.white),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              inputFormatters: <TextInputFormatter>[
                                                                FilteringTextInputFormatter
                                                                    .digitsOnly,
                                                                LengthLimitingTextInputFormatter(
                                                                    controller
                                                                        .mobileLength),
                                                              ],
                                                              topLabel:
                                                                  "Mobile Number",
                                                              hintText:
                                                                  "Enter Mobile Number",
                                                              controller: controller
                                                                  .rescueMobileNoController,
                                                              validator: (p0) {
                                                                if (p0 ==
                                                                        null ||
                                                                    p0.isEmpty) {
                                                                  return "Please enter rescue Description";
                                                                }

                                                                return null;
                                                              },
                                                            ),
                                                            Gap(20.h),
                                                            Text(
                                                              'Post Category',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                      color: AppColors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                            ),
                                                            const Gap(8),
                                                            DropdownButtonHideUnderline(
                                                              child:
                                                                  DropdownButton2<
                                                                      Categorie>(
                                                                isExpanded:
                                                                    true,
                                                                hint: Text(
                                                                  'Select Category',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium!
                                                                      .copyWith(
                                                                        color: AppColors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                ),
                                                                items: rescueDetailController
                                                                    .rescueCategory
                                                                    .map(
                                                                      (item) =>
                                                                          DropdownMenuItem(
                                                                        value:
                                                                            item,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            AppNetworkImageLoader(
                                                                              url: item.eventIcon ?? '',
                                                                              height: 30.h,
                                                                              width: 30.h,
                                                                              boxFit: BoxFit.cover,
                                                                            ),
                                                                            SizedBox(width: 10.w),
                                                                            Text(
                                                                              item.eventName ?? '',
                                                                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                                                    color: AppColors.white,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                    .toList(),
                                                                value: rescueDetailController.selectedCategory !=
                                                                            null &&
                                                                        rescueDetailController
                                                                            .rescueCategory
                                                                            .contains(rescueDetailController
                                                                                .selectedCategory)
                                                                    ? rescueDetailController
                                                                        .selectedCategory
                                                                    : null,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    rescueDetailController
                                                                            .selectedCategory =
                                                                        value;
                                                                  });
                                                                },
                                                                buttonStyleData:
                                                                    ButtonStyleData(
                                                                  height: 55.h,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: AppColors
                                                                          .textFeildBorderColor,
                                                                      width:
                                                                          1.5,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                ),
                                                                dropdownSearchData:
                                                                    DropdownSearchData(
                                                                  searchController:
                                                                      rescueDetailController
                                                                          .rescueCategoryController,
                                                                  searchInnerWidgetHeight:
                                                                      50,
                                                                  searchInnerWidget:
                                                                      Container(
                                                                    height: 50,
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      top: 8,
                                                                      bottom: 4,
                                                                      right: 8,
                                                                      left: 8,
                                                                    ),
                                                                    child:
                                                                        TextFormField(
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              AppColors.white),
                                                                      expands:
                                                                          true,
                                                                      maxLines:
                                                                          null,
                                                                      controller:
                                                                          rescueDetailController
                                                                              .rescueCategoryController,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        isDense:
                                                                            true,
                                                                        contentPadding:
                                                                            const EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              10,
                                                                          vertical:
                                                                              8,
                                                                        ),
                                                                        hintText:
                                                                            'Search for an item...',
                                                                        hintStyle: const TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                AppColors.white),
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  searchMatchFn:
                                                                      (DropdownMenuItem<Categorie>
                                                                              item,
                                                                          String
                                                                              searchValue) {
                                                                    final category =
                                                                        item.value;
                                                                    if (category ==
                                                                            null ||
                                                                        category.eventName ==
                                                                            null) {
                                                                      return false;
                                                                    }

                                                                    return category
                                                                        .eventName!
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            searchValue.toLowerCase());
                                                                  },
                                                                ),
                                                                dropdownStyleData:
                                                                    DropdownStyleData(
                                                                  maxHeight:
                                                                      300.h,
                                                                  offset:
                                                                      const Offset(
                                                                          0,
                                                                          -5),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: const Color(
                                                                        0xff3D3D42),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                  scrollbarTheme:
                                                                      ScrollbarThemeData(
                                                                    thumbColor: WidgetStateProperty.all(AppColors
                                                                        .white
                                                                        .withValues(
                                                                            alpha:
                                                                                0.5)),
                                                                    radius: const Radius
                                                                        .circular(
                                                                        5),
                                                                    thickness:
                                                                        WidgetStateProperty
                                                                            .all(4),
                                                                  ),
                                                                ),
                                                                menuItemStyleData:
                                                                    MenuItemStyleData(
                                                                  height: 50.h,
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              10.w),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Gap(20.w),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            CommonTextField(
                                                              topLabel: "Name",
                                                              hintText:
                                                                  "Enter Name",
                                                              controller: controller
                                                                  .rescueNameController,
                                                              validator: (p0) {
                                                                if (p0 ==
                                                                        null ||
                                                                    p0.isEmpty) {
                                                                  return "Please enter rescue name";
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                            Gap(20.h),
                                                            CommonTextField(
                                                              topLabel:
                                                                  "Location",
                                                              hintText:
                                                                  "Enter Location",
                                                              controller: controller
                                                                  .rescueLocationController,
                                                              validator: (p0) {
                                                                if (p0 ==
                                                                        null ||
                                                                    p0.isEmpty) {
                                                                  return "Please enter rescue location";
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                            Gap(20.h),
                                                            Text(
                                                              "Date & Time",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                      color: AppColors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                            ),
                                                            Gap(10.h),
                                                            InkWell(
                                                              onTap: () async {
                                                                controller
                                                                    .selectedRescueDate = await controller.pickDateTime(
                                                                        context,
                                                                        initialDate:
                                                                            controller
                                                                                .selectedRescueDate) ??
                                                                    DateTime
                                                                        .now();
                                                                controller
                                                                    .update();
                                                              },
                                                              child: Container(
                                                                height: 55.h,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            10.w),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: AppColors
                                                                        .textFeildBorderColor,
                                                                    width: 1.5,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      DateFormat(
                                                                              'd MMM, y, h:mm a')
                                                                          .format(
                                                                              controller.selectedRescueDate),
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyMedium!
                                                                          .copyWith(
                                                                              color: AppColors.white,
                                                                              fontWeight: FontWeight.w500),
                                                                    ),
                                                                    const Spacer(),
                                                                    Assets.icons
                                                                        .icWatch
                                                                        .svg(),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Gap(20.h),
                                                            CommonTextField(
                                                              topLabel:
                                                                  "Hashtag",
                                                              hintText:
                                                                  "Enter Hashtag",
                                                              controller: controller
                                                                  .rescueHashtagController,
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Gap(20.h),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: CommonTextField(
                                                          topLabel: "Like",
                                                          hintText:
                                                              "Enter Like",
                                                          controller: controller
                                                              .rescueLikeController,
                                                        ),
                                                      ),
                                                      Gap(20.w),
                                                      Expanded(
                                                        child: CommonTextField(
                                                          topLabel: "Share",
                                                          hintText:
                                                              "Enter Share",
                                                          controller: controller
                                                              .rescueShareController,
                                                        ),
                                                      ),
                                                      Gap(20.w),
                                                      Expanded(
                                                        child: CommonTextField(
                                                          topLabel: "View",
                                                          hintText:
                                                              "Enter View",
                                                          controller: controller
                                                              .rescueViewController,
                                                        ),
                                                      ),
                                                      Gap(20.w),
                                                      Expanded(
                                                        child: CommonTextField(
                                                          topLabel: "Comment",
                                                          hintText:
                                                              "Enter Comment",
                                                          controller: controller
                                                              .rescueCommentController,
                                                          // suffixIcon: InkWell(
                                                          //   onTap: () async {
                                                          //     await controller
                                                          //         .openCommentDailoge(
                                                          //             context);
                                                          //   },
                                                          //   child: Assets
                                                          //       .icons.icComment
                                                          //       .svg()
                                                          //       .paddingSymmetric(
                                                          //           horizontal: 20.w),
                                                          // ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Gap(20.h),
                                                ],
                                              ),
                                            ),
                                            Gap(20.h),
                                            RescueTimelineView(
                                              buildContext: context,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ).paddingAll(20.sp),
                          ],
                        ));
                      }),
                      Container(
                        height: 75.h,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: const BoxDecoration(
                          color: AppColors.drawerBgColor,
                          border: Border(
                            top: BorderSide(
                                color: AppColors.borderColor, width: 3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 130,
                              height: 40,
                              child: CommonButton(
                                  color: AppColors.red,
                                  radius: 5,
                                  widget: Text(
                                    'Delete',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w600),
                                  ),
                                  onPressed: () {
                                    commonDialog(
                                      context: context,
                                      subtitle:
                                          'Are you sure want to delete rescue?',
                                      title: 'Delete Rescue',
                                      onTap: () async {
                                        NavigatorRoute.navigateBack(
                                            context: context);
                                        await rescueDetailController
                                            .deleteEventApiCalling(
                                                rescueDetailController
                                                        .getSingleRescueData
                                                        .id ??
                                                    '',
                                                context);
                                      },
                                    );
                                  }),
                            ),
                            const Gap(20),
                            SizedBox(
                              width: 130,
                              height: 40,
                              child: CommonButton(
                                  color: AppColors.textFeildBorderColor,
                                  radius: 5,
                                  widget: Text(
                                    'Update',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w600),
                                  ),
                                  onPressed: () async {
                                    rescueDetailController
                                        .updateRescueApiCalling(context, pl);
                                  }),
                            ),
                            const Gap(20),
                            GetBuilder<RescueDetailController>(
                                builder: (controller) {
                              return controller.getSingleRescueData.status ==
                                      'Timeout'
                                  ? const SizedBox()
                                  : SizedBox(
                                      width: 130,
                                      height: 40,
                                      child: CommonButton(
                                          color: AppColors.green,
                                          radius: 5,
                                          widget: Text(
                                            controller.getSingleRescueData
                                                        .status ==
                                                    'Pending'
                                                ? 'Resolved'
                                                : 'Unresolved',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: AppColors.white,
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ),
                                          onPressed: () async {
                                            rescueDetailController
                                                .updateRescueStatusApiCalling(
                                                    context, pl);
                                          }),
                                    );
                            })
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Obx(
            () {
              return rescueDetailController.detailLoader.value
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Container();
            },
          ),
        ],
      ),
    );
  }
}
