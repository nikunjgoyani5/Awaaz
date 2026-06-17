import 'dart:async';

import 'package:eagle_eye_admin/controller/user_management_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/page/dashboard_screen/components/header.dart';
import 'package:eagle_eye_admin/page/user_management_screen/components/user_profile_card_view.dart';
import 'package:eagle_eye_admin/page/user_profile_screen/user_profile_view.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/widget/textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class UserManagementDashboardView extends StatefulWidget {
  const UserManagementDashboardView({super.key});

  @override
  State<UserManagementDashboardView> createState() =>
      _UserManagementDashboardViewState();
}

class _UserManagementDashboardViewState
    extends State<UserManagementDashboardView> {
  UserManagementController userManagementController = Get.find();

  openUserProfileView(
      {required BuildContext context, required String userId}) async {


    showDialog(
      context: context,
        routeSettings:
        const RouteSettings(name: '/userManagement/userProfile'),
      builder: (context) {
        return UserProfileView(
          userId: userId,
        );
      },
    );




  }

  @override
  void initState() {
    // init();
    super.initState();
  }

  Future init() async {
    userManagementController.searchController.clear();
    userManagementController.usersList.clear();
    userManagementController.pageNumber = 1;
    await userManagementController.getUsersAPI(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserManagementController>(

        initState: (state) {

        },
        builder: (controller) {

      return Expanded(
        flex: 5,
        child: Stack(
          children: [
            SizedBox(
                height: 500,
                child: FittedBox(child: Image.asset(Assets.image.mapBg.path))),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 85.h,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom:
                          BorderSide(color: AppColors.borderColor, width: 3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                          controller: controller.searchController,
                          onChanged: (value) async {
                            if (controller.debounce?.isActive ?? false) {
                              controller.debounce?.cancel();
                            }
                            controller.debounce =
                                Timer(const Duration(seconds: 1), () async {
                              userManagementController.usersList.clear();
                              userManagementController.pageNumber = 1;
                              await userManagementController.getUsersAPI(
                                context: context,
                                  searchText: value);
                            });
                          },
                        ),
                      ),
                      const Spacer(),
                      const ProfileCard()
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "User Manage",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w600, color: AppColors.white),
                ).paddingSymmetric(horizontal: 20.w),
                Gap(20.h),
                controller.loader.value
                    ? Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Wrap(
                            children: [
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: Lottie.asset(
                                    'assets/animation/loader.json',
                                    fit: BoxFit.cover,
                                    height: 50,
                                    width: 200),
                              ),
                            ],
                          ),
                        ),
                      )
                    : controller.usersList.isNotEmpty
                        ? Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "User Manage",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w700),
                                    ),
                                    Gap(15.w),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14.sp,
                                    ),
                                    Gap(15.w),
                                    Text(
                                      controller.selectedSubTab == 4.1
                                          ? "All Users"
                                          : 'Blocked Users',
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
                                  child: Stack(
                                    children: [
                                      NotificationListener(
                                        onNotification: (notification) {
                                          if (notification
                                                  is ScrollEndNotification &&
                                              notification
                                                      .metrics.extentAfter ==
                                                  0) {
                                            if ((controller.getAllUsersModel
                                                        .body?.page ??
                                                    0) <
                                                (controller.getAllUsersModel
                                                        .body?.totalPages ??
                                                    0)) {
                                              controller.userPagination(context: context);
                                            }
                                          }
                                          return false;
                                        },
                                        child: GridView.builder(
                                          shrinkWrap: true,
                                          itemCount:
                                              controller.usersList.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4,
                                            crossAxisSpacing: 20,
                                            mainAxisSpacing: 20,
                                            childAspectRatio: 1.8,
                                          ),
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                                onTap: () async {
                                                  await openUserProfileView(
                                                      context: context,
                                                      userId: controller
                                                              .usersList[index]
                                                              .id ??
                                                          '');
                                                },
                                                child: CurrentUserView(
                                                  userData: controller
                                                      .usersList[index],
                                                ));
                                          },
                                        ).paddingSymmetric(horizontal: 20.w),
                                      ),
                                      Obx(
                                        () {
                                          return controller
                                                  .paginationLoader.value
                                              ? const Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child:
                                                      LinearProgressIndicator(
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : const SizedBox.shrink();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Expanded(
                            child: Center(
                              child: Text(
                                'No Profile Found',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.white),
                              ),
                            ),
                          ),
                Gap(20.h),
              ],
            ),
          ],
        ),
      );
    });
  }
}
