import 'package:eagle_eye_admin/controller/rescue_detail_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/model/get_all_rescue_updates.dart';
import 'package:eagle_eye_admin/page/event_screen/component/event_image_preview_dialog.dart';
import 'package:eagle_eye_admin/page/event_screen/component/event_preview_dailoge.dart';
import 'package:eagle_eye_admin/page/user_profile_screen/user_profile_view.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/utils/app_image_viewer.dart';
import 'package:eagle_eye_admin/widget/app_network_image.dart';
import 'package:eagle_eye_admin/widget/button.dart';
import 'package:eagle_eye_admin/widget/common_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class RescueUpdateDailoge extends StatefulWidget {
  const RescueUpdateDailoge({super.key});

  @override
  State<RescueUpdateDailoge> createState() => _RescueUpdateDailogeState();
}

class _RescueUpdateDailogeState extends State<RescueUpdateDailoge>
    with TickerProviderStateMixin {
  GlobalKey key = GlobalKey();
  late TabController tabController;
  RescueDetailController rescueDetailController = Get.find();

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    rescueDetailController.getRescueUpdatesList(
        context: context, status: 'Pending');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RescueDetailController>(builder: (controller) {
      return Dialog(
        key: key,
        alignment: Alignment.topCenter,
        insetPadding: EdgeInsets.only(top: 50.h, bottom: 50.h),
        backgroundColor: AppColors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
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
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              DefaultTabController(
                initialIndex: 0,
                length: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        padding: EdgeInsets.all(2.sp),
                        width: 250.w,
                        height: 45.h,
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: TabBar(
                          controller: tabController,
                          dividerColor: AppColors.transparent,
                          indicatorSize: TabBarIndicatorSize.tab,
                          padding: EdgeInsets.zero,
                          indicatorPadding: EdgeInsets.zero,
                          labelPadding: EdgeInsets.zero,
                          indicator: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey,
                          labelStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white),
                          unselectedLabelStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.white),
                          tabs: const [
                            Tab(
                              text: "Update",
                            ),
                            Tab(
                              text: "Disapprove",
                            ),
                          ],
                          onTap: (value) {
                            setState(() async {
                              tabController.index = value;

                              if (tabController.index == 0) {
                                await rescueDetailController
                                    .getRescueUpdatesList(
                                        context: context, status: 'Pending');
                              } else if (tabController.index == 1) {
                                await rescueDetailController
                                    .getRescueUpdatesList(
                                        context: context, status: 'Rejected');
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    Gap(30.h),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Theme(
                            data: ThemeData(
                              scrollbarTheme: ScrollbarThemeData(
                                trackColor: WidgetStateProperty.all(AppColors
                                    .textFeildBorderColor
                                    .withValues(alpha: 0.5)),
                                thumbColor: WidgetStateProperty.all(
                                    AppColors.white.withValues(alpha: 0.2)),
                              ),
                            ),
                            child: Scrollbar(
                              radius: const Radius.circular(0),
                              trackVisibility: true,
                              scrollbarOrientation: ScrollbarOrientation.right,
                              thumbVisibility: true,
                              interactive: true,
                              controller:
                                  controller.rescueUpdateScrollController,
                              child: Obx(
                                () {
                                  return controller.rescueUpdateLoader.value ==
                                          true
                                      ? const Center(
                                          child: SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      : controller.rescueUpdatesList.isNotEmpty
                                          ? ListView.separated(
                                              controller: controller
                                                  .rescueUpdateScrollController,
                                              padding:
                                                  EdgeInsets.only(right: 15.w),
                                              itemBuilder: (context, index) {
                                                return RescueUpdatePostCard(
                                                  tabController: tabController,
                                                  rescueUpdateData: controller
                                                      .rescueUpdatesList[index],
                                                );
                                              },
                                              itemCount: controller
                                                  .rescueUpdatesList.length,
                                              separatorBuilder:
                                                  (context, index) => Gap(10.h),
                                            )
                                          : Center(
                                              child: Text(
                                                'No Rescue Update Found',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppColors.white),
                                              ),
                                            );
                                },
                              ),
                            ),
                          ),
                          Theme(
                            data: ThemeData(
                              scrollbarTheme: ScrollbarThemeData(
                                trackColor: WidgetStateProperty.all(AppColors
                                    .textFeildBorderColor
                                    .withValues(alpha: 0.5)),
                                thumbColor: WidgetStateProperty.all(
                                    AppColors.white.withValues(alpha: 0.2)),
                              ),
                            ),
                            child: Scrollbar(
                              radius: const Radius.circular(0),
                              trackVisibility: true,
                              scrollbarOrientation: ScrollbarOrientation.right,
                              thumbVisibility: true,
                              interactive: true,
                              controller:
                                  controller.rescueUpdateScrollController,
                              child: Obx(
                                () {
                                  return controller.rescueUpdateLoader.value ==
                                          true
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : controller.rescueUpdatesList.isNotEmpty
                                          ? ListView.separated(
                                              controller: controller
                                                  .rescueUpdateScrollController,
                                              padding:
                                                  EdgeInsets.only(right: 15.w),
                                              itemBuilder: (context, index) {
                                                return RescueUpdatePostCard(
                                                  tabController: tabController,
                                                  rescueUpdateData: controller
                                                      .rescueUpdatesList[index],
                                                );
                                              },
                                              itemCount: controller
                                                  .rescueUpdatesList.length,
                                              separatorBuilder:
                                                  (context, index) => Gap(10.h),
                                            )
                                          : Center(
                                              child: Text(
                                                'No Rescue Update Found',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppColors.white),
                                              ),
                                            );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 8.w,
                top: 5.h,
                child: IconButton(
                    onPressed: () {
                      NavigatorRoute.navigateBack(context: context);
                    },
                    icon: const Icon(Icons.close, color: AppColors.white)),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class RescueUpdatePostCard extends StatelessWidget {
  final TabController? tabController;
  final RescueUpdateData rescueUpdateData;

  const RescueUpdatePostCard(
      {super.key, required this.tabController, required this.rescueUpdateData});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RescueDetailController>(builder: (controller) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.eventCardBgColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    radius: 0,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return UserProfileView(
                            userId: rescueUpdateData.userId ?? "",
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        ClipOval(
                          child: Image.network(
                              rescueUpdateData.profilePicture ?? "",
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                            return AppImageViewer.showAssetImage(
                              path: Assets.image.noDataSelected.path,
                              height: 40,
                              width: 40,
                              boxFit: BoxFit.cover,
                            );
                          }),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16 / 2),
                          child: Text(
                            rescueUpdateData.name ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(20),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (rescueUpdateData.attachmentFileType == 'Video') {
                        showDialog(
                          context: context,
                          routeSettings:
                              const RouteSettings(name: '/event/eventPreview'),
                          builder: (context) {
                            return EventPreviewDailoge(
                                videoPath: rescueUpdateData.attachment ?? '');
                          },
                        );
                      } else if (rescueUpdateData.attachmentFileType ==
                          'Image') {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return EventImagePreviewDialog(
                              imageURL: rescueUpdateData.attachment ?? '',
                            );
                          },
                        );
                      } else {}
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: AppNetworkImageLoader(
                            url: rescueUpdateData.thumbnail ?? "",
                            height: MediaQuery.of(context).size.height * 0.085,
                            width: MediaQuery.of(context).size.width * 0.045,
                            boxFit: BoxFit.cover,
                          ),
                        ),
                        (rescueUpdateData.attachmentFileType == 'Video')
                            ? Assets.icons.icPlay.svg()
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rescueUpdateData.description ?? '',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      const Gap(10),
                      Row(
                        children: [
                          (rescueUpdateData.address?.isNotEmpty ?? false)
                              ? Assets.icons.icLocation.svg()
                              : const SizedBox(),
                          SizedBox(
                            width: 180,
                            child: Text(
                              rescueUpdateData.address ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: AppColors.grey929da9,
                                      fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
                  Gap(20.w),
                  (tabController!.index == 0)
                      ? Row(
                          children: [
                            SizedBox(
                              width: 120.w,
                              height: 35.h,
                              child: CommonButton(
                                  color: AppColors.borderColor,
                                  radius: 5,
                                  widget: Text(
                                    'Disapprove',
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
                                      subtitle: 'Are you sure want to reject?',
                                      title: 'Disapprove',
                                      onTap: () async {
                                        NavigatorRoute.navigateBack(
                                            context: context);
                                        await controller
                                            .updateRescueUpdateStatus(
                                          status: 'Rejected',
                                          context: context,
                                          rescueUpdateId:
                                              rescueUpdateData.id ?? '',
                                          eventId: controller
                                                  .getSingleRescueData.id ??
                                              "",
                                        )
                                            .then(
                                          (value) async {
                                            await controller
                                                .getRescueUpdatesList(
                                                    context: context,
                                                    status: 'Pending');
                                          },
                                        );
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
                                  'Update',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w600),
                                ),
                                onPressed: () async {
                                  controller.fillData(rescueUpdateData);
                                  await controller.openAddTimeLineDailoge(
                                      context, 'Update',controller.getSingleRescueData.id??'');
                                },
                              ),
                            )
                          ],
                        )
                      : GestureDetector(
                          onTap: () {
                            commonDialog(
                              context: context,
                              subtitle: 'Are you sure want to rollback?',
                              title: 'Rollback changes',
                              onTap: () async {
                                NavigatorRoute.navigateBack(context: context);
                                await controller
                                    .updateRescueUpdateStatus(
                                  status: 'Pending',
                                  context: context,
                                  rescueUpdateId: rescueUpdateData.id ?? '',
                                  eventId:
                                      controller.getSingleRescueData.id ?? "",
                                )
                                    .then(
                                  (value) async {
                                    await controller.getRescueUpdatesList(
                                        context: context, status: 'Rejected');
                                  },
                                );
                              },
                            );
                          },
                          child: SizedBox(
                            width: 130.w,
                            height: 35.h,
                            child: Container(
                              alignment: AlignmentDirectional.center,
                              decoration: BoxDecoration(
                                color: AppColors.red.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'Disapproved',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: AppColors.red,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        )
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
