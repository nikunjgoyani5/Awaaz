import 'package:eagle_eye/core/constant/app_constant.dart';
import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/widget/video_player_pageview.dart';
import 'package:eagle_eye/presentation/main/edit_profile_screen/bloc/edit_profile_cubit.dart';
import 'package:eagle_eye/presentation/main/my_profile_screen/bloc/bloc/my_profile_cubit.dart';
import 'package:eagle_eye/routes/app_navigation.dart';
import 'package:eagle_eye/routes/app_routes.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widget/app_common_loader_screen.dart';
import '../../../core/widget/app_network_image_loader.dart';
import '../../../gen/assets.gen.dart';
import '../news_details_screen/bloc/news_details_screen_bloc_cubit.dart';
import 'widget/post_loading_shimmer_widget.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    FirebaseEvents.setFirebaseEvent('my_profile_screen', {});
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    context.read<MyProfileCubit>().setProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyProfileCubit, MyProfileState>(
        buildWhen: (previous, current) =>
            previous.isLoading != current.isLoading,
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                AppCommonLoaderScreen(
                  inAsyncCall: false,
                  child: Column(
                    children: [
                      SizedBox(height: 60.h),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              FirebaseEvents.setFirebaseEvent(
                                  'click_edit_profile_btn', {});
                              await context.read<EditProfileCubit>().init();
                              await NavigatorRoute.navigateTo(
                                  context, AppRoutes.editProfile);
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.actionBtnBgColor,
                              ),
                              child: AppNetworkImageLoader(
                                url: state.profilePic,
                                boxFit: BoxFit.cover,
                                placeHolderIMAGE: Assets.images.imgUserPlc,
                                borderRadius: 300.r,
                              ),
                            ),
                          ),
                          Positioned(
                            right: -5,
                            bottom: 0,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async {
                                FirebaseEvents.setFirebaseEvent(
                                    'click_edit_profile_btn', {});
                                await context.read<EditProfileCubit>().init();
                                await NavigatorRoute.navigateTo(
                                    context, AppRoutes.editProfile);
                              },
                              child: Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.blackColor,
                                ),
                                child: Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.whiteColor,
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: AppColors.blackColor,
                                      size: 16.sp,
                                    )),
                              ),
                            ),
                          )
                        ],
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 20.h, left: 20.w, right: 20.w),
                          child: Text(
                            state.name.isEmpty ? 'User' : state.name,
                            maxLines: 2,
                            style: TextStyles.bold(28.sp,
                                textOverflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w900,
                                fontFamily: testTiemposHeadline),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          state.userName.isEmpty
                              ? '@username'
                              : '@${state.userName}',
                          maxLines: 2,
                          style: TextStyles.bold(
                            16.sp,
                            textOverflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w400,
                            fontColor: AppColors.textHintGrayColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 60.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                BlocBuilder<MyProfileCubit, MyProfileState>(
                                  buildWhen: (previous, current) =>
                                      previous.myProfile != current.myProfile,
                                  builder: (context, state) {
                                    return Text(
                                      state.myProfile?.allBroadcastCounts ??
                                          '0',
                                      style: TextStyles.bold(20.sp,
                                          fontFamily: testTiemposHeadline),
                                    );
                                  },
                                ),
                                Text(
                                  'BROADCASTS',
                                  style: TextStyles.regular(14.sp,
                                      fontColor: AppColors.textHintGrayColor),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 25),
                              child: Column(
                                children: [
                                  BlocBuilder<MyProfileCubit, MyProfileState>(
                                    buildWhen: (previous, current) =>
                                        previous.myProfile != current.myProfile,
                                    builder: (context, state) {
                                      return Text(
                                        state.myProfile?.verifiedEventCounts ??
                                            '0',
                                        style: TextStyles.bold(20.sp,
                                            fontFamily: testTiemposHeadline),
                                      );
                                    },
                                  ),
                                  Text(
                                    'VERIFIED',
                                    style: TextStyles.regular(14.sp,
                                        fontColor: AppColors.textHintGrayColor),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                BlocBuilder<MyProfileCubit, MyProfileState>(
                                  buildWhen: (previous, current) =>
                                      previous.myProfile != current.myProfile,
                                  builder: (context, state) {
                                    return Text(
                                      state.myProfile
                                              ?.totalApprovedEventViews ??
                                          '0',
                                      style: TextStyles.bold(20.sp,
                                          fontFamily: testTiemposHeadline),
                                    );
                                  },
                                ),
                                Text(
                                  'VIEWS',
                                  style: TextStyles.regular(14.sp,
                                      fontColor: AppColors.textHintGrayColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
                          labelColor: AppColors.whiteColor,
                          unselectedLabelColor: AppColors.textHintGrayColor,
                          dividerColor: Colors.transparent,
                          indicatorColor: Colors.black,
                          padding: EdgeInsets.zero,
                          tabAlignment: TabAlignment.start,
                          labelPadding:
                              EdgeInsets.symmetric(vertical: 1, horizontal: 16),
                          onTap: (value) async {
                            context.read<MyProfileCubit>().changeIndex(value);
                            if (value == 2) {
                              await context
                                  .read<MyProfileCubit>()
                                  .getProfileData();
                            }
                          },
                          isScrollable: true,
                          tabs: [
                            BlocBuilder<MyProfileCubit, MyProfileState>(
                              buildWhen: (previous, current) =>
                                  previous.currentIndex != current.currentIndex,
                              builder: (context, state) {
                                return Tab(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Assets.icons.icAllBroadcasts.svg(
                                          // height: 25.h,
                                          // width: 25.w,
                                          colorFilter: ColorFilter.mode(
                                        state.currentIndex == 0
                                            ? AppColors.whiteColor
                                            : AppColors.textHintGrayColor,
                                        BlendMode.srcIn,
                                      )),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Text(
                                        'All Post',
                                        style: TextStyles.regular(20.sp,
                                            fontColor: state.currentIndex == 0
                                                ? AppColors.whiteColor
                                                : AppColors.textHintGrayColor),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            BlocBuilder<MyProfileCubit, MyProfileState>(
                              buildWhen: (previous, current) =>
                                  previous.currentIndex != current.currentIndex,
                              builder: (context, state) {
                                return Tab(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Assets.icons.icVerified.svg(
                                          // height: 25.h,
                                          // width: 25.w,
                                          colorFilter: ColorFilter.mode(
                                        state.currentIndex == 1
                                            ? AppColors.whiteColor
                                            : AppColors.textHintGrayColor,
                                        BlendMode.srcIn,
                                      )),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Text(
                                        'Verified',
                                        style: TextStyles.regular(20.sp,
                                            fontColor: state.currentIndex == 1
                                                ? AppColors.whiteColor
                                                : AppColors.textHintGrayColor),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            BlocBuilder<MyProfileCubit, MyProfileState>(
                              buildWhen: (previous, current) =>
                                  previous.currentIndex != current.currentIndex,
                              builder: (context, state) {
                                return Tab(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Assets.icons.icSavedPost.svg(
                                          // height: 25.h,
                                          // width: 25.w,
                                          colorFilter: ColorFilter.mode(
                                        state.currentIndex == 2
                                            ? AppColors.whiteColor
                                            : AppColors.textHintGrayColor,
                                        BlendMode.srcIn,
                                      )),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Text(
                                        'Saved',
                                        style: TextStyles.regular(20.sp,
                                            fontColor: state.currentIndex == 2
                                                ? AppColors.whiteColor
                                                : AppColors.textHintGrayColor),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            BlocBuilder<MyProfileCubit, MyProfileState>(
                              buildWhen: (previous, current) =>
                                  previous.currentIndex != current.currentIndex,
                              builder: (context, state) {
                                return Tab(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Assets.icons.icDraft1.svg(
                                          // height: 25.h,
                                          // width: 25.w,
                                          colorFilter: ColorFilter.mode(
                                        state.currentIndex == 3
                                            ? AppColors.whiteColor
                                            : AppColors.textHintGrayColor,
                                        BlendMode.srcIn,
                                      )),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Text(
                                        'All Draft',
                                        style: TextStyles.regular(20.sp,
                                            fontColor: state.currentIndex == 3
                                                ? AppColors.whiteColor
                                                : AppColors.textHintGrayColor),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            BlocBuilder<MyProfileCubit, MyProfileState>(
                              builder: (context, state) {
                                return state.isLoading
                                    ? PostLoadingShimmerWidget()
                                    : Visibility(
                                        visible: state.myProfile?.allBroadcasts
                                                ?.isNotEmpty ??
                                            false,
                                        replacement: Center(
                                          child: Text('No post found'),
                                        ),
                                        child: GridView.builder(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4.w, vertical: 7.h),
                                          itemCount: state.myProfile
                                                  ?.allBroadcasts?.length ??
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
                                                    'click_my_profile_video',
                                                    {});
                                                if (!mounted) return;
                                                if (state
                                                        .myProfile
                                                        ?.allBroadcasts?[index]
                                                        .adminCreatedPostId
                                                        ?.isNotEmpty ??
                                                    false) {
                                                  context
                                                      .read<
                                                          NewsDetailsScreenBlocCubit>()
                                                      .init();
                                                  context
                                                      .read<
                                                          NewsDetailsScreenBlocCubit>()
                                                      .getPostId(state
                                                              .myProfile
                                                              ?.allBroadcasts?[
                                                                  index]
                                                              .adminCreatedPostId ??
                                                          '');
                                                  context
                                                      .read<
                                                          NewsDetailsScreenBlocCubit>()
                                                      .getEventNewsDetailData();
                                                  context
                                                      .read<
                                                          NewsDetailsScreenBlocCubit>()
                                                      .getInThisAreaPostList();
                                                  NavigatorRoute.navigateTo(
                                                      context,
                                                      AppRoutes.newsDetails,
                                                      args: {
                                                        "isHome": false,
                                                      });
                                                } else {
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          VideoPlayerPageView(
                                                        videoUrl: state
                                                                .myProfile
                                                                ?.allBroadcasts?[
                                                                    index]
                                                                .attachment ??
                                                            '',
                                                        isDraftVideo: false,
                                                        draftData: state
                                                                .myProfile
                                                                ?.allBroadcasts?[
                                                            index],
                                                        contentType: state
                                                                .myProfile
                                                                ?.allBroadcasts?[
                                                                    index]
                                                                .fileType ??
                                                            "",
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Stack(children: [
                                                AppNetworkImageLoader(
                                                  url: state
                                                          .myProfile
                                                          ?.allBroadcasts?[
                                                              index]
                                                          .thumbnail ??
                                                      '',
                                                  height: double.infinity,
                                                  width: double.infinity,
                                                  boxFit: BoxFit.cover,
                                                  borderRadius: 0,
                                                ),
                                                Container(
                                                  height: double.infinity,
                                                  width: double.infinity,
                                                  color: state
                                                              .myProfile
                                                              ?.allBroadcasts?[
                                                                  index]
                                                              .postType ==
                                                          null
                                                      ? Colors.transparent
                                                      : Colors.black.withValues(
                                                          alpha: 0.5),
                                                  child: Center(
                                                    child: Text(
                                                      state
                                                                  .myProfile
                                                                  ?.allBroadcasts?[
                                                                      index]
                                                                  .postType ==
                                                              "incident"
                                                          ? "Event"
                                                          : state
                                                                      .myProfile
                                                                      ?.allBroadcasts?[
                                                                          index]
                                                                      .postType ==
                                                                  "general_category"
                                                              ? "General"
                                                              : state
                                                                          .myProfile
                                                                          ?.allBroadcasts?[
                                                                              index]
                                                                          .postType ==
                                                                      "rescue"
                                                                  ? "Rescue"
                                                                  : "",
                                                      style: TextStyles.medium(
                                                        16.sp,
                                                        fontColor: AppColors
                                                            .whiteColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  // visible: state
                                                  //     .myProfile
                                                  //     ?.allBroadcasts?[index]
                                                  //     .adminCreatedPostId
                                                  //     ?.isNotEmpty ??
                                                  //     false,
                                                  visible: false,
                                                  child: Align(
                                                    alignment:
                                                    Alignment.bottomLeft,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(bottom: 7,left: 7),
                                                      child: Assets.icons.icPostVerifed.svg(
                                                          colorFilter:
                                                          ColorFilter.mode(
                                                              AppColors
                                                                  .whiteColor,
                                                              BlendMode
                                                                  .srcIn)),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment(0.8, 0.9),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Assets.icons.icEye.svg(
                                                          colorFilter:
                                                              ColorFilter.mode(
                                                                  AppColors
                                                                      .whiteColor,
                                                                  BlendMode
                                                                      .srcIn)),
                                                      Gap(2),
                                                      Text(
                                                        state
                                                                .myProfile
                                                                ?.allBroadcasts?[
                                                                    index]
                                                                .eventPostViewCounts ??
                                                            '0',
                                                        style: TextStyles.medium(
                                                            12.sp,
                                                            fontColor: AppColors
                                                                .whiteColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]),
                                            );
                                          },
                                        ),
                                      );
                              },
                            ),
                            BlocBuilder<MyProfileCubit, MyProfileState>(
                              builder: (context, state) {
                                return state.isLoading
                                    ? PostLoadingShimmerWidget()
                                    : Visibility(
                                        visible: state
                                                .myProfile
                                                ?.verifiedEventPosts
                                                ?.isNotEmpty ??
                                            false,
                                        replacement: Center(
                                          child: Text('No post found'),
                                        ),
                                        child: GridView.builder(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4.w, vertical: 7.h),
                                          itemCount: state
                                                  .myProfile
                                                  ?.verifiedEventPosts
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
                                                    'click_my_profile_video',
                                                    {});
                                                if (!mounted) return;
                                                context
                                                    .read<
                                                        NewsDetailsScreenBlocCubit>()
                                                    .init();
                                                context
                                                    .read<
                                                        NewsDetailsScreenBlocCubit>()
                                                    .getPostId(state
                                                            .myProfile
                                                            ?.verifiedEventPosts?[
                                                                index]
                                                            .adminCreatedPostId ??
                                                        '');
                                                context
                                                    .read<
                                                        NewsDetailsScreenBlocCubit>()
                                                    .getEventNewsDetailData();
                                                context
                                                    .read<
                                                        NewsDetailsScreenBlocCubit>()
                                                    .getInThisAreaPostList();
                                                NavigatorRoute.navigateTo(
                                                    context,
                                                    AppRoutes.newsDetails,
                                                    args: {
                                                      "isHome": false,
                                                    });
                                              },
                                              child: Stack(
                                                children: [
                                                  AppNetworkImageLoader(
                                                    url: state
                                                            .myProfile
                                                            ?.verifiedEventPosts?[
                                                                index]
                                                            .thumbnail ??
                                                        '',
                                                    height: double.infinity,
                                                    width: double.infinity,
                                                    boxFit: BoxFit.cover,
                                                    borderRadius: 0,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment(0.8, 0.9),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Assets.icons.icEye.svg(
                                                            colorFilter:
                                                                ColorFilter.mode(
                                                                    AppColors
                                                                        .whiteColor,
                                                                    BlendMode
                                                                        .srcIn)),
                                                        Gap(2),
                                                        Text(
                                                          state
                                                                  .myProfile
                                                                  ?.verifiedEventPosts?[
                                                                      index]
                                                                  .eventPostViewCounts ??
                                                              '0',
                                                          style: TextStyles.medium(
                                                              12.sp,
                                                              fontColor: AppColors
                                                                  .whiteColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      );
                              },
                            ),
                            BlocBuilder<MyProfileCubit, MyProfileState>(
                              builder: (context, state) {
                                return state.isLoading
                                    ? PostLoadingShimmerWidget()
                                    : Visibility(
                                        visible: state.myProfile?.savedPosts
                                                ?.isNotEmpty ??
                                            false,
                                        replacement: Center(
                                          child: Text('No saved post found.'),
                                        ),
                                        child: GridView.builder(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4.w, vertical: 7.h),
                                          itemCount: state.myProfile?.savedPosts
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
                                                    'click_my_profile_video',
                                                    {});
                                                if (!mounted) return;
                                                context
                                                    .read<
                                                        NewsDetailsScreenBlocCubit>()
                                                    .init();
                                                context
                                                    .read<
                                                        NewsDetailsScreenBlocCubit>()
                                                    .getPostId(state
                                                            .myProfile
                                                            ?.savedPosts?[index]
                                                            .adminCreatedPostId ??
                                                        '');
                                                context
                                                    .read<
                                                        NewsDetailsScreenBlocCubit>()
                                                    .getEventNewsDetailData();
                                                context
                                                    .read<
                                                        NewsDetailsScreenBlocCubit>()
                                                    .getInThisAreaPostList();
                                                await NavigatorRoute.navigateTo(
                                                    context,
                                                    AppRoutes.newsDetails,
                                                    args: {
                                                      "isHome": false,
                                                    });
                                                await context
                                                    .read<MyProfileCubit>()
                                                    .getProfileData();
                                              },
                                              child: Stack(
                                                children: [
                                                  AppNetworkImageLoader(
                                                    url: state
                                                            .myProfile
                                                            ?.savedPosts?[index]
                                                            .thumbnail ??
                                                        '',
                                                    height: double.infinity,
                                                    width: double.infinity,
                                                    boxFit: BoxFit.cover,
                                                    borderRadius: 0,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment(0.8, 0.9),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Assets.icons.icEye.svg(
                                                            colorFilter:
                                                                ColorFilter.mode(
                                                                    AppColors
                                                                        .whiteColor,
                                                                    BlendMode
                                                                        .srcIn)),
                                                        Gap(2),
                                                        Text(
                                                          state
                                                                  .myProfile
                                                                  ?.savedPosts?[
                                                                      index]
                                                                  .eventPostViewCounts ??
                                                              '0',
                                                          style: TextStyles.medium(
                                                              12.sp,
                                                              fontColor: AppColors
                                                                  .whiteColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      );
                              },
                            ),
                            BlocBuilder<MyProfileCubit, MyProfileState>(
                              builder: (context, state) {
                                return state.isLoading
                                    ? PostLoadingShimmerWidget()
                                    : Visibility(
                                        visible: state.draftEvent?.draftData
                                                ?.isNotEmpty ??
                                            false,
                                        replacement: Center(
                                          child: Text('No draft post found.'),
                                        ),
                                        child: GridView.builder(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4.w, vertical: 7.h),
                                          itemCount: state.draftEvent?.draftData
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
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        VideoPlayerPageView(
                                                      videoUrl: state
                                                              .draftEvent
                                                              ?.draftData![
                                                                  index]
                                                              .attachment ??
                                                          '',
                                                      isDraftVideo: true,
                                                      draftData: state
                                                          .draftEvent
                                                          ?.draftData?[index],
                                                      contentType: 'video',
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Stack(
                                                children: [
                                                  AppNetworkImageLoader(
                                                    url: state
                                                            .draftEvent
                                                            ?.draftData![index]
                                                            .thumbnail ??
                                                        '',
                                                    height: double.infinity,
                                                    width: double.infinity,
                                                    boxFit: BoxFit.cover,
                                                    borderRadius: 0,
                                                  ),
                                                  Container(
                                                    height: double.infinity,
                                                    width: double.infinity,
                                                    color: Colors.black
                                                        .withValues(alpha: 0.5),
                                                    child: Center(
                                                      child: Text(
                                                        state
                                                                    .draftEvent
                                                                    ?.draftData?[
                                                                        index]
                                                                    .postType ==
                                                                "incident"
                                                            ? "Event"
                                                            : state
                                                                        .draftEvent
                                                                        ?.draftData?[
                                                                            index]
                                                                        .postType ==
                                                                    "general_category"
                                                                ? "General"
                                                                : "",
                                                        style:
                                                            TextStyles.medium(
                                                          16.sp,
                                                          fontColor: AppColors
                                                              .whiteColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                    right: 0,
                    top: 60.h,
                    child: IconButton(
                        onPressed: () {
                          FirebaseEvents.setFirebaseEvent(
                              'click_my_profile_setting_btn', {});
                          NavigatorRoute.navigateTo(
                              context, AppRoutes.settingsScreen);
                        },
                        icon: Assets.icons.icSettings.svg()))
              ],
            ),
          );
        });
  }
}
