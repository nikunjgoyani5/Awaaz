import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:eagle_eye_admin/controller/app_controller.dart';
import 'package:eagle_eye_admin/controller/event_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/page/dashboard_screen/components/header.dart';
import 'package:eagle_eye_admin/page/event_screen/component/event_location_and_calender_view.dart';
import 'package:eagle_eye_admin/page/event_screen/component/event_post_card_view.dart';
import 'package:eagle_eye_admin/page/event_screen/event_draft_screen.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/utils/responsive_utils.dart';
import 'package:eagle_eye_admin/widget/textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EventDashboardView extends StatefulWidget {
  const EventDashboardView({super.key});

  @override
  State<EventDashboardView> createState() => _EventDashboardViewState();
}

class _EventDashboardViewState extends State<EventDashboardView> {
  EventController eventController = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventController>(initState: (state) async {
      eventController.filterEvents.clear();
      eventController.pageNumber=1;
      eventController.eventSearchController.clear();
      await eventController.getEventsList(context: context);
      await eventController.getAllReactions(context: context);
      await eventController.getAllCategories(context: context);
    }, builder: (controller) {
      return
        eventController.selectedSubTab ==1.1
             ?
        Expanded(
        flex: 5,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    Assets.image.mapBg.path,
                  ),
                  fit: BoxFit.contain)),
          child: Column(
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
                              height: 48,
                              width: 50,
                              child: Padding(
                                padding: const EdgeInsets.all(13),
                                child: Assets.icons.icSearch.svg(),
                              )),
                          height: 45,
                          fillColor: AppColors.borderColor,
                          enableBorderColor: AppColors.borderColor,
                          hintText: "Search",
                          controller: controller.eventSearchController,
                          onChanged: (value) async {
                            if (controller.debounce?.isActive ?? false) {
                              controller.debounce?.cancel();
                            }
                            controller.debounce =
                                Timer(const Duration(seconds: 1), () async {
                                  controller.filterEvents.clear();
                                  controller.pageNumber= 1;
                                  await controller.getEventsList(context: context);
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
              // ElevatedButton(onPressed: () {
              //   Get.offAll(() => VideoUploadScreen());
              // }, child: Text('Done')),
              // const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Event',
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

                        controller.clearEventData();

                        await controller.openAddEventDialog("Create",context);
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
                                'New Event',
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

                          Row(children: [
                            const Gap(20),
                            Expanded(child:  MouseRegion(
                              onHover: (event) {
                                setState(() {
                                  controller.finalTotalEventContainerColor =
                                      AppColors.borderColor;
                                });

                                controller.update();
                              },
                              onExit: (event) {
                                setState(
                                      () {
                                    controller
                                        .finalTotalEventContainerColor =
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
                                  controller.filterEvents.clear();
                                  controller.pageNumber = 1;
                                  controller.eventSearchController.clear();
                                  await controller.getEventsList(context: context);
                                  controller.update();
                                },
                                child: finalTotalCard(
                                  'Total Post',
                                  controller.getFilterEventModel.body
                                      ?.totalCounts
                                      ?.toString() ??
                                      '0',
                                  controller.selectedContainerValue == 0
                                      ? AppColors.borderColor
                                      : controller
                                      .finalTotalEventContainerColor,
                                ),
                              ),
                            ),),
                            const Gap(10),
                            Expanded(
                              child: MouseRegion(
                                onHover: (event) {
                                  setState(() {
                                    controller
                                        .totalEventApproveContainerColor =
                                        AppColors.borderColor;
                                  });

                                  controller.update();
                                },
                                onExit: (event) {
                                  setState(() {
                                    controller
                                        .totalEventApproveContainerColor =
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
                                    controller.filterEvents.clear();
                                    controller.pageNumber = 1;
                                    controller.eventSearchController.clear();
                                    await controller.getEventsList(context: context);

                                    controller.update();
                                  },
                                  child: finalTotalCard(
                                    'Total Approved Events',
                                    controller.getFilterEventModel.body
                                        ?.approvedCount
                                        ?.toString() ??
                                        '0',
                                    controller.selectedContainerValue == 1
                                        ? AppColors.borderColor
                                        : controller
                                        .totalEventApproveContainerColor,
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
                                        .totalEventDisApproveContainerColor =
                                        AppColors.borderColor;
                                  });

                                  controller.update();
                                },
                                onExit: (event) {
                                  setState(() {
                                    controller
                                        .totalEventDisApproveContainerColor =
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
                                    controller.filterEvents.clear();
                                    controller.pageNumber = 1;
                                    controller.eventSearchController.clear();
                                    await controller.getEventsList(context: context
                                    );

                                    controller.update();
                                  },
                                  child: finalTotalCard(
                                    'Total Disapproved Posts',
                                    controller.getFilterEventModel.body
                                        ?.rejectedCount
                                        ?.toString() ??
                                        '0',
                                    controller.selectedContainerValue == 2
                                        ? AppColors.borderColor
                                        : controller
                                        .totalEventDisApproveContainerColor,
                                  ),
                                ),
                              ),
                            ),
                            const Gap(20),
                          ],),


                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Qued Events (${controller.getFilterEventModel.body?.pendingCount??0})',
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
                                        eventController.selectedSubTab =1.2;
                                        eventController.update();
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

                                    ],
                                    onChanged: (value) {
                                      if (value == 0) {
                                        controller.selectedContainerValue = 0;
                                        controller.update();
                                        controller.filterEvents.clear();
                                        controller.pageNumber = 1;
                                        controller.eventSearchController
                                            .clear();
                                        controller.filterType= null;
                                        controller.getEventsList(context: context);
                                      } else if (value == 1) {
                                        controller.selectedContainerValue = 3;
                                        controller.update();
                                        controller.filterEvents.clear();
                                        controller.pageNumber = 1;
                                        controller.eventSearchController
                                            .clear();
                                        controller.getEventsList(
                                           context: context,
                                            filterType: 'Pending');
                                        controller.filterType = "Pending";
                                      }
                                    },
                                    dropdownStyleData: DropdownStyleData(
                                      padding: EdgeInsets.zero,
                                      maxHeight: 200.h,
                                      width: 120.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: AppColors.textFeildBorderColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withValues(alpha:0.1),
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
                                    menuItemStyleData: const MenuItemStyleData(
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
                                        controller.filterEvents.clear();
                                        controller.pageNumber = 1;
                                        controller.eventSearchController
                                            .clear();
                                        await controller.getEventsList(context: context,filterType:(controller.filterType!= null)? controller.filterType: null);
                                      },
                                      icon: Assets.icons.icRefresh.svg()),
                                )
                              ],
                            ),
                          ),
                          const Gap(15),
                          Obx(
                            () {
                              return /*eventController
                                      .eventSearchController.text.isNotEmpty
                                  ? eventController.searchedEvents.isNotEmpty
                                      ? Expanded(
                                          child: ListView.separated(
                                            controller: controller
                                                .dashboardEventScrollController,
                                            scrollDirection: Axis.vertical,
                                            clipBehavior: Clip.hardEdge,
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return EventPostCardView(
                                                index: index,
                                                event: eventController
                                                    .searchedEvents[index],
                                              );
                                            },
                                            separatorBuilder:
                                                (context, index) => Gap(10.h),
                                            itemCount: eventController
                                                .searchedEvents.length,
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
                                        )
                                  : */
                              eventController.loader.value
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
                                      : eventController.filterEvents.isNotEmpty
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
                                                                    .getFilterEventModel
                                                                    .body
                                                                    ?.page ??
                                                                0) <
                                                            (controller
                                                                    .getFilterEventModel
                                                                    .body
                                                                    ?.totalPages ??
                                                                0)) {
                                                          controller
                                                              .eventPagination(context);
                                                        }
                                                      }
                                                      return false;
                                                    },
                                                    child: ListView.separated(
                                                      controller: controller
                                                          .dashboardEventScrollController,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      physics:
                                                          const AlwaysScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return EventPostCardView(
                                                          event: eventController
                                                                  .filterEvents[
                                                              index],
                                                          index: index,
                                                        );
                                                      },
                                                      separatorBuilder:
                                                          (context, index) =>
                                                              Gap(10.h),
                                                      itemCount: eventController
                                                          .filterEvents.length,
                                                    ),
                                                  ),
                                                  Obx(
                                                    () {
                                                      return controller
                                                              .paginationLoader
                                                              .value
                                                          ? const Align(
                                                              alignment: Alignment
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
                                                          color:
                                                              AppColors.white),
                                                ),
                                              ),
                                            );
                            },
                          ),
                          Gap(20.h),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      const SizedBox(width: 16),
                    if (!Responsive.isMobile(context))
                      const Expanded(
                        flex: 2,
                        child: EventLocationAndCalenderView(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ):
        const EventDraftScreen();
    });
  }

  Widget finalTotalCard(String title, String value, Color color) {
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
            Text(
              title,
              style: const TextStyle(color: AppColors.white, fontSize: 14),
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
