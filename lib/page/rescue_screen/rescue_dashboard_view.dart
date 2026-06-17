import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:eagle_eye_admin/controller/app_controller.dart';
import 'package:eagle_eye_admin/controller/rescue_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/page/dashboard_screen/components/header.dart';
import 'package:eagle_eye_admin/page/rescue_screen/component/rescue_draft_screen.dart';
import 'package:eagle_eye_admin/page/rescue_screen/component/rescue_location_and_calender_view.dart';
import 'package:eagle_eye_admin/page/rescue_screen/component/rescue_post_card_view.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/utils/responsive_utils.dart';
import 'package:eagle_eye_admin/widget/textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class RescueDashboardView extends StatefulWidget {
  const RescueDashboardView({super.key});

  @override
  State<RescueDashboardView> createState() => _RescueDashboardViewState();
}

class _RescueDashboardViewState extends State<RescueDashboardView> {
  RescueController controller = Get.put(RescueController());

  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {

    controller.filterRescue.clear();
    controller.pageNumber=1;
    controller.rescueSearchController.clear();
    await controller.getRescueList(context: context);
    await controller.getAllCategories(context: context);
    await controller.getPendingRescueCount(context: context );

  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RescueController>(builder: (controller) {
      return

      controller.selectedSubTab ==2.1?
        Expanded(
        flex: 5,
        child: Stack(
          children: [
            SizedBox(
                height: 500,
                child: FittedBox(child: Image.asset(Assets.image.mapBg.path))),
            Column(
              children: [
                Container(
                  height: 85.h,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.borderColor, width: 3),
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
                            controller: controller.rescueSearchController,
                            onChanged: (value) async {

                              if (controller.debounce?.isActive ?? false) {
                                controller.debounce?.cancel();
                              }
                              controller.debounce =
                                  Timer(const Duration(seconds: 1), () async {
                                    controller.filterRescue.clear();
                                    controller.pageNumber= 1;
                                    await controller.getRescueList(context: context);
                                    controller.update();
                                    setState(() {});
                                  });
                            },
                          ),
                        ),
                      if (!Responsive.isMobile(context))
                        Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
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
                        'Rescue',
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
                          controller.clearRescueData();
                          await controller.openAddRescueDialog(
                              "Create", context);
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
                                const Icon(Icons.add, color: AppColors.white),
                                const Gap(7),
                                Text(
                                  'New Rescue',
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
                                            .finalTotalRescueContainerColor =
                                            AppColors.borderColor;
                                      });

                                      controller.update();
                                    },
                                    onExit: (event) {
                                      setState(
                                            () {
                                          controller
                                              .finalTotalRescueContainerColor =
                                              AppColors.drawerBgColor;
                                        },
                                      );
                                      controller.update();
                                    },
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () async {
                                        setState(() {
                                          controller.selectedContainerValue = 0;
                                        });
                                        controller.pageNumber=1;
                                        controller.filterRescue.clear();
                                        controller.rescueSearchController.clear();
                                        await controller.getRescueList(context: context);
                                        controller.update();
                                      },
                                      child: finalTotalCard(
                                        'Total Rescue',
                                        '${controller.getFilterRescueModel.body?.totalCounts??0}',
                                        controller.selectedContainerValue == 0
                                            ? AppColors.borderColor
                                            : controller
                                            .finalTotalRescueContainerColor,
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
                                            .totalRescueApproveContainerColor =
                                            AppColors.borderColor;
                                      });

                                      controller.update();
                                    },
                                    onExit: (event) {
                                      setState(() {
                                        controller
                                            .totalRescueApproveContainerColor =
                                            AppColors.drawerBgColor;
                                      });
                                      controller.update();
                                    },
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () async {
                                        setState(() {
                                          controller.selectedContainerValue = 1;
                                        });
                                        controller.pageNumber=1;
                                        controller.filterRescue.clear();
                                        controller.rescueSearchController.clear();
                                        await controller.getRescueList(context: context);
                                        controller.update();
                                      },
                                      child: finalTotalCard(
                                          'Total Approved Rescue',
                                          '${controller.getFilterRescueModel.body?.approvedCount??0}',
                                          controller.selectedContainerValue == 1
                                              ? AppColors.borderColor
                                              : controller
                                              .totalRescueApproveContainerColor,
                                          updateValue: "Update(${controller.rescueUpdateCount})"),
                                    ),
                                  ),
                                ),
                                const Gap(10),
                                Expanded(
                                  child: MouseRegion(
                                    onHover: (event) {
                                      setState(() {
                                        controller
                                            .totalRescueDisApproveContainerColor =
                                            AppColors.borderColor;
                                      });

                                      controller.update();
                                    },
                                    onExit: (event) {
                                      setState(() {
                                        controller
                                            .totalRescueDisApproveContainerColor =
                                            AppColors.drawerBgColor;
                                      });
                                      controller.update();
                                    },
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () async {
                                        setState(() {
                                          controller.selectedContainerValue = 2;
                                        });
                                        controller.pageNumber=1;
                                        controller.filterRescue.clear();
                                        controller.rescueSearchController.clear();
                                        await controller.getRescueList(context: context);
                                        controller.update();
                                      },
                                      child: finalTotalCard(
                                        'Total Disapproved Rescue',
                                        '${controller.getFilterRescueModel.body?.rejectedCount??0}',
                                        controller.selectedContainerValue == 2
                                            ? AppColors.borderColor
                                            : controller
                                            .totalRescueDisApproveContainerColor,
                                      ),
                                    ),
                                  ),
                                ),   const Gap(10),

                              ],
                            ),

                            const SizedBox(height: 16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Qued Rescues (${controller.getFilterRescueModel.body?.pendingCount??0})',
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
                                    backgroundColor: AppColors.borderColor,
                                    child: IconButton(
                                      onPressed: () async {
                                        controller.selectedSubTab =2.2;
                                        controller.update();
                                        setState(() {

                                        });
                                      },
                                      icon: const Icon(Icons.drafts,color: Colors.white,),),
                                  ),
                                  const Gap(15),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton2<int>(
                                      customButton: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: AppColors.borderColor,
                                        child: Assets.icons.icFilter.svg(),
                                      ),
                                      buttonStyleData: ButtonStyleData(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50.r),
                                        ),
                                      ),
                                      items: [
                                        DropdownMenuItem<int>(
                                          value: 0,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Text(
                                              "All",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.white,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        DropdownMenuItem<int>(
                                          value: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Text(
                                              "Qued",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.white,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        DropdownMenuItem<int>(
                                          value: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Text(
                                              "Founded",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.white,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        if (value == 0) {
                                          controller.selectedContainerValue = 0;
                                          controller.update();
                                          controller.filterRescue.clear();
                                          controller.pageNumber = 1;
                                          controller.rescueSearchController
                                              .clear();
                                          controller.filterType= null;
                                          controller.getRescueList(context: context);
                                        } else if (value == 1) {
                                          controller.selectedContainerValue = 3;
                                          controller.update();
                                          controller.filterRescue.clear();
                                          controller.pageNumber = 1;
                                          controller.rescueSearchController
                                              .clear();
                                          controller.filterType = "Pending";
                                          controller.getRescueList(
                                              context: context,
                                              filterType: 'Pending');
                                        }
                                        else if (value == 2) {
                                          controller.selectedContainerValue = 1;
                                          controller.update();
                                          controller.filterRescue.clear();
                                          controller.pageNumber = 1;
                                          controller.rescueSearchController
                                              .clear();
                                          controller.getRescueList(
                                              context: context,
                                              filterType: 'Approved',
                                          status: 'Resolved'
                                          );
                                        }
                                      },
                                      dropdownStyleData: DropdownStyleData(
                                        padding: EdgeInsets.zero,
                                        maxHeight: 200.h,
                                        width: 150.w,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: AppColors.textFeildBorderColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withValues(alpha: 0.1),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        offset: const Offset(-60, -2),
                                        elevation: 4,
                                        useRootNavigator: true,
                                        scrollbarTheme: ScrollbarThemeData(
                                          thumbColor: WidgetStateProperty.all(
                                              AppColors.borderColor),
                                          radius: const Radius.circular(20),
                                          thickness: WidgetStateProperty.all(4),
                                        ),
                                      ),
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 10.0),
                                      ),
                                    ),
                                  ),
                                  const Gap(15),
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: AppColors.borderColor,
                                    child: IconButton(
                                        onPressed: () async {
                                          controller.filterRescue.clear();
                                          controller.pageNumber = 1;
                                          controller.rescueSearchController
                                              .clear();
                                          await controller.getRescueList(context: context, filterType:(controller.filterType!= null)? controller.filterType: null);
                                        },
                                        icon: Assets.icons.icRefresh.svg()),
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
                                    : controller.filterRescue.isNotEmpty
                                        ? Expanded(
                                            child: Stack(
                                              children: [
                                                NotificationListener(
                                                  onNotification:
                                                      (notification) {
                                                    if (notification
                                                            is ScrollEndNotification &&
                                                        notification.metrics
                                                                .extentAfter ==
                                                            0) {
                                                      if ((controller
                                                                  .getFilterRescueModel
                                                                  .body
                                                                  ?.page ??
                                                              0) <
                                                          (controller
                                                                  .getFilterRescueModel
                                                                  .body
                                                                  ?.totalPages ??
                                                              0)) {
                                                        controller
                                                            .rescuePagination(
                                                                context);
                                                      }
                                                    }
                                                    return false;
                                                  },
                                                  child: ListView.separated(
                                                    controller: controller
                                                        .dashboardRescueScrollController,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    clipBehavior: Clip.hardEdge,
                                                    physics:
                                                        const AlwaysScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return RescuePostCardView(
                                                        index: index,
                                                        filterRescue: controller
                                                                .filterRescue[
                                                            index],
                                                      );
                                                    },
                                                    separatorBuilder:
                                                        (context, index) =>
                                                            Gap(10.h),
                                                    itemCount: controller
                                                        .filterRescue.length,
                                                  ),
                                                ),
                                                Obx(
                                                  () {
                                                    return controller
                                                            .paginationLoader
                                                            .value
                                                        ?
                                                       const Align(
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                            child:
                                                                LinearProgressIndicator(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )
                                                        : const SizedBox
                                                            .shrink();
                                                  },
                                                ),
                                              ],
                                            ),
                                          )
                                        : Expanded(
                                            child: Center(
                                              child: Text(
                                                'No Event Found',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppColors.white),
                                              ),
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
                          child: RescueLocationAndCalenderView(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ) : const RescueDraftScreen();
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
