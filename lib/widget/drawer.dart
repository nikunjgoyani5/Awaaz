import 'package:eagle_eye_admin/controller/dashboard_controller.dart';
import 'package:eagle_eye_admin/controller/event_controller.dart';
import 'package:eagle_eye_admin/controller/report_controller.dart';
import 'package:eagle_eye_admin/controller/rescue_controller.dart';
import 'package:eagle_eye_admin/controller/user_management_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/route/app_route.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/service/storage/storage_service.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/widget/app_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    EventController eventController = Get.put(EventController());
    Get.put(DashboardController());
    ReportController reportController = Get.put(ReportController());
    UserManagementController userManagementController =
        Get.put(UserManagementController());
    RescueController rescueController = Get.put(RescueController());
    return GetBuilder<DashboardController>(builder: (controller) {
      return Drawer(
        backgroundColor: AppColors.drawerBgColor,
        shape: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: AppColors.borderColor,
            width: 3,
          ),
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              height: 75.h,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              decoration: const BoxDecoration(
                color: Color(0xff0A0A0A),
                border: Border(
                  bottom: BorderSide(
                    width: 3,
                    color: AppColors.borderColor,
                  ),
                  right: BorderSide(
                    width: 3,
                    color: AppColors.borderColor,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: AppNetworkImageLoader(
                      url: StorageService.getProfilePic() ?? '',
                      height: 30,
                      width: 30,
                      boxFit: BoxFit.fill,
                    ),
                  ),
                  Gap(20.w),
                  Text(
                    'AWAAZ OPERATOR',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontSize: 12,
                        color: AppColors.white,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
            const Gap(10),
            DrawerListTile(
                title: 'Event',
                svgSrc: Assets.icons.icLocation.path,
                press: () {
                  if (Get.currentRoute != "/dashboard") {
                    // NavigatorRoute.navigateBack(context: context);
                    NavigatorRoute.navigateToSpecificPage(
                        AppRoutes.event, context);
                  }
                  controller.selectedTab = 0;
                  StorageService.saveSelectedTab(0);
                  controller.isOpenReportDropdown = false;
                  controller.isOpenUserManageDropdown = false;
                  controller.update();

                  eventController.selectedSubTab = 1.1;
                  eventController.update();
                },
                gradientColor: controller.selectedTab == 0
                    ? AppColors.selectedTabGradient
                    : null,
                dropdown:
                    const SizedBox() /*CircleAvatar(
                radius: 10.5,
                backgroundColor: AppColors.green,
                child: Text(
                  '3',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: AppColors.white, fontWeight: FontWeight.w500),
                ),
              ),*/
                ),
            const Gap(5),
            DrawerListTile(
                title: 'General',
                svgSrc: Assets.icons.icGeneralPost.path,
                press: () {
                  if (Get.currentRoute != "/dashboard") {
                    // NavigatorRoute.navigateBack(context: context);
                    NavigatorRoute.navigateToSpecificPage(
                        AppRoutes.event, context);
                  }
                  controller.selectedTab = 5;
                  StorageService.saveSelectedTab(5);
                  controller.isOpenReportDropdown = false;
                  controller.isOpenUserManageDropdown = false;
                  controller.update();
                  eventController.selectedSubTab = 5.1;
                  eventController.update();
                },
                gradientColor: controller.selectedTab == 5
                    ? AppColors.selectedTabGradient
                    : null,
                dropdown:
                    const SizedBox() /*CircleAvatar(
                radius: 10.5,
                backgroundColor: AppColors.green,
                child: Text(
                  '3',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: AppColors.white, fontWeight: FontWeight.w500),
                ),
              ),*/
                ),
            const Gap(5),
            DrawerListTile(
                title: 'Rescue',
                svgSrc: Assets.icons.icRescue.path,
                press: () {
                  if (Get.currentRoute != "/dashboard") {
                    // NavigatorRoute.navigateBack(context: context);
                    NavigatorRoute.navigateToSpecificPage(
                        AppRoutes.event, context);
                  }
                  controller.selectedTab = 1;
                  StorageService.saveSelectedTab(1);
                  controller.isOpenReportDropdown = false;
                  controller.isOpenUserManageDropdown = false;
                  controller.update();
                  rescueController.selectedSubTab = 2.1;
                  rescueController.update();
                },
                gradientColor: controller.selectedTab == 1
                    ? AppColors.selectedTabGradient
                    : null,
                dropdown: const SizedBox()
                /*    CircleAvatar(
                radius: 10.5,
                backgroundColor: AppColors.green,
                child: Text(
                  '8',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: AppColors.white, fontWeight: FontWeight.w500),
                ),
              ),*/
                ),
            const Gap(5),
            DrawerListTile(
              title: 'Report',
              svgSrc: Assets.icons.icReport.path,
              press: () {
                if (Get.currentRoute != "/dashboard") {
                  // NavigatorRoute.navigateBack(context: context);
                  NavigatorRoute.navigateToSpecificPage(
                      AppRoutes.event, context);
                }

                if (controller.selectedTab != 2) {
                  controller.isOpenReportDropdown = true;
                }

                reportController.selectedSubTab = 3.1;
                StorageService.saveSelectedSubTab(0);

                controller.selectedTab = 2;
                StorageService.saveSelectedTab(2);

                controller.isOpenUserManageDropdown = false;
                controller.update();
                reportController.update();
              },
              gradientColor: controller.selectedTab == 2
                  ? AppColors.selectedTabGradient
                  : null,
              dropdown: Row(
                children: [
                  // CircleAvatar(
                  //   radius: 10.5,
                  //   backgroundColor: AppColors.green,
                  //   child: Text(
                  //     '5',
                  //     style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  //         color: AppColors.white, fontWeight: FontWeight.w500),
                  //   ),
                  // ),
                  Gap(5.w),
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      controller.isOpenReportDropdown =
                          !controller.isOpenReportDropdown;
                      controller.update();
                      setState(() {});
                    },
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: AppColors.transparent,
                      child: Icon(
                        controller.isOpenReportDropdown
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: AppColors.grey909090,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
              dropdownWidget: controller.isOpenReportDropdown
                  ? Column(
                      children: [
                        ListTile(
                            title: Text(
                              'Post',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color:
                                          reportController.selectedSubTab == 3.1
                                              ? AppColors.white
                                              : AppColors.grey909090,
                                      fontWeight: FontWeight.w500),
                            ),
                            onTap: () {
                              if (Get.currentRoute != "/dashboard") {
                                // NavigatorRoute.navigateBack(context: context);
                                NavigatorRoute.navigateToSpecificPage(
                                    AppRoutes.event, context);
                              }
                              reportController.selectedSubTab = 3.1;
                              StorageService.saveSelectedSubTab(3.1);
                              controller.selectedTab = 2;
                              StorageService.saveSelectedTab(2);
                              controller.update();
                              reportController.update();
                            },
                            trailing: const SizedBox()
                            // CircleAvatar(
                            //   radius: 10.5,
                            //   backgroundColor: AppColors.transparent,
                            //   child: Text(
                            //     '2',
                            //     style: Theme.of(context)
                            //         .textTheme
                            //         .bodySmall!
                            //         .copyWith(
                            //             color: AppColors.green,
                            //             fontWeight: FontWeight.w500),
                            //   ),
                            // ),
                            ),
                        ListTile(
                          title: Text(
                            'Comment',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color:
                                        reportController.selectedSubTab == 3.2
                                            ? AppColors.white
                                            : AppColors.grey909090,
                                    fontWeight: FontWeight.w500),
                          ),
                          onTap: () {
                            if (Get.currentRoute != "/dashboard") {
                              // NavigatorRoute.navigateBack(context: context);
                              NavigatorRoute.navigateToSpecificPage(
                                  AppRoutes.event, context);
                            }
                            reportController.selectedSubTab = 3.2;
                            StorageService.saveSelectedSubTab(3.2);
                            controller.selectedTab = 2;

                            StorageService.saveSelectedTab(2);
                            controller.update();
                            reportController.update();
                          },
                          // trailing:
                          // CircleAvatar(
                          //   radius: 10.5,
                          //   backgroundColor: AppColors.transparent,
                          //   child: Text(
                          //     '2',
                          //     style: Theme.of(context)
                          //         .textTheme
                          //         .bodySmall!
                          //         .copyWith(
                          //             color: AppColors.green,
                          //             fontWeight: FontWeight.w500),
                          //   ),
                          // ),
                        ),
                        ListTile(
                          title: Text(
                            'Profile',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color:
                                        reportController.selectedSubTab == 3.3
                                            ? AppColors.white
                                            : AppColors.grey909090,
                                    fontWeight: FontWeight.w500),
                          ),
                          onTap: () {
                            if (Get.currentRoute != "/dashboard") {
                              // NavigatorRoute.navigateBack(context: context);
                              NavigatorRoute.navigateToSpecificPage(
                                  AppRoutes.event, context);
                            }
                            reportController.selectedSubTab = 3.3;
                            StorageService.saveSelectedSubTab(3.3);
                            controller.selectedTab = 2;
                            StorageService.saveSelectedTab(2);
                            controller.update();
                            reportController.update();
                          },
                          // trailing: CircleAvatar(
                          //   radius: 10.5,
                          //   backgroundColor: AppColors.transparent,
                          //   child: Text(
                          //     '1',
                          //     style: Theme.of(context)
                          //         .textTheme
                          //         .bodySmall!
                          //         .copyWith(
                          //             color: AppColors.green,
                          //             fontWeight: FontWeight.w500),
                          //   ),
                          // ),
                        ),
                      ],
                    ).paddingOnly(left: 65.w)
                  : const SizedBox.shrink(),
            ),
            const Gap(5),
            DrawerListTile(
              title: 'User Manage',
              svgSrc: Assets.icons.icUserManagement.path,
              press: () async {
                if (Get.currentRoute != "/dashboard") {
                  // NavigatorRoute.navigateBack(context: context);
                  NavigatorRoute.navigateToSpecificPage(
                      AppRoutes.event, context);
                }
                if (controller.selectedTab != 3) {
                  controller.isOpenUserManageDropdown = true;
                }
                userManagementController.selectedSubTab = 4.1;
                StorageService.saveSelectedSubTab(4.1);
                controller.selectedTab = 3;
                StorageService.saveSelectedTab(3);
                controller.isOpenReportDropdown = false;
                controller.update();
                userManagementController.update();
                userManagementController.pageNumber = 1;
                userManagementController.usersList.clear();
                userManagementController.searchController.clear();
                await userManagementController.getUsersAPI(context: context);
              },
              gradientColor: controller.selectedTab == 3
                  ? AppColors.selectedTabGradient
                  : null,
              dropdown: Row(
                children: [
                  // CircleAvatar(
                  //   radius: 10.5,
                  //   backgroundColor: AppColors.green,
                  //   child: Text(
                  //     '2',
                  //     style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  //         color: AppColors.white, fontWeight: FontWeight.w500),
                  //   ),
                  // ),
                  Gap(5.w),
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      controller.isOpenUserManageDropdown =
                          !controller.isOpenUserManageDropdown;
                      controller.update();
                      setState(() {});
                    },
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: AppColors.transparent,
                      child: Icon(
                        controller.isOpenUserManageDropdown
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: AppColors.grey909090,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
              dropdownWidget: controller.isOpenUserManageDropdown
                  ? Column(
                      children: [
                        ListTile(
                          title: Text(
                            'User',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: userManagementController
                                                .selectedSubTab ==
                                            4.1
                                        ? AppColors.white
                                        : AppColors.grey909090,
                                    fontWeight: FontWeight.w500),
                          ),
                          onTap: () async {
                            if (Get.currentRoute != "/dashboard") {
                              // NavigatorRoute.navigateBack(context: context);
                              NavigatorRoute.navigateToSpecificPage(
                                  AppRoutes.event, context);
                            }
                            controller.selectedTab = 3;
                            StorageService.saveSelectedTab(3);
                            controller.update();
                            userManagementController.selectedSubTab = 4.1;
                            StorageService.saveSelectedSubTab(4.1);
                            userManagementController.update();
                            userManagementController.pageNumber = 1;
                            userManagementController.usersList.clear();
                            userManagementController.searchController.clear();
                            await userManagementController.getUsersAPI(
                                context: context);
                          },
                          // trailing: CircleAvatar(
                          //   radius: 10.5,
                          //   backgroundColor: AppColors.transparent,
                          //   child: Text(
                          //     '1',
                          //     style: Theme.of(context)
                          //         .textTheme
                          //         .bodySmall!
                          //         .copyWith(
                          //             color: AppColors.green,
                          //             fontWeight: FontWeight.w500),
                          //   ),
                          // ),
                        ),
                        ListTile(
                          title: Text(
                            'Block',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: userManagementController
                                                .selectedSubTab ==
                                            4.2
                                        ? AppColors.white
                                        : AppColors.grey909090,
                                    fontWeight: FontWeight.w500),
                          ),
                          onTap: () async {
                            if (Get.currentRoute != "/dashboard") {
                              // NavigatorRoute.navigateBack(context: context);
                              NavigatorRoute.navigateToSpecificPage(
                                  AppRoutes.event, context);
                            }
                            controller.selectedTab = 3;
                            StorageService.saveSelectedTab(3);
                            controller.update();
                            userManagementController.selectedSubTab = 4.2;
                            StorageService.saveSelectedSubTab(4.2);
                            userManagementController.update();
                            userManagementController.pageNumber = 1;
                            userManagementController.usersList.clear();
                            userManagementController.searchController.clear();
                            await userManagementController.getUsersAPI(
                                context: context);
                          },
                          // trailing: CircleAvatar(
                          //   radius: 10.5,
                          //   backgroundColor: AppColors.transparent,
                          //   child: Text(
                          //     '1',
                          //     style: Theme.of(context)
                          //         .textTheme
                          //         .bodySmall!
                          //         .copyWith(
                          //             color: AppColors.green,
                          //             fontWeight: FontWeight.w500),
                          //   ),
                          // ),
                        ),
                      ],
                    ).paddingOnly(left: 65.w)
                  : const SizedBox.shrink(),
            ),
            const Gap(5),
            StorageService.getIsSuperAdmin() == true
                ? DrawerListTile(
                    title: 'Manage Admin',
                    svgSrc: Assets.icons.icUserManagement.path,
                    press: () {
                      if (Get.currentRoute != "/dashboard") {
                        // NavigatorRoute.navigateBack(context: context);
                        NavigatorRoute.navigateToSpecificPage(
                            AppRoutes.event, context);
                      }
                      controller.selectedTab = 4;
                      StorageService.saveSelectedTab(4);
                      controller.update();
                    },
                    gradientColor: controller.selectedTab == 4
                        ? AppColors.selectedTabGradient
                        : null,
                    dropdown: const SizedBox())
                : const SizedBox(),
          ],
        ),
      );
    });
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
    this.dropdown,
    this.dropdownWidget,
    this.gradientColor,
  });

  final String title, svgSrc;
  final Widget? dropdown;
  final Widget? dropdownWidget;
  final VoidCallback press;
  final LinearGradient? gradientColor;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (controller) {
      return InkWell(
        radius: 0,
        highlightColor: AppColors.transparent,
        focusColor: AppColors.transparent,
        splashColor: AppColors.transparent,
        onTap: press,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 5.h),
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12),
              decoration: BoxDecoration(
                gradient: gradientColor,
                border: gradientColor != null
                    ? const Border(
                        left: BorderSide(color: AppColors.white, width: 6),
                      )
                    : null,
              ),
              child: Row(
                children: [
                  gradientColor != null
                      ? const SizedBox.shrink()
                      : const Gap(6),
                  SvgPicture.asset(svgSrc,
                      height: 30.h,
                      width: 30.w,
                      colorFilter: ColorFilter.mode(
                        gradientColor != null
                            ? AppColors.white
                            : AppColors.grey909090,
                        BlendMode.srcIn,
                      )),
                  Gap(20.w),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: gradientColor != null
                            ? AppColors.white
                            : AppColors.grey909090,
                        fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  dropdown ?? const SizedBox.shrink(),
                ],
              ),
            ),
            dropdownWidget ?? const SizedBox.shrink(),
          ],
        ),
      );
    });
  }
}
