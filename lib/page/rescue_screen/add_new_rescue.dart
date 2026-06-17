import 'dart:developer';
import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:eagle_eye_admin/controller/event_controller.dart';
import 'package:eagle_eye_admin/controller/rescue_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/model/categories_model.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/utils/app_functions.dart';
import 'package:eagle_eye_admin/utils/app_image_viewer.dart';
import 'package:eagle_eye_admin/widget/app_network_image.dart';
import 'package:eagle_eye_admin/widget/button.dart';
import 'package:eagle_eye_admin/widget/common_dialog.dart';
import 'package:eagle_eye_admin/widget/hashtag_formatter.dart';
import 'package:eagle_eye_admin/widget/textfeild.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../event_screen/component/add_category.dart';

class AddNewRescue extends StatefulWidget {
  final String? page;
  final bool isUser;
  final String? draftId;

  const AddNewRescue(
      {super.key, required this.page, required this.isUser, this.draftId});

  @override
  State<AddNewRescue> createState() => _AddNewRescueState();
}

class _AddNewRescueState extends State<AddNewRescue> {
  RescueController controller = Get.put(RescueController());
  EventController eventController = Get.put(EventController());
  GlobalKey key = GlobalKey();
  bool isHovered = false;

  Widget buildImage() {
    if (kIsWeb) {
      if (controller.selectedImageOrVideo != null) {
        return Image.memory(
          controller.selectedImageOrVideoBytes!,
          fit: BoxFit.cover,
        );
      }
      return Image.network(
        'https://via.placeholder.com/150',
        fit: BoxFit.cover,
      );
    } else {
      if (controller.selectedImageOrVideo != null) {
        return Image.file(
          File(controller.selectedImageOrVideo!.path),
          fit: BoxFit.cover,
        );
      }
      return Container(
        color: Colors.grey,
        child: const Center(
          child: Text(
            'No Image Available',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    if (widget.isUser == true && widget.draftId == null) {
      controller.setCreateRescueData();

      setState(() {});
    }
    if (widget.draftId != null) {
      controller.setDraftRescueData();

      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ProgressLoader pl = ProgressLoader(context, isDismissible: true);
    return GetBuilder<RescueController>(builder: (controller) {
      return Dialog(
        key: key,
        alignment: Alignment.topCenter,
        insetPadding: EdgeInsets.only(top: 40.h),
        backgroundColor: AppColors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: StatefulBuilder(
          builder: (context, update) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        widget.isUser == true
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    ClipOval(
                                        child: Container(
                                      height: 40,
                                      alignment: Alignment.center,
                                      width: 40,
                                      decoration: const BoxDecoration(
                                        color: AppColors.attachCardColor,
                                      ),
                                      child: AppNetworkImageLoader(
                                          url: controller.selectedRescue
                                                  .profilePicture ??
                                              '',
                                          height: 40,
                                          width: 40,
                                          boxFit: BoxFit.cover),
                                    )),
                                    const Gap(10),
                                    Text(
                                      controller.selectedRescue.name ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  "New Rescue",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w500),
                                ),
                              ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            if (widget.draftId != null) {

                              NavigatorRoute.navigateBack(context: context);
                            } else {
                              commonDialog(
                                context: context,
                                subtitle: 'Do you  want to save as  draft?',
                                title: 'Create Draft',
                                onTapCancel: () {
                                  NavigatorRoute.navigateBack(context: context);
                                  NavigatorRoute.navigateBack(context: context);
                                },
                                onTap: () async {
                                  NavigatorRoute.navigateBack(context: context);
                                  controller.createDraftEvent(
                                      context, pl, widget.isUser);
                                },
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    Gap(35.h),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: Theme(
                        data: ThemeData(
                          scrollbarTheme: ScrollbarThemeData(
                            trackColor: WidgetStateProperty.all(AppColors
                                .textFeildBorderColor
                                .withValues(alpha: 0.5)),
                            thumbColor: WidgetStateProperty.all(
                                AppColors.white.withValues(alpha: 0.2)),
                          ),
                        ),
                        child: Scrollbar(
                          radius: const Radius.circular(0),
                          trackVisibility: true,
                          scrollbarOrientation: ScrollbarOrientation.right,
                          thumbVisibility: true,
                          interactive: true,
                          controller: controller.addRescueScrollController,
                          child: SingleChildScrollView(
                            controller: controller.addRescueScrollController,
                            child: Padding(
                              padding: EdgeInsets.only(right: 15.w),
                              child: Form(
                                key: controller.formKey,
                                child: Column(
                                  children: [
                                    widget.draftId != null
                                        ? controller.selectedRescueDraftData
                                                    .thumbnail !=
                                                null
                                            ? Container(
                                                height: 200.h,
                                                alignment: Alignment.center,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColors.attachCardColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                ),
                                                child: AppNetworkImageLoader(
                                                    url: controller
                                                            .selectedRescueDraftData
                                                            .thumbnail ??
                                                        '',
                                                    height: 200.h,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    boxFit: BoxFit.cover),
                                              )
                                            : (controller
                                                        .selectedImageOrVideo !=
                                                    null)
                                                ? MouseRegion(
                                                    onHover: (_) => setState(
                                                        () => isHovered = true),
                                                    onExit: (_) => setState(
                                                        () =>
                                                            isHovered = false),
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          height: 200.h,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              child:
                                                                  buildImage()),
                                                        ),
                                                        if (isHovered)
                                                          Positioned.fill(
                                                            child: InkWell(
                                                              onTap: () {
                                                                controller
                                                                        .selectedFile =
                                                                    null;
                                                                controller
                                                                        .selectedImageOrVideo =
                                                                    null;
                                                                controller
                                                                    .update();
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .black
                                                                      .withValues(
                                                                          alpha:
                                                                              0.6),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child: Center(
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      const Icon(
                                                                          Icons
                                                                              .delete,
                                                                          color:
                                                                              Colors.red),
                                                                      Gap(5.w),
                                                                      const Text(
                                                                        'Remove File',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.red,
                                                                          fontSize:
                                                                              16,
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.r),
                                                    onTap: () async {
                                                      await controller
                                                          .openVideoOrImageDialog(
                                                              context: context);
                                                      // controller.selectedFile =
                                                      //     await controller.pickFile();
                                                      // controller.update();
                                                    },
                                                    child: Container(
                                                      height: 200.h,
                                                      alignment:
                                                          Alignment.center,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                        color: AppColors
                                                            .attachCardColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.r),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    20.w,
                                                                vertical: 20.h),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Assets.icons
                                                                .icAttachFile
                                                                .svg(
                                                              height: 45.h,
                                                              width: 45.w,
                                                            ),
                                                            Gap(10.w),
                                                            Text(
                                                              'Attach Video/Image',
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
                                                      ),
                                                    ),
                                                  )
                                        : widget.isUser == true
                                            ? Container(
                                                height: 200.h,
                                                alignment: Alignment.center,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColors.attachCardColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                ),
                                                child: AppNetworkImageLoader(
                                                    url: controller
                                                            .selectedRescue
                                                            .thumbnail ??
                                                        '',
                                                    height: 200.h,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    boxFit: BoxFit.cover),
                                              )
                                            : (controller
                                                        .selectedImageOrVideo !=
                                                    null)
                                                ? MouseRegion(
                                                    onHover: (_) => setState(
                                                        () => isHovered = true),
                                                    onExit: (_) => setState(
                                                        () =>
                                                            isHovered = false),
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          height: 160,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              child:
                                                                  buildImage()),
                                                        ),
                                                        if (isHovered)
                                                          Positioned.fill(
                                                            child: InkWell(
                                                              onTap: () {
                                                                controller
                                                                        .selectedImageOrVideo =
                                                                    null;
                                                                controller
                                                                        .selectedImageOrVideoBytes =
                                                                    null;
                                                                controller
                                                                    .update();
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .black
                                                                      .withValues(
                                                                          alpha:
                                                                              0.6),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child: Center(
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      const Icon(
                                                                          Icons
                                                                              .delete,
                                                                          color:
                                                                              Colors.red),
                                                                      Gap(5.w),
                                                                      const Text(
                                                                        'Remove File',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.red,
                                                                          fontSize:
                                                                              16,
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.r),
                                                    onTap: () async {
                                                      await controller
                                                          .openVideoOrImageDialog(
                                                              context: context);
                                                      controller.update();
                                                    },
                                                    child: Container(
                                                      height: 160.h,
                                                      alignment:
                                                          Alignment.center,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                        color: AppColors
                                                            .attachCardColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.r),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    20.w,
                                                                vertical: 20.h),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Assets.icons
                                                                .icAttachFile
                                                                .svg(
                                                              height: 45.h,
                                                              width: 45.w,
                                                            ),
                                                            Gap(10.w),
                                                            Text(
                                                              'Attach File',
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
                                                      ),
                                                    ),
                                                  ),
                                    Gap(20.h),
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Post Category',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                    color: AppColors.white,
                                                    fontWeight:
                                                    FontWeight.w500),
                                              ),
                                              const Gap(8),
                                              DropdownButtonHideUnderline(
                                                child:
                                                DropdownButton2<Categorie>(
                                                  isExpanded: true,
                                                  hint: Text(
                                                    'Select Category',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                      color:
                                                      AppColors.white,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                    ),
                                                  ),
                                                  items:
                                                  controller.eventCategory
                                                      .map(
                                                        (item) =>
                                                        DropdownMenuItem(
                                                          value: item,
                                                          child: Row(
                                                            children: [
                                                              AppImageViewer.showNetworkImage(
                                                                  url: item
                                                                      .eventIcon,
                                                                  height:
                                                                  30.h,
                                                                  width:
                                                                  30.h),
                                                              SizedBox(
                                                                  width:
                                                                  10.w),
                                                              Expanded(
                                                                child: Text(
                                                                  item.eventName ??
                                                                      '',
                                                                  style: Theme.of(
                                                                      context)
                                                                      .textTheme
                                                                      .bodyMedium!
                                                                      .copyWith(
                                                                    color:
                                                                    AppColors.white,
                                                                    fontWeight:
                                                                    FontWeight.w500,
                                                                  ),
                                                                  overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                  )
                                                      .toList(),
                                                  value: controller
                                                      .selectedCategory !=
                                                      null &&
                                                      controller
                                                          .eventCategory
                                                          .contains(controller
                                                          .selectedCategory)
                                                      ? controller
                                                      .selectedCategory
                                                      : null,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      controller
                                                          .selectedCategory =
                                                          value;
                                                    });
                                                  },
                                                  buttonStyleData:
                                                  ButtonStyleData(
                                                    height: 55.h,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: AppColors
                                                            .textFeildBorderColor,
                                                        width: 1.5,
                                                      ),
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          5),
                                                    ),
                                                  ),
                                                  dropdownSearchData:
                                                  DropdownSearchData(
                                                    searchController:
                                                    eventController
                                                        .eventCategoryController,
                                                    searchInnerWidgetHeight: 50,
                                                    searchInnerWidget: Column(
                                                      children: [
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
                                                          child: TextFormField(
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                color: AppColors
                                                                    .white),
                                                            expands: true,
                                                            maxLines: null,
                                                            controller:
                                                            eventController
                                                                .eventCategoryController,
                                                            onChanged: (value) {
                                                              setState(() {});
                                                              update
                                                                  .call(() {});
                                                            },
                                                            decoration:
                                                            InputDecoration(
                                                              isDense: true,
                                                              contentPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                horizontal: 10,
                                                                vertical: 8,
                                                              ),
                                                              hintText:
                                                              'Search for an item...',
                                                              hintStyle:
                                                              const TextStyle(
                                                                  fontSize:
                                                                  12,
                                                                  color: AppColors
                                                                      .white),
                                                              border:
                                                              OutlineInputBorder(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    8),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            NavigatorRoute
                                                                .navigateBack(
                                                                context:
                                                                context);


                                                            showDialog(
                                                                context:
                                                                context,
                                                                builder:
                                                                    (context) {
                                                                  return const AddCategoryDialog(
                                                                    postType: 'rescue',
                                                                  );
                                                                }).then(
                                                                  (value) async {
                                                                log('Category added');
                                                                await controller
                                                                    .getAllCategories(
                                                                    context:
                                                                    context);

                                                                setState(() {});
                                                                update.call(
                                                                        () {});
                                                              },
                                                            );
                                                          },
                                                          child: Container(
                                                            margin:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                8),
                                                            height: 35,
                                                            decoration:
                                                            BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                5,
                                                              ),
                                                              border: Border.all(
                                                                  color: AppColors
                                                                      .grey909090,
                                                                  width: 0.6),
                                                            ),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                              children: [
                                                                const Icon(
                                                                  Icons
                                                                      .add_box_rounded,
                                                                  color: AppColors
                                                                      .grey909090,
                                                                  size: 20,
                                                                ),
                                                                const Gap(7),
                                                                Text(
                                                                  'Add New',
                                                                  style: Theme.of(
                                                                      context)
                                                                      .textTheme
                                                                      .bodyMedium!
                                                                      .copyWith(
                                                                      color: AppColors
                                                                          .white,
                                                                      fontWeight: FontWeight
                                                                          .w500,
                                                                      fontSize:
                                                                      10),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    searchMatchFn:
                                                        (DropdownMenuItem<
                                                        Categorie>
                                                    item,
                                                        String
                                                        searchValue) {
                                                      final category =
                                                          item.value;
                                                      if (category == null ||
                                                          category.eventName ==
                                                              null) {
                                                        return false;
                                                      }

                                                      return category.eventName!
                                                          .toLowerCase()
                                                          .contains(searchValue
                                                          .toLowerCase());
                                                    },
                                                  ),
                                                  dropdownStyleData:
                                                  DropdownStyleData(
                                                    maxHeight: 600.h,
                                                    offset: const Offset(0, -5),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xff3D3D42),
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          5),
                                                    ),
                                                    scrollbarTheme:
                                                    ScrollbarThemeData(
                                                      thumbColor:
                                                      WidgetStateProperty
                                                          .all(AppColors
                                                          .white
                                                          .withValues(
                                                          alpha:
                                                          0.5)),
                                                      radius:
                                                      const Radius.circular(
                                                          5),
                                                      thickness:
                                                      WidgetStateProperty
                                                          .all(4),
                                                    ),
                                                  ),
                                                  menuItemStyleData:
                                                  MenuItemStyleData(
                                                    height: 50.h,
                                                    padding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10.w),
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
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Date & Time",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                    color: AppColors.white,
                                                    fontWeight:
                                                    FontWeight.w500),
                                              ),
                                              Gap(10.h),
                                              InkWell(
                                                onTap: () async {
                                                  controller
                                                      .selectedRescueDate =
                                                      await controller.pickDateTime(
                                                          context,
                                                          initialDate:
                                                          controller
                                                              .selectedRescueDate) ??
                                                          DateTime.now();
                                                  controller.update();
                                                },
                                                child: Container(
                                                  height: 55.h,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.w),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: AppColors
                                                          .textFeildBorderColor,
                                                      width: 1.5,
                                                    ),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        5),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        DateFormat(
                                                            'd MMM, y, h:mm a')
                                                            .format(controller
                                                            .selectedRescueDate),
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
                                                      const Spacer(),
                                                      Assets.icons.icWatch
                                                          .svg(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Gap(20.h),
                                    CommonTextField(
                                      topLabel: "Title",
                                      hintText: "Enter Title",
                                      controller:
                                          controller.rescueTitleController,
                                      validator: (p0) {
                                        if (p0 == null || p0.isEmpty) {
                                          return "Please enter rescue title";
                                        }
                                        return null;
                                      },
                                    ),
                                    Gap(20.h),
                                    CommonTextField(
                                      topLabel: "Name",
                                      hintText: "Enter Name",
                                      controller:
                                          controller.rescueNameController,
                                      validator: (p0) {
                                        if (p0 == null || p0.isEmpty) {
                                          return "Please enter rescue name";
                                        }
                                        return null;
                                      },
                                    ),
                                    Gap(20.h),
                                    CommonTextField(
                                      topLabel: "Description",
                                      hintText: "Enter Description",
                                      controller: controller
                                          .rescueDescriptionController,
                                      validator: (p0) {
                                        if (p0 == null || p0.isEmpty) {
                                          return "Please enter rescue description";
                                        }
                                        return null;
                                      },
                                    ),
                                    Gap(20.h),
                                    CommonTextField(
                                      topLabel: "Location",
                                      hintText: "Enter Location",
                                      controller:
                                          controller.rescueLocationController,
                                      validator: (p0) {
                                        if (p0 == null || p0.isEmpty) {
                                          return "Please enter rescue location";
                                        }
                                        return null;
                                      },
                                    ),
                                    Gap(20.h),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CommonTextField(
                                            topLabel: "Latitude",
                                            hintText: "Enter Latitude",
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d*\.?\d*$')),
                                            ],
                                            controller: controller
                                                .rescueLatitudeController,
                                            validator: (p0) {
                                              if (p0 == null || p0.isEmpty) {
                                                return "Please enter event latitude";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        Gap(15.w),
                                        Expanded(
                                          child: CommonTextField(
                                            topLabel: "Longitude",
                                            hintText: "Enter Longitude",
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d*\.?\d*$')),
                                            ],
                                            controller: controller
                                                .rescueLongitudeController,
                                            validator: (p0) {
                                              if (p0 == null || p0.isEmpty) {
                                                return "Please enter event longitude";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Gap(20.h),
                                    CommonTextField(
                                      inputFormatters: <TextInputFormatter>[
                                        LengthLimitingTextInputFormatter(controller.mobileLength),
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
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    const Icon(Icons.flag,
                                                        size: 24),
                                              );
                                            },
                                            countryListTheme:
                                                CountryListThemeData(
                                              flagSize: 25,
                                              backgroundColor: Colors.white,
                                              textStyle: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.blueGrey),
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              inputDecoration: InputDecoration(
                                                labelText: 'Search',
                                                hintText:
                                                    'Start typing to search',
                                                prefixIcon:
                                                    const Icon(Icons.search),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: const Color(
                                                              0xFF8C98A8)
                                                          .withValues(
                                                              alpha: 0.2)),
                                                ),
                                              ),
                                            ),
                                            onSelect: (Country country) {
                                              controller.countryCode =
                                                  "+${country.phoneCode}";


                                             controller.mobileLength=  AppFunctions.getMobileNumberLength( controller.countryCode);
                                              controller.update();
                                            },
                                          );
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Gap(10),
                                            Text(
                                              controller.countryCode,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium!
                                                  .copyWith(
                                                      color: AppColors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      topLabel: "Mobile Number",
                                      hintText: "Enter Mobile Number",
                                      controller:
                                          controller.rescueMobileNoController,
                                      validator: (p0) {

                                        if (p0 == null || p0.isEmpty) {
                                          return "Please enter rescue mobile number";
                                        }
                                        return null;
                                      },
                                    ),
                                    Gap(20.h),
                                    CommonTextField(
                                      inputFormatters: [
                                        HashtagInputFormatter()
                                      ],
                                      topLabel: "Hashtag",
                                      hintText: "Enter Hashtag",
                                      controller:
                                          controller.rescueHashtagController,
                                      validator: (p0) {
                                        if (p0 == null || p0.isEmpty) {
                                          return "Please enter rescue hashtag";
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Gap(25.h),
                    Row(
                      children: [
                        const Spacer(),
                        widget.isUser == true
                            ? SizedBox(
                                width: 135.w,
                                height: 45.h,
                                child: CommonButton(
                                    color: AppColors.attachCardColor,
                                    radius: 5,
                                    widget: Text(
                                      'Reject',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w400),
                                    ),
                                    onPressed: () async {
                                      NavigatorRoute.navigateBack(context:  context);
                                      await controller
                                          .statusUpdateAPI(
                                          status: 'Rejected',
                                          context: context,
                                          rescueId:
                                          controller.selectedRescue.id ??
                                              '',
                                          isNotify: true);


                                    }),
                              )
                            : const SizedBox(),
                        const Gap(20),
                        SizedBox(
                          width: 135.w,
                          height: 45.h,
                          child: CommonButton(
                              color: AppColors.green,
                              radius: 5,
                              widget: Text(
                                widget.isUser == true? "Accept": 'Post',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w400),
                              ),
                              onPressed: () async {
                                if (widget.draftId != null) {
                                  await controller.updateRescueDraft(
                                      draftId: widget.draftId ?? '',
                                      context: context,
                                      pl: pl,
                                      isUser: widget.isUser);
                                } else {
                                  await controller.createRescue(
                                      context, pl, widget.isUser);
                                }
                              }),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
