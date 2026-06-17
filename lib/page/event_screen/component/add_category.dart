import 'dart:developer';

import 'package:dio/dio.dart' as test;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:eagle_eye_admin/api/repository/reaction_and_category_repository.dart';
import 'package:eagle_eye_admin/controller/event_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/model/categories_model.dart';
import 'package:eagle_eye_admin/model/response_model.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/utils/app_image_viewer.dart';
import 'package:eagle_eye_admin/widget/button.dart';
import 'package:eagle_eye_admin/widget/dailoges.dart';
import 'package:eagle_eye_admin/widget/textfeild.dart';
import 'package:eagle_eye_admin/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({super.key, required this.postType});

  final String postType;

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  bool isHovered = false;

  XFile? categoryIcon;

  Uint8List? categoryIconBytes;

  GlobalKey<FormState> categoryFormKey = GlobalKey();
  TextEditingController eventCategoryNameController = TextEditingController();
  TextEditingController eventSubCategoryController = TextEditingController();

  Categorie? selectedSubcategory;

  List<Categorie> eventCategory = [];

  createCategory(
      BuildContext context, ProgressLoader pl, String postType) async {
    if (selectedSubcategory == null) {
      showToast(
          context: context,
          title: 'Category!',
          message: 'Please select sub category',
          bgColor: AppColors.red);
      return;
    } else if (categoryIcon == null) {
      showToast(
          context: context,
          title: 'Category!',
          message: 'Please select attachment',
          bgColor: AppColors.red);
      return;
    } else if (categoryFormKey.currentState?.validate() == true) {
      try {
        await pl.show();
        Uint8List? attachmentByte;
        if (categoryIcon != null) {
          attachmentByte = await categoryIcon!.readAsBytes();
        }

        var data = {
          'eventName': eventCategoryNameController.text,
          if (categoryIcon != null)
            'eventIcon': test.MultipartFile.fromBytes(
              attachmentByte ?? Uint8List(0),
              filename: categoryIcon!.name,
            ),
          'notificationCategotyName':
              selectedSubcategory?.notificationCategotyName ?? '',
          'postType': postType
        };

        ResponseModel res = await ReactionAndCategoryRepository.createCategory(
            context: context, data: data);
        await pl.hide();
        if (res.status == true) {
          NavigatorRoute.navigateBack(context: context);

          showToast(context: context, title: 'Success', message: res.message);

          setState(() {});
        } else {
          showToast(
              context: context,
              title: 'Error',
              message: res.message,
              bgColor: AppColors.red);
        }
      } catch (e) {
        await pl.hide();
        log('Create Category :- $e');
      }
    }
  }

  init() async {
    await getAllCategories(context: context);
  }

  getAllCategories({
    required BuildContext context,
  }) async {
    try {
      ResponseModel res = await ReactionAndCategoryRepository.getAllCategories(
          postType: widget.postType, context: context);
      if (res.status == true) {
        CategoriesModel categoriesModel =
            CategoriesModel.fromJson(res.toJson());
        eventCategory.clear();
        eventCategory.addAll(categoriesModel.body!);
        setState(() {});
      } else {
        log('Get All Categories :- ${res.message}');
      }
    } catch (e) {
      log('Get All Categories :- $e');
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProgressLoader pl = ProgressLoader(context, isDismissible: true);
    return Dialog(
      alignment: Alignment.topCenter,
      insetPadding: EdgeInsets.only(top: 40.h, bottom: 40.h),
      backgroundColor: AppColors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: StatefulBuilder(
        builder: (con, update) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
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
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Form(
              key: categoryFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        "Create Category",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.white),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          NavigatorRoute.navigateBack(context: context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  Gap(20.h),
                  Text(
                    'Category Icon',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.white, fontWeight: FontWeight.w500),
                  ),
                  Gap(10.h),
                  (categoryIconBytes != null)
                      ? MouseRegion(
                          onHover: (_) => setState(() => isHovered = true),
                          onExit: (_) => setState(() => isHovered = false),
                          child: Stack(
                            children: [
                              Container(
                                height: 280.h,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(
                                    categoryIconBytes!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              if (isHovered)
                                Positioned.fill(
                                  child: InkWell(
                                    onTap: () {
                                      categoryIcon = null;
                                      categoryIconBytes = null;
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.black.withValues(alpha: 0.6),
                                        borderRadius: BorderRadius.circular(8),
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
                            showDialog(
                              context: context,
                              builder: (context) {
                                return PhotoOrVideoOptionDailoge(
                                  isVideoHide: true,
                                  onPhotoTap: () async {
                                    categoryIcon =
                                        await Get.find<EventController>()
                                            .pickMedia(MediaType.image);
                                    categoryIconBytes =
                                        await categoryIcon!.readAsBytes();

                                    setState(() {});
                                    NavigatorRoute.navigateBack(
                                        context: context);
                                  },
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 280.h,
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                  Text(
                    'Category Name',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.white, fontWeight: FontWeight.w500),
                  ),
                  Gap(10.h),
                  CommonTextField(
                      hintText: 'Enter Category Name',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter category name !';
                        }
                        return null;
                      },
                      controller: eventCategoryNameController),
                  Gap(20.h),
                  Text(
                    'Post Category',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.white, fontWeight: FontWeight.w500),
                  ),
                  const Gap(8),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<Categorie>(
                      isExpanded: true,
                      hint: Text(
                        'Select Category',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                      items: eventCategory
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Row(
                                children: [
                                  AppImageViewer.showNetworkImage(
                                      url: item.eventIcon,
                                      height: 30.h,
                                      width: 30.h),
                                  SizedBox(width: 10.w),
                                  Text(
                                    item.eventName ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      value: selectedSubcategory != null &&
                              eventCategory.contains(selectedSubcategory)
                          ? selectedSubcategory
                          : null,
                      onChanged: (value) {
                        setState(() {
                          selectedSubcategory = value;
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
                      dropdownSearchData: DropdownSearchData(
                        searchController: eventSubCategoryController,
                        searchInnerWidgetHeight: 50,
                        searchInnerWidget: Column(
                          children: [
                            Container(
                              height: 50,
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 4,
                                right: 8,
                                left: 8,
                              ),
                              child: TextFormField(
                                style: const TextStyle(
                                    fontSize: 12, color: AppColors.white),
                                expands: true,
                                maxLines: null,
                                controller: eventSubCategoryController,
                                onChanged: (value) {
                                  setState(() {});
                                  update.call(() {});
                                },
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  hintText: 'Search for an item...',
                                  hintStyle: const TextStyle(
                                      fontSize: 12, color: AppColors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        searchMatchFn: (DropdownMenuItem<Categorie> item,
                            String searchValue) {
                          final category = item.value;
                          if (category == null || category.eventName == null) {
                            return false;
                          }

                          return category.eventName!
                              .toLowerCase()
                              .contains(searchValue.toLowerCase());
                        },
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
                        height: 50.h,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                      ),
                    ),
                  ),
                  const Gap(20),
                  Row(
                    children: [
                      const Spacer(),
                      SizedBox(
                        width: 135.w,
                        height: 40.h,
                        child: CommonButton(
                          color: AppColors.green,
                          radius: 5,
                          widget: Text(
                            'Create',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w500),
                          ),
                          onPressed: () async {
                            await createCategory(context, pl, widget.postType);
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
  }
}
