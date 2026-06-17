import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:eagle_eye_admin/api/repository/report_repository.dart';
import 'package:eagle_eye_admin/api/repository/user_repository.dart';

import 'package:eagle_eye_admin/controller/user_management_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/model/app_user_profile_model.dart';
import 'package:eagle_eye_admin/model/response_model.dart';
import 'package:eagle_eye_admin/page/event_screen/component/event_preview_dailoge.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/widget/app_network_image.dart';
import 'package:eagle_eye_admin/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class UserProfileView extends StatefulWidget {
  final String userId;

  const UserProfileView({super.key, required this.userId});

  @override
  UserProfileViewState createState() => UserProfileViewState();
}

class UserProfileViewState extends State<UserProfileView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  int selectedTab = 0;
  bool isPopupOpen = false;
  RxBool loader = false.obs;

  GetAppUserProfileData getAppUserProfile = GetAppUserProfileData();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    togglePopup();

    init();
  }

  init() async {
    await getUserProfileView(userId: widget.userId, context: context);
  }

  Future<void> getUserProfileView(
      {required String userId, required BuildContext context})

  async {
    try {
      loader.value = true;
      ResponseModel res = await UserRepository.getUserProfile(userId: userId,context: context);

      if (res.status == true) {
        getAppUserProfile = GetAppUserProfileData.fromJson(res.body);
        log('Get User:- $res');
      } else {
        showToast(
            context: context,
            title: 'User',
            message: res.message,
            bgColor: AppColors.red);
        log('Get User : - $res');
      }
      setState(() {});
      loader.value = false;
    } catch (e) {
      loader.value = false;
      log('Get USer :- $e');
    }
  }

  Future userBlockAPICalling({
    required String userId,
  }) async {
    try {
      UserManagementController userController = Get.find();
      ResponseModel res =
          await ReportRepository.userBlockUnblock(userId: userId,context: context);
      if (res.status == true) {
        NavigatorRoute.navigateBack(context:  context);
        showToast(context: context, title: 'User', message: res.message);
        setState(() {});
        userController.usersList.clear();
        userController.pageNumber =1;
        userController.searchController.clear();
        await userController.getUsersAPI(context: context);
        userController.update();
      } else {
        showToast(
            context: context,
            title: 'User',
            message: res.message,
            bgColor: AppColors.red);
        log('Block unblock Users:- ${res.message}');
      }
      loader.value = false;
    } catch (e) {
      loader.value = false;
      showToast(
          context: context,
          title: 'User',
          message: 'Something went wrong!',
          bgColor: AppColors.red);

      log('Block unblock Users:- $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void togglePopup() {
    setState(() {
      isPopupOpen = !isPopupOpen;
    });

    if (isPopupOpen) {
      _animationController.forward();
    } else {
      _animationController.reverse();
      NavigatorRoute.navigateBack(context:  context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        DefaultTabController(
          length: 2,
          child: SlideTransition(
            position: _slideAnimation,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.30,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: AppColors.borderColor,
                ),
                child: buildProfileContent(getAppUserProfile),
              ),
            ),
          ),
        ),
        Obx(
          () {
            return loader.value
                ? const Padding(
                    padding: EdgeInsets.only(right: 200),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Container();
          },
        )
      ],
    );
  }

  Widget buildProfileContent(GetAppUserProfileData getAppUserProfile) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: AppColors.borderColor,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(10.sp),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: togglePopup,
                        ),
                        Expanded(
                          child: Text(
                            getAppUserProfile.name ?? '',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600),
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<int>(
                            customButton: Assets.icons.icMenu.svg(),
                            buttonStyleData: ButtonStyleData(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                            ),
                            items: [
                              DropdownMenuItem<int>(
                                value: 0,
                                onTap: () {
                                  userBlockAPICalling(userId: widget.userId);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text(
                                    getAppUserProfile.isBlocked ? "Unblock" : 'Block',
                                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              if (value == 0) {}
                            },
                            dropdownStyleData: DropdownStyleData(
                              padding: EdgeInsets.zero,
                              maxHeight: 200.h,
                              width: 150.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.textFeildBorderColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha:0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              offset: const Offset(-80, -2),
                              elevation: 4,
                              useRootNavigator: true,
                              scrollbarTheme: ScrollbarThemeData(
                                thumbColor: WidgetStateProperty.all(AppColors.borderColor),
                                radius: const Radius.circular(20),
                                thickness: WidgetStateProperty.all(4),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              padding:
                              EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Gap(30.h),
                    ClipOval(
                      child: Container(
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        height: 120.w,
                        width: 120.w,
                        child: AppNetworkImageLoader(
                          url: getAppUserProfile.profilePicture ?? '',
                          boxFit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Gap(50.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildStat(
                            getAppUserProfile.allBroadcastCounts?.toString() ??
                                '0',
                            "BROADCASTS"),
                        buildStat(
                            getAppUserProfile.verifiedEventCounts?.toString() ??
                                '0',
                            "VERIFIED"),
                        buildStat(
                            getAppUserProfile.totalApprovedEventViews
                                    ?.toString() ??
                                '0',
                            "VIEWS"),
                      ],
                    ),
                    Gap(30.h),
                  ],
                ),
              ),
              Container(
                height: 50.h,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors.tabBarBorderColor),
                    bottom: BorderSide(color: AppColors.tabBarBorderColor),
                  ),
                ),
                child: TabBar(
                  onTap: (value) {
                    setState(() {
                      selectedTab = value;
                    });
                  },
                  labelPadding: EdgeInsets.zero,
                  indicatorPadding: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  indicatorColor: AppColors.white,
                  indicatorWeight: 0.01,
                  automaticIndicatorColorAdjustment: false,
                  overlayColor:
                      const WidgetStatePropertyAll(AppColors.transparent),
                  tabs: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Assets.icons.icVideoVerify.svg(
                            height: 25.h,
                            width: 25.w,
                            colorFilter: ColorFilter.mode(
                              selectedTab == 0
                                  ? AppColors.white
                                  : AppColors.grey909090,
                              BlendMode.srcIn,
                            )),
                        Gap(10.w),
                        Text(
                          'Verified(${getAppUserProfile.verifiedEventCounts?.toString() ?? 0})',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  color: selectedTab == 0
                                      ? AppColors.white
                                      : AppColors.grey909090,
                                  fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Assets.icons.icAllBroadcast.svg(
                            height: 25.h,
                            width: 25.w,
                            colorFilter: ColorFilter.mode(
                              selectedTab == 1
                                  ? AppColors.white
                                  : AppColors.grey909090,
                              BlendMode.srcIn,
                            )),
                        Gap(10.w),
                        Text(
                          'All Broadcasts(${getAppUserProfile.allBroadcastCounts?.toString() ?? 0})',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  color: selectedTab == 1
                                      ? AppColors.white
                                      : AppColors.grey909090,
                                  fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Gap(10.h),
              Expanded(
                child: TabBarView(
                  children: [
                    (getAppUserProfile.verifiedEventPosts?.isNotEmpty ?? false)
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: GridView.builder(
                              itemCount: getAppUserProfile
                                      .verifiedEventPosts?.length ??
                                  0,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                childAspectRatio: 0.8,
                              ),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    showDialog(
                                      context: context,

                                      builder: (context) {
                                        return EventPreviewDailoge(
                                            videoPath: getAppUserProfile
                                                .verifiedEventPosts?[index]
                                                .attachment ??
                                                '')
                                            ;
                                      },
                                    );





                                  },
                                  child: SizedBox(
                                    height: 100.h,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(2),
                                      child: AppNetworkImageLoader(
                                        url: getAppUserProfile
                                                .verifiedEventPosts?[index]
                                                .thumbnail ??
                                            '',
                                        boxFit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Text(
                              'No Data Found',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.white),
                            ),
                          ),
                    (getAppUserProfile.allBroadcasts?.isNotEmpty ?? false)
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: GridView.builder(
                              itemCount:
                                  getAppUserProfile.allBroadcasts?.length ?? 0,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                childAspectRatio: 0.8,
                              ),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    getAppUserProfile
                                            .allBroadcasts?[index].attachment ??
                                        '';
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(2),
                                    child: AppNetworkImageLoader(
                                      url: getAppUserProfile
                                              .allBroadcasts?[index]
                                              .thumbnail ??
                                          '',
                                      boxFit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Text(
                              'No Data Found',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.white),
                            ),
                          ),
                  ],
                ),
              )
            ],
          ),

        ],
      ),
    );
  }

  Widget buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: AppColors.white, fontWeight: FontWeight.w600),
        ),
        Gap(2.h),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: AppColors.grey909090, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
