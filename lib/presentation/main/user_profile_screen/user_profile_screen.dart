import 'package:eagle_eye/core/constant/app_constant.dart';
import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/widget/common_app_bar.dart';
import 'package:eagle_eye/data/models/other_user_profile_model.dart';
import 'package:eagle_eye/presentation/main/chat_screen/chat_details_screen.dart';
import 'package:eagle_eye/presentation/main/news_details_screen/news_details_screen.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/text_styles.dart';
import '../../../core/utils/app_functions.dart';
import '../../../core/utils/app_prefrence.dart';
import '../../../core/widget/app_network_image_loader.dart';
import '../../../core/widget/common_bottom_sheet.dart';
import '../../../core/widget/common_popup_menu_button.dart';
import '../../../core/widget/video_player_pageview.dart';
import '../../../gen/assets.gen.dart';
import '../my_profile_screen/widget/post_loading_shimmer_widget.dart';
import 'bloc/user_profile_cubit.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with TickerProviderStateMixin {
  int currentIndex = 0;
  late TabController tabController;
  bool isImage(String url) {
    return url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg') ||
        url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.gif') ||
        url.toLowerCase().endsWith('.webp');
  }

  bool isVideo(String url) {
    return url.toLowerCase().endsWith('.mp4') ||
        url.toLowerCase().endsWith('.mov') ||
        url.toLowerCase().endsWith('.avi') ||
        url.toLowerCase().endsWith('.mkv') ||
        url.toLowerCase().endsWith('.webm');
  }

  @override
  void initState() {
    FirebaseEvents.setFirebaseEvent('user_profile_screen', {});
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppCommonAppBar(
        title: '',
        action: [
          BlocBuilder<UserProfileCubit, UserProfileState>(
              builder: (context, state) {
            if (state.otherUserProfileData?.id !=
                PrefService.getString(PrefService.userId)) {
              return AppPopupMenuButton(
                onOpened: () {
                  FirebaseEvents.setFirebaseEvent('user_profile_more_btn', {});
                },
                popupMenuItems: [
                  PopupMenuItem(
                    child: Text(
                      'Report',
                      style: TextStyles.regular(17.sp,
                          fontColor: AppColors.whiteColor),
                    ),
                    onTap: () {
                      context.read<UserProfileCubit>().init();
                      showAppBottomSheet(
                        context,
                        AppCommonBottomSheet(
                          sheetBGColor: AppColors.actionBtnBgColor,
                          body: ReportUserMainBottomSheet(),
                          isOpenWithGradient: false,
                        ),
                      );
                    },
                  ),
                  PopupMenuItem(
                    child: Text(
                      (state.otherUserProfileData?.isBlocked ?? true)
                          ? 'Unblock'
                          : 'Block',
                      style: TextStyles.regular(17.sp,
                          fontColor: AppColors.whiteColor),
                    ),
                    onTap: () {
                      context
                          .read<UserProfileCubit>()
                          .blockUser(isFromProfile: true, context: context);
                    },
                  ),
                ],
              );
            }
            return SizedBox();
          }),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 30.h),
          BlocBuilder<UserProfileCubit, UserProfileState>(
            builder: (context, state) {
              return Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.actionBtnBgColor,
                ),
                child: AppNetworkImageLoader(
                  url: state.otherUserProfileData?.profilePicture ?? '',
                  boxFit: BoxFit.cover,
                  placeHolderIMAGE: Assets.images.imgUserPlc,
                  borderRadius: 300.r,
                ),
              );
            },
          ),
          SizedBox(height: 10.h),
          BlocBuilder<UserProfileCubit, UserProfileState>(
            builder: (context, state) {
              return SizedBox(
                width: 180.w,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 20.h,
                    ),
                    child: Text(
                      state.otherUserProfileData?.name ?? 'User',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyles.bold(30.sp,
                          fontWeight: FontWeight.w900,
                          fontFamily: testTiemposHeadline),
                    ),
                  ),
                ),
              );
            },
          ),
          BlocBuilder<UserProfileCubit, UserProfileState>(
            builder: (context, state) {
              return SizedBox(
                width: 180.w,
                child: Center(
                  child: Text(
                    '@${state.otherUserProfileData?.username ?? 'username'}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyles.regular(18.sp,
                        fontWeight: FontWeight.w500,
                        fontColor: AppColors.textHintGrayColor),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 10.h),
          BlocBuilder<UserProfileCubit, UserProfileState>(
            builder: (context, state) {
              if (state.otherUserProfileData?.id !=
                  PrefService.getString(PrefService.userId)) {
                return OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDetailsScreen(
                            toUserData: state.otherUserProfileData ??
                                OtherUserProfileData(),
                            isRequestPage: false,
                          ),
                        ));
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.popUpTextFieldBlackColor,
                    side: BorderSide.none,
                    shape: BeveledRectangleBorder(
                        side: BorderSide.none,
                        borderRadius: BorderRadius.circular(5.r)),
                    fixedSize: Size(150.w, 45.h),
                    minimumSize: Size(150.w, 45.h),
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                  ),
                  child: Text(
                    "Message",
                    style: TextStyles.semiBold(18.sp),
                  ),
                );
              }
              return SizedBox();
            },
          ),
          // Address widget
          /* BlocBuilder<UserProfileCubit, UserProfileState>(
            builder: (context, state) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 1.h,
                  ),
                  child: Text(
                    state.otherUserProfileData?.name ?? 'User',
                    style: TextStyles.medium(
                      20.sp,
                      fontColor: AppColors.textHintGrayColor,
                    ),
                  ),
                ),
              );
            },
          ),*/
          SizedBox(height: 20.h),
          Container(
            decoration: BoxDecoration(
              border: Border.symmetric(
                  horizontal: BorderSide(
                color: AppColors.actionBtnBgColor,
              )),
            ),
            child: TabBar(
                controller: tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                padding: EdgeInsets.zero,
                labelColor: AppColors.whiteColor,
                unselectedLabelColor: AppColors.textHintGrayColor,
                dividerColor: Colors.transparent,
                indicatorColor: Colors.black,
                labelPadding: EdgeInsets.symmetric(vertical: 1),
                onTap: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Assets.icons.icVerified.svg(
                            colorFilter: ColorFilter.mode(
                          currentIndex == 0
                              ? AppColors.whiteColor
                              : AppColors.textHintGrayColor,
                          BlendMode.srcIn,
                        )),
                        SizedBox(
                          width: 8.w,
                        ),
                        BlocBuilder<UserProfileCubit, UserProfileState>(
                          builder: (context, state) {
                            return Text(
                              state.otherUserProfileData?.verifiedEventCounts !=
                                      null
                                  ? 'Verified (${state.otherUserProfileData!.verifiedEventCounts})'
                                  : 'Verified (0)',
                              style: TextStyles.regular(20.sp,
                                  fontColor: currentIndex == 0
                                      ? AppColors.whiteColor
                                      : AppColors.textHintGrayColor),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Assets.icons.icAllBroadcasts.svg(
                            colorFilter: ColorFilter.mode(
                          currentIndex == 1
                              ? AppColors.whiteColor
                              : AppColors.textHintGrayColor,
                          BlendMode.srcIn,
                        )),
                        SizedBox(
                          width: 8.w,
                        ),
                        BlocBuilder<UserProfileCubit, UserProfileState>(
                          builder: (context, state) {
                            return Text(
                              state.otherUserProfileData?.allBroadcastCounts !=
                                      null
                                  ? 'All Broadcasts (${state.otherUserProfileData!.allBroadcastCounts})'
                                  : 'All Broadcasts (0)',
                              style: TextStyles.regular(20.sp,
                                  fontColor: currentIndex == 1
                                      ? AppColors.whiteColor
                                      : AppColors.textHintGrayColor),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
          Expanded(
            child: TabBarView(controller: tabController, children: [
              // Verified
              BlocBuilder<UserProfileCubit, UserProfileState>(
                builder: (context, state) {
                  return state.isLoading
                      ? PostLoadingShimmerWidget()
                      : GridView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 7.h),
                          itemCount: state.otherUserProfileData
                                  ?.verifiedEventPosts?.length ??
                              0,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                  crossAxisCount: 3),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                FirebaseEvents.setFirebaseEvent(
                                    'click_user_profile_video', {});
                                if (isImage(state
                                        .otherUserProfileData
                                        ?.verifiedEventPosts?[index]
                                        .attachment ??
                                    '')) {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NetworkImageScreen(
                                        imageUrl: state
                                                .otherUserProfileData
                                                ?.verifiedEventPosts?[index]
                                                .attachment ??
                                            '',
                                      ),
                                    ),
                                  );
                                } else if (isVideo(state
                                        .otherUserProfileData
                                        ?.verifiedEventPosts?[index]
                                        .attachment ??
                                    '')) {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VideoPlayerPageView(
                                        sensetiveContent: state
                                            .otherUserProfileData
                                            ?.verifiedEventPosts?[index]
                                            .isSensitiveContent,
                                        videoUrl: state
                                                .otherUserProfileData
                                                ?.verifiedEventPosts?[index]
                                                .attachment ??
                                            '',
                                        contentType: 'video',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: AppNetworkImageLoader(
                                url: state
                                        .otherUserProfileData
                                        ?.verifiedEventPosts?[index]
                                        .thumbnail ??
                                    '',
                                boxFit: BoxFit.cover,
                                borderRadius: 0,
                              ),
                            );
                          },
                        );
                },
              ),
              // All Broadcasts
              BlocBuilder<UserProfileCubit, UserProfileState>(
                builder: (context, state) {
                  return state.isLoading
                      ? PostLoadingShimmerWidget()
                      : GridView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 7.h),
                          itemCount: state.otherUserProfileData?.allBroadcasts
                                  ?.length ??
                              0,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                  crossAxisCount: 3),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                FirebaseEvents.setFirebaseEvent(
                                    'click_user_profile_video', {});
                                if (isImage(state.otherUserProfileData
                                        ?.allBroadcasts?[index].attachment ??
                                    '')) {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NetworkImageScreen(
                                        imageUrl: state
                                                .otherUserProfileData
                                                ?.allBroadcasts?[index]
                                                .attachment ??
                                            '',
                                      ),
                                    ),
                                  );
                                } else if (isVideo(state.otherUserProfileData
                                        ?.allBroadcasts?[index].attachment ??
                                    '')) {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VideoPlayerPageView(
                                        sensetiveContent: state
                                            .otherUserProfileData
                                            ?.allBroadcasts?[index]
                                            .isSensitiveContent,
                                        videoUrl: state
                                                .otherUserProfileData
                                                ?.allBroadcasts?[index]
                                                .attachment ??
                                            '',
                                        contentType: 'video',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: AppNetworkImageLoader(
                                url: state.otherUserProfileData
                                        ?.allBroadcasts?[index].thumbnail ??
                                    '',
                                boxFit: BoxFit.cover,
                                borderRadius: 0,
                              ),
                            );
                          },
                        );
                },
              ),
            ]),
          )
        ],
      ),
    );
  }
}
