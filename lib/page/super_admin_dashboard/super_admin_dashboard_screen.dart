import 'package:eagle_eye_admin/controller/super_admin_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/page/dashboard_screen/components/header.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/widget/button.dart';
import 'package:eagle_eye_admin/widget/common_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SuperAdminDashboardScreen extends StatefulWidget {
  const SuperAdminDashboardScreen({super.key});

  @override
  State<SuperAdminDashboardScreen> createState() =>
      _SuperAdminDashboardScreenState();
}

class _SuperAdminDashboardScreenState extends State<SuperAdminDashboardScreen> {

  SuperAdminController superAdminController= Get.put(SuperAdminController());
  @override
  void initState() {
superAdminController.init(context: context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Expanded(
      flex: 5,
      child: GetBuilder<SuperAdminController>(
          init: SuperAdminController(),
          builder: (controller) {
            return Stack(
              children: [
                Image.asset(Assets.image.mapBg.path),
                Container(

                    decoration: BoxDecoration(
                      color: AppColors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
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
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                         Spacer(),

                              ProfileCard()
                            ],
                          ),
                        ),
                        const Gap(22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Text(
                              "WELCOME TO THE SUPER OPERATOR  OF AWAAZ APP",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                  fontSize: 30.w,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w700),
                            ),

                          ],
                        ),




                        Expanded(
                          child: Padding(
                            padding:EdgeInsets.symmetric(
                              horizontal:  MediaQuery.of(context).size.width * 0.2
                                  ,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [



                                const Gap(50),
                                Align(
                                  alignment: AlignmentDirectional.center,
                                  child: Assets.image.aawazLogo.svg(),
                                ),
                                const Gap(30),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          controller.onChangeTab(0,
                                          context: context);
                                        },
                                        child: Container(
                                          height: 50.h,
                                          decoration: BoxDecoration(
                                            color: controller.selectedTab == 0
                                                ? AppColors.white.withValues(alpha:0.6)
                                                : AppColors.white.withValues(alpha:0.1),
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Pending',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall!
                                                .copyWith(
                                                fontSize: 15,
                                                color: controller.selectedTab == 0
                                                    ? AppColors.black
                                                    : AppColors.white,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Gap(10.w),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          controller.onChangeTab(1,context: context);
                                        },
                                        child: Container(
                                          height: 50.h,
                                          decoration: BoxDecoration(
                                            color: controller.selectedTab == 1
                                                ? AppColors.white.withValues(alpha:0.6)
                                                : AppColors.white.withValues(alpha:0.1),
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Approved',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall!
                                                .copyWith(
                                                fontSize: 15,
                                                color: controller.selectedTab == 1
                                                    ? AppColors.black
                                                    : AppColors.white,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Gap(10.w),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.onChangeTab(2,context: context);
                                        },
                                        child: Container(
                                          height: 50.h,
                                          decoration: BoxDecoration(
                                            color: controller.selectedTab == 2
                                                ? AppColors.white.withValues(alpha:0.6)
                                                : AppColors.white.withValues(alpha:0.1),
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Disabled',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall!
                                                .copyWith(
                                                fontSize: 15,
                                                color: controller.selectedTab == 2
                                                    ? AppColors.black
                                                    : AppColors.white,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(20),
                                Obx(
                                      () {
                                    return controller.loader.value
                                        ? Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Gap(
                                          200.h,
                                        ),
                                        const Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            CircularProgressIndicator(
                                              color: AppColors.white,
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                        : controller.filteredAdminList.isNotEmpty
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
                                                    .allAdminModel
                                                    .body
                                                    ?.page ??
                                                    0) <
                                                    (controller
                                                        .allAdminModel
                                                        .body
                                                        ?.totalPages ??
                                                        0)) {
                                                  controller.adminPagination(
                                                    context: context
                                                     );
                                                }
                                              }
                                              return false;
                                            },

                                            child: ListView.separated(
                                              separatorBuilder: (context, index) {
                                                return Gap(10.h);
                                              },
                                              itemCount: controller
                                                  .filteredAdminList.length,
                                              padding: EdgeInsets.zero,
                                              itemBuilder: (con, index) {
                                                return InkWell(
                                                  focusColor: AppColors.transparent,
                                                  overlayColor:
                                                  WidgetStateProperty.all(
                                                      AppColors.transparent),
                                                  radius: 0,
                                                  onTap: () async {},
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .eventCardBgColor,
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.all(20),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                controller
                                                                    .filteredAdminList[
                                                                index]
                                                                    .name ??
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
                                                                        .w700),
                                                              ),
                                                              const Gap(10),
                                                              Text(
                                                                controller
                                                                    .filteredAdminList[
                                                                index]
                                                                    .email ??
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
                                                                        .w600),
                                                              ),
                                                            ],
                                                          ),
                                                          const Spacer(),
                                                          controller.selectedTab ==
                                                              0
                                                              ? Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 120.w,
                                                                height: 35.h,
                                                                child: CommonButton(
                                                                    color: AppColors.borderColor,
                                                                    radius: 5,
                                                                    widget: Text(
                                                                      'Disable',
                                                                      style: Theme.of(context)
                                                                          .textTheme
                                                                          .bodyMedium!
                                                                          .copyWith(
                                                                          color: AppColors.grey929da9,
                                                                          fontWeight: FontWeight.w600),
                                                                    ),
                                                                    onPressed: () async {
                                                                      commonDialog(
                                                                        context: context,
                                                                        subtitle:
                                                                        'Are you sure want to disable admin?',
                                                                        title:
                                                                        'Disable Admin',
                                                                        onTap:
                                                                            () async {
                                                                          NavigatorRoute.navigateBack(context:  context);
                                                                          await controller.adminStatusUpdateAPI(
                                                                              adminId: controller.filteredAdminList[index].id ?? "",
                                                                              status: 'Rejected',
                                                                              context: context);
                                                                        },
                                                                      );
                                                                    }),
                                                              ),
                                                              const Gap(20),
                                                              SizedBox(
                                                                width: 120.w,
                                                                height: 35.h,
                                                                child: CommonButton(
                                                                    color: AppColors.white,
                                                                    radius: 5,
                                                                    widget: Text(
                                                                      'Approve',
                                                                      style: Theme.of(context)
                                                                          .textTheme
                                                                          .bodyMedium!
                                                                          .copyWith(
                                                                          color: AppColors.black,
                                                                          fontWeight: FontWeight.w600),
                                                                    ),
                                                                    onPressed: () async {

                                                                      await controller.adminStatusUpdateAPI(
                                                                          adminId: controller.filteredAdminList[index].id ??
                                                                              "",
                                                                          status:
                                                                          'Approved',
                                                                          context:
                                                                          context);
                                                                    }),
                                                              )
                                                            ],
                                                          )
                                                              : controller.selectedTab ==
                                                              1
                                                              ? GestureDetector(
                                                            onTap: () {
                                                              commonDialog(
                                                                context: context,
                                                                subtitle:
                                                                'Are you sure want to disable admin?',
                                                                title:
                                                                'Disable Admin',
                                                                onTap:
                                                                    () async {

                                                                  NavigatorRoute.navigateBack(context:  context);
                                                                  await controller.adminStatusUpdateAPI(
                                                                      adminId: controller.filteredAdminList[index].id ??
                                                                          "",
                                                                      status:
                                                                      'Rejected',
                                                                      context:
                                                                      context);
                                                                },
                                                              );
                                                            },
                                                            child:
                                                            SizedBox(
                                                              width:
                                                              120.w,
                                                              height:
                                                              35.h,
                                                              child:
                                                              Container(
                                                                alignment:
                                                                Alignment
                                                                    .center,
                                                                decoration:
                                                                BoxDecoration(
                                                                  color: AppColors
                                                                      .green
                                                                      .withValues(alpha:0.1),
                                                                  borderRadius:
                                                                  BorderRadius.circular(10),
                                                                ),
                                                                child:
                                                                Text(
                                                                  'Approved',
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .bodyMedium!
                                                                      .copyWith(
                                                                      color: AppColors.green,
                                                                      fontWeight: FontWeight.w600),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                              : GestureDetector(
                                                            onTap:
                                                                () async {
                                                              commonDialog(
                                                                context: context,
                                                                subtitle:
                                                                'Are you sure want to roll back disabled admin?',
                                                                title:
                                                                'Roll Back Admin',
                                                                onTap:
                                                                    () async {
                                                                  NavigatorRoute.navigateBack(context:  context);
                                                                  await controller.adminStatusUpdateAPI(
                                                                      adminId: controller.filteredAdminList[index].id ??
                                                                          "",
                                                                      status:
                                                                      'Pending',
                                                                      context:
                                                                      context);
                                                                },
                                                              );
                                                            },
                                                            child:
                                                            Container(
                                                              height:
                                                              35.h,
                                                              padding: const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                  10),
                                                              alignment:
                                                              Alignment
                                                                  .center,
                                                              decoration:
                                                              BoxDecoration(
                                                                color: AppColors
                                                                    .red
                                                                    .withValues(alpha:
                                                                    0.1),
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    10),
                                                              ),
                                                              child: Text(
                                                                'Disabled',
                                                                style: Theme.of(
                                                                    context)
                                                                    .textTheme
                                                                    .bodyMedium!
                                                                    .copyWith(
                                                                    color: AppColors.red,
                                                                    fontWeight: FontWeight.w600),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
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
                                        ],
                                      ),
                                    )
                                        : Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Gap(
                                          200.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'No Admin Found',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                  fontWeight:
                                                  FontWeight.w600,
                                                  color: AppColors.white),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            );
          }),
    );
  }
}
