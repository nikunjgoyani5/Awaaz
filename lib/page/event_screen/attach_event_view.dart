import 'dart:convert';
import 'dart:developer';

import 'package:eagle_eye_admin/controller/app_controller.dart';
import 'package:eagle_eye_admin/controller/attach_file_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/model/get_filter_events.dart';
import 'package:eagle_eye_admin/page/dashboard_screen/components/header.dart';
import 'package:eagle_eye_admin/page/event_screen/component/attach_event_card_view.dart';
import 'package:eagle_eye_admin/page/event_screen/component/event_preview_dailoge.dart';
import 'package:eagle_eye_admin/page/event_screen/component/expanded_text_feild.dart';
import 'package:eagle_eye_admin/route/app_route.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/service/storage/storage_service.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/utils/responsive_utils.dart';
import 'package:eagle_eye_admin/widget/app_network_image.dart';
import 'package:eagle_eye_admin/widget/button.dart';
import 'package:eagle_eye_admin/widget/drawer.dart';
import 'package:eagle_eye_admin/widget/hashtag_formatter.dart';
import 'package:eagle_eye_admin/widget/textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AttachEventView extends StatefulWidget {
  const AttachEventView({super.key});

  @override
  State<AttachEventView> createState() => _AttachEventViewState();
}

class _AttachEventViewState extends State<AttachEventView> {
  // DashboardController controller = Get.put(DashboardController());
  AttachFileController attachEventController = Get.put(AttachFileController());
  bool isHovered = false;
  FilterEvents? userPost;

  @override
  void initState() {
    init();
    super.initState();
  }

  FilterEvents getEvent() {
    String? eventJson = StorageService.getUserPost();
    log("===Event json===$eventJson");
    if (eventJson != null) {
      return FilterEvents.fromJson(
          jsonDecode(eventJson)); // Convert back to object
    }
    return FilterEvents();
  }

  init() async {
    // userPost = Get.arguments;
    userPost = getEvent();
    await attachEventController.getEventsList(
        context: context,
        long: double.parse(userPost?.longitude?.toString() ?? '0.0'),
        lat: double.parse(userPost?.latitude?.toString() ?? '0.0'));
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProgressLoader pl = ProgressLoader(context, isDismissible: true);
    return Scaffold(
      drawer: const DrawerWidget(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Responsive.isDesktop(context))
            const Expanded(
              child: DrawerWidget(),
            ),
          Expanded(
            flex: 5,
            child: Form(
              key: attachEventController.formKey,
              child: Column(
                children: [
                  GetBuilder<AttachFileController>(builder: (controller) {
                    return Container(
                      height: 85.h,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: AppColors.borderColor, width: 3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (!Responsive.isDesktop(context))
                            IconButton(
                              icon: const Icon(Icons.menu),
                              onPressed: appController.controlMenu,
                            ),
                          if (!Responsive.isMobile(context))
                            GestureDetector(
                              onTap: () {
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
                          SizedBox(
                            height: 60,
                            width: 400,
                            child: CommonTextField(
                              prefixIcon: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(13),
                                    child: Assets.icons.icSearch.svg(),
                                  )),
                              height: 45,
                              fillColor: AppColors.borderColor,
                              enableBorderColor: AppColors.borderColor,
                              hintText: "Search",
                              controller:
                                  attachEventController.searchController,
                              onChanged: (value) async {
                                attachEventController.approvedEventList.clear();
                                attachEventController.pageNumber = 1;
                                await attachEventController.getEventsList(
                                    context: context,
                                    long: double.parse(
                                        userPost?.longitude.toString() ??
                                            '0.0'),
                                    lat: double.parse(
                                        userPost?.latitude.toString() ??
                                            '0.0'));
                                // attachEventController.filterItems(value);
                                attachEventController.update();
                                setState(() {});
                              },
                            ),
                          ),
                          if (!Responsive.isMobile(context))
                            Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
                          const ProfileCard()
                        ],
                      ),
                    );
                  }),
                  Expanded(
                    child: Row(
                      children: [
                        GetBuilder<AttachFileController>(builder: (controller) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.22,
                            decoration: const BoxDecoration(
                              color: AppColors.attachEventListBarColor,
                              border: Border(
                                right: BorderSide(
                                    color: AppColors.borderColor, width: 3),
                              ),
                            ),
                            child: Column(
                              children: [
                                Gap(20.h),
                                Row(
                                  children: [
                                    Text(
                                      'All Event',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.white),
                                    ),
                                    // const Spacer(),
                                    // CircleAvatar(
                                    //   radius: 20,
                                    //   backgroundColor: AppColors.borderColor,
                                    //   child: IconButton(
                                    //       onPressed: () {},
                                    //       icon: Assets.icons.icFilter.svg()),
                                    // ),
                                  ],
                                ).paddingSymmetric(horizontal: 20),
                                Gap(20.h),
                                Obx(
                                  () {
                                    return /*attachEventController
                                            .searchController.text.isNotEmpty
                                        ? attachEventController
                                                .filteredApprovedEventList
                                                .isNotEmpty
                                            ? Expanded(
                                                child: Theme(
                                                  data: ThemeData(
                                                    scrollbarTheme:
                                                        ScrollbarThemeData(
                                                      trackColor:
                                                          WidgetStateProperty
                                                              .all(AppColors
                                                                  .textFeildBorderColor
                                                                  .withValues(alpha:
                                                                      0.5)),
                                                      thumbColor:
                                                          WidgetStateProperty
                                                              .all(AppColors
                                                                  .white
                                                                  .withValues(alpha:
                                                                      0.2)),
                                                    ),
                                                  ),
                                                  child: ListView.builder(
                                                    controller:
                                                        attachEventController
                                                            .eventAttachScrollController,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount: attachEventController
                                                        .filteredApprovedEventList
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          attachEventController
                                                                  .selectedEvent =
                                                              attachEventController
                                                                      .filteredApprovedEventList[
                                                                  index];

                                                          attachEventController
                                                              .onSelectEvent(
                                                                  userPost ??
                                                                      FilterEvents());
                                                        },
                                                        child:
                                                            AttachEventCardView(
                                                          eventData:
                                                              attachEventController
                                                                      .filteredApprovedEventList[
                                                                  index],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              )
                                            : Expanded(
                                                child: Center(
                                                  child: Text(
                                                    'No Data Found',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: AppColors
                                                                .white),
                                                  ),
                                                ),
                                              )
                                        :*/
                                        attachEventController.loader.value
                                            ? Column(
                                                children: [
                                                  const Gap(200),
                                                  FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: SizedBox(
                                                        height: 150,
                                                        width: 150,
                                                        child: Lottie.asset(
                                                            'assets/animation/loader.json')),
                                                  ),
                                                ],
                                              )
                                            : attachEventController
                                                    .approvedEventList
                                                    .isNotEmpty
                                                ? Expanded(
                                                    child: Theme(
                                                      data: ThemeData(
                                                        scrollbarTheme:
                                                            ScrollbarThemeData(
                                                          trackColor: WidgetStateProperty
                                                              .all(AppColors
                                                                  .textFeildBorderColor
                                                                  .withValues(
                                                                      alpha:
                                                                          0.5)),
                                                          thumbColor:
                                                              WidgetStateProperty
                                                                  .all(AppColors
                                                                      .white
                                                                      .withValues(
                                                                          alpha:
                                                                              0.2)),
                                                        ),
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          NotificationListener(
                                                            onNotification:
                                                                (notification) {
                                                              if (notification
                                                                      is ScrollEndNotification &&
                                                                  notification
                                                                          .metrics
                                                                          .extentAfter ==
                                                                      0) {
                                                                if ((attachEventController
                                                                            .getFilterEventModel
                                                                            .body
                                                                            ?.page ??
                                                                        0) <
                                                                    (attachEventController
                                                                            .getFilterEventModel
                                                                            .body
                                                                            ?.totalPages ??
                                                                        0)) {
                                                                  attachEventController.eventPagination(
                                                                      context:
                                                                          context,
                                                                      long: double.parse(userPost
                                                                              ?.longitude
                                                                              .toString() ??
                                                                          '0.0'),
                                                                      lat: double.parse(userPost
                                                                              ?.latitude
                                                                              .toString() ??
                                                                          '0.0'));
                                                                }
                                                              }
                                                              return false;
                                                            },
                                                            child: ListView
                                                                .builder(
                                                              controller:
                                                                  attachEventController
                                                                      .eventAttachScrollController,
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              itemCount:
                                                                  attachEventController
                                                                      .approvedEventList
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    attachEventController
                                                                        .selectedEvent = attachEventController
                                                                            .approvedEventList[
                                                                        index];
                                                                    attachEventController.onSelectEvent(
                                                                        userPost ??
                                                                            FilterEvents());
                                                                  },
                                                                  child:
                                                                      AttachEventCardView(
                                                                    eventData:
                                                                        attachEventController
                                                                            .approvedEventList[index],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          Obx(
                                                            () {
                                                              return attachEventController
                                                                      .paginationLoader
                                                                      .value
                                                                  ? const Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomCenter,
                                                                      child:
                                                                          LinearProgressIndicator(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    )
                                                                  : const SizedBox
                                                                      .shrink();
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : Expanded(
                                                    child: Center(
                                                      child: Text(
                                                        'No Data Found',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: AppColors
                                                                    .white),
                                                      ),
                                                    ),
                                                  );
                                  },
                                ),
                              ],
                            ),
                          );
                        }),
                        GetBuilder<AttachFileController>(builder: (controller) {
                          return Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage(Assets.image.mapBg.path))),
                              child: (controller.selectedEvent != null)
                                  ? SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Attach File",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall!
                                                .copyWith(
                                                    color: AppColors.white,
                                                    fontWeight:
                                                        FontWeight.w700),
                                          ),
                                          Gap(20.h),
                                          Row(
                                            children: [
                                              InkWell(
                                                overlayColor:
                                                    WidgetStateProperty.all(
                                                        Colors.transparent),
                                                radius: 0,
                                                onTap: () {
                                                  NavigatorRoute.navigateBack(
                                                      context: context);
                                                },
                                                child: Text(
                                                  "Event",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          color:
                                                              AppColors.white,
                                                          fontWeight:
                                                              FontWeight.w700),
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
                                                  controller.selectedEvent
                                                          ?.title ??
                                                      '',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          color: AppColors.blue,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Gap(30.h),
                                          Row(
                                            children: [
                                              ClipOval(
                                                child: AppNetworkImageLoader(
                                                  url: userPost
                                                          ?.profilePicture ??
                                                      "",
                                                  height: 40,
                                                  width: 40,
                                                  boxFit: BoxFit.contain,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20 / 2),
                                                child: Text(
                                                  userPost?.name ?? '',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                          color:
                                                              AppColors.white,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Gap(20.h),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              ///select Image code
                                              // (controller.selectedAttachEventFile !=
                                              //         null)
                                              //     ? MouseRegion(
                                              //         onHover: (_) => setState(
                                              //             () =>
                                              //                 isHovered = true),
                                              //         onExit: (_) => setState(
                                              //             () => isHovered =
                                              //                 false),
                                              //         child: Stack(
                                              //           children: [
                                              //             Container(
                                              //               height: MediaQuery.of(
                                              //                           context)
                                              //                       .size
                                              //                       .height *
                                              //                   0.22,
                                              //               width: MediaQuery.of(
                                              //                           context)
                                              //                       .size
                                              //                       .width *
                                              //                   0.20,
                                              //               decoration:
                                              //                   BoxDecoration(
                                              //                 color:
                                              //                     Colors.black,
                                              //                 borderRadius:
                                              //                     BorderRadius
                                              //                         .circular(
                                              //                             8),
                                              //               ),
                                              //               child: ClipRRect(
                                              //                 borderRadius:
                                              //                     BorderRadius
                                              //                         .circular(
                                              //                             8),
                                              //                 child:
                                              //                     Image.memory(
                                              //                   controller
                                              //                       .selectedAttachEventFile!,
                                              //                   fit: BoxFit
                                              //                       .cover, // Ensures the image covers the entire box
                                              //                 ),
                                              //               ),
                                              //             ),
                                              //             if (isHovered)
                                              //               Positioned.fill(
                                              //                 child: InkWell(
                                              //                   onTap: () {
                                              //                     controller
                                              //                             .selectedAttachEventFile =
                                              //                         null;
                                              //                     controller
                                              //                         .update();
                                              //                   },
                                              //                   child:
                                              //                       Container(
                                              //                     decoration:
                                              //                         BoxDecoration(
                                              //                       color: Colors
                                              //                           .black
                                              //                           .withValues(alpha:
                                              //                               0.6),
                                              //                       borderRadius:
                                              //                           BorderRadius
                                              //                               .circular(8),
                                              //                     ),
                                              //                     child: Center(
                                              //                       child: Row(
                                              //                         mainAxisSize:
                                              //                             MainAxisSize
                                              //                                 .min,
                                              //                         children: [
                                              //                           const Icon(
                                              //                               Icons
                                              //                                   .delete,
                                              //                               color:
                                              //                                   Colors.red),
                                              //                           Gap(5
                                              //                               .w),
                                              //                           const Text(
                                              //                             'Remove File',
                                              //                             style:
                                              //                                 TextStyle(
                                              //                               color:
                                              //                                   Colors.red,
                                              //                               fontSize:
                                              //                                   16,
                                              //                               fontWeight:
                                              //                                   FontWeight.bold,
                                              //                             ),
                                              //                           ),
                                              //                         ],
                                              //                       ),
                                              //                     ),
                                              //                   ),
                                              //                 ),
                                              //               ),
                                              //           ],
                                              //         ),
                                              //       )
                                              //     : InkWell(
                                              //         borderRadius:
                                              //             BorderRadius.circular(
                                              //                 8.r),
                                              //         onTap: () async {
                                              //           // controller
                                              //           //         .selectedAttachEventFile =
                                              //           //     await controller
                                              //           //         .pickFile();
                                              //           // controller.update();
                                              //         },
                                              //         child: Container(
                                              //           height: MediaQuery.of(
                                              //                       context)
                                              //                   .size
                                              //                   .height *
                                              //               0.22,
                                              //           width: MediaQuery.of(
                                              //                       context)
                                              //                   .size
                                              //                   .width *
                                              //               0.20,
                                              //           decoration:
                                              //               BoxDecoration(
                                              //             color: AppColors
                                              //                 .drawerBgColor,
                                              //             borderRadius:
                                              //                 BorderRadius
                                              //                     .circular(
                                              //                         8.r),
                                              //           ),
                                              //           child: Padding(
                                              //             padding: EdgeInsets
                                              //                 .symmetric(
                                              //                     horizontal:
                                              //                         20.w,
                                              //                     vertical:
                                              //                         20.h),
                                              //             child: Column(
                                              //               mainAxisAlignment:
                                              //                   MainAxisAlignment
                                              //                       .center,
                                              //               crossAxisAlignment:
                                              //                   CrossAxisAlignment
                                              //                       .center,
                                              //               children: [
                                              //                 Assets.icons
                                              //                     .icAttachFile
                                              //                     .svg(
                                              //                   height: 35.h,
                                              //                   width: 35.w,
                                              //                   colorFilter:
                                              //                       const ColorFilter
                                              //                           .mode(
                                              //                     AppColors
                                              //                         .grey909090,
                                              //                     BlendMode
                                              //                         .srcIn,
                                              //                   ),
                                              //                 ),
                                              //                 Gap(10.w),
                                              //                 Text(
                                              //                   'Attach File',
                                              //                   style: Theme.of(
                                              //                           context)
                                              //                       .textTheme
                                              //                       .bodyMedium!
                                              //                       .copyWith(
                                              //                         color: AppColors
                                              //                             .grey909090,
                                              //                         fontWeight:
                                              //                             FontWeight
                                              //                                 .w500,
                                              //                       ),
                                              //                 ),
                                              //               ],
                                              //             ),
                                              //           ),
                                              //         ),
                                              //       ),

                                              ///show thumbnail

                                              GestureDetector(
                                                onTap: () async {
                                                  showDialog(
                                                    context: context,
                                                    routeSettings:
                                                        const RouteSettings(
                                                            name:
                                                                '/event/eventPreview'),
                                                    builder: (context) {
                                                      return EventPreviewDailoge(
                                                        videoPath: userPost
                                                                ?.attachment ??
                                                            '',
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.22,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.20,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        AppColors.drawerBgColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.r),
                                                  ),
                                                  child: AppNetworkImageLoader(
                                                    url: userPost?.thumbnail ??
                                                        "",
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.22,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.20,
                                                    boxFit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),

                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20.w),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // CommonTextField(
                                                      //   height: 100.h,
                                                      //   maxLines: 3,
                                                      //   topLabel: "Description",
                                                      //   hintText:
                                                      //       "Enter Description",
                                                      //   controller: controller
                                                      //       .eventDescriptionController,
                                                      //   validator: (p0) {
                                                      //     if (p0 == null ||
                                                      //         p0.isEmpty) {
                                                      //       return "Please enter your description";
                                                      //     }
                                                      //     return null;
                                                      //   },
                                                      // ),

                                                      Text(
                                                        "Description",
                                                        style: Theme.of(context)
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
                                                      ExpandedTextField(
                                                        child: TextFormField(
                                                          validator: (p0) {
                                                            if (p0 == null ||
                                                                p0.isEmpty) {
                                                              return "Please enter your description";
                                                            }
                                                            return null;
                                                          },
                                                          controller: controller
                                                              .eventDescriptionController,
                                                          maxLines: 100,
                                                          cursorColor:
                                                              AppColors.white,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .labelMedium!
                                                              .copyWith(
                                                                  color: AppColors
                                                                      .white),
                                                          decoration:
                                                              InputDecoration(
                                                            // fillColor: fillColor,
                                                            // filled: fillColor != null ? true : false,
                                                            counter:
                                                                const SizedBox
                                                                    .shrink(),
                                                            // prefixIcon: prefixIcon,
                                                            // suffixIcon: suffixIcon,
                                                            enabledBorder:
                                                                const OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: AppColors
                                                                    .textFeildBorderColor,
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            focusedBorder:
                                                                const OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: AppColors
                                                                    .textFeildBorderColor,
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            errorStyle:
                                                                const TextStyle(
                                                                    height: 0,
                                                                    color:
                                                                        AppColors
                                                                            .red),
                                                            errorBorder:
                                                                const OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: AppColors
                                                                    .red,
                                                              ),
                                                            ),
                                                            focusedErrorBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .error,
                                                              ),
                                                            ),
                                                            hintText:
                                                                'Enter Description',
                                                            hintStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelMedium!
                                                                .copyWith(
                                                                    color: AppColors
                                                                        .grey929da9),
                                                          ),
                                                          // maxLines: 100,
                                                        ),
                                                      ),
                                                      const Gap(12),
                                                      CommonTextField(
                                                        topLabel: "Hashtag",
                                                        hintText:
                                                            "Enter #Hashtags Separated by Space",
                                                        controller: controller
                                                            .eventHashtagController,
                                                        inputFormatters: [HashtagInputFormatter()],
                                                        // validator: (p0) {
                                                        //   if (p0 == null ||
                                                        //       p0.isEmpty) {
                                                        //     return "Please enter event hashtag";
                                                        //   }
                                                        //   return null;
                                                        // },
                                                      ),
                                                      const Gap(12),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.15,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Time",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyMedium!
                                                                        .copyWith(
                                                                            color:
                                                                                AppColors.white,
                                                                            fontWeight: FontWeight.w500),
                                                                  ),
                                                                  Gap(10.h),
                                                                  InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      await controller
                                                                          .pickDate(
                                                                        context,
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          55.h,
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              10.w),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              AppColors.textFeildBorderColor,
                                                                          width:
                                                                              1.5,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(5),
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Text(
                                                                            controller.timeDataInString,
                                                                            style:
                                                                                Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.white, fontWeight: FontWeight.w500),
                                                                          ),
                                                                          const Spacer(),
                                                                          Assets
                                                                              .icons
                                                                              .icWatch
                                                                              .svg(),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )),
                                                          Gap(20.w),
                                                          Checkbox(
                                                            checkColor:
                                                                AppColors.white,
                                                            activeColor:
                                                                AppColors.blue,
                                                            value: controller
                                                                .isSensitive,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                controller
                                                                        .isSensitive =
                                                                    value ??
                                                                        false;
                                                              });
                                                              controller
                                                                  .update();
                                                            },
                                                          ),
                                                          Gap(10.w),
                                                          Text(
                                                            "Sensitive Content",
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
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.15,
                                                          ),
                                                          Gap(20.w),
                                                          Checkbox(
                                                            checkColor:
                                                                AppColors.white,
                                                            activeColor:
                                                                AppColors.blue,
                                                            value: controller
                                                                .isShareAnonymously,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                controller
                                                                        .isShareAnonymously =
                                                                    value ??
                                                                        false;
                                                              });
                                                              controller
                                                                  .update();
                                                            },
                                                          ),
                                                          Gap(10.w),
                                                          Text(
                                                            "Share Anonymously",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
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
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Gap(100),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 130,
                                                height: 40,
                                                child: CommonButton(
                                                    color: AppColors.grey929da9,
                                                    radius: 5,
                                                    widget: Text(
                                                      'Cancel',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color: AppColors
                                                                  .white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                    ),
                                                    onPressed: () {
                                                      controller.selectedEvent =
                                                          null;
                                                      controller.update();
                                                    }),
                                              ),
                                              Gap(20.w),
                                              SizedBox(
                                                width: 130,
                                                height: 40,
                                                child: CommonButton(
                                                    color: controller
                                                            .selectedDateTime
                                                            .isAfter(
                                                                DateTime.now())
                                                        ? Colors.white
                                                        : AppColors.green,
                                                    radius: 5,
                                                    widget: Text(
                                                      controller
                                                              .selectedDateTime
                                                              .isAfter(DateTime
                                                                  .now())
                                                          ? 'Schedule'
                                                          : 'Post',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color: controller
                                                                      .selectedDateTime
                                                                      .isAfter(
                                                                          DateTime
                                                                              .now())
                                                                  ? Colors.black
                                                                  : AppColors
                                                                      .white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    onPressed: () async {
                                                      if (attachEventController
                                                              .formKey
                                                              .currentState
                                                              ?.validate() ??
                                                          false) {
                                                        await attachEventController
                                                            .attachPostEventAPI(
                                                          context: context,
                                                          pl: pl,
                                                          userPostData:
                                                              userPost ??
                                                                  FilterEvents(),
                                                        );
                                                      }
                                                    }),
                                              )
                                            ],
                                          )
                                        ],
                                      ).paddingAll(20.sp),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            Assets.image.noDataSelected.path,
                                            height: 300.h,
                                            width: 300.w,
                                          ),
                                        ),
                                        Gap(20.h),
                                        Text(
                                          "Select an event and attach",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  color: AppColors.white,
                                                  fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                            ),
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
    );
  }
}
