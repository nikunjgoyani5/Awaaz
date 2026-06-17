import 'package:eagle_eye_admin/controller/dashboard_controller.dart';
import 'package:eagle_eye_admin/controller/report_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/page/dashboard_screen/components/header.dart';
import 'package:eagle_eye_admin/page/reports_screen/components/report_post_view.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/widget/common_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ReportDashboardView extends StatefulWidget {
  const ReportDashboardView({super.key});

  @override
  State<ReportDashboardView> createState() => _ReportDashboardViewState();
}

class _ReportDashboardViewState extends State<ReportDashboardView> {
  ReportController reportController = Get.find();
  DashboardController dashController = Get.find();

  @override
  void initState() {
    reportController.init(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProgressLoader pl = ProgressLoader(context, isDismissible: true);
    return GetBuilder<ReportController>(
        init: ReportController(),
        builder: (controller) {
          return Expanded(
            flex: 5,
            child: Stack(
              children: [
                SizedBox(
                    height: 500,
                    child:
                        FittedBox(child: Image.asset(Assets.image.mapBg.path))),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Header(),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          "Report",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white),
                        ).paddingSymmetric(horizontal: 20.w),
                        const Spacer(),
                        const ProfileCard(),
                      ],
                    ),
                    Gap(20.h),
                    controller.selectedSubTab == 0
                        ? Obx(
                            () {
                              return controller.loader.value
                                  ? Column(
                                      children: [
                                        Gap(350.h),
                                        Center(
                                            child: Lottie.asset(
                                                'assets/animation/loader.json',
                                                height: 100,
                                                width: 100,
                                                fit: BoxFit.cover)),
                                      ],
                                    )
                                  : Expanded(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.w),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: MediaQuery.of(context).size.height * 0.4,
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .eventCardBgColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    padding:
                                                        EdgeInsets.all(20.sp),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Profile",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyLarge!
                                                                      .copyWith(
                                                                          color: AppColors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                ),
                                                                Text(
                                                                  "(${controller.reportedUsersList.length})",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyLarge!
                                                                      .copyWith(
                                                                          color: AppColors
                                                                              .grey909090,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                ),
                                                              ],
                                                            ),
                                                            const Spacer(),
                                                            InkWell(
                                                              overlayColor:
                                                                  WidgetStateProperty
                                                                      .all(Colors
                                                                          .transparent),
                                                              onTap: () {
                                                                controller
                                                                        .selectedSubTab =
                                                                    3.3;
                                                                dashController
                                                                    .update();
                                                                controller
                                                                    .update();
                                                              },
                                                              child: Text(
                                                                "See all",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyLarge!
                                                                    .copyWith(
                                                                        color: AppColors
                                                                            .blue,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Gap(20.h),
                                                        controller
                                                            .reportedUsersList.isEmpty?

                                                        Column(

                                                          children: [
                                                            Gap(100.h),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  'No Reported Profile Found',
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .bodyMedium!
                                                                      .copyWith(
                                                                      fontWeight:
                                                                      FontWeight.w600,
                                                                      color:
                                                                      AppColors.white),
                                                                ),
                                                              ],
                                                            ),

                                                          ],

                                                        ) :

                                                        Expanded(
                                                          child: ListView
                                                              .separated(
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return ProfileReportTileView(
                                                                      onDelete:
                                                                          () async {
                                                                        NavigatorRoute
                                                                            .navigateBack(context:  context);
                                                                        await controller.userBlockAPICalling(
                                                                            pl:
                                                                                pl,
                                                                            userId: controller.reportedUsersList[index].reportedUserId ??
                                                                                '',
                                                                            context:
                                                                                context);
                                                                      },
                                                                      reportedUSer:
                                                                          controller
                                                                              .reportedUsersList[index],
                                                                    );
                                                                  },
                                                                  separatorBuilder:
                                                                      (context,
                                                                              index) =>
                                                                          Gap(20
                                                                              .h),
                                                                  itemCount: controller
                                                                              .reportedUsersList
                                                                              .length <=
                                                                          4
                                                                      ? controller
                                                                          .reportedUsersList
                                                                          .length
                                                                      : 4),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Gap(20.w),
                                                Expanded(
                                                  child: Container(
                                                    height: MediaQuery.of(context).size.height * 0.4,
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .eventCardBgColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    padding:
                                                        EdgeInsets.all(20.sp),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Comment",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyLarge!
                                                                      .copyWith(
                                                                          color: AppColors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                ),
                                                                Text(
                                                                  "(${controller.reportedCommentsList.length})",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyLarge!
                                                                      .copyWith(
                                                                          color: AppColors
                                                                              .grey909090,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                ),
                                                              ],
                                                            ),
                                                            const Spacer(),
                                                            InkWell(
                                                              overlayColor:
                                                                  WidgetStateProperty
                                                                      .all(Colors
                                                                          .transparent),
                                                              onTap: () {
                                                                controller
                                                                        .selectedSubTab =
                                                                    3.2;
                                                                controller
                                                                    .update();
                                                                dashController
                                                                    .update();
                                                              },
                                                              child: Text(
                                                                "See all",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyLarge!
                                                                    .copyWith(
                                                                        color: AppColors
                                                                            .blue,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Gap(20.h),
                                                        controller
                                                            .reportedCommentsList.isEmpty?

                                                        Column(

                                                          children: [
                                                            Gap(100.h),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  'No Reported Comment Found',
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .bodyMedium!
                                                                      .copyWith(
                                                                      fontWeight:
                                                                      FontWeight.w600,
                                                                      color:
                                                                      AppColors.white),
                                                                ),
                                                              ],
                                                            ),

                                                          ],

                                                        ) :       Expanded(
                                                          child: ListView
                                                              .separated(
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return CommentReportTileView(
                                                                      reportedComments:
                                                                          controller
                                                                              .reportedCommentsList[index],
                                                                    );
                                                                  },
                                                                  separatorBuilder:
                                                                      (context,
                                                                              index) =>
                                                                          Gap(20
                                                                              .h),
                                                                  itemCount: controller
                                                                              .reportedCommentsList
                                                                              .length <=
                                                                          4
                                                                      ? controller
                                                                          .reportedCommentsList
                                                                          .length
                                                                      : 4),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Gap(20.h),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 20.w),
                                              decoration: BoxDecoration(
                                                color:
                                                    AppColors.eventCardBgColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding: EdgeInsets.all(20.sp),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "Report Post",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .copyWith(
                                                                    color: AppColors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                          ),
                                                          Text(
                                                            "(${controller.reportedPostList.length})",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .copyWith(
                                                                    color: AppColors
                                                                        .grey909090,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                          ),
                                                        ],
                                                      ),
                                                      const Spacer(),
                                                      InkWell(
                                                        overlayColor:
                                                            WidgetStateProperty
                                                                .all(Colors
                                                                    .transparent),
                                                        onTap: () {
                                                          controller
                                                                  .selectedSubTab =
                                                              3.1;
                                                          controller.update();
                                                          dashController
                                                              .update();
                                                        },
                                                        child: Text(
                                                          "See all",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyLarge!
                                                              .copyWith(
                                                                  color:
                                                                      AppColors
                                                                          .blue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Gap(20.h),
                                             controller.reportedPostList.isEmpty?     Column(

                                                    children: [
                                                      Gap(100.h),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            'No Reported Post Found',
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .copyWith(
                                                                fontWeight:
                                                                FontWeight.w600,
                                                                color:
                                                                AppColors.white),
                                                          ),
                                                        ],
                                                      ),

                                                    ],

                                                  )  :    Expanded(
                                                    child: ListView.separated(
                                                        shrinkWrap: true,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return PostReportTileView(
                                                            onDelete: () async {


                                                              commonDialog(
                                                                context: context,
                                                                subtitle: 'Are you sure want to delete post?',
                                                                title: 'Delete Post',
                                                                onTap: () async {
                                                                  NavigatorRoute.navigateBack(context: context);
                                                                  NavigatorRoute.navigateBack(context: context);
                                                                  await controller.deletePostApiCalling(postId: controller
                                                                      .reportedPostList[
                                                                  index].postId??'', context: context, pl: pl);
                                                                },
                                                              );





                                                            },
                                                            reportedPost: controller
                                                                    .reportedPostList[
                                                                index],
                                                          );
                                                        },
                                                        separatorBuilder:
                                                            (context, index) =>
                                                                Gap(10.h),
                                                        itemCount: controller
                                                                    .reportedPostList
                                                                    .length <=
                                                                4
                                                            ? controller
                                                                .reportedPostList
                                                                .length
                                                            : 4),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                            },
                          )
                        : controller.selectedSubTab == 3.1
                            ? Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          overlayColor: WidgetStateProperty.all(
                                              Colors.transparent),
                                          radius: 0,
                                          onTap: () {
                                            controller.selectedSubTab = 0;
                                            controller.update();
                                          },
                                          child: Text(
                                            "Report",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: AppColors.white,
                                                    fontWeight:
                                                        FontWeight.w700),
                                          ),
                                        ),
                                        Gap(15.w),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 14.sp,
                                        ),
                                        Gap(15.w),
                                        Text(
                                          "Report Post",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: AppColors.blue,
                                                  fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ).paddingSymmetric(horizontal: 20.w),
                                    Gap(20.h),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 20.w),
                                        decoration: BoxDecoration(
                                          color: AppColors.eventCardBgColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: EdgeInsets.all(20.sp),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Report Post",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                          color:
                                                              AppColors.white,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                ),
                                                Text(
                                                  "(${controller.reportedPostList.length})",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                          color: AppColors
                                                              .grey909090,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                            Gap(20.h),
                                             controller
                                        .reportedPostList.isEmpty?
                                             Column(

                                              children: [
                                                Gap(350.h),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'No Reported Post Found',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          color:
                                                          AppColors.white),
                                                    ),
                                                  ],
                                                ),

                                              ],

                                            )   :   Expanded(
                                              child: GridView.builder(
                                                itemCount: controller
                                                    .reportedPostList.length,
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 4,
                                                  crossAxisSpacing: 20,
                                                  mainAxisSpacing: 20,
                                                  childAspectRatio: 1.8,
                                                ),
                                                itemBuilder: (context, index) {
                                                  return PostReportCardView(
                                                    onDelete: () async {


                                                      commonDialog(
                                                        context: context,
                                                        subtitle: 'Are you sure want to delete post?',
                                                        title: 'Delete Post',
                                                        onTap: () async {
                                                          NavigatorRoute.navigateBack(context: context);
                                                          NavigatorRoute.navigateBack(context: context);
                                                          await controller.deletePostApiCalling(postId: controller
                                                              .reportedPostList[
                                                          index].postId??'', context: context, pl: pl);
                                                        },
                                                      );






                                                    },
                                                    reportedPost: controller
                                                            .reportedPostList[
                                                        index],
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : controller.selectedSubTab == 3.2
                                ? Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            InkWell(
                                              overlayColor:
                                                  WidgetStateProperty.all(
                                                      Colors.transparent),
                                              radius: 0,
                                              onTap: () {
                                                controller.selectedSubTab = 0;
                                                controller.update();
                                              },
                                              child: Text(
                                                "Report",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: AppColors.white,
                                                        fontWeight:
                                                            FontWeight.w700),
                                              ),
                                            ),
                                            Gap(15.w),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 14.sp,
                                            ),
                                            Gap(15.w),
                                            Text(
                                              "Report Comment",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color: AppColors.blue,
                                                      fontWeight:
                                                          FontWeight.w700),
                                            ),
                                          ],
                                        ).paddingSymmetric(horizontal: 20.w),
                                        Gap(20.h),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 20.w),
                                            decoration: BoxDecoration(
                                              color: AppColors.eventCardBgColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: EdgeInsets.all(20.sp),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Report Comment ",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                              color: AppColors
                                                                  .white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                    Text(
                                                      "(${controller.reportedCommentsList.length})",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                              color: AppColors
                                                                  .grey909090,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                  ],
                                                ),
                                                Gap(20.h),
                                                controller
                                                    .reportedCommentsList.isEmpty?
                                                Column(

                                                  children: [
                                                    Gap(350.h),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          'No Reported Comment Found',
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .bodyMedium!
                                                              .copyWith(
                                                              fontWeight:
                                                              FontWeight.w600,
                                                              color:
                                                              AppColors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                                    :     Expanded(
                                                  child: GridView.builder(
                                                    itemCount: controller
                                                        .reportedCommentsList
                                                        .length,
                                                    gridDelegate:
                                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 4,
                                                      crossAxisSpacing: 20,
                                                      mainAxisSpacing: 20,
                                                      childAspectRatio: 1.8,
                                                    ),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return CommentReportCardView(

                                                        reportedComments: controller
                                                                .reportedCommentsList[
                                                            index],
                                                      );
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : controller.selectedSubTab == 3.3
                                    ? Expanded(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                InkWell(
                                                  overlayColor:
                                                      WidgetStateProperty.all(
                                                          Colors.transparent),
                                                  radius: 0,
                                                  onTap: () {
                                                    controller.selectedSubTab =
                                                        0;
                                                    controller.update();
                                                  },
                                                  child: Text(
                                                    "Report",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                            color:
                                                                AppColors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                  ),
                                                ),
                                                Gap(15.w),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 14.sp,
                                                ),
                                                Gap(15.w),
                                                Text(
                                                  "Report Profile",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          color: AppColors.blue,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                ),
                                              ],
                                            ).paddingSymmetric(
                                                horizontal: 20.w),
                                            Gap(20.h),
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                                decoration: BoxDecoration(
                                                  color: AppColors
                                                      .eventCardBgColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                padding: EdgeInsets.all(20.sp),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Report Profile ",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyLarge!
                                                              .copyWith(
                                                                  color:
                                                                      AppColors
                                                                          .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                        ),
                                                        Text(
                                                          "(${controller.reportedUsersList.length})",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyLarge!
                                                              .copyWith(
                                                                  color: AppColors
                                                                      .grey909090,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                        ),
                                                      ],
                                                    ),
                                                    Gap(20.h),


                                                    controller
                                                        .reportedUsersList.isEmpty?           Column(

                                                      children: [
                                                        Gap(350.h),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              'No Reported Profile Found',
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                  fontWeight:
                                                                  FontWeight.w600,
                                                                  color:
                                                                  AppColors.white),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ):
                                                    Expanded(
                                                      child: GridView.builder(
                                                        itemCount: controller
                                                            .reportedUsersList
                                                            .length,
                                                        gridDelegate:
                                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 4,
                                                          crossAxisSpacing: 20,
                                                          mainAxisSpacing: 20,
                                                          childAspectRatio: 1.7,
                                                        ),
                                                        itemBuilder:
                                                            (context, index) {
                                                          return ProfileReportCardView(
                                                            reportedUser: controller
                                                                    .reportedUsersList[
                                                                index],
                                                            onDelete: () async {
                                                              NavigatorRoute
                                                                  .navigateBack(context: context);
                                                              await controller.userBlockAPICalling(
                                                                  pl: pl,
                                                                  userId: controller
                                                                          .reportedUsersList[
                                                                              index]
                                                                          .reportedUserId ??
                                                                      '',
                                                                  context:
                                                                      context);

                                                            },
                                                          );
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox.shrink()
                  ],
                ),
              ],
            ),
          );
        });
  }
}
