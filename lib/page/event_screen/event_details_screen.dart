import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:eagle_eye_admin/controller/event_detail_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/model/categories_model.dart';
import 'package:eagle_eye_admin/page/event_screen/component/event_image_preview_dialog.dart';
import 'package:eagle_eye_admin/page/event_screen/component/event_preview_dailoge.dart';
import 'package:eagle_eye_admin/page/event_screen/component/event_timeline_view.dart';
import 'package:eagle_eye_admin/page/event_screen/component/expanded_text_feild.dart';
import 'package:eagle_eye_admin/page/user_profile_screen/user_profile_view.dart';
import 'package:eagle_eye_admin/route/app_route.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/service/storage/storage_service.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/utils/app_image_viewer.dart';
import 'package:eagle_eye_admin/utils/responsive_utils.dart';
import 'package:eagle_eye_admin/widget/app_network_image.dart';
import 'package:eagle_eye_admin/widget/button.dart';
import 'package:eagle_eye_admin/widget/common_dialog.dart';
import 'package:eagle_eye_admin/widget/drawer.dart';
import 'package:eagle_eye_admin/widget/hashtag_formatter.dart';
import 'package:eagle_eye_admin/widget/textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  // DashboardController controller = Get.put(DashboardController());
  EventDetailController eventDetailController =
      Get.put(EventDetailController());
  bool isHovered = false;

  @override
  void initState() {
    eventDetailController.onRefresh(context: context);
    // if (Get.arguments != null) {
    //   // eventDetailController.getSingleEventList(Get.arguments);
    //   eventDetailController.selectedValue = null;
    //   eventDetailController.selectedEventReaction = null;
    //   eventDetailController.getAllCategories();
    //   eventDetailController.getAllReactions();
    //   eventDetailController.getSingleEventList(Get.arguments);
    // }
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
                  key: eventDetailController.formKey,
                  child: Column(
                    children: [
                      // const Header(),
                      GetBuilder<EventDetailController>(
                          builder: (eventDetailController) {
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
                                      "Attach File",
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
                                                    .bodySmall!
                                                    .copyWith(
                                                        color: AppColors.white,
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          onPressed: () {
                                            eventDetailController
                                                .openAttachFile(context);
                                          }),
                                    ),
                                    Gap(10.w),
                                    SizedBox(
                                      width: 160.w,
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
                                            await eventDetailController
                                                .openAddTimeLineDialogBox(
                                                    context,
                                                    StorageService
                                                            .getEventId() ??
                                                        '');
                                          }),
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
                                        // NavigatorRoute.navigateBack(context:  context);
                                        context.pop();
                                      },
                                      child: Text(
                                        "Event",
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
                                    Text(
                                      eventDetailController
                                              .getSingleEventData.title ??
                                          '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: AppColors.blue,
                                              fontWeight: FontWeight.w700),
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
                                      controller: eventDetailController
                                          .eventDetailsScrollController,
                                      child: SingleChildScrollView(
                                        controller: eventDetailController
                                            .eventDetailsScrollController,
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
                                                        onTap: () async {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return UserProfileView(
                                                                userId: eventDetailController
                                                                        .getSingleEventData
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
                                                                  eventDetailController
                                                                          .getSingleEventData
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
                                                                eventDetailController
                                                                        .getSingleEventData
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
                                                    ],
                                                  ),
                                                  Gap(15.h),
                                                  eventDetailController
                                                              .getSingleEventData
                                                              .thumbnail !=
                                                          null
                                                      ? Stack(
                                                          alignment: Alignment
                                                              .topRight,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () async {
                                                                if (eventDetailController
                                                                        .getSingleEventData
                                                                        .attachmentFileType ==
                                                                    'Video') {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return EventPreviewDailoge(
                                                                          videoPath:
                                                                              eventDetailController.getSingleEventData.attachment ?? '');
                                                                    },
                                                                  );
                                                                } else if (eventDetailController
                                                                        .getSingleEventData
                                                                        .attachmentFileType ==
                                                                    'Image') {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return EventImagePreviewDialog(
                                                                        imageURL:
                                                                            eventDetailController.getSingleEventData.attachment ??
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
                                                                      url: eventDetailController
                                                                              .getSingleEventData
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
                                                                  eventDetailController
                                                                              .getSingleEventData
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
                                                                eventDetailController
                                                                    .getSingleEventData
                                                                    .thumbnail = null;
                                                                eventDetailController
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
                                                      : (eventDetailController
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
                                                                        eventDetailController
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
                                                                          eventDetailController.postFirstFile =
                                                                              null;
                                                                          eventDetailController.postFirstFileBytes =
                                                                              null;
                                                                          eventDetailController
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
                                                                eventDetailController
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
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
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
                                                                items: eventDetailController
                                                                    .eventCategory
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
                                                                value: eventDetailController.selectedValue !=
                                                                            null &&
                                                                        eventDetailController
                                                                            .eventCategory
                                                                            .contains(eventDetailController
                                                                                .selectedValue)
                                                                    ? eventDetailController
                                                                        .selectedValue
                                                                    : null,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    eventDetailController
                                                                            .selectedValue =
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
                                                                      eventDetailController
                                                                          .eventCategoryController,
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
                                                                          eventDetailController
                                                                              .eventCategoryController,
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
                                                            Text(
                                                              "Start Date",
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
                                                                eventDetailController
                                                                        .selectedDateTime =
                                                                    await eventDetailController.pickDate(
                                                                        context,
                                                                        dateTime:
                                                                            eventDetailController.selectedDateTime);
                                                                setState(() {});
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
                                                                      eventDetailController
                                                                          .formatDateData(
                                                                              eventDetailController.selectedDateTime),
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
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Gap(20.h),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
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
                                                              controller:
                                                                  eventDetailController
                                                                      .eventTitleController,
                                                              validator: (p0) {
                                                                if (p0 ==
                                                                        null ||
                                                                    p0.isEmpty) {
                                                                  return "Please enter event title";
                                                                }
                                                                return null;
                                                              },
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
                                                              topLabel:
                                                                  "Hashtag",
                                                              hintText:
                                                                  "Enter #Hashtags Separated by Space",
                                                              controller:
                                                                  eventDetailController
                                                                      .eventHashtagController,
                                                              inputFormatters: [
                                                                HashtagInputFormatter()
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Gap(20.h),
                                                  CommonTextField(
                                                    topLabel: "Location",
                                                    hintText: "Enter Location",
                                                    controller:
                                                        eventDetailController
                                                            .eventLocationController,
                                                    // validator: (p0) {
                                                    //   if (p0 ==
                                                    //           null ||
                                                    //       p0.isEmpty) {
                                                    //     return "Please enter event location";
                                                    //   }
                                                    //   return null;
                                                    // },
                                                  ),
                                                  Gap(20.h),
                                                  Text(
                                                    "Description",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                            color:
                                                                AppColors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                  ),
                                                  const Gap(8),
                                                  ExpandedTextField(
                                                    child: TextFormField(
                                                      controller:
                                                          eventDetailController
                                                              .eventDescriptionController,
                                                      maxLines: 100,
                                                      cursorColor:
                                                          AppColors.white,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelMedium!
                                                          .copyWith(
                                                              color: AppColors
                                                                  .white),
                                                      decoration:
                                                          InputDecoration(
                                                        // fillColor: fillColor,
                                                        // filled: fillColor != null ? true : false,
                                                        counter: const SizedBox
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
                                                                color: AppColors
                                                                    .red),
                                                        errorBorder:
                                                            const OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color:
                                                                AppColors.red,
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
                                                  Gap(20.h),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
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
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              inputFormatters: <TextInputFormatter>[
                                                                FilteringTextInputFormatter
                                                                    .allow(RegExp(
                                                                        r'^\d*\.?\d*$')),
                                                              ],
                                                              topLabel:
                                                                  "Latitude",
                                                              hintText:
                                                                  "Enter latitude",
                                                              controller:
                                                                  eventDetailController
                                                                      .eventLatController,
                                                              validator: (p0) {
                                                                if (p0 ==
                                                                        null ||
                                                                    p0.isEmpty) {
                                                                  return "Please enter latitude";
                                                                }
                                                                return null;
                                                              },
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
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              inputFormatters: <TextInputFormatter>[
                                                                FilteringTextInputFormatter
                                                                    .allow(RegExp(
                                                                        r'^\d*\.?\d*$')),
                                                              ],
                                                              topLabel:
                                                                  "Longitude",
                                                              hintText:
                                                                  "Enter longitude",
                                                              controller:
                                                                  eventDetailController
                                                                      .eventLongController,
                                                              validator: (p0) {
                                                                if (p0 ==
                                                                        null ||
                                                                    p0.isEmpty) {
                                                                  return "Please enter longitude";
                                                                }
                                                                return null;
                                                              },
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
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          inputFormatters: <TextInputFormatter>[
                                                            FilteringTextInputFormatter
                                                                .digitsOnly,
                                                          ],
                                                          topLabel: "Like",
                                                          hintText:
                                                              "Enter Like",
                                                          controller:
                                                              eventDetailController
                                                                  .eventLikeController,
                                                          validator: (p0) {
                                                            if (p0 == null ||
                                                                p0.isEmpty) {
                                                              return "Please enter Like";
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                      Gap(20.w),
                                                      Expanded(
                                                        child: CommonTextField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          inputFormatters: <TextInputFormatter>[
                                                            FilteringTextInputFormatter
                                                                .digitsOnly,
                                                          ],
                                                          topLabel: "Share",
                                                          hintText:
                                                              "Enter Share",
                                                          controller:
                                                              eventDetailController
                                                                  .eventShareController,
                                                          validator: (p0) {
                                                            if (p0 == null ||
                                                                p0.isEmpty) {
                                                              return "Please enter share";
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                      Gap(20.w),
                                                      Expanded(
                                                        child: CommonTextField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          inputFormatters: <TextInputFormatter>[
                                                            FilteringTextInputFormatter
                                                                .digitsOnly,
                                                          ],
                                                          topLabel: "View",
                                                          hintText:
                                                              "Enter View",
                                                          controller:
                                                              eventDetailController
                                                                  .eventViewController,
                                                          validator: (p0) {
                                                            if (p0 == null ||
                                                                p0.isEmpty) {
                                                              return "Please enter view";
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                      Gap(20.w),
                                                      Expanded(
                                                        child: CommonTextField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          inputFormatters: <TextInputFormatter>[
                                                            FilteringTextInputFormatter
                                                                .digitsOnly,
                                                          ],
                                                          topLabel: "Comment",
                                                          hintText:
                                                              "Enter Comment",
                                                          controller:
                                                              eventDetailController
                                                                  .eventCommentController,
                                                          validator: (p0) {
                                                            if (p0 == null ||
                                                                p0.isEmpty) {
                                                              return "Please enter comment";
                                                            }
                                                            return null;
                                                          },
                                                          // suffixIcon: InkWell(
                                                          //   onTap: () async {
                                                          //     await eventDetailController
                                                          //         .openCommentBox(
                                                          //             context);
                                                          //   },
                                                          //   child: Assets
                                                          //       .icons.icComment
                                                          //       .svg()
                                                          //       .paddingSymmetric(
                                                          //           horizontal:
                                                          //               20.w),
                                                          // ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Gap(20.h),
                                            const EventTimelineView(),
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
                                          'Are you sure want to delete event?',
                                      title: 'Delete Event',
                                      onTap: () async {
                                        NavigatorRoute.navigateBack(
                                            context: context);
                                        await eventDetailController
                                            .deleteEventApiCalling(
                                                eventDetailController
                                                        .getSingleEventData
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
                                    eventDetailController.updateEvent(
                                        context, pl);
                                  }),
                            )
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
              return eventDetailController.detailLoader.value
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
