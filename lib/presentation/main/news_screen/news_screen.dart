import 'dart:developer';
import 'dart:ui';
import 'package:eagle_eye/core/constant/app_constant.dart';
import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/theme/text_styles.dart';
import 'package:eagle_eye/core/utils/app_functions.dart';
import 'package:eagle_eye/core/widget/app_network_image_loader.dart';
import 'package:eagle_eye/core/widget/common_bottom_sheet.dart';
import 'package:eagle_eye/core/widget/progress_loader.dart';
import 'package:eagle_eye/gen/assets.gen.dart';
import 'package:eagle_eye/presentation/main/go_live_screen/bloc/go_live_cubit.dart';
import 'package:eagle_eye/presentation/main/news_details_screen/bloc/news_details_screen_bloc_cubit.dart';
import 'package:eagle_eye/presentation/main/news_screen/bloc/news_screen_bloc_cubit.dart';
import 'package:eagle_eye/presentation/main/news_screen/news_loading_widget.dart';
import 'package:eagle_eye/presentation/main/news_screen/react_button.dart';
import 'package:eagle_eye/presentation/main/user_profile_screen/bloc/user_profile_cubit.dart';
import 'package:eagle_eye/routes/app_navigation.dart';
import 'package:eagle_eye/routes/app_routes.dart';
import 'package:eagle_eye/services/ads_service/ad_label.dart';
import 'package:eagle_eye/services/ads_service/ads_helper.dart';
import 'package:eagle_eye/services/ads_service/native_ads.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
import 'package:eagle_eye/services/remote_config_service/remote_config_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../core/widget/common_app_bar.dart';
import '../../../services/socket_service/socket_service.dart';
import '../map_screen/bloc/map_screen_cubit.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  AnimationController? animationController;

  int eventTypeTabbarValue() => eventTypeValue;
  int eventTypeValue = 0;
  final List<String> events = ['Event', 'General', 'Rescue'];
  @override
  void initState() {
    FirebaseEvents.setFirebaseEvent('news_screen', {});
    super.initState();

    _scrollController.addListener(_onScroll);
    animationController = AnimationController(
      duration: Duration(seconds: 1), // 1-second animation
      vsync: this,
    )..repeat(reverse: false);
  }

  @override
  void dispose() {
    animationController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      if (!context.read<NewsScreenBlocCubit>().state.isBottomLoading) {
        context.read<NewsScreenBlocCubit>().loadMoreEventNews(eventTypeValue == 0
            ? "incident"
            : (eventTypeValue == 1)
                ? "general_category"
                : "rescue");
      }
    }
  }

  int getActualIndex(int index) {
    if (adsHelper.getshowAds() && adsHelper.getAdsIsEnable(AdsLabel.newsScreenNative)) {
      return index - (index ~/ ((firebaseRemoteConfigService.getFirebaseAdsData().newsListAdsIndex ?? 0) + 1));
    } else {
      return index;
    }
  }

  @override
  Widget build(BuildContext context) {
    ProgressLoader pl = ProgressLoader(context, isDismissible: true);
    return Scaffold(
      appBar: HomeAppBar(
        title: BlocBuilder<MapScreenCubit, MapScreenState>(
          buildWhen: (previous, current) => previous.currentCity != current.currentCity,
          builder: (context, state) {
            return BlocBuilder<NewsScreenBlocCubit, NewsScreenBlocState>(
              builder: (context, newsScreenState) {
                return Text(
                  newsScreenState.type == 'latest' ? 'Global' : state.currentCity,
                  style: TextStyles.semiBold(36.sp, fontFamily: testTiemposHeadline),
                );
              },
            );
          },
        ),
        action: [
          PopupMenuButton<int>(
              color: AppColors.actionBtnBgColor,
              offset: Offset(0, 52.h),
              onOpened: () {
                FirebaseEvents.setFirebaseEvent('click_news_filter_btn', {});
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    height: 50.h,
                    child: Text(
                      'Latest',
                      style: TextStyles.medium(20.sp),
                    ),
                    onTap: () async {
                      await context.read<NewsScreenBlocCubit>().changeType('latest');

                      await context.read<NewsScreenBlocCubit>().getNewsEvents(
                            'latest',
                            postType: eventTypeValue == 0
                                ? "incident"
                                : eventTypeValue == 1
                                    ? "general_category"
                                    : 'rescue',
                          );
                    },
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem(
                    height: 50.h,
                    child: Text(
                      "Trending",
                      style: TextStyles.medium(20.sp),
                    ),
                    onTap: () async {
                      await context.read<NewsScreenBlocCubit>().changeType('trending');
                      await context.read<NewsScreenBlocCubit>().getNewsEvents(
                            'trending',
                            postType: eventTypeValue == 0
                                ? "incident"
                                : eventTypeValue == 1
                                    ? "general_category"
                                    : 'rescue',
                          );
                    },
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem(
                    height: 50.h,
                    child: Text(
                      'My Feed',
                      style: TextStyles.medium(20.sp),
                    ),
                    onTap: () async {
                      await context.read<NewsScreenBlocCubit>().changeType('myfeed');

                      await context.read<NewsScreenBlocCubit>().getNewsEvents(
                            'myFeed',
                            postType: eventTypeValue == 0
                                ? "incident"
                                : eventTypeValue == 1
                                    ? "general_category"
                                    : 'rescue',
                          );
                    },
                  ),
                ];
              },
              child: CircleAvatar(
                radius: 25.r,
                backgroundColor: AppColors.actionBtnBgColor,
                child: Assets.icons.icFilter.svg(),
              )),
          Gap(10.w),
          ValueListenableBuilder(
            valueListenable: SocketService.userChatUnreadNotifier,
            builder: (context, value, child) {
              return GestureDetector(
                onTap: () async {
                  await NavigatorRoute.navigateTo(context, AppRoutes.chatList);
                  SocketService.sentUnreadCountRequest();
                },
                child: CircleAvatar(
                  radius: 25.r,
                  backgroundColor: AppColors.actionBtnBgColor,
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12.sp),
                        child: Assets.icons.icMessanger.svg(),
                      ),
                      Visibility(
                        visible: value != 0,
                        child: Positioned(
                          right: 0,
                          child: CircleAvatar(
                            radius: 10.r,
                            backgroundColor: AppColors.redColor,
                            child: Text(
                              (value >= 99) ? '99' : '$value',
                              style: TextStyles.semiBold(12.sp),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Gap(20.w),
        ],
      ),
      body: BlocBuilder<NewsScreenBlocCubit, NewsScreenBlocState>(
        builder: (context, state) {
          return state.isLoading
              ? Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: buildSwitch(state),
                    ),
                    NewsLoadingWidget(),
                  ],
                )
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    RefreshIndicator(
                      color: AppColors.whiteColor,
                      onRefresh: () {
                        context.read<NewsScreenBlocCubit>().init();
                        return context.read<NewsScreenBlocCubit>().getNewsEvents(state.type,
                            postType: eventTypeValue == 0
                                ? "incident"
                                : (eventTypeValue == 1)
                                    ? "general_category"
                                    : "rescue");
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: (state.eventPostList != null && (state.eventPostList?.isNotEmpty ?? false))
                              ? ListView.separated(
                                  controller: _scrollController,
                                  shrinkWrap: false,
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  separatorBuilder: (context, index) => Gap(10.h),
                                  itemCount: (adsHelper.getshowAds() &&
                                          adsHelper.getAdsIsEnable(AdsLabel.newsScreenNative))
                                      ? ((state.eventPostList?.length ?? 0) + (state.isBottomLoading ? 1 : 0)) +
                                          ((state.eventPostList?.length ?? 0) ~/
                                              (firebaseRemoteConfigService.getFirebaseAdsData().newsListAdsIndex ?? 0))
                                      : ((state.eventPostList?.length ?? 0) + (state.isBottomLoading ? 1 : 0)),
                                  itemBuilder: (context, index) {
                                    // Calculate if this index should show an ad
                                    bool shouldShowAd = adsHelper.getshowAds() &&
                                        adsHelper.getAdsIsEnable(AdsLabel.newsScreenNative) &&
                                        (index + 1) %
                                                ((firebaseRemoteConfigService.getFirebaseAdsData().newsListAdsIndex ??
                                                        0) +
                                                    1) ==
                                            0;

                                    // Calculate the actual index for the news item
                                    int actualIndex = getActualIndex(index);

                                    // Show loading indicator at the end
                                    if (state.isBottomLoading &&
                                        index ==
                                            ((adsHelper.getshowAds() &&
                                                    adsHelper.getAdsIsEnable(AdsLabel.newsScreenNative))
                                                ? ((state.eventPostList?.length ?? 0) +
                                                    ((state.eventPostList?.length ?? 0) ~/
                                                        (firebaseRemoteConfigService
                                                                .getFirebaseAdsData()
                                                                .newsListAdsIndex ??
                                                            0)))
                                                : (state.eventPostList?.length ?? 0))) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.whiteColor,
                                        ),
                                      );
                                    }

                                    // Show ad if this index should show an ad
                                    if (shouldShowAd) {
                                      return NativeAdsWidget(
                                        adLbl: AdsLabel.newsScreenNative,
                                      );
                                    }

                                    // Show news item
                                    return GestureDetector(
                                      onDoubleTap: () async {
                                        FirebaseEvents.setFirebaseEvent('click_news_reaction_btn', {});
                                        await context.read<NewsDetailsScreenBlocCubit>().addReactionPost(
                                            state.eventPostList?[actualIndex].id ?? '', context, false);
                                      },
                                      onTap: () {
                                        FirebaseEvents.setFirebaseEvent('click_news_details', {});
                                        if (!mounted) return;
                                        context.read<NewsDetailsScreenBlocCubit>().init();
                                        context
                                            .read<NewsDetailsScreenBlocCubit>()
                                            .getPostId(state.eventPostList![actualIndex].id ?? '');
                                        context.read<NewsDetailsScreenBlocCubit>().getEventNewsDetailData();
                                        context.read<GoLiveCubit>().getAddressFromLatLang(
                                            latitude: state.eventPostList?[actualIndex].latitude,
                                            longitude: state.eventPostList?[actualIndex].longitude);
                                        context.read<NewsDetailsScreenBlocCubit>().getInThisAreaPostList();
                                        NavigatorRoute.navigateTo(context, AppRoutes.newsDetails, args: {
                                          "isHome": false,
                                        });
                                      },
                                      behavior: HitTestBehavior.translucent,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.r),
                                          color: AppColors.newsCardBgColor,
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Visibility(
                                              visible: state.eventPostList![actualIndex].attachments != null &&
                                                  state.eventPostList![actualIndex].attachments!.isNotEmpty,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10.r),
                                                  topRight: Radius.circular(10.r),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    SizedBox(
                                                      height: 250.h,
                                                      child: PageView.builder(
                                                        onPageChanged: (value) {
                                                          context.read<NewsScreenBlocCubit>().onPageChanged(value);
                                                        },
                                                        controller: PageController(initialPage: 0),
                                                        itemCount:
                                                            state.eventPostList![actualIndex].attachments?.length ?? 0,
                                                        itemBuilder: (context, pageIndex) {
                                                          return AppNetworkImageLoader(
                                                            url: state.eventPostList![actualIndex]
                                                                    .attachments![pageIndex].thumbnail ??
                                                                '',
                                                            borderRadius: 10.r,
                                                            boxFit: BoxFit.cover,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    if ((state.eventPostList![actualIndex].attachments?.length ?? 0) >
                                                        1)
                                                      Positioned(
                                                        bottom: 15.h,
                                                        left: 0,
                                                        right: 0,
                                                        child: Align(
                                                          alignment: Alignment.bottomCenter,
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: List.generate(
                                                                state.eventPostList![actualIndex].attachments?.length ??
                                                                    0, (actualIndex) {
                                                              return Container(
                                                                height: 6.h,
                                                                width: 12.w,
                                                                margin: EdgeInsets.symmetric(horizontal: 2.w),
                                                                decoration: BoxDecoration(
                                                                  color: (actualIndex == state.attachmentCurrentIndex)
                                                                      ? AppColors.whiteColor
                                                                      : AppColors.whiteColor.withValues(alpha: 0.3),
                                                                  shape: (actualIndex == state.attachmentCurrentIndex)
                                                                      ? BoxShape.rectangle
                                                                      : BoxShape.rectangle,
                                                                  borderRadius: BorderRadius.circular(5.r),
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ),
                                                      ),
                                                    Positioned(
                                                      bottom: 10.h,
                                                      left: 10.w,
                                                      child: Row(
                                                        children: [
                                                          Assets.icons.icEye.svg(
                                                            colorFilter: const ColorFilter.mode(
                                                              Colors.white,
                                                              BlendMode.srcIn,
                                                            ),
                                                          ),
                                                          Gap(5.w),
                                                          Text(
                                                            state.eventPostList![actualIndex].viewCounts.toString(),
                                                            style: TextStyles.semiBold(16.sp),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 20.sp, right: 20.sp, top: 10.sp),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      FirebaseEvents.setFirebaseEvent(
                                                          'click_news_user_profile_photo', {});
                                                      if (state.eventPostList?[actualIndex].attachments?[0].userId ==
                                                              null ||
                                                          (state.eventPostList?[actualIndex].attachments?[0]
                                                                  .isShareAnonymously ==
                                                              true)) {
                                                        return;
                                                      } else {
                                                        context.read<UserProfileCubit>().getUserId(
                                                              state.eventPostList?[actualIndex].attachments?[0]
                                                                      .userId ??
                                                                  '',
                                                            );
                                                        context.read<UserProfileCubit>().getUserInfo();
                                                        NavigatorRoute.navigateTo(context, AppRoutes.userProfile);
                                                      }
                                                    },
                                                    child: Row(
                                                      children: [
                                                        state.eventPostList?[actualIndex].attachments?[0]
                                                                    .isShareAnonymously ==
                                                                true
                                                            ? Container(
                                                                height: 30,
                                                                width: 30,
                                                                decoration: BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  color: AppColors.actionBtnBgColor,
                                                                ),
                                                                child: AppNetworkImageLoader(
                                                                  url: '',
                                                                  boxFit: BoxFit.cover,
                                                                  placeHolderIMAGE: Assets.images.imgUserPlc,
                                                                  borderRadius: 300.r,
                                                                ))
                                                            : Container(
                                                                height: 30,
                                                                width: 30,
                                                                decoration: BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  color: AppColors.actionBtnBgColor,
                                                                ),
                                                                child: AppNetworkImageLoader(
                                                                  url: state.eventPostList?[actualIndex].attachments?[0]
                                                                          .profilePicture ??
                                                                      '',
                                                                  boxFit: BoxFit.cover,
                                                                  placeHolderIMAGE: Assets.images.imgUserPlc,
                                                                  borderRadius: 300.r,
                                                                ),
                                                              ),
                                                        Gap(10.w),
                                                        state.eventPostList?[actualIndex].attachments?[0]
                                                                    .isShareAnonymously ==
                                                                true
                                                            ? Expanded(
                                                                child: Text(
                                                                  'Awaaz User',
                                                                  maxLines: 1,
                                                                  style: TextStyles.light(
                                                                      textOverflow: TextOverflow.ellipsis,
                                                                      16.sp,
                                                                      fontWeight: FontWeight.w400),
                                                                ),
                                                              )
                                                            : Expanded(
                                                                child: Text(
                                                                  state.eventPostList?[actualIndex].attachments?[0]
                                                                          .name ??
                                                                      'Awaaz',
                                                                  maxLines: 1,
                                                                  textAlign: TextAlign.justify,
                                                                  style: TextStyles.light(
                                                                      textOverflow: TextOverflow.ellipsis,
                                                                      16.sp,
                                                                      fontWeight: FontWeight.w400),
                                                                ),
                                                              )
                                                      ],
                                                    ),
                                                  ),
                                                  Gap(10.h),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        state.eventPostList![actualIndex].distance ?? '0',
                                                        style: TextStyles.light(16.sp),
                                                      ),
                                                      Gap(10.w),
                                                      Assets.icons.icDot.svg(),
                                                      Gap(10.w),
                                                      Text(
                                                        state.eventPostList?[actualIndex].eventTime != null
                                                            ? DateFormat('dd MMM yyyy').format(
                                                                state.eventPostList?[actualIndex].eventTime ??
                                                                    DateTime.now())
                                                            : '',
                                                        style: TextStyles.light(16.sp, fontWeight: FontWeight.w300),
                                                      ),
                                                      Gap(10.w),
                                                      Assets.icons.icDot.svg(),
                                                      Gap(10.w),
                                                      Text(
                                                        state.eventPostList?[actualIndex].eventTime != null
                                                            ? timeAgo(state.eventPostList?[actualIndex].eventTime
                                                                    ?.toLocal() ??
                                                                DateTime.now())
                                                            : '',
                                                        style: TextStyles.light(16.sp),
                                                      ),
                                                    ],
                                                  ),
                                                  Gap(10.h),
                                                  Text(
                                                    state.eventPostList?[actualIndex].title ?? '',
                                                    // textAlign:
                                                    //     TextAlign.justify,
                                                    style: TextStyles.semiBold(26.sp, fontFamily: testTiemposHeadline),
                                                    maxLines: 2,
                                                  ),
                                                  Gap(10.h),
                                                  Text(
                                                    state.eventPostList?[actualIndex].description ?? '',
                                                    // textAlign:
                                                    //     TextAlign.justify,
                                                    style:
                                                        TextStyles.light(16.sp, fontColor: AppColors.textHintGrayColor),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                  ),
                                                  Gap(10.h),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                          child: GestureDetector(
                                                        onTap: () async {
                                                          FirebaseEvents.setFirebaseEvent(
                                                              'click_news_reaction_btn', {});
                                                          await context
                                                              .read<NewsDetailsScreenBlocCubit>()
                                                              .addReactionPost(
                                                                  state.eventPostList?[actualIndex].id ?? '',
                                                                  context,
                                                                  false);
                                                        },
                                                        behavior: HitTestBehavior.translucent,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            ReactButton(
                                                              reactionIcon:
                                                                  state.eventPostList?[actualIndex].reactionIcon ?? '',
                                                              hasReacted:
                                                                  state.eventPostList?[actualIndex].hasReacted == true,
                                                            ),
                                                            Gap(2.h),
                                                            Text(
                                                              state.eventPostList?[actualIndex].reactionCounts
                                                                      ?.toString() ??
                                                                  '0',
                                                              style: TextStyles.regular(16.sp,
                                                                  fontColor: AppColors.whiteColor),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                      // Expanded(
                                                      //   child:
                                                      //       GestureDetector(
                                                      //     onTap: () async {
                                                      //       FirebaseEvents
                                                      //           .setFirebaseEvent(
                                                      //               'click_news_reaction_btn',
                                                      //               {});
                                                      //       await context
                                                      //           .read<
                                                      //               NewsDetailsScreenBlocCubit>()
                                                      //           .addReactionPost(
                                                      //               state.eventPostList?[actualIndex]
                                                      //                       .id ??
                                                      //                   '',
                                                      //               context,
                                                      //               false);
                                                      //     },
                                                      //     child: Column(
                                                      //       mainAxisAlignment:
                                                      //           MainAxisAlignment
                                                      //               .center,
                                                      //       crossAxisAlignment:
                                                      //           CrossAxisAlignment
                                                      //               .center,
                                                      //       children: [
                                                      //         ClipOval(
                                                      //           child:
                                                      //               Container(
                                                      //             padding:
                                                      //                 EdgeInsets
                                                      //                     .all(6),
                                                      //             color: state.eventPostList?[actualIndex].hasReacted ==
                                                      //                     true
                                                      //                 ? Colors
                                                      //                     .white54
                                                      //                 : Colors
                                                      //                     .transparent,
                                                      //             child:
                                                      //                 CachedNetworkImage(
                                                      //               height:
                                                      //                   30,
                                                      //               width: 30,
                                                      //               fit: BoxFit
                                                      //                   .contain,
                                                      //               errorWidget:
                                                      //                   (context,
                                                      //                       url,
                                                      //                       error) {
                                                      //                 return Image.asset(Assets
                                                      //                     .images
                                                      //                     .fire
                                                      //                     .path);
                                                      //               },
                                                      //               imageUrl:
                                                      //                   state.eventPostList?[actualIndex].reactionIcon ??
                                                      //                       '',
                                                      //             ),
                                                      //           ),
                                                      //         ),
                                                      //         Gap(2.h),
                                                      //         Text(
                                                      //           state.eventPostList?[actualIndex]
                                                      //                   .reactionCounts
                                                      //                   ?.toString() ??
                                                      //               '0',
                                                      //           style: TextStyles.regular(
                                                      //               16.sp,
                                                      //               fontColor:
                                                      //                   AppColors
                                                      //                       .whiteColor),
                                                      //         ),
                                                      //       ],
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                      Gap(10.w),
                                                      BlocBuilder<NewsScreenBlocCubit, NewsScreenBlocState>(
                                                        builder: (context, state) {
                                                          return Expanded(
                                                            child: TextButton(
                                                                onPressed: () {
                                                                  FirebaseEvents.setFirebaseEvent(
                                                                      'click_news_comment_btn', {});
                                                                  context.read<NewsScreenBlocCubit>().getPostComments(
                                                                      state.eventPostList?[actualIndex].id ?? '');
                                                                  showAppBottomSheet(
                                                                    context,
                                                                    AppCommonBottomSheet(
                                                                      isOpenWithGradient: false,
                                                                      isPaddingNotShow: true,
                                                                      body: NewsCommentBottomSheet(
                                                                        bottomButton: Column(
                                                                          children: [
                                                                            Divider(
                                                                              color: AppColors.tabbarIndicatorColor,
                                                                              thickness: 1.3,
                                                                            ),
                                                                            SizedBox(
                                                                              height: 15,
                                                                            ),
                                                                            InkWell(
                                                                              onTap: () {},
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.symmetric(
                                                                                    horizontal: 20),
                                                                                child: Text(
                                                                                  'Delete',
                                                                                  style: TextStyles.semiBold(20.sp,
                                                                                      fontColor: AppColors.redColor),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        eventPostId:
                                                                            state.eventPostList?[actualIndex].id ?? '',
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Container(
                                                                      padding: EdgeInsets.all(6),
                                                                      child: Assets.icons.icMessage.svg(),
                                                                    ),
                                                                    Gap(2.h),
                                                                    Text(
                                                                      state.eventPostList?[actualIndex].commentCounts
                                                                              ?.toString() ??
                                                                          '0',
                                                                      style: TextStyles.regular(16.sp,
                                                                          fontColor: AppColors.whiteColor),
                                                                    ),
                                                                  ],
                                                                )),
                                                          );
                                                        },
                                                      ),
                                                      Gap(10.w),
                                                      BlocBuilder<NewsScreenBlocCubit, NewsScreenBlocState>(
                                                        builder: (context, state) {
                                                          return Expanded(
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Container(
                                                                  padding: EdgeInsets.all(6),
                                                                  child: Assets.icons.icEye.svg(
                                                                    colorFilter: const ColorFilter.mode(
                                                                      Colors.white,
                                                                      BlendMode.srcIn,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Gap(2.h),
                                                                Text(
                                                                  state.eventPostList?[actualIndex].viewCounts
                                                                          ?.toString() ??
                                                                      '0',
                                                                  style: TextStyles.regular(16.sp,
                                                                      fontColor: AppColors.whiteColor),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      Gap(10.w),
                                                      BlocBuilder<NewsScreenBlocCubit, NewsScreenBlocState>(
                                                        builder: (context, state) {
                                                          return Expanded(
                                                            child: TextButton(
                                                              onPressed: () async {
                                                                FirebaseEvents.setFirebaseEvent(
                                                                    'click_news_share_btn', {});
                                                                try {
                                                                  String shareUrl =
                                                                      'Awaaz:Real Time City Alert \n https://news.awaazeye.com/${state.eventPostList?[actualIndex].id ?? ''}';
                                                                  AppFunctions.sharePostText(
                                                                    url: shareUrl,
                                                                  );
                                                                } catch (e) {
                                                                  await pl.hide();
                                                                  log("Share error: $e");
                                                                }
                                                              },
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Container(
                                                                    padding: EdgeInsets.all(6),
                                                                    child: Assets.icons.icShare.svg(),
                                                                  ),
                                                                  Gap(2.h),
                                                                  Text(
                                                                    'Share',
                                                                    style: TextStyles.regular(16.sp,
                                                                        fontColor: AppColors.whiteColor),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                              : Center(
                                  child: Text('No news events found'),
                                ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10.h,
                      child: buildSwitch(state),
                    )
                  ],
                );
        },
      ),
    );
  }

  Widget buildSwitch(state) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(events.length, (index) {
              final isSelected = eventTypeValue == index;
              return GestureDetector(
                onTap: () async {
                  eventTypeValue = index;
                  if (index == 0) {
                    eventTypeValue = index;
                    await context.read<NewsScreenBlocCubit>().getNewsEvents(state.type, postType: "incident");
                    setState(() {});
                  } else if (index == 1) {
                    eventTypeValue = index;
                    await context.read<NewsScreenBlocCubit>().getNewsEvents(state.type, postType: "general_category");
                    setState(() {});
                  } else if (index == 2) {
                    eventTypeValue = index;
                    await context.read<NewsScreenBlocCubit>().getNewsEvents(state.type, postType: "rescue");
                    setState(() {});
                  }
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        events[index],
                        style: TextStyles.bold(20.sp,
                            fontColor: isSelected ? Colors.black : Colors.white, fontFamily: alice),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
