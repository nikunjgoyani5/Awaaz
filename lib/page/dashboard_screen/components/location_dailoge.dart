import 'dart:async';

import 'package:eagle_eye_admin/controller/dashboard_controller.dart';
import 'package:eagle_eye_admin/controller/event_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/service/storage/storage_service.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/widget/textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class LocationDailoge extends StatefulWidget {
  const LocationDailoge({super.key});

  @override
  State<LocationDailoge> createState() => _LocationDailogeState();
}

class _LocationDailogeState extends State<LocationDailoge> {
  GlobalKey key = GlobalKey();

  EventController eventController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (controller) {
      return Dialog(
        key: key,
        alignment: Alignment.topCenter,
        insetPadding: EdgeInsets.only(top: 40.h),
        backgroundColor: AppColors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    "Location",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: AppColors.white, fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      context.pop(false);
                    },
                     )
                ],
              ),
              Gap(30.h),
              CommonTextField(
                prefixIcon: SizedBox(
                    height: 50,
                    width: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(13),
                      child: Assets.icons.icSearch.svg(),
                    )),
                hintText: "Search",
                controller: controller.locationSearchController,
                onChanged: (value) async {


                  if (controller.debounce?.isActive ?? false) {
                    controller.debounce?.cancel();
                  }
                  controller.debounce =
                      Timer(const Duration(seconds: 1), () async {
                        await controller.searchAddress(value, context);
                        controller.update();
                        setState(() {});
                      });




                },
              ),
              Gap(20.h),
              // InkWell(
              //   onTap: () async {
              //     await controller.fetchOpratorCurrentLocation(pl);
              //   },
              //   radius: 0,
              //   overlayColor: WidgetStateProperty.all(AppColors.transparent),
              //   child: SizedBox(
              //     child: Row(
              //       children: [
              //         Assets.icons.icFetchLocation.svg(width: 20),
              //         Gap(5.w),
              //         Text(
              //           "Detect my location",
              //           style: Theme.of(context).textTheme.titleSmall!.copyWith(
              //               color: AppColors.white,
              //               fontWeight: FontWeight.w500),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              Obx(
                () {
                  return controller.locationLoader.value
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 100,
                                width: 100,
                                child: Lottie.asset(
                                    'assets/animation/loader.json')),
                          ],

                        )
                      : controller.filteredLocationList.isNotEmpty
                          ? ListView.separated(
                              itemBuilder: (con, index) => GestureDetector(
                                onTap: () async {
                                  controller.selectedIndex = index;
                                  controller.selectedLocation =
                                      controller.filteredLocationList[index];
                                  controller.update();
                                  StorageService.saveAddress('${controller.selectedLocation?.city ?? ""} ${controller.selectedLocation?.country ?? ''}');

                                  eventController.selectedLocation =
                                      controller.filteredLocationList[index];
                                  eventController.longitude = controller
                                      .filteredLocationList[index]
                                      .longitude ??= 0.0;
                                  eventController.latitude = controller
                                      .filteredLocationList[index]
                                      .latitude ??= 0.0;
                                  StorageService.saveLatitude(controller
                                      .filteredLocationList[index]
                                      .latitude ??
                                      0.0);
                                  StorageService.saveLongitude(controller
                                      .filteredLocationList[index]
                                      .longitude ??
                                      0.0);
                                  eventController.update();
                                  controller.filteredLocationList.clear();
                                  controller.selectedIndex = 0;
                                  controller.selectedLocation = null;
                                  controller.locationSearchController.clear();
                                  setState(() {});
                                  context.pop(true);

                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      fillColor: const WidgetStatePropertyAll(
                                          AppColors.transparent),
                                      checkColor: AppColors.white,
                                      value: controller.selectedIndex == index,
                                      activeColor: Colors.white,
                                      onChanged: (value) async {
                                        controller.selectedIndex = index;
                                        controller.selectedLocation = controller
                                            .filteredLocationList[index];
                                        controller.update();
                                        eventController.selectedLocation =
                                            controller
                                                .filteredLocationList[index];
                                        eventController.longitude = controller
                                                .filteredLocationList[index]
                                                .longitude ??
                                            0.0;
                                        eventController.latitude = controller
                                                .filteredLocationList[index]
                                                .latitude ??
                                            0.0;
                                        StorageService.saveLatitude(controller
                                                .filteredLocationList[index]
                                                .latitude ??
                                            0.0);
                                        StorageService.saveLongitude(controller
                                                .filteredLocationList[index]
                                                .longitude ??
                                            0.0);
                                        eventController.update();
                                        controller.filteredLocationList.clear();
                                        controller.selectedIndex = 0;
                                        controller.selectedLocation = null;
                                        controller.locationSearchController
                                            .clear();
                                        setState(() {});
                                        context.pop(true);



                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16 / 2),
                                      child: Text(
                                        '${controller.filteredLocationList[index].city ?? ''} ${controller.filteredLocationList[index].country ?? ""}',
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
                              ),
                              separatorBuilder: (context, index) => Gap(5.h),
                              itemCount: controller.filteredLocationList.length,
                              shrinkWrap: true,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'No Location Found',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.white),
                                ),
                              ],
                            );
                },
              ),

              Gap(30.h),
            ],
          ),
        ),
      );
    });
  }
}
