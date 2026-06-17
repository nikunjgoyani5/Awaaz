import 'dart:async';

import 'package:eagle_eye_admin/controller/app_controller.dart';
import 'package:eagle_eye_admin/controller/general_controller.dart';

import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/page/dashboard_screen/components/header.dart';
import 'package:eagle_eye_admin/page/general_screen/component/general_card_view.dart';
import 'package:eagle_eye_admin/page/general_screen/component/general_location_and_calender_view.dart';
import 'package:eagle_eye_admin/page/general_screen/general_draft_screen.dart';

import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/utils/responsive_utils.dart';
import 'package:eagle_eye_admin/widget/textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class GeneralDashBoardView extends StatefulWidget {
  const GeneralDashBoardView({super.key});

  @override
  State<GeneralDashBoardView> createState() => _GeneralDashBoardViewState();
}

class _GeneralDashBoardViewState extends State<GeneralDashBoardView> {
  GeneralController controller = Get.put(GeneralController());

  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {
    controller.filterGeneralList.clear();
    controller.pageNumber = 1;
    controller.generalSearchController.clear();
    await controller.getAllCategories(context: context);
    await controller.getGeneralPostList(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (controller) {
      return controller.selectedSubTab == 5.1
          ? Expanded(
              flex: 5,
              child: Stack(
                children: [
                  SizedBox(
                      height: 500,
                      child: FittedBox(
                          child: Image.asset(Assets.image.mapBg.path))),
                  Column(
                    children: [
                      Container(
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
                              SizedBox(
                                height: 60,
                                width: 400,
                                child: CommonTextField(
                                  prefixIcon: SizedBox(
                                      height: 45,
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
                                      controller.generalSearchController,
                                  onChanged: (value) {
                                    if (controller.debounce?.isActive ??
                                        false) {
                                      controller.debounce?.cancel();
                                    }
                                    controller.debounce = Timer(
                                        const Duration(seconds: 1), () async {
                                      controller.filterGeneralList.clear();
                                      controller.pageNumber = 1;
                                      await controller.getGeneralPostList(
                                          context: context);
                                      controller.update();
                                      setState(() {});
                                    });
                                  },
                                ),
                              ),
                            if (!Responsive.isMobile(context))
                              Spacer(
                                  flex: Responsive.isDesktop(context) ? 2 : 1),
                            const ProfileCard()
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'General',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.white),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () async {
                                controller.clearGeneralData();
                                await controller.openAddGeneralDialog(
                                    false, context);
                              },
                              child: Container(
                                  width: 160,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xff1FA9FF),
                                        Color(0xff1C7EFF),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.add,
                                          color: AppColors.white),
                                      const Gap(7),
                                      Text(
                                        'New Post',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      )
                                    ],
                                  )),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Gap(20),
                                      Expanded(
                                        child: MouseRegion(
                                          onHover: (event) {
                                            setState(() {
                                              controller
                                                      .finalTotalGeneralContainerColor =
                                                  AppColors.borderColor;
                                            });

                                            controller.update();
                                          },
                                          onExit: (event) {
                                            setState(
                                              () {
                                                controller
                                                        .finalTotalGeneralContainerColor =
                                                    AppColors.drawerBgColor;
                                              },
                                            );
                                            controller.update();
                                          },
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            onTap: () async {
                                              setState(() {
                                                controller
                                                    .selectedContainerValue = 0;
                                              });
                                              controller.pageNumber = 1;
                                              controller.filterGeneralList
                                                  .clear();
                                              controller.generalSearchController
                                                  .clear();
                                              await controller
                                                  .getGeneralPostList(
                                                      context: context);
                                              controller.update();
                                            },
                                            child: finalTotalCard(
                                              'Total General',
                                              '${controller.getFilterGeneralModel.body?.totalCounts ?? 0}',
                                              controller.selectedContainerValue ==
                                                      0
                                                  ? AppColors.borderColor
                                                  : controller
                                                      .finalTotalGeneralContainerColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Gap(10),
                                      Expanded(
                                        child: MouseRegion(
                                          onHover: (event) {
                                            setState(() {
                                              controller
                                                      .totalGeneralApproveContainerColor =
                                                  AppColors.borderColor;
                                            });

                                            controller.update();
                                          },
                                          onExit: (event) {
                                            setState(() {
                                              controller
                                                      .totalGeneralApproveContainerColor =
                                                  AppColors.drawerBgColor;
                                            });
                                            controller.update();
                                          },
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            onTap: () async {
                                              setState(() {
                                                controller
                                                    .selectedContainerValue = 1;
                                              });
                                              controller.pageNumber = 1;
                                              controller.filterGeneralList
                                                  .clear();
                                              controller.generalSearchController
                                                  .clear();
                                              await controller
                                                  .getGeneralPostList(
                                                      context: context);
                                              controller.update();
                                            },
                                            child: finalTotalCard(
                                              'Total Approved General',
                                              '${controller.getFilterGeneralModel.body?.approvedCount ?? 0}',
                                              controller.selectedContainerValue ==
                                                      1
                                                  ? AppColors.borderColor
                                                  : controller
                                                      .totalGeneralApproveContainerColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Gap(10),
                                      Expanded(
                                        child: MouseRegion(
                                          onHover: (event) {
                                            setState(() {
                                              controller
                                                      .totalGeneralDisApproveContainerColor =
                                                  AppColors.borderColor;
                                            });

                                            controller.update();
                                          },
                                          onExit: (event) {
                                            setState(() {
                                              controller
                                                      .totalGeneralDisApproveContainerColor =
                                                  AppColors.drawerBgColor;
                                            });
                                            controller.update();
                                          },
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            onTap: () async {
                                              setState(() {
                                                controller
                                                    .selectedContainerValue = 2;
                                              });
                                              controller.pageNumber = 1;
                                              controller.filterGeneralList
                                                  .clear();
                                              controller.generalSearchController
                                                  .clear();
                                              await controller
                                                  .getGeneralPostList(
                                                      context: context);
                                              controller.update();
                                            },
                                            child: finalTotalCard(
                                              'Total Disapproved General',
                                              '${controller.getFilterGeneralModel.body?.rejectedCount ?? 0}',
                                              controller.selectedContainerValue ==
                                                      2
                                                  ? AppColors.borderColor
                                                  : controller
                                                      .totalGeneralDisApproveContainerColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Gap(10),
                                    ],
                                  ),

                                  const SizedBox(height: 16),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'All General (${controller.getFilterGeneralModel.body?.totalCounts ?? 0})',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.white),
                                        ),
                                        const Spacer(),
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor:
                                              AppColors.borderColor,
                                          child: IconButton(
                                            onPressed: () async {
                                              controller.selectedSubTab = 5.2;
                                              controller.update();
                                              setState(() {});
                                            },
                                            icon: const Icon(
                                              Icons.drafts,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const Gap(15),
                                        GestureDetector(
                                          onTap: () {
                                            // controller.isDropDownOpen =
                                            //     !controller.isDropDownOpen;
                                            // controller.update();
                                            // setState(() {});
                                            controller.openGeneralFilterDialog(
                                                context);
                                          },
                                          child: CircleAvatar(
                                            radius: 20,
                                            backgroundColor:
                                                AppColors.borderColor,
                                            child: Assets.icons.icFilter.svg(),
                                          ),
                                        ),
                                        const Gap(15),
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor:
                                              AppColors.borderColor,
                                          child: IconButton(
                                              onPressed: () async {
                                                controller.filterGeneralList
                                                    .clear();
                                                controller.pageNumber = 1;
                                                controller
                                                    .generalSearchController
                                                    .clear();
                                                await controller
                                                    .getGeneralPostList(
                                                        context: context);
                                              },
                                              icon:
                                                  Assets.icons.icRefresh.svg()),
                                        )
                                      ],
                                    ),
                                  ),
                                  const Gap(15),

                                  Obx(
                                    () {
                                      return controller.loader.value
                                          ? Expanded(
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: const Wrap(
                                                  children: [
                                                    SizedBox(
                                                      height: 50,
                                                      width: 50,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : controller
                                                  .filterGeneralList.isNotEmpty
                                              ? Expanded(
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
                                                            if ((controller
                                                                        .getFilterGeneralModel
                                                                        .body
                                                                        ?.page ??
                                                                    0) <
                                                                (controller
                                                                        .getFilterGeneralModel
                                                                        .body
                                                                        ?.totalPages ??
                                                                    0)) {
                                                              controller
                                                                  .generalPostPagination(
                                                                      context);
                                                            }
                                                          }
                                                          return false;
                                                        },
                                                        child:
                                                            ListView.separated(
                                                          controller: controller
                                                              .dashboardGeneralScrollController,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          clipBehavior:
                                                              Clip.hardEdge,
                                                          physics:
                                                              const AlwaysScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return GeneralPostCardView(
                                                              index: index,
                                                              filterGeneral:
                                                                  controller
                                                                          .filterGeneralList[
                                                                      index],
                                                            );
                                                          },
                                                          separatorBuilder:
                                                              (context,
                                                                      index) =>
                                                                  Gap(10.h),
                                                          itemCount: controller
                                                              .filterGeneralList
                                                              .length,
                                                        ),
                                                      ),
                                                      Obx(
                                                        () {
                                                          return controller
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
                                                      controller.isDropDownOpen ==
                                                              true
                                                          ? Positioned(
                                                              top: 0,
                                                              right: 50,
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        15),
                                                                width: 180,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                5),
                                                                    color: AppColors
                                                                        .grey2C2C2C),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    ListView
                                                                        .separated(
                                                                      shrinkWrap:
                                                                          true,
                                                                      separatorBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return const SizedBox(
                                                                          height:
                                                                              10,
                                                                        );
                                                                      },
                                                                      itemCount: controller
                                                                          .generalCategory
                                                                          .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            controller.onSelectCategory(controller.generalCategory[index].id ??
                                                                                '');

                                                                            setState(() {});
                                                                          },
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 25,
                                                                                width: 25,
                                                                                child: Checkbox(
                                                                                  checkColor: Colors.white,
                                                                                  activeColor: AppColors.black,
                                                                                  value: controller.selectedFilterCategoryList.contains(controller.generalCategory[index].id),
                                                                                  fillColor: WidgetStateProperty.resolveWith((states) {
                                                                                    if (states.contains(WidgetState.selected)) {
                                                                                      return AppColors.blue;
                                                                                    }
                                                                                    return Colors.transparent;
                                                                                  }),
                                                                                  onChanged: (value) async {
                                                                                    controller.onSelectCategory(controller.generalCategory[index].id ?? '');

                                                                                    setState(() {});
                                                                                  },
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 7,
                                                                              ),
                                                                              Text(
                                                                                controller.generalCategory[index].eventName ?? '',
                                                                                style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w500, color: AppColors.white),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 7,
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        controller.isDropDownOpen =
                                                                            false;
                                                                        controller
                                                                            .filterGeneralList
                                                                            .clear();
                                                                        controller
                                                                            .pageNumber = 1;
                                                                        await controller.getGeneralPostList(
                                                                            context:
                                                                                context);
                                                                        controller
                                                                            .update();
                                                                        setState(
                                                                            () {});
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            35,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              AppColors.blue,
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                            4,
                                                                          ),
                                                                        ),
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            const Text(
                                                                          'Apply',
                                                                          style:
                                                                              TextStyle(color: AppColors.white),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                    ],
                                                  ),
                                                )
                                              : Expanded(
                                                  child: Stack(
                                                    children: [
                                                      Center(
                                                        child: Text(
                                                          'No General Found',
                                                          style: Theme.of(
                                                                  context)
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
                                                      controller.isDropDownOpen ==
                                                              true
                                                          ? Positioned(
                                                              top: 0,
                                                              right: 50,
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        15),
                                                                width: 180,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                5),
                                                                    color: AppColors
                                                                        .grey2C2C2C),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    ListView
                                                                        .separated(
                                                                      shrinkWrap:
                                                                          true,
                                                                      separatorBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return const SizedBox(
                                                                          height:
                                                                              10,
                                                                        );
                                                                      },
                                                                      itemCount: controller
                                                                          .generalCategory
                                                                          .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            controller.onSelectCategory(controller.generalCategory[index].id ??
                                                                                '');

                                                                            setState(() {});
                                                                          },
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 25,
                                                                                width: 25,
                                                                                child: Checkbox(
                                                                                  checkColor: Colors.white,
                                                                                  activeColor: AppColors.black,
                                                                                  value: controller.selectedFilterCategoryList.contains(controller.generalCategory[index].id),
                                                                                  fillColor: WidgetStateProperty.resolveWith((states) {
                                                                                    if (states.contains(WidgetState.selected)) {
                                                                                      return AppColors.blue;
                                                                                    }
                                                                                    return Colors.transparent;
                                                                                  }),
                                                                                  onChanged: (value) async {
                                                                                    controller.onSelectCategory(controller.generalCategory[index].id ?? '');

                                                                                    setState(() {});
                                                                                  },
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 7,
                                                                              ),
                                                                              Text(
                                                                                controller.generalCategory[index].eventName ?? '',
                                                                                style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w500, color: AppColors.white),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 7,
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        controller.isDropDownOpen =
                                                                            false;
                                                                        controller
                                                                            .filterGeneralList
                                                                            .clear();
                                                                        controller
                                                                            .pageNumber = 1;
                                                                        await controller.getGeneralPostList(
                                                                            context:
                                                                                context);
                                                                        controller
                                                                            .update();
                                                                        setState(
                                                                            () {});
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            35,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              AppColors.blue,
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                            4,
                                                                          ),
                                                                        ),
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            const Text(
                                                                          'Apply',
                                                                          style:
                                                                              TextStyle(color: AppColors.white),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                    ],
                                                  ),
                                                );
                                    },
                                  ),
                                  // Expanded(
                                  //   child: Theme(
                                  //     data: ThemeData(
                                  //       scrollbarTheme: ScrollbarThemeData(
                                  //         trackColor: WidgetStateProperty.all(
                                  //             AppColors.textFeildBorderColor
                                  //                 .withValues(alpha:0.5)),
                                  //         thumbColor: WidgetStateProperty.all(
                                  //             AppColors.white.withValues(alpha:0.2)),
                                  //       ),
                                  //     ),
                                  //     child: Scrollbar(
                                  //       radius: const Radius.circular(0),
                                  //       trackVisibility: true,
                                  //       scrollbarOrientation:
                                  //           ScrollbarOrientation.right,
                                  //       thumbVisibility: true,
                                  //       interactive: true,
                                  //       controller: controller
                                  //           .dashboardRescueScrollController,
                                  //       child: ListView.separated(
                                  //         controller: controller
                                  //             .dashboardRescueScrollController,
                                  //         scrollDirection: Axis.vertical,
                                  //         clipBehavior: Clip.hardEdge,
                                  //         physics:
                                  //             const AlwaysScrollableScrollPhysics(),
                                  //         shrinkWrap: true,
                                  //         itemBuilder: (context, index) =>
                                  //             const RescuePostCardView(),
                                  //         separatorBuilder: (context, index) =>
                                  //             Gap(10.h),
                                  //         itemCount: 10,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  Gap(20.h),
                                ],
                              ),
                            ),
                            if (!Responsive.isMobile(context))
                              const SizedBox(width: 16),
                            if (!Responsive.isMobile(context))
                              const Expanded(
                                flex: 2,
                                child: GeneralLocationAndCalenderView(),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : const GeneralDraftScreen();
    });
  }

  Widget finalTotalCard(String title, String value, Color color,
      {String? updateValue}) {
    return Container(
      width: MediaQuery.of(context).size.width / 5.4,
      height: 130,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(color: AppColors.white, fontSize: 16.sp),
                ),
                const Spacer(),
                if (updateValue != null)
                  Row(
                    children: [
                      Assets.icons.icDot.svg(),
                      const Gap(5),
                      Text(
                        updateValue,
                        style: TextStyle(
                            color: AppColors.green,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
              ],
            ),
            Text(
              value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
