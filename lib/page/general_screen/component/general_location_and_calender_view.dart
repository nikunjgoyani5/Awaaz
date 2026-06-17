import 'dart:developer';

import 'package:eagle_eye_admin/controller/dashboard_controller.dart';
import 'package:eagle_eye_admin/controller/general_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/page/dashboard_screen/components/select_distance_dialog.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/service/storage/storage_service.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class GeneralLocationAndCalenderView extends StatefulWidget {
  const GeneralLocationAndCalenderView({super.key});

  @override
  State<GeneralLocationAndCalenderView> createState() =>
      _GeneralLocationAndCalenderViewState();
}

class _GeneralLocationAndCalenderViewState
    extends State<GeneralLocationAndCalenderView> {
  GeneralController controller = Get.put(GeneralController());
  DashboardController dashboardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (controller) {
      return Padding(
        padding: EdgeInsets.only(right: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async {
                      controller.isFilter = !controller.isFilter;
                      controller.update();
                      controller.filterGeneralList.clear();
                      controller.pageNumber = 1;
                      controller.generalSearchController.clear();
                      await controller.getGeneralPostList(context: context);
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.drawerBgColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 7),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Filter',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            const Gap(5),
                            Checkbox(
                              checkColor: Colors.black,
                              activeColor: AppColors.black,
                              value: controller.isFilter,
                              fillColor:
                              WidgetStateProperty.resolveWith((states) {
                                if (states.contains(WidgetState.selected)) {
                                  return AppColors.white;
                                }
                                return Colors.transparent;
                              }),
                              onChanged: (value) async {
                                controller.isFilter = value!;
                                controller.update();
                                controller.filterGeneralList.clear();
                                controller.pageNumber = 1;
                                controller.generalSearchController.clear();
                                await controller.getGeneralPostList(
                                    context: context);
                              },
                            ),
                            const Gap(
                              10,
                            ),
                            Tooltip(
                              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.8,right: 20),

                              message:                   "When this filter is selected, then only the entered location & specific date's general post data will be shown in dashboard.",
                              textAlign: TextAlign.center,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                  fontSize: 15.w,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                              child: Container(
                                height: 25,
                                width: 25,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    color: Colors.white24,
                                    shape: BoxShape.circle),
                                child: const Icon(
                                  Icons.question_mark,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(10),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.drawerBgColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Location",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          Gap(10.w),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SelectDistanceDialog(
                                      onTapDone: () async {
                                        dashboardController
                                            .selectedRadiusValue =
                                            dashboardController.radiusValue;
                                        NavigatorRoute.navigateBack(
                                            context: context);
                                        controller.filterGeneralList.clear();
                                        controller.pageNumber = 1;
                                        controller.generalSearchController
                                            .clear();
                                        await controller.getGeneralPostList(
                                            context: context);
                                        setState(() {});
                                      },
                                    );
                                  },
                                );
                              },
                              overlayColor:
                              WidgetStateProperty.all(Colors.transparent),
                              child: Container(
                                alignment: Alignment.center,
                                height: 30,
                                width: 170,
                                decoration: BoxDecoration(
                                  color: Colors.white30,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  'Distance : ${dashboardController.selectedRadiusValue.toStringAsFixed(2)} KM',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                          Gap(10.w),
                          IconButton(
                            onPressed: () {
                              controller.openLocationDailoge(context);
                            },
                            icon: Assets.icons.icSearch.svg(
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                              height: 20,
                            ),
                          ),
                        ],
                      ),
                      const Gap(20),
                      StorageService.getAddress()!= null && StorageService.getAddress()!.isNotEmpty ?
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Assets.icons.icLocation.svg(width: 25),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 16 / 2),
                            child: Text(
                              StorageService.getAddress() ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () async {
                              String address =
                                  StorageService.getCurrentAddress() ?? '';
                              double lat =
                                  StorageService.getCurrentLatitude() ?? 0.0;
                              double long =
                                  StorageService.getCurrentLongitude() ?? 0.0;
                              StorageService.saveLatitude(lat);
                              StorageService.saveLongitude(long);
                              StorageService.saveAddress(address);

                              controller.update();
                              setState(() {});

                              controller.filterGeneralList.clear();
                              controller.pageNumber = 1;
                              controller.generalSearchController.clear();
                              await controller.getGeneralPostList(context: context);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: AppColors.grey909090,
                            ),
                          )
                        ],
                      ) :const SizedBox()
                    ],
                  ),
                ),
              ),
              Gap(20.h),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.drawerBgColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 28.h),
                  child: TableCalendar(
                    firstDay: DateTime(2000),
                    lastDay: DateTime.now(),
                    focusedDay: controller.focusedDay,
                    selectedDayPredicate: (day) {
                      return isSameDay(controller.focusedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      controller.focusedDay = selectedDay;
                      controller.update();
                      log('Selected Day: $selectedDay');
                      controller.filterGeneralList.clear();
                      controller.pageNumber = 1;
                      controller.generalSearchController.clear();
                      controller.getGeneralPostList(context: context);
                    },
                    calendarStyle: CalendarStyle(
                      todayDecoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.transparent,
                      ),
                      holidayTextStyle:
                      Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      disabledTextStyle:
                      Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: AppColors.grey909090,
                        fontWeight: FontWeight.w500,
                      ),
                      weekendTextStyle:
                      Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
                    ),
                    calendarBuilders: CalendarBuilders(

                      defaultBuilder: (context, day, focusedDay) {
                        for (CalendarDatum d in controller.staticCalendarData) {
                          if (day.day == d.date.day &&
                              day.month == d.date.month &&
                              day.year == d.date.year) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${day.day}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Gap(10.h),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    (d.update != true)
                                        ? const SizedBox.shrink()
                                        : Assets.icons.icDot.svg(
                                      height: 5,
                                      colorFilter: const ColorFilter.mode(
                                        AppColors.green,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    (d.approve != true)
                                        ? const SizedBox.shrink()
                                        : Assets.icons.icDot.svg(
                                      height: 5,
                                      colorFilter: const ColorFilter.mode(
                                        AppColors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ],
                                ).paddingSymmetric(horizontal: 15),
                              ],
                            );
                          }
                        }
                        return null;
                      },
                      selectedBuilder: (context, date, events) => InkWell(
                        child: Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: AppColors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            date.day.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Gap(10.h),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Assets.icons.icDot.svg(
              //       height: 10,
              //       colorFilter: const ColorFilter.mode(
              //         AppColors.green,
              //         BlendMode.srcIn,
              //       ),
              //     ),
              //     Gap(5.w),
              //     Text(
              //       "Update",
              //       style: Theme.of(context)
              //           .textTheme
              //           .titleSmall!
              //           .copyWith(color: Colors.white),
              //     ),
              //     Gap(40.w),
              //     Assets.icons.icDot.svg(
              //       height: 10,
              //       colorFilter: const ColorFilter.mode(
              //         AppColors.white,
              //         BlendMode.srcIn,
              //       ),
              //     ),
              //     Gap(5.w),
              //     Text(
              //       "Approve",
              //       style: Theme.of(context)
              //           .textTheme
              //           .titleSmall!
              //           .copyWith(color: Colors.white),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      );
    });
  }
}

class CalendarDatum {
  final DateTime date;
  final bool update;
  final bool approve;

  CalendarDatum({
    required this.date,
    required this.update,
    required this.approve,
  });
}
