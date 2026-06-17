import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:eagle_eye_admin/controller/general_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/model/categories_model.dart';
import 'package:eagle_eye_admin/page/event_screen/component/add_category.dart';

import 'package:eagle_eye_admin/page/event_screen/component/expanded_text_feild.dart';
import 'package:eagle_eye_admin/page/general_screen/component/add_new_subcategory.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';

import 'package:eagle_eye_admin/utils/app_image_viewer.dart';
import 'package:eagle_eye_admin/widget/app_network_image.dart';
import 'package:eagle_eye_admin/widget/button.dart';
import 'package:eagle_eye_admin/widget/common_dialog.dart';

import 'package:eagle_eye_admin/widget/hashtag_formatter.dart';
import 'package:eagle_eye_admin/widget/textfeild.dart';
import 'package:eagle_eye_admin/widget/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AddNewGeneral extends StatefulWidget {
  final bool? isUser;
  final String? draftId;

  const AddNewGeneral({super.key, this.isUser, this.draftId});

  @override
  State<AddNewGeneral> createState() => _AddNewGeneralState();
}

class _AddNewGeneralState extends State<AddNewGeneral> {
  GeneralController controller = Get.put(GeneralController());

  final RegExp hashtagRegExp =
      RegExp(r'^(#\w+)([ ,#\w]*)?$'); // Ensures proper hashtag format
  String formatHashtags(String input) {
    List<String> words =
        input.split(RegExp(r'[ ,]+')).where((word) => word.isNotEmpty).toList();
    return words
        .map((word) => word.startsWith('#') ? word : '#$word')
        .join(', ');
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    await controller.getAllCategories(context: context);

    if (widget.isUser == true && widget.draftId == null) {
      controller.setCreateGeneralData();
    }

    if (widget.draftId != null) {
      controller.setDraftGeneralData();
    }

    setState(() {});
  }

  GlobalKey key = GlobalKey();

  bool isHovered = false;
  bool isHoveredCustom = false;

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
  Widget build(BuildContext context) {
    ProgressLoader pl = ProgressLoader(context, isDismissible: true);
    return GetBuilder<GeneralController>(builder: (controller) {
      return Dialog(
        key: key,
        alignment: Alignment.topCenter,
        insetPadding: EdgeInsets.only(top: 40.h, bottom: 40.h),
        backgroundColor: AppColors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: StatefulBuilder(
          builder: (con, update) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 1536
                    ? MediaQuery.of(context).size.width * 0.30
                    : MediaQuery.of(context).size.width > 1024
                        ? MediaQuery.of(context).size.width * 0.28
                        : MediaQuery.of(context).size.width > 600
                            ? MediaQuery.of(context).size.width * 0.2
                            : MediaQuery.of(context).size.width * 0.1,
              ),
              decoration: BoxDecoration(
                color: AppColors.borderColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            if (widget.isUser == true)
                              CircleAvatar(
                                radius: 19,
                                child: AppNetworkImageLoader(
                                  url: controller
                                          .selectedGeneral.profilePicture ??
                                      '',
                                  boxFit: BoxFit.fill,
                                ),
                              ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                (widget.isUser == false)
                                    ? 'New General'
                                    : controller.selectedGeneral.name ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            if (widget.draftId != null) {
                              NavigatorRoute.navigateBack(context: context);
                            } else if (controller.selectedCategory == null &&
                                controller.selectedSubCategory == null &&
                                controller.selectedImageOrVideo == null &&
                                controller
                                    .generalTitleController.text.isEmpty &&
                                controller.generalDesController.text.isEmpty &&
                                controller.generalLongController.text.isEmpty &&
                                controller
                                    .generalAddressController.text.isEmpty &&
                                controller.generalLatController.text.isEmpty) {
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
                                  controller.createDraftGeneral(
                                      context, pl, widget.isUser ?? false);
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
                    Gap(20.h),
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
                          controller: controller.createGeneralScrollController,
                          child: SingleChildScrollView(
                            controller:
                                controller.createGeneralScrollController,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: widget.draftId != null
                                            ? controller.selectedGeneralDraftData
                                                        .thumbnail !=
                                                    null
                                                ? Container(
                                                    height: 200.h,
                                                    alignment: Alignment.center,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .attachCardColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r),
                                                    ),
                                                    child: AppNetworkImageLoader(
                                                        url: controller
                                                                .selectedGeneralDraftData
                                                                .thumbnail ??
                                                            '',
                                                        height: 200.h,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        boxFit: BoxFit.cover),
                                                  )
                                                : (controller
                                                            .selectedImageOrVideo !=
                                                        null)
                                                    ? MouseRegion(
                                                        onHover: (_) =>
                                                            setState(() =>
                                                                isHovered =
                                                                    true),
                                                        onExit: (_) => setState(
                                                            () => isHovered =
                                                                false),
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              height: 200.h,
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .black,
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
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .black
                                                                          .withValues(
                                                                              alpha: 0.6),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          const Icon(
                                                                              Icons.delete,
                                                                              color: Colors.red),
                                                                          Gap(5
                                                                              .w),
                                                                          const Text(
                                                                            'Remove File',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.red,
                                                                              fontSize: 16,
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
                                                                .circular(8.r),
                                                        onTap: () async {
                                                          await controller
                                                              .openVideoOrImageDialog(
                                                                  context:
                                                                      context);
                                                          // controller.selectedFile =
                                                          //     await controller.pickFile();
                                                          // controller.update();
                                                        },
                                                        child: Container(
                                                          height: 200.h,
                                                          alignment:
                                                              Alignment.center,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
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
                                                            padding: EdgeInsets
                                                                .symmetric(
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
                                                                              FontWeight.w500),
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
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .attachCardColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r),
                                                    ),
                                                    child: AppNetworkImageLoader(
                                                        url: controller
                                                                .selectedGeneral
                                                                .thumbnail ??
                                                            '',
                                                        height: 200.h,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        boxFit: BoxFit.cover),
                                                  )
                                                : (controller
                                                            .selectedImageOrVideo !=
                                                        null)
                                                    ? MouseRegion(
                                                        onHover: (_) =>
                                                            setState(() =>
                                                                isHovered =
                                                                    true),
                                                        onExit: (_) => setState(
                                                            () => isHovered =
                                                                false),
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              height: 200.h,
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .black,
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
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .black
                                                                          .withValues(
                                                                              alpha: 0.6),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          const Icon(
                                                                              Icons.delete,
                                                                              color: Colors.red),
                                                                          Gap(5
                                                                              .w),
                                                                          const Text(
                                                                            'Remove File',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.red,
                                                                              fontSize: 16,
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
                                                                .circular(8.r),
                                                        onTap: () async {
                                                          await controller
                                                              .openVideoOrImageDialog(
                                                                  context:
                                                                      context);
                                                        },
                                                        child: Container(
                                                          height: 200.h,
                                                          alignment:
                                                              Alignment.center,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
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
                                                            padding: EdgeInsets
                                                                .symmetric(
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
                                                                              FontWeight.w500),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                      ),
                                    ],
                                  ),
                                  Gap(20.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Category',
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
                                              child: DropdownButton2<Categorie>(
                                                isExpanded: true,
                                                hint: Text(
                                                  'Select Category',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        color: AppColors.white,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                ),
                                                items: controller
                                                    .generalCategory
                                                    .map(
                                                      (item) =>
                                                          DropdownMenuItem(
                                                        value: item,
                                                        child: Row(
                                                          children: [
                                                            AppImageViewer
                                                                .showNetworkImage(
                                                                    url: item
                                                                        .eventIcon,
                                                                    height:
                                                                        30.h,
                                                                    width:
                                                                        30.h),
                                                            SizedBox(
                                                                width: 10.w),
                                                            Text(
                                                              item.eventName ??
                                                                  '',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                    color: AppColors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
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
                                                            .generalCategory
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

                                                    if (value?.subCategories !=
                                                        null) {
                                                      controller.subCategoryList
                                                          .clear();
                                                      controller.subCategoryList
                                                          .addAll(value!
                                                              .subCategories!);
                                                    }
                                                    controller
                                                            .isSubCategoryOpen =
                                                        false;
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
                                                  searchController: controller
                                                      .generalCategoryController,
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
                                                          controller: controller
                                                              .generalCategoryController,
                                                          onChanged: (value) {
                                                            setState(() {});
                                                            update.call(() {});
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
                                                                'Search Category Name...',
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
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return const AddCategoryDialog(
                                                                  postType:
                                                                      'general_category',
                                                                );
                                                              }).then(
                                                            (value) async {
                                                              await controller
                                                                  .getAllCategories(
                                                                      context:
                                                                          context);

                                                              setState(() {});
                                                              update
                                                                  .call(() {});
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
                                                          alignment:
                                                              Alignment.center,
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
                                                                        fontWeight:
                                                                            FontWeight
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
                                                          String searchValue) {
                                                    final category = item.value;
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
                                                    color:
                                                        const Color(0xff3D3D42),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  scrollbarTheme:
                                                      ScrollbarThemeData(
                                                    thumbColor:
                                                        WidgetStateProperty.all(
                                                            AppColors.white
                                                                .withValues(
                                                                    alpha:
                                                                        0.5)),
                                                    radius:
                                                        const Radius.circular(
                                                            5),
                                                    thickness:
                                                        WidgetStateProperty.all(
                                                            4),
                                                  ),
                                                ),
                                                menuItemStyleData:
                                                    MenuItemStyleData(
                                                  height: 50.h,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.w),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Gap(20.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Sub Category',
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
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (controller.subCategoryList
                                                      .isEmpty) {
                                                    controller
                                                            .isSubCategoryOpen =
                                                        !controller
                                                            .isSubCategoryOpen;
                                                    controller.update();
                                                    update.call(() {});
                                                    setState(() {});
                                                  }
                                                },
                                                child: DropdownButton2<
                                                    SubCategory>(
                                                  isExpanded: true,
                                                  hint: Text(
                                                    'Select Sub Category',
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
                                                      controller.subCategoryList
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
                                                                  Text(
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
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                          .toList(),
                                                  value: controller
                                                                  .selectedSubCategory !=
                                                              null &&
                                                          controller
                                                              .subCategoryList
                                                              .contains(controller
                                                                  .selectedSubCategory)
                                                      ? controller
                                                          .selectedSubCategory
                                                      : null,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      controller
                                                              .selectedSubCategory =
                                                          value;
                                                      controller
                                                              .isSubCategoryOpen =
                                                          false;
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
                                                    searchController: controller
                                                        .generalCategoryController,
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
                                                            controller: controller
                                                                .generalCategoryController,
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
                                                                  'Search Category Name...',
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
                                                            if (controller
                                                                    .selectedCategory !=
                                                                null) {
                                                              NavigatorRoute
                                                                  .navigateBack(
                                                                      context:
                                                                          context);
                                                              controller
                                                                      .subCategoryIcon =
                                                                  null;
                                                              controller
                                                                      .subCategoryIconBytes =
                                                                  null;
                                                              controller
                                                                  .subCategoryNameController
                                                                  .clear();

                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return const AddNewSubCategory();
                                                                  }).then(
                                                                (value) async {
                                                                  setState(
                                                                      () {});
                                                                  update.call(
                                                                      () {});
                                                                },
                                                              );
                                                            } else {
                                                              showToast(
                                                                  context:
                                                                      context,
                                                                  title:
                                                                      'Sub category',
                                                                  message:
                                                                      'Please select category first',
                                                                  bgColor:
                                                                      AppColors
                                                                          .red);
                                                            }
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
                                                                      .attachCardColor,
                                                                  size: 20,
                                                                ),
                                                                const Gap(7),
                                                                Text(
                                                                  'Add New subcategory',
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
                                                                    SubCategory>
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
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Gap(15.h),
                                  Stack(
                                    children: [
                                      Column(
                                        children: [
                                          CommonTextField(
                                            topLabel: "Title",
                                            hintText: "Enter Title",
                                            controller: controller
                                                .generalTitleController,
                                            validator: (p0) {
                                              if (p0 == null || p0.isEmpty) {
                                                return "Please enter event title";
                                              }
                                              return null;
                                            },
                                          ),
                                          Gap(15.h),
                                        ],
                                      ),
                                      controller.isSubCategoryOpen == true
                                          ? Container(
                                              height: 70,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  8,
                                                ),
                                                color: AppColors.grey2C2C2C,
                                              ),
                                              alignment: Alignment.center,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (controller
                                                              .selectedCategory !=
                                                          null) {
                                                        controller
                                                                .isSubCategoryOpen =
                                                            false;
                                                        controller.update();
                                                        update.call(() {});
                                                        setState(() {});
                                                        controller
                                                                .subCategoryIcon =
                                                            null;
                                                        controller
                                                                .subCategoryIconBytes =
                                                            null;
                                                        controller
                                                            .subCategoryNameController
                                                            .clear();

                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return const AddNewSubCategory();
                                                            }).then(
                                                          (value) async {
                                                            setState(() {});
                                                            update.call(() {});
                                                          },
                                                        );
                                                      } else {
                                                        showToast(
                                                            context: context,
                                                            title:
                                                                'Sub category',
                                                            message:
                                                                'Please select category first',
                                                            bgColor:
                                                                AppColors.red);
                                                      }
                                                    },
                                                    child: Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8),
                                                      height: 35,
                                                      decoration: BoxDecoration(
                                                        color: AppColors
                                                            .borderColor,
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
                                                      alignment:
                                                          Alignment.center,
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
                                                            'Add New subcategory',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .copyWith(
                                                                    color: AppColors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
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
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                  Text(
                                    "Description",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w500),
                                  ),
                                  const Gap(8),
                                  ExpandedTextField(
                                    child: TextFormField(
                                      controller:
                                          controller.generalDesController,

                                      maxLines: 100,

                                      cursorColor: AppColors.white,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(color: AppColors.white),
                                      decoration: InputDecoration(
                                        // fillColor: fillColor,
                                        // filled: fillColor != null ? true : false,
                                        counter: const SizedBox.shrink(),
                                        // prefixIcon: prefixIcon,
                                        // suffixIcon: suffixIcon,
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                AppColors.textFeildBorderColor,
                                            width: 1.5,
                                          ),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                AppColors.textFeildBorderColor,
                                            width: 1.5,
                                          ),
                                        ),
                                        errorStyle: const TextStyle(
                                            height: 0, color: AppColors.red),
                                        errorBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.red,
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
                                          ),
                                        ),
                                        hintText: 'Enter Description',
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(
                                                color: AppColors.grey929da9),
                                      ),
                                      // maxLines: 100,
                                    ),
                                  ),
                                  Gap(15.h),
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
                                          controller:
                                              controller.generalLatController,
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
                                          controller:
                                              controller.generalLongController,
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
                                  Gap(15.h),
                                  CommonTextField(
                                    topLabel: "Address",
                                    hintText: "Enter Address",
                                    controller:
                                        controller.generalAddressController,
                                    // validator: (p0) {
                                    //   if (p0 == null || p0.isEmpty) {
                                    //     return "Please enter event Address";
                                    //   }
                                    //   return null;
                                    // },
                                  ),
                                  Gap(15.h),
                                  CommonTextField(
                                    topLabel: "Hashtag",
                                    hintText:
                                        "Enter #Hashtags Separated by Space",
                                    controller:
                                        controller.generalHashController,
                                    inputFormatters: [HashtagInputFormatter()],
                                  ),
                                  Gap(15.h),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      // SizedBox(
                                      //     width: MediaQuery.of(context)
                                      //             .size
                                      //             .width *
                                      //         0.18,
                                      //     child: Column(
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.start,
                                      //       crossAxisAlignment:
                                      //           CrossAxisAlignment.start,
                                      //       children: [
                                      //         Text(
                                      //           "Start Date",
                                      //           style: Theme.of(context)
                                      //               .textTheme
                                      //               .bodyMedium!
                                      //               .copyWith(
                                      //                   color: AppColors.white,
                                      //                   fontWeight:
                                      //                       FontWeight.w500),
                                      //         ),
                                      //         Gap(10.h),
                                      //         InkWell(
                                      //           onTap: () async {
                                      //             // controller.selectedTime =
                                      //             //     await controller.pickTime(
                                      //             //         context,
                                      //             //         selectedTime: controller
                                      //             //             .selectedTime);
                                      //             //
                                      //             // DateTime now = DateTime.now();
                                      //             // DateTime timeOfDay = DateTime(
                                      //             //     now.year,
                                      //             //     now.month,
                                      //             //     now.day,
                                      //             //     controller.selectedTime!.hour,
                                      //             //     controller
                                      //             //         .selectedTime!.minute);
                                      //             // DateFormat formatter =
                                      //             //     DateFormat('hh:mm a');
                                      //             // controller.timeDataInString =
                                      //             //     formatter.format(timeOfDay);
                                      //             // setState(() {});
                                      //
                                      //             controller.pickDate(context);
                                      //           },
                                      //           child: Container(
                                      //             height: 55.h,
                                      //             padding: EdgeInsets.symmetric(
                                      //                 horizontal: 10.w),
                                      //             decoration: BoxDecoration(
                                      //               border: Border.all(
                                      //                 color: AppColors
                                      //                     .textFeildBorderColor,
                                      //                 width: 1.5,
                                      //               ),
                                      //               borderRadius:
                                      //                   BorderRadius.circular(
                                      //                       5),
                                      //             ),
                                      //             child: Row(
                                      //               children: [
                                      //                 Text(
                                      //                   controller.formatDateData(
                                      //                       controller
                                      //                           .selectedDateTime),
                                      //                   style: Theme.of(context)
                                      //                       .textTheme
                                      //                       .bodyMedium!
                                      //                       .copyWith(
                                      //                           color: AppColors
                                      //                               .white,
                                      //                           fontWeight:
                                      //                               FontWeight
                                      //                                   .w500),
                                      //                 ),
                                      //                 const Spacer(),
                                      //                 Assets.icons.icWatch
                                      //                     .svg(),
                                      //               ],
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     )),
                                      // Gap(20.w),
                                      Row(
                                        children: [
                                          SizedBox(
                                              child: Row(
                                            children: [
                                              Checkbox(
                                                checkColor: AppColors.white,
                                                activeColor: AppColors.blue,
                                                value: controller
                                                    .isGeneralSensitive,
                                                onChanged: (value) {
                                                  setState(() {
                                                    controller
                                                            .isGeneralSensitive =
                                                        value ?? false;
                                                  });
                                                  controller.update();
                                                },
                                              ),
                                              Gap(10.w),
                                              Text(
                                                "Sensitive Content",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall!
                                                    .copyWith(
                                                        color: AppColors.white,
                                                        fontWeight:
                                                            FontWeight.w500),
                                              ),
                                            ],
                                          )),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Gap(25.h),
                    widget.isUser == true
                        ? Row(
                            children: [
                              const Spacer(),
                              SizedBox(
                                width: 135.w,
                                height: 48.h,
                                child: CommonButton(
                                  color: AppColors.attachCardColor,
                                  radius: 5,
                                  widget: Text(
                                    'Reject',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w500),
                                  ),
                                  onPressed: () async {
                                    NavigatorRoute.navigateBack(
                                        context: context);
                                    await controller.statusUpdateAPI(
                                        status: 'Rejected',
                                        context: context,
                                        postId:
                                            controller.selectedGeneral.id ?? '',
                                        isNotify: true);
                                  },
                                ),
                              ),
                              const Gap(20),
                              SizedBox(
                                width: 135.w,
                                height: 48.h,
                                child: CommonButton(
                                  color: AppColors.green,
                                  radius: 5,
                                  widget: Text(
                                    'Accept',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w500),
                                  ),
                                  onPressed: () async {
                                    await controller.createNewGeneral(
                                        context, pl, widget.isUser ?? false);
                                  },
                                ),
                              )
                            ],
                          )
                        : Row(
                            children: [
                              const Spacer(),
                              SizedBox(
                                width: 135.w,
                                height: 40.h,
                                child: CommonButton(
                                  color: AppColors.green,
                                  radius: 5,
                                  widget: Text(
                                    'Post',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w500),
                                  ),
                                  onPressed: () async {
                                    if (widget.draftId != null) {
                                      await controller.updateGeneralDraft(
                                        draftId: widget.draftId ?? '',
                                        context: context,
                                        pl: pl,
                                      );
                                    } else {
                                      await controller.createNewGeneral(
                                          context, pl, widget.isUser ?? false);
                                    }
                                  },
                                ),
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
