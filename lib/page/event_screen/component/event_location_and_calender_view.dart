import 'dart:developer';

import 'package:eagle_eye_admin/controller/dashboard_controller.dart';
import 'package:eagle_eye_admin/controller/event_controller.dart';
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

class EventLocationAndCalenderView extends StatefulWidget {
  const EventLocationAndCalenderView({super.key});

  @override
  State<EventLocationAndCalenderView> createState() =>
      _EventLocationAndCalenderViewState();
}

class _EventLocationAndCalenderViewState
    extends State<EventLocationAndCalenderView> {
  DashboardController dashboardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventController>(builder: (controller) {
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
                      controller.isClearFilter = !controller.isClearFilter;
                      controller.update();
                      controller.filterEvents.clear();
                      controller.pageNumber = 1;
                      controller.eventSearchController.clear();
                      await controller.getEventsList(context: context);
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
                              value: controller.isClearFilter,
                              fillColor: WidgetStateProperty.resolveWith((states) {
                                if (states.contains(WidgetState.selected)) {
                                  return AppColors.white;
                                }
                                return Colors.transparent;
                              }),

                              onChanged: (value) async {
                                controller.isClearFilter = value!;
                                controller.update();
                                controller.filterEvents.clear();
                                controller.pageNumber = 1;
                                controller.eventSearchController.clear();
                                await controller.getEventsList(context: context);
                              },
                            ),
                            const Gap(
                              10,
                            ),
                            MouseRegion(
                              onHover: (event) {
                                controller.isHoverFilter = true;

                                controller.update();
                                setState(() {});
                              },
                              onExit: (event) {
                                controller.isHoverFilter = false;

                                controller.update();
                                setState(() {});
                              },
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
              Stack(
                children: [
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
                                        // return AlertDialog(
                                        //   insetPadding: EdgeInsets.zero,
                                        //   titlePadding: EdgeInsets.zero,
                                        //   backgroundColor:
                                        //       AppColors.transparent,
                                        //   shape: RoundedRectangleBorder(
                                        //     borderRadius:
                                        //         BorderRadius.circular(10),
                                        //   ),
                                        //   title: StatefulBuilder(
                                        //     builder: (con, update) {
                                        //       return Container(
                                        //           padding:
                                        //               const EdgeInsets.all(25),
                                        //           decoration: BoxDecoration(
                                        //               color: AppColors.white,
                                        //               borderRadius:
                                        //                   BorderRadius.circular(
                                        //                       15)),
                                        //           child: Column(
                                        //             children: [
                                        //               Row(
                                        //                 mainAxisAlignment:
                                        //                     MainAxisAlignment
                                        //                         .spaceBetween,
                                        //                 children: [
                                        //                   const SizedBox(
                                        //                     height: 30,
                                        //                     width: 70,
                                        //                   ),
                                        //                   Text(
                                        //                     "Select Distance",
                                        //                     style: TextStyles.bold(
                                        //                         25,
                                        //                         fontColor:
                                        //                             Colors
                                        //                                 .black),
                                        //                   ),
                                        //                   Container(
                                        //                     alignment: Alignment
                                        //                         .center,
                                        //                     height: 30,
                                        //                     width: 100,
                                        //                     decoration:
                                        //                         BoxDecoration(
                                        //                       color: Colors
                                        //                           .black45,
                                        //                       borderRadius:
                                        //                           BorderRadius
                                        //                               .circular(
                                        //                                   30),
                                        //                     ),
                                        //                     child: Text(
                                        //                       '${controller.radiusValue.toStringAsFixed(2)} KM',
                                        //                       style: Theme.of(
                                        //                               context)
                                        //                           .textTheme
                                        //                           .titleSmall!
                                        //                           .copyWith(
                                        //                               color: Colors
                                        //                                   .black,
                                        //                               fontWeight:
                                        //                                   FontWeight
                                        //                                       .w600),
                                        //                     ),
                                        //                   )
                                        //                 ],
                                        //               ),
                                        //               const Gap(30),
                                        //               Padding(
                                        //                 padding:
                                        //                     const EdgeInsets
                                        //                         .symmetric(
                                        //                         horizontal:
                                        //                             50.0),
                                        //                 child: Text(
                                        //                   'You can select a range for location to show events!',
                                        //                   textAlign:
                                        //                       TextAlign.center,
                                        //                   style: TextStyles
                                        //                       .semiBold(18,
                                        //                           fontColor:
                                        //                               Colors
                                        //                                   .black),
                                        //                 ),
                                        //               ),
                                        //               const Gap(40),
                                        //               Row(
                                        //                 children: [
                                        //                   Container(
                                        //                     alignment: Alignment
                                        //                         .center,
                                        //                     height: 30,
                                        //                     width: 30,
                                        //                     decoration:
                                        //                         const BoxDecoration(
                                        //                             color: Colors
                                        //                                 .black45,
                                        //                             shape: BoxShape
                                        //                                 .circle),
                                        //                     child: Text(
                                        //                       '1',
                                        //                       style: Theme.of(
                                        //                               context)
                                        //                           .textTheme
                                        //                           .titleSmall!
                                        //                           .copyWith(
                                        //                               color: Colors
                                        //                                   .black,
                                        //                               fontWeight:
                                        //                                   FontWeight
                                        //                                       .w600),
                                        //                     ),
                                        //                   ),
                                        //                   Expanded(
                                        //                     child: Slider(
                                        //                       min: 1,
                                        //                       max: 500,
                                        //                       value: controller
                                        //                           .radiusValue,
                                        //                       activeColor:
                                        //                           AppColors
                                        //                               .black,
                                        //                       inactiveColor:
                                        //                           AppColors
                                        //                               .borderColor,
                                        //                       onChanged:
                                        //                           (value) {
                                        //                         controller
                                        //                                 .radiusValue =
                                        //                             value;
                                        //                         setState(() {});
                                        //                         controller
                                        //                             .update();
                                        //                         update.call(
                                        //                             () {});
                                        //                       },
                                        //                     ),
                                        //                   ),
                                        //                   Container(
                                        //                     alignment: Alignment
                                        //                         .center,
                                        //                     height: 30,
                                        //                     width: 60,
                                        //                     decoration: BoxDecoration(
                                        //                         color: Colors
                                        //                             .black45,
                                        //                         borderRadius:
                                        //                             BorderRadius
                                        //                                 .circular(
                                        //                                     10)),
                                        //                     child: Text(
                                        //                       '500',
                                        //                       style: Theme.of(
                                        //                               context)
                                        //                           .textTheme
                                        //                           .titleSmall!
                                        //                           .copyWith(
                                        //                               color: Colors
                                        //                                   .black,
                                        //                               fontWeight:
                                        //                                   FontWeight
                                        //                                       .w600),
                                        //                     ),
                                        //                   ),
                                        //                 ],
                                        //               ),
                                        //               const Gap(10),
                                        //               CommonTextField(
                                        //                 cursorColor: Colors.black,
                                        //
                                        //                 onChanged: (value) {
                                        //
                                        //
                                        //                   num value = num
                                        //                       .parse(controller
                                        //                           .distanceController
                                        //                           .text);
                                        //                   if(value>500){
                                        //                     controller
                                        //                         .radiusValue = 500;
                                        //                     controller.distanceController.text= '500';
                                        //                   }
                                        //                   else {
                                        //                     controller
                                        //                         .radiusValue =
                                        //                         double.parse(value
                                        //                             .toStringAsFixed(
                                        //                             2));
                                        //                   }
                                        //
                                        //                   setState(() {
                                        //
                                        //                   });
                                        //                   update.call((){});
                                        //                   controller.update();
                                        //                 },
                                        //                 textStyle: Theme.of(
                                        //                         context)
                                        //                     .textTheme
                                        //                     .labelMedium!
                                        //                     .copyWith(
                                        //                         color: AppColors
                                        //                             .black),
                                        //                 hintText:
                                        //                     'Enter Distance',
                                        //                 controller: controller
                                        //                     .distanceController,
                                        //                 keyboardType:
                                        //                     TextInputType
                                        //                         .number,
                                        //                 inputFormatters: <TextInputFormatter>[
                                        //                   FilteringTextInputFormatter
                                        //                       .allow(RegExp(
                                        //                           r'^\d*\.?\d*$')),
                                        //                 ],
                                        //               ),
                                        //               const Gap(10),
                                        //               Row(
                                        //                 mainAxisAlignment:
                                        //                     MainAxisAlignment
                                        //                         .end,
                                        //                 children: [
                                        //                   SizedBox(
                                        //                     height: 35,
                                        //                     child:
                                        //                         ElevatedButton(
                                        //                             style: ElevatedButton
                                        //                                 .styleFrom(
                                        //                               shape:
                                        //                                   RoundedRectangleBorder(
                                        //                                 borderRadius:
                                        //                                     BorderRadius.circular(8),
                                        //                               ),
                                        //                               overlayColor: AppColors
                                        //                                   .black
                                        //                                   .withValues(
                                        //                                       alpha: 0.2),
                                        //                               shadowColor:
                                        //                                   Colors
                                        //                                       .black,
                                        //                               backgroundColor:
                                        //                                   Colors
                                        //                                       .black,
                                        //                             ),
                                        //                             onPressed:
                                        //                                 () async {
                                        //                               // NavigatorRoute.navigateBack(
                                        //                               //     context:
                                        //                               //         context);
                                        //                               // await controller
                                        //                               //     .updateRadiusAPI(
                                        //                               //         context:
                                        //                               //             context,
                                        //                               //         pl: pl,
                                        //                               //         radius: controller
                                        //                               //             .radiusValue);
                                        //                               controller
                                        //                                       .selectedRadiusValue =
                                        //                                   controller
                                        //                                       .radiusValue;
                                        //                               NavigatorRoute.navigateBack(
                                        //                                   context:
                                        //                                       context);
                                        //                               controller
                                        //                                   .filterEvents
                                        //                                   .clear();
                                        //                               controller
                                        //                                   .pageNumber = 1;
                                        //                               controller
                                        //                                   .eventSearchController
                                        //                                   .clear();
                                        //                               await controller
                                        //                                   .getEventsList(context: context);
                                        //                               setState(
                                        //                                   () {});
                                        //                             },
                                        //                             child: Text(
                                        //                               'Done',
                                        //                               style: TextStyles.semiBold(
                                        //                                   17,
                                        //                                   fontColor:
                                        //                                       Colors.white),
                                        //                             )),
                                        //                   ),
                                        //                 ],
                                        //               ),
                                        //             ],
                                        //           ));
                                        //     },
                                        //   ),
                                        // );

                                        return  SelectDistanceDialog(
                                          onTapDone: () async {
                                          dashboardController
                                              .selectedRadiusValue =
                                              dashboardController
                                                  .radiusValue;
                                          NavigatorRoute.navigateBack(
                                              context:
                                              context);

                                          controller
                                              .filterEvents
                                              .clear();
                                          controller
                                              .pageNumber = 1;
                                          controller
                                              .eventSearchController
                                              .clear();
                                          await controller
                                              .getEventsList(context: context);
                                          setState(
                                                  () {});
                                        },);
                                      },
                                    );
                                  },
                                  overlayColor: WidgetStateProperty.all(
                                      Colors.transparent),
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
                          StorageService.getAddress()!= null && StorageService.getAddress()!.isNotEmpty ?      Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Assets.icons.icLocation.svg(width: 25),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16 / 2),
                                      child: Text(
                                        StorageService.getAddress()??'',
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
                                        controller.selectedLocation = null;
String address = StorageService
    .getCurrentAddress() ?? '';
                                        double lat = StorageService
                                                .getCurrentLatitude() ??
                                            0.0;
                                        double long = StorageService
                                                .getCurrentLongitude() ??
                                            0.0;
                                        StorageService.saveLatitude(lat);
                                        StorageService.saveLongitude(long);
                                        StorageService.saveAddress(address);

                                        controller.update();
                                        setState(() {});

                                        controller.filterEvents.clear();
                                        controller.pageNumber = 1;
                                        controller.eventSearchController
                                            .clear();
                                        await controller.getEventsList(context: context);
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: AppColors.grey909090,
                                      ),
                                    )
                                  ],
                                ): const SizedBox(),

                        ],
                      ),
                    ),
                  ),
                  controller.isHoverFilter
                      ? Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 7),
                          child: Text(
                            "When this filter is selected, then only the entered location & specific date's event data will be shown in dashboard.",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontSize: 15.w,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                          ),
                        )
                      : const SizedBox(),
                ],
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
                    lastDay: DateTime(2100),
                    focusedDay: controller.focusedDay,
                    selectedDayPredicate: (day) {
                      return isSameDay(controller.focusedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      controller.focusedDay = selectedDay;
                      controller.update();
                      log('Selected Day: $selectedDay');
                      controller.filterEvents.clear();
                      controller.pageNumber = 1;
                      controller.eventSearchController.clear();
                      controller.getEventsList(context: context);
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
              )
            ],
          ),
        ),
      );
    });
  }
}
