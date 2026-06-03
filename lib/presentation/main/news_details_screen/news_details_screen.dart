import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:eagle_eye/core/constant/app_constant.dart';
import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/theme/text_styles.dart';
import 'package:eagle_eye/core/utils/app_functions.dart';
import 'package:eagle_eye/core/widget/app_network_image_loader.dart';
import 'package:eagle_eye/core/widget/common_app_bar.dart';
import 'package:eagle_eye/core/widget/common_bottom_sheet.dart';
import 'package:eagle_eye/core/widget/common_text_button.dart';
import 'package:eagle_eye/core/widget/common_textfield.dart';
import 'package:eagle_eye/core/widget/video_player_pageview.dart';
import 'package:eagle_eye/data/models/event_news_detail_model.dart';
import 'package:eagle_eye/gen/assets.gen.dart';
import 'package:eagle_eye/presentation/main/news_details_screen/area_post_loader_loader.dart';
import 'package:eagle_eye/presentation/main/news_details_screen/area_post_widget.dart';
import 'package:eagle_eye/presentation/main/news_details_screen/bloc/news_details_screen_bloc_cubit.dart';
import 'package:eagle_eye/presentation/main/news_screen/react_button.dart';
import 'package:eagle_eye/routes/app_navigation.dart';
import 'package:eagle_eye/services/ads_service/ad_label.dart';
import 'package:eagle_eye/services/ads_service/banner_ads.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
// import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';

import '../../../core/constant/app_assets.dart';
import '../../../core/utils/app_prefrence.dart';
import '../../../core/widget/common_app_image_show.dart';
import '../../../routes/app_routes.dart';
import '../go_live_screen/bloc/go_live_cubit.dart';
import '../news_screen/bloc/news_screen_bloc_cubit.dart';
import '../send_alert/bloc/send_alert_cubit.dart';

class NewsDetailsScreen extends StatefulWidget {
  final bool isHome;

  const NewsDetailsScreen({super.key, required this.isHome});

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  TextEditingController sendCommentController = TextEditingController();
  late NewsDetailsScreenBlocCubit _newsCubit;
  final Map<int, ChewieController> _chewieControllers = {};
  double likeScale = 1.0;
  bool isMuted = false;
  bool isDownloading = false;
  bool showDownloadAnimation = false;
  final platform = MethodChannel('com.example.app/media_scanner');
  bool isNotificationAnimation = false;

  final GlobalKey tooltipKey = GlobalKey();
  final GlobalKey globalKey = GlobalKey();

  void showTooltip() {
    final dynamic tooltip = tooltipKey.currentState;
    tooltip?.ensureTooltipVisible(); // Manually show tooltip
  }

  @override
  void initState() {
    FirebaseEvents.setFirebaseEvent('news_details_screen', {});
    super.initState();

    Future.delayed(Duration.zero).then(
      (value) {
        init();
        PrefService.singleclear(PrefService.eventDetailsId);
      },
    );
  }

  Future init() async {
    await context.read<NewsDetailsScreenBlocCubit>().viewCountPost(context);
    // context.read<NewsDetailsScreenBlocCubit>().addAttachmentView();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Obtain the cubit reference
    _newsCubit = context.read<NewsDetailsScreenBlocCubit>();
  }

  bool isFullScreenMode = false;
  String? imageUrl;

  @override
  void dispose() {
    _chewieControllers.forEach((key, controller) {
      controller.videoPlayerController.dispose();
      controller.dispose();
    });
    _newsCubit.disposeControllers();
    _chewieControllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Video Player height configurations
    final double collapsedHeight = screenHeight * 0.3; // 30% when collapsed
    final double expandedHeight =
        screenHeight * 0.5; // Adjust as needed when expanded
    final double videoPlayerWidth = screenWidth;
    return GestureDetector(
      onTap: closeKeyboard,
      child:
          BlocBuilder<NewsDetailsScreenBlocCubit, NewsDetailsScreenBlocState>(
        builder: (context, state) {
          return Scaffold(
            appBar: isFullScreenMode == false
                ? PreferredSize(
                    preferredSize: Size.fromHeight(60.h),
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 30.h, left: 20.w),
                          height: 100.h,
                          decoration: BoxDecoration(
                            gradient: state.isNewsCritical
                                ? LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xff700000),
                                      Color(0xff700000).withValues(alpha: 0.5),
                                      Color(0xff700000).withValues(alpha: 0.3),
                                      Color(0xff700000).withValues(alpha: 0.3),
                                      Color(0xff700000).withValues(alpha: 0.0),
                                    ],
                                  )
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {
                                    NavigatorRoute.navigateBack(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Assets.icons.icBackArrow
                                        .svg(height: 40.h),
                                  )),
                              Expanded(
                                child: Text(
                                  state.eventNewsDetailData?.address ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyles.semiBold(26.sp,
                                      fontFamily: testTiemposHeadline),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (state.eventNewsDetailData?.postType !=
                                      "general_category")
                                    Visibility(
                                      visible: state.eventNewsDetailData
                                                  ?.postType ==
                                              'rescue' &&
                                          state.eventNewsDetailData?.status ==
                                              'Resolved',
                                      child: Assets.icons.icRescueGreen.svg(),
                                    ),
                                  Gap(10.w),
                                  if (state.isNotificationAnimation &&
                                      state.eventNewsDetailData?.postType !=
                                          "general_category")
                                    ClipOval(
                                      child: Container(
                                        color: Colors.white,
                                        child: Lottie.asset(
                                          "assets/animation/notification_new.json",
                                          width: 30,
                                          height: 30,
                                          repeat: false,
                                          onLoaded: (composition) {
                                            Future.delayed(composition.duration,
                                                () {
                                              context
                                                  .read<
                                                      NewsDetailsScreenBlocCubit>()
                                                  .setNotificationAnimationFalse();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  if (!state.isNotificationAnimation &&
                                      state.eventNewsDetailData?.postType !=
                                          null &&
                                      state.eventNewsDetailData?.postType !=
                                          "general_category")
                                    Tooltip(
                                      key: tooltipKey,
                                      decoration: BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                            15,
                                          ),
                                          bottomRight: Radius.circular(
                                            15,
                                          ),
                                        ),
                                      ),
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 50),
                                      textStyle: TextStyles.regular(17.sp,
                                          fontColor: AppColors.blackColor),
                                      message:
                                          "Turn on notification to get an update every time we share unused information regarding this event",
                                      child: GestureDetector(
                                          onLongPress: () {
                                            showTooltip();
                                          },
                                          onTap: () async {
                                            FirebaseEvents.setFirebaseEvent(
                                                'click_news_detail_notification_on_off',
                                                {});
                                            await context
                                                .read<
                                                    NewsDetailsScreenBlocCubit>()
                                                .notificationOnOff();
                                          },
                                          child: state.isNotification == true
                                              ? Icon(
                                                  Icons
                                                      .notifications_active_outlined,
                                                  size: 25,
                                                )
                                              : Icon(
                                                  Icons.notifications_off,
                                                  size: 25,
                                                )),
                                    ),
                                  PopupMenuButton<int>(
                                    color: AppColors.blackColor,
                                    onOpened: () {
                                      FirebaseEvents.setFirebaseEvent(
                                          'click_news_detail_more_btn', {});
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return [
                                        PopupMenuItem(
                                          child: Text(
                                            'Report',
                                            style: TextStyles.regular(17.sp,
                                                fontColor:
                                                    AppColors.whiteColor),
                                          ),
                                          onTap: () {
                                            context
                                                .read<
                                                    NewsDetailsScreenBlocCubit>()
                                                .clearReason();
                                            showAppBottomSheet(
                                              context,
                                              AppCommonBottomSheet(
                                                sheetBGColor:
                                                    AppColors.actionBtnBgColor,
                                                body: ReportPostBottomSheet(),
                                                isOpenWithGradient: false,
                                              ),
                                            );
                                          },
                                        ),
                                        PopupMenuDivider(),
                                        PopupMenuItem(
                                          child: Text(
                                            state.isSaved
                                                ? 'Unsave Post'
                                                : 'Save Post',
                                            style: TextStyles.regular(17.sp,
                                                fontColor:
                                                    AppColors.whiteColor),
                                          ),
                                          onTap: () async {
                                            await context
                                                .read<
                                                    NewsDetailsScreenBlocCubit>()
                                                .savePost();
                                          },
                                        ),
                                      ];
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : AppBar(
                    backgroundColor: Colors.black,
                    title: Text(
                      'Post',
                      style: TextStyles.semiBold(26.sp,
                          fontFamily: testTiemposHeadline),
                    ),
                    leading: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          isFullScreenMode = false;
                          showDownloadAnimation = false;
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Assets.icons.icBackArrow.svg(height: 40.h),
                        )),
                    toolbarHeight: 40,
                    actions: [
                      PopupMenuButton<int>(
                        color: AppColors.blackColor,
                        onOpened: () {
                          FirebaseEvents.setFirebaseEvent(
                              'click_news_detail_more_btn', {});
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem(
                              child: Text(
                                'Report',
                                style: TextStyles.regular(17.sp,
                                    fontColor: AppColors.whiteColor),
                              ),
                              onTap: () {
                                context
                                    .read<NewsDetailsScreenBlocCubit>()
                                    .clearReason();
                                showAppBottomSheet(
                                  context,
                                  AppCommonBottomSheet(
                                    sheetBGColor: AppColors.actionBtnBgColor,
                                    body: ReportPostBottomSheet(),
                                    isOpenWithGradient: false,
                                  ),
                                );
                              },
                            ),
                            PopupMenuDivider(),
                            PopupMenuItem(
                              child: Text(
                                state.isSaved ? 'Unsave Post' : 'Save Post',
                                style: TextStyles.regular(17.sp,
                                    fontColor: AppColors.whiteColor),
                              ),
                              onTap: () async {
                                await context
                                    .read<NewsDetailsScreenBlocCubit>()
                                    .savePost();
                              },
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BannerAdsWidget(adLbl: AdsLabel.newsDetailsScreenBanner),
              ],
            ),
            body: RefreshIndicator(
              color: AppColors.whiteColor,
              onRefresh: () {
                return context
                    .read<NewsDetailsScreenBlocCubit>()
                    .getEventNewsDetailData();
              },
              child: Stack(
                children: [
                  // BlocBuilder<GoLiveCubit, GoLiveState>(
                  //   buildWhen: (previous, current) {
                  //     return previous.googleAddressData !=
                  //         current.googleAddressData;
                  //   },
                  //   builder: (context, state) {
                  //     return Align(
                  //         alignment: Alignment(0, 0),
                  //         child: watermarkWidget(context));
                  //   },
                  // ),
                  Align(
                    alignment: Alignment(0, 0),
                    child: Container(
                      height: 230.h,
                      width: double.infinity,
                      color: AppColors.blackColor,
                    ),
                  ),
                  state.isLoading
                      ? AreaPostLoaderWidget()
                      : (state.eventNewsDetailData != null)
                          ? isFullScreenMode
                              ? Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    if (imageUrl != null) ...[
                                      Container(
                                        width: double.infinity,
                                        color: Colors.black,
                                        alignment: Alignment.center,
                                        child: FittedBox(
                                          fit: BoxFit.cover,
                                          // Use BoxFit.cover or BoxFit.fitWidth as needed
                                          child:
                                              AppImageViewer.showNetworkImage(
                                                  url: imageUrl ?? ""),
                                        ),
                                      ),
                                    ],
                                    if (imageUrl == null &&
                                        state.attachmentVideoControllers?[state
                                                .selectedAttachmentIndex] !=
                                            null) ...[
                                      GestureDetector(
                                        onTap: () {
                                          if (_chewieControllers[state
                                                      .selectedAttachmentIndex]
                                                  ?.isPlaying ==
                                              true) {
                                            _chewieControllers[state
                                                    .selectedAttachmentIndex]!
                                                .pause();
                                          } else {
                                            _chewieControllers[state
                                                    .selectedAttachmentIndex]!
                                                .play();
                                          }
                                          setState(() {});
                                        },
                                        child: state
                                                    .attachmentVideoControllers![
                                                        state
                                                            .selectedAttachmentIndex]!
                                                    .value
                                                    .aspectRatio <
                                                1
                                            ? Chewie(
                                                controller: _chewieControllers[
                                                    state
                                                        .selectedAttachmentIndex]!)
                                            : Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                color: Colors.black,
                                                child: FittedBox(
                                                  fit: BoxFit.cover,
                                                  // Use BoxFit.cover or BoxFit.fitWidth as needed
                                                  child: Container(
                                                    color: Colors.black,
                                                    width: _chewieControllers[state
                                                            .selectedAttachmentIndex]!
                                                        .videoPlayerController
                                                        .value
                                                        .size
                                                        .width,
                                                    height: _chewieControllers[state
                                                            .selectedAttachmentIndex]!
                                                        .videoPlayerController
                                                        .value
                                                        .size
                                                        .height,
                                                    child: Chewie(
                                                      controller:
                                                          _chewieControllers[state
                                                              .selectedAttachmentIndex]!,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (_chewieControllers[state
                                                      .selectedAttachmentIndex]
                                                  ?.isPlaying ==
                                              true) {
                                            _chewieControllers[state
                                                    .selectedAttachmentIndex]!
                                                .pause();
                                          } else {
                                            _chewieControllers[state
                                                    .selectedAttachmentIndex]!
                                                .play();
                                          }
                                          setState(() {});
                                        },
                                        child: _chewieControllers[state
                                                        .selectedAttachmentIndex]
                                                    ?.isPlaying ==
                                                true
                                            ? SizedBox()
                                            : ClipOval(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 40,
                                                  width: 40,
                                                  color: Colors.black45,
                                                  child: Icon(Icons.play_arrow),
                                                ),
                                              ),
                                      ),
                                    ],
                                    if (imageUrl == null &&
                                        state.attachmentVideoControllers?[state
                                                .selectedAttachmentIndex] ==
                                            null) ...[
                                      Container(
                                        width: double.infinity,
                                        color: Colors.black,
                                        alignment: Alignment.center,
                                        child: FittedBox(
                                          fit: BoxFit.cover,
                                          // Use BoxFit.cover or BoxFit.fitWidth as needed
                                          child: AppImageViewer.showAssetImage(
                                              path: AppImageAsset.appIcon),
                                        ),
                                      ),
                                    ],
                                    if (imageUrl == null)
                                      Positioned(
                                        top: 0,
                                        right: 45,
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isMuted = !isMuted;
                                              _chewieControllers[0]!.setVolume(
                                                  isMuted ? 0.0 : 1.0);
                                              log("isMuted :- $isMuted");
                                            });
                                          },
                                          icon: isMuted == true
                                              ? Icon(
                                                  Icons.volume_off,
                                                  size: 27,
                                                )
                                              : Icon(
                                                  Icons.volume_up,
                                                  size: 27,
                                                ),
                                        ),
                                      ),
                                    Positioned(
                                      top: 0,
                                      right: 5,
                                      child: IconButton(
                                        onPressed: () {
                                          FirebaseEvents.setFirebaseEvent(
                                              'click_news_detail_video_full_screen_on_off',
                                              {});
                                          setState(() {
                                            isFullScreenMode =
                                                !isFullScreenMode;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.fullscreen_outlined,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 10.h,
                                      left: 10.w,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 7, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Assets.icons.icEye.svg(
                                              height: 20,
                                              width: 20,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                Colors.white,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            Gap(5.w),
                                            Text(
                                              state.eventNewsDetailData
                                                      ?.viewCounts
                                                      ?.toString() ??
                                                  '0',
                                              style: TextStyles.semiBold(16.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (state.eventNewsDetailData?.attachments
                                            ?.first.isSensitiveContent ==
                                        true) ...[
                                      Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        color:
                                            Colors.black.withValues(alpha: 0.6),
                                        child: BackdropFilter(
                                          filter: ui.ImageFilter.blur(
                                              sigmaX: 15, sigmaY: 15),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                    height: 40.h,
                                                    child: FittedBox(
                                                      child: Assets
                                                          .icons.icEyeOff
                                                          .svg(),
                                                    )),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Text(
                                                  'Sensitive content',
                                                  style: TextStyles.bold(18.sp),
                                                ),
                                                Text(
                                                  'This video may contain graphic or violent content. ',
                                                  style:
                                                      TextStyles.medium(14.sp),
                                                ),
                                                SizedBox(
                                                  height: 20.h,
                                                ),
                                                Divider(
                                                  indent: 50.w,
                                                  endIndent: 50.w,
                                                ),
                                                CommonTextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      state
                                                              .eventNewsDetailData
                                                              ?.attachments
                                                              ?.first
                                                              .isSensitiveContent =
                                                          false;
                                                      _chewieControllers[state
                                                              .selectedAttachmentIndex]!
                                                          .play();
                                                    });
                                                  },
                                                  widget: Text(
                                                    'Show Anyway',
                                                    style: TextStyles.semiBold(
                                                        15.sp),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                )
                              : SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 400),
                                        height: isFullScreenMode
                                            ? (screenHeight *
                                                0.3) // Video player moves to center
                                            : 0, // Default is zero
                                      ),
                                      BlocBuilder<NewsDetailsScreenBlocCubit,
                                          NewsDetailsScreenBlocState>(
                                        builder: (context, state) {
                                          return AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 400),
                                            height: isFullScreenMode
                                                ? expandedHeight
                                                : collapsedHeight,
                                            width: videoPlayerWidth,
                                            child: Column(
                                              children: [
                                                CarouselSlider.builder(
                                                  itemCount: state
                                                          .eventNewsDetailData!
                                                          .attachments
                                                          ?.length ??
                                                      0,
                                                  itemBuilder: (context, index,
                                                      realIndex) {
                                                    if (state
                                                            .eventNewsDetailData!
                                                            .attachments![index]
                                                            .attachmentFileType ==
                                                        "Video") {
                                                      VideoPlayerController?
                                                          videoController =
                                                          state.attachmentVideoControllers?[
                                                              index];
                                                      if (!_chewieControllers
                                                          .containsKey(index)) {
                                                        if (videoController !=
                                                            null) {
                                                          _chewieControllers[
                                                                  index] =
                                                              ChewieController(
                                                            videoPlayerController:
                                                                videoController,
                                                            autoPlay: state
                                                                        .eventNewsDetailData
                                                                        ?.attachments
                                                                        ?.first
                                                                        .isSensitiveContent ==
                                                                    true
                                                                ? false
                                                                : index ==
                                                                    state
                                                                        .attachmentCurrentIndex,
                                                            autoInitialize:
                                                                true,
                                                            allowMuting: true,
                                                            placeholder: Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: AppColors
                                                                    .whiteColor,
                                                              ),
                                                            ),
                                                            allowPlaybackSpeedChanging:
                                                                false,
                                                            allowFullScreen:
                                                                true,
                                                            showControls: false,
                                                            showControlsOnInitialize:
                                                                false,
                                                            looping: true,
                                                            aspectRatio:
                                                                // 16 / 9,
                                                                videoController
                                                                    .value
                                                                    .aspectRatio,
                                                            bufferingBuilder:
                                                                (context) {
                                                              return Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: AppColors
                                                                      .whiteColor,
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        }
                                                      }
                                                      return _chewieControllers[
                                                                  index] !=
                                                              null
                                                          ? Stack(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    isFullScreenMode =
                                                                        !isFullScreenMode;
                                                                    imageUrl =
                                                                        null;
                                                                    context
                                                                        .read<
                                                                            NewsDetailsScreenBlocCubit>()
                                                                        .setAttachmentIndex(
                                                                            index);
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child:
                                                                      SizedBox(
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    // height: isFullScreenMode  ? MediaQuery.of(
                                                                    //     context)
                                                                    //     .size
                                                                    //     .height : null,
                                                                    child: Chewie(
                                                                        controller:
                                                                            _chewieControllers[index]!),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  top: 2,
                                                                  right: 5,
                                                                  child:
                                                                      IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        isMuted =
                                                                            !isMuted;
                                                                        _chewieControllers[index]!.setVolume(isMuted
                                                                            ? 0.0
                                                                            : 1.0);
                                                                        log("isMuted :- $isMuted");
                                                                      });
                                                                    },
                                                                    icon: isMuted ==
                                                                            true
                                                                        ? Icon(Icons
                                                                            .volume_off)
                                                                        : Icon(Icons
                                                                            .volume_up),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  right: 5,
                                                                  bottom: 0,
                                                                  child:
                                                                      IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        showDownloadAnimation =
                                                                            false;
                                                                        isFullScreenMode =
                                                                            !isFullScreenMode;

                                                                        context
                                                                            .read<NewsDetailsScreenBlocCubit>()
                                                                            .setAttachmentIndex(index);
                                                                      });
                                                                    },
                                                                    icon: Icon(Icons
                                                                        .fullscreen_outlined),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  bottom: 10.h,
                                                                  left: 10.w,
                                                                  child: Row(
                                                                    children: [
                                                                      Assets
                                                                          .icons
                                                                          .icEye
                                                                          .svg(
                                                                        colorFilter:
                                                                            const ColorFilter.mode(
                                                                          Colors
                                                                              .white,
                                                                          BlendMode
                                                                              .srcIn,
                                                                        ),
                                                                      ),
                                                                      Gap(5.w),
                                                                      Text(
                                                                        state.eventNewsDetailData?.viewCounts?.toString() ??
                                                                            '0',
                                                                        style: TextStyles.semiBold(
                                                                            16.sp),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                if (state
                                                                        .eventNewsDetailData
                                                                        ?.attachments
                                                                        ?.first
                                                                        .isSensitiveContent ==
                                                                    true) ...[
                                                                  Container(
                                                                    width: double
                                                                        .infinity,
                                                                    height: double
                                                                        .infinity,
                                                                    color: Colors
                                                                        .black
                                                                        .withValues(
                                                                            alpha:
                                                                                0.6),
                                                                    child:
                                                                        BackdropFilter(
                                                                      filter: ui.ImageFilter.blur(
                                                                          sigmaX:
                                                                              15,
                                                                          sigmaY:
                                                                              15),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            SizedBox(
                                                                                height: 40.h,
                                                                                child: FittedBox(
                                                                                  child: Assets.icons.icEyeOff.svg(),
                                                                                )),
                                                                            SizedBox(
                                                                              height: 10.h,
                                                                            ),
                                                                            Text(
                                                                              'Sensitive content',
                                                                              style: TextStyles.bold(18.sp),
                                                                            ),
                                                                            Text(
                                                                              'This video may contain graphic or violent content. ',
                                                                              style: TextStyles.medium(14.sp),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 20.h,
                                                                            ),
                                                                            Divider(
                                                                              indent: 50.w,
                                                                              endIndent: 50.w,
                                                                            ),
                                                                            CommonTextButton(
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  state.eventNewsDetailData?.attachments?.first.isSensitiveContent = false;
                                                                                  _chewieControllers[state.selectedAttachmentIndex]!.play();
                                                                                });
                                                                              },
                                                                              widget: Text(
                                                                                'Show Anyway',
                                                                                style: TextStyles.semiBold(15.sp),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ],
                                                            )
                                                          : Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: AppColors
                                                                    .whiteColor,
                                                              ),
                                                            );
                                                    } else {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          isFullScreenMode =
                                                              !isFullScreenMode;
                                                          context
                                                              .read<
                                                                  NewsDetailsScreenBlocCubit>()
                                                              .setAttachmentIndex(
                                                                  index);
                                                          imageUrl = state
                                                              .eventNewsDetailData!
                                                              .attachments![
                                                                  index]
                                                              .attachment;
                                                          setState(() {});
                                                        },
                                                        child: SizedBox(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                                    Radius.circular(
                                                                        7.0)),
                                                            child:
                                                                AppNetworkImageLoader(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              url: state
                                                                      .eventNewsDetailData!
                                                                      .attachments?[
                                                                          index]
                                                                      .attachment ??
                                                                  '',
                                                              boxFit:
                                                                  BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  options: CarouselOptions(
                                                    aspectRatio: 2.0,
                                                    enlargeCenterPage: true,
                                                    enableInfiniteScroll: false,
                                                    initialPage: 0,
                                                    autoPlay: false,
                                                    viewportFraction: 0.92,
                                                    enlargeFactor: 0.15,
                                                    onPageChanged:
                                                        (index, reason) {
                                                      context
                                                          .read<
                                                              NewsDetailsScreenBlocCubit>()
                                                          .onPageChanged(
                                                              index, reason);
                                                    },
                                                  ),
                                                ),
                                                if ((state
                                                            .eventNewsDetailData!
                                                            .attachments
                                                            ?.length ??
                                                        0) >
                                                    1) ...[
                                                  Gap(10.h),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: List.generate(
                                                          state
                                                                  .eventNewsDetailData!
                                                                  .attachments
                                                                  ?.length ??
                                                              0, (index) {
                                                        return Container(
                                                          height: 6.h,
                                                          width: 12.w,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      2.w),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: (index ==
                                                                    state
                                                                        .attachmentCurrentIndex)
                                                                ? AppColors
                                                                    .whiteColor
                                                                : AppColors
                                                                    .whiteColor
                                                                    .withValues(
                                                                        alpha:
                                                                            0.3),
                                                            shape: (index ==
                                                                    state
                                                                        .attachmentCurrentIndex)
                                                                ? BoxShape
                                                                    .rectangle
                                                                : BoxShape
                                                                    .rectangle,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.r),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      Visibility(
                                        visible: !isFullScreenMode,
                                        child: Column(
                                          children: [
                                            Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20.w),
                                                  child: BlocBuilder<
                                                      NewsDetailsScreenBlocCubit,
                                                      NewsDetailsScreenBlocState>(
                                                    buildWhen: (previous,
                                                            current) =>
                                                        previous
                                                            .eventNewsDetailData !=
                                                        current
                                                            .eventNewsDetailData,
                                                    builder: (context, state) {
                                                      String date = '';
                                                      String time = '';
                                                      if (state.eventNewsDetailData !=
                                                              null &&
                                                          state.eventNewsDetailData!
                                                                  .eventTime !=
                                                              null) {
                                                        date = DateFormat(
                                                                'dd MMM')
                                                            .format(state
                                                                .eventNewsDetailData!
                                                                .eventTime!
                                                                .toLocal());
                                                        time = timeAgo(
                                                            state
                                                                .eventNewsDetailData!
                                                                .eventTime!
                                                                .toLocal(),
                                                            hideAgoSuffix:
                                                                true);
                                                      }
                                                      return Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          ReadMoreText(
                                                            state.eventNewsDetailData
                                                                    ?.title ??
                                                                'Title',
                                                            trimMode:
                                                                TrimMode.Line,
                                                            trimLines: 2,
                                                            style: TextStyles
                                                                .semiBold(26.sp,
                                                                    fontFamily:
                                                                        testTiemposHeadline),
                                                            colorClickableText:
                                                                Colors.white,
                                                            trimCollapsedText:
                                                                'Show more',
                                                            trimExpandedText:
                                                                ' Show less',
                                                            moreStyle:
                                                                TextStyles
                                                                    .light(
                                                              18.sp,
                                                              fontColor:
                                                                  Colors.white,
                                                            ),
                                                            lessStyle:
                                                                TextStyles
                                                                    .light(
                                                              18.sp,
                                                              fontColor:
                                                                  Colors.white,
                                                            ),
                                                          ),

                                                          // Text(
                                                          //   state.eventNewsDetailData
                                                          //           ?.title ??
                                                          //       'Title',
                                                          //   style: TextStyles
                                                          //       .semiBold(
                                                          //           26.sp,
                                                          //           fontFamily:
                                                          //               testTiemposHeadline),
                                                          //   maxLines: 2,
                                                          // ),
                                                          Gap(10.h),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      state.eventNewsDetailData
                                                                              ?.distance ??
                                                                          '0 km',
                                                                      style: TextStyles
                                                                          .light(
                                                                              18.sp),
                                                                    ),
                                                                    Gap(10.w),
                                                                    Assets.icons
                                                                        .icDot
                                                                        .svg(),
                                                                    Gap(10.w),
                                                                    Text(
                                                                      date,
                                                                      style: TextStyles
                                                                          .light(
                                                                              18.sp),
                                                                    ),
                                                                    Gap(10.w),
                                                                    Assets.icons
                                                                        .icDot
                                                                        .svg(),
                                                                    Gap(10.w),
                                                                    Text(
                                                                      time,
                                                                      style: TextStyles
                                                                          .light(
                                                                              18.sp),
                                                                    ),
                                                                    Gap(10.w),
                                                                    Assets.icons
                                                                        .icDot
                                                                        .svg(),
                                                                    Gap(10.w),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        '${state.eventNewsDetailData?.notifiedUserCount.toString() ?? '0'} Notified',
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: TextStyles.light(
                                                                            18.sp),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Gap(10.h),
                                                          ReadMoreText(
                                                            state.eventNewsDetailData
                                                                    ?.description ??
                                                                'Description',
                                                            // textAlign: TextAlign
                                                            //     .justify,
                                                            trimMode:
                                                                TrimMode.Line,
                                                            trimLines: 3,
                                                            style: TextStyles.medium(
                                                                18.sp,
                                                                fontColor: AppColors
                                                                    .whiteColor),
                                                            colorClickableText:
                                                                Colors.white,
                                                            trimCollapsedText:
                                                                '  Show more',
                                                            trimExpandedText:
                                                                ' Show less',
                                                            moreStyle: TextStyles
                                                                .medium(16.sp,
                                                                    fontColor:
                                                                        AppColors
                                                                            .whiteColor),
                                                            lessStyle: TextStyles
                                                                .medium(16.sp,
                                                                    fontColor:
                                                                        AppColors
                                                                            .whiteColor),
                                                          ),
                                                          Gap(5.h),
                                                          Visibility(
                                                            visible: state
                                                                    .eventNewsDetailData
                                                                    ?.hashTags
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            child: Text(
                                                              state.eventNewsDetailData
                                                                      ?.hashTags
                                                                      ?.join(
                                                                          ' ') ??
                                                                  '',
                                                              style: TextStyles.light(
                                                                  16.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontColor:
                                                                      AppColors
                                                                          .whiteColor),
                                                              maxLines: 3,
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: state
                                                              .eventNewsDetailData
                                                              ?.postType ==
                                                          'rescue' &&
                                                      state.eventNewsDetailData
                                                              ?.status !=
                                                          'Resolved',
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 20.w,
                                                        bottom: 15.h),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Have you Spot them/it?',
                                                          style: TextStyles.light(
                                                              16.sp,
                                                              fontColor: AppColors
                                                                  .whiteColor),
                                                          maxLines: 3,
                                                        ),
                                                        Gap(2.w),
                                                        InkWell(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          onTap: () {
                                                            context
                                                                .read<
                                                                    SendAlertCubit>()
                                                                .init();
                                                            context
                                                                .read<
                                                                    SendAlertCubit>()
                                                                .getCurrentLatLonAndTime(
                                                                    context);
                                                            showAppBottomSheet(
                                                              context,
                                                              AppCommonBottomSheet(
                                                                sheetBGColor:
                                                                    AppColors
                                                                        .actionBtnBgColor,
                                                                body: RescuePersonFoundBottomSheet(
                                                                    postId: state
                                                                            .eventNewsDetailData
                                                                            ?.id ??
                                                                        ''),
                                                                isOpenWithGradient:
                                                                    false,
                                                              ),
                                                            );
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  'Provide Update!',
                                                                  style: TextStyles.semiBold(
                                                                      16.sp,
                                                                      fontColor:
                                                                          AppColors
                                                                              .whiteColor,
                                                                      textDecoration:
                                                                          TextDecoration
                                                                              .underline),
                                                                ),
                                                                Gap(7.w),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    context
                                                                        .read<
                                                                            SendAlertCubit>()
                                                                        .init();
                                                                    context
                                                                        .read<
                                                                            SendAlertCubit>()
                                                                        .getCurrentLatLonAndTime(
                                                                            context);
                                                                    showAppBottomSheet(
                                                                      context,
                                                                      AppCommonBottomSheet(
                                                                        sheetBGColor:
                                                                            AppColors.actionBtnBgColor,
                                                                        body: RescuePersonFoundBottomSheet(
                                                                            postId:
                                                                                state.eventNewsDetailData?.id ?? ''),
                                                                        isOpenWithGradient:
                                                                            false,
                                                                      ),
                                                                    );
                                                                  },
                                                                  child: Assets
                                                                      .icons
                                                                      .icRescueUpdate
                                                                      .svg(),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                // Gap(10.h),
                                              ],
                                            ),
                                            Gap(10.h),
                                            BlocBuilder<
                                                NewsDetailsScreenBlocCubit,
                                                NewsDetailsScreenBlocState>(
                                              buildWhen: (previous, current) =>
                                                  previous
                                                      .eventNewsDetailData !=
                                                  current.eventNewsDetailData,
                                              builder: (context, state) {
                                                return Visibility(
                                                  visible: state
                                                              .eventNewsDetailData !=
                                                          null &&
                                                      state.eventNewsDetailData!
                                                              .timeLines !=
                                                          null &&
                                                      state
                                                          .eventNewsDetailData!
                                                          .timeLines!
                                                          .isNotEmpty,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Divider(
                                                              color: AppColors
                                                                  .actionBtnBgColor,
                                                              thickness: 1,
                                                            ),
                                                          ),
                                                          Gap(12.w),
                                                          Text(
                                                            'Timeline',
                                                            style: TextStyles
                                                                .semiBold(26.sp,
                                                                    fontFamily:
                                                                        testTiemposHeadline),
                                                            maxLines: 2,
                                                          ),
                                                          Gap(12.w),
                                                          Expanded(
                                                            child: Divider(
                                                              color: AppColors
                                                                  .actionBtnBgColor,
                                                              thickness: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Gap(15.h),
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemBuilder:
                                                            (context, index) {
                                                          String time = '';
                                                          time = DateFormat.jm()
                                                              .format(state
                                                                  .eventNewsDetailData!
                                                                  .timeLines![
                                                                      index]
                                                                  .eventTime!
                                                                  .toLocal());

                                                          return Align(
                                                            alignment: Alignment
                                                                .topCenter,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      time,
                                                                      style: TextStyles.regular(
                                                                          16.sp,
                                                                          fontColor:
                                                                              AppColors.textHintGrayColor),
                                                                    ),
                                                                    Gap(10.w),
                                                                    InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        FirebaseEvents.setFirebaseEvent(
                                                                            'click_news_detail_timeline_play_btn',
                                                                            {});
                                                                        List<Attachment>
                                                                            attachment =
                                                                            [];

                                                                        if (state.eventNewsDetailData !=
                                                                            null) {
                                                                          if (state.eventNewsDetailData!.attachments !=
                                                                              null) {
                                                                            for (var element
                                                                                in state.eventNewsDetailData!.attachments!) {
                                                                              if (state.eventNewsDetailData!.timeLines![index].attachmentId == element.attachmentId) {
                                                                                if (element.attachmentFileType == 'Image') {
                                                                                  await Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                      builder: (context) => NetworkImageScreen(
                                                                                        imageUrl: element.attachment ?? '',
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                } else {
                                                                                  attachment.add(element);
                                                                                  await Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                      builder: (context) => VideoPlayerPageView(
                                                                                        sensetiveContent: element.isSensitiveContent,
                                                                                        videoUrl: element.attachment ?? '',
                                                                                        contentType: 'video',
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                }
                                                                                break;
                                                                              }
                                                                            }
                                                                          }
                                                                        }

                                                                        log("Attachment: $attachment");
                                                                      },
                                                                      child:
                                                                          CircleAvatar(
                                                                        radius:
                                                                            12.r,
                                                                        backgroundColor:
                                                                            AppColors.actionBtnBgColor,
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .play_arrow,
                                                                          size:
                                                                              16.sp,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Gap(5.h),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              30.w),
                                                                  child: Text(
                                                                    state
                                                                            .eventNewsDetailData!
                                                                            .timeLines![index]
                                                                            .description ??
                                                                        'Description',
                                                                    style: TextStyles
                                                                        .regular(
                                                                            16.sp),
                                                                    maxLines:
                                                                        10,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ),
                                                                Visibility(
                                                                  visible: state
                                                                              .eventNewsDetailData!
                                                                              .timeLines![
                                                                                  index]
                                                                              .address !=
                                                                          null &&
                                                                      state
                                                                          .eventNewsDetailData!
                                                                          .timeLines![
                                                                              index]
                                                                          .address!
                                                                          .isNotEmpty,
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            30.w),
                                                                    child: Text(
                                                                      state.eventNewsDetailData!.timeLines![index]
                                                                              .address ??
                                                                          '',
                                                                      style: TextStyles
                                                                          .regular(
                                                                              16.sp),
                                                                      maxLines:
                                                                          10,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                ),
                                                                if (index !=
                                                                    state
                                                                            .eventNewsDetailData!
                                                                            .timeLines!
                                                                            .length -
                                                                        0)
                                                                  Gap(10.h),
                                                                if (index !=
                                                                    state
                                                                            .eventNewsDetailData!
                                                                            .timeLines!
                                                                            .length -
                                                                        0)
                                                                  Assets.icons
                                                                      .icTimelinePath
                                                                      .svg(),
                                                                if (index !=
                                                                    state
                                                                            .eventNewsDetailData!
                                                                            .timeLines!
                                                                            .length -
                                                                        0)
                                                                  Gap(10.h),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                        itemCount: state
                                                                    .eventNewsDetailData !=
                                                                null
                                                            ? state
                                                                    .eventNewsDetailData!
                                                                    .timeLines
                                                                    ?.length ??
                                                                0
                                                            : 0,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                            Visibility(
                                                visible: state
                                                            .eventNewsDetailData !=
                                                        null &&
                                                    state.eventNewsDetailData!
                                                            .timeLines !=
                                                        null &&
                                                    state.eventNewsDetailData!
                                                        .timeLines!.isNotEmpty,
                                                child: Gap(10.h)),
                                            state.isInThisAreaLoading
                                                ? InThisAreaPostLoader()
                                                : BlocBuilder<
                                                    NewsDetailsScreenBlocCubit,
                                                    NewsDetailsScreenBlocState>(
                                                    buildWhen: (previous,
                                                            current) =>
                                                        previous
                                                            .inThisAreaEventDataList !=
                                                        current
                                                            .inThisAreaEventDataList,
                                                    builder: (context, state) {
                                                      return Visibility(
                                                        visible: state
                                                                    .inThisAreaEventDataList !=
                                                                null &&
                                                            state
                                                                .inThisAreaEventDataList!
                                                                .isNotEmpty,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      Divider(
                                                                    color: AppColors
                                                                        .actionBtnBgColor,
                                                                    thickness:
                                                                        1,
                                                                  ),
                                                                ),
                                                                Gap(12.w),
                                                                Text(
                                                                  'In this area',
                                                                  style: TextStyles
                                                                      .semiBold(
                                                                          26.sp,
                                                                          fontFamily:
                                                                              testTiemposHeadline),
                                                                  maxLines: 2,
                                                                ),
                                                                Gap(12.w),
                                                                Expanded(
                                                                  child:
                                                                      Divider(
                                                                    color: AppColors
                                                                        .actionBtnBgColor,
                                                                    thickness:
                                                                        1,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Gap(20.h),
                                                            ListView.separated(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10.w),
                                                              physics:
                                                                  NeverScrollableScrollPhysics(),
                                                              shrinkWrap: true,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    FirebaseEvents
                                                                        .setFirebaseEvent(
                                                                            'click_news_detail_in_this_area_event',
                                                                            {});
                                                                    if (!mounted) {
                                                                      return;
                                                                    }
                                                                    context
                                                                        .read<
                                                                            NewsDetailsScreenBlocCubit>()
                                                                        .init();
                                                                    context
                                                                        .read<
                                                                            NewsDetailsScreenBlocCubit>()
                                                                        .getPostId(state.inThisAreaEventDataList![index].id ??
                                                                            '');
                                                                    context
                                                                        .read<
                                                                            NewsDetailsScreenBlocCubit>()
                                                                        .getEventNewsDetailData();
                                                                    context
                                                                        .read<
                                                                            NewsDetailsScreenBlocCubit>()
                                                                        .getInThisAreaPostList();
                                                                    NavigatorRoute.navigateToReplacement(
                                                                        context,
                                                                        AppRoutes
                                                                            .newsDetails,
                                                                        args: {
                                                                          "isHome":
                                                                              false,
                                                                        });
                                                                  },
                                                                  child:
                                                                      AreaPostWidget(
                                                                    inThisAreaEventData:
                                                                        state.inThisAreaEventDataList![
                                                                            index],
                                                                  ),
                                                                );
                                                              },
                                                              separatorBuilder:
                                                                  (context,
                                                                          index) =>
                                                                      Gap(10.h),
                                                              itemCount: state
                                                                      .inThisAreaEventDataList
                                                                      ?.length ??
                                                                  0,
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                            Gap(20.h),
                                          ],
                                        ),
                                      ),
                                      Gap(68.h),
                                    ],
                                  ),
                                )
                          : Center(
                              child: Text(
                                'Data not found.',
                                style: TextStyles.semiBold(22.sp,
                                    fontColor: AppColors.whiteColor),
                              ),
                            ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 70.h,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.blackColor,
                            AppColors.blackColor.withValues(alpha: 0.7),
                            AppColors.blackColor.withValues(alpha: 0.4),
                            AppColors.blackColor.withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: (isFullScreenMode) ? 360.h : 280.h,
                    right: 5.w,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // state.isLikeAnimation == true
                        //     ? CircleAvatar(
                        //         radius: 30.r,
                        //         child: Lottie.asset(
                        //           "assets/animation/like_thumb.json",
                        //           repeat: false,
                        //           onLoaded: (composition) {
                        //             Future.delayed(composition.duration, () {
                        //               context
                        //                   .read<NewsDetailsScreenBlocCubit>()
                        //                   .setLikeAnimationFalse();
                        //             });
                        //           },
                        //         ),
                        //       )
                        //     :

                        GestureDetector(
                          onTapDown: (_) => setState(() => likeScale = 0.9),
                          onTapUp: (_) => setState(() => likeScale = 1.0),
                          onTap: () async {
                            FirebaseEvents.setFirebaseEvent(
                                'click_news_detail_reaction_btn', {});
                            HapticFeedback.mediumImpact();
                            await context
                                .read<NewsDetailsScreenBlocCubit>()
                                .addReactionPost(state.postId, context, true);
                          },
                          child:
                              //new
                              ReactButton(
                                  bgColor: AppColors.actionBtnBgColor,
                                  size: 51,
                                  reactionIcon:
                                      state.eventNewsDetailData?.reactionIcon ??
                                          '',
                                  hasReacted: state.isReacted == true),

                          ///old
                          //     AnimatedScale(
                          //   scale: likeScale,
                          //   duration: Duration(milliseconds: 100),
                          //   child: CircleAvatar(
                          //     radius: 30.r,
                          //     backgroundColor: state.isReacted == true
                          //         ? Colors.white54
                          //         : AppColors.actionBtnBgColor,
                          //     child: Padding(
                          //       padding: EdgeInsets.all(10.sp),
                          //       child: AppNetworkImageLoader(
                          //         url:
                          //             state.eventNewsDetailData?.reactionIcon ??
                          //                 '',
                          //         height: 28,
                          //         width: 28,
                          //         boxFit: BoxFit.contain,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ),
                        Gap(5.h),
                        BlocBuilder<NewsDetailsScreenBlocCubit,
                            NewsDetailsScreenBlocState>(
                          buildWhen: (previous, current) =>
                              previous.reactionCount != current.reactionCount,
                          builder: (context, state) {
                            return Text(
                              state.reactionCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                // White text
                                fontSize: 16.sp,
                                fontWeight: FontWeight.normal,

                                fontFamily: robotoFont,
                                shadows: [
                                  Shadow(
                                      offset: Offset(2, 2),
                                      blurRadius: 4,
                                      color: Colors.black.withValues(
                                          alpha: 0.2) // Shadow color
                                      ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: (isFullScreenMode) ? 260.h : 180.h,
                    right: 5.w,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            FirebaseEvents.setFirebaseEvent(
                                'click_news_detail_comment_btn', {});
                            context
                                .read<NewsScreenBlocCubit>()
                                .getPostComments(state.postId);
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
                                  eventPostId: state.postId,
                                ),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 30.r,
                            backgroundColor: AppColors.actionBtnBgColor,
                            child: Padding(
                              padding: EdgeInsets.all(14.sp),
                              child: Assets.icons.icMessage.svg(),
                            ),
                          ),
                        ),
                        Gap(5.h),
                        BlocBuilder<NewsDetailsScreenBlocCubit,
                            NewsDetailsScreenBlocState>(
                          buildWhen: (previous, current) =>
                              previous.commentCount != current.commentCount,
                          builder: (context, state) {
                            return Text(
                              state.commentCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                // White text
                                fontSize: 16.sp,
                                fontWeight: FontWeight.normal,

                                fontFamily: robotoFont,
                                shadows: [
                                  Shadow(
                                      offset: Offset(2, 2),
                                      blurRadius: 4,
                                      color: Colors.black.withValues(
                                          alpha: 0.2) // Shadow color
                                      ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: (isFullScreenMode) ? 180.h : 100.h,
                    right: 5.w,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            FirebaseEvents.setFirebaseEvent(
                                'click_news_detail_share_btn', {});
                            if (state.eventNewsDetailData != null) {
                              showAppBottomSheet(
                                context,
                                AppCommonBottomSheet(
                                  // sheetBGColor: AppColors.tabbarIndicatorColor,
                                  isOpenWithGradient: false,
                                  body: ShareEventBottomSheet(
                                    eventNewsDetailData:
                                        state.eventNewsDetailData!,
                                  ),
                                ),
                              );
                            } else {
                              AppFunctions.showToast('Event Data not found');
                            }
                          },
                          child: CircleAvatar(
                            radius: 30.r,
                            backgroundColor: AppColors.actionBtnBgColor,
                            child: Padding(
                              padding: EdgeInsets.all(14.sp),
                              child: Assets.icons.icShare.svg(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isFullScreenMode,
                    child: Positioned(
                      bottom: 100.h,
                      right: 5.w,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: isDownloading || showDownloadAnimation
                            ? null
                            : () async {
                                FirebaseEvents.setFirebaseEvent(
                                    'click_news_detail_download_btn', {});
                                try {
                                  if (Platform.isAndroid) {
                                    PermissionStatus? status;
                                    DeviceInfoPlugin deviceInfo =
                                        DeviceInfoPlugin();
                                    AndroidDeviceInfo androidInfo =
                                        await deviceInfo.androidInfo;

                                    if (androidInfo.version.sdkInt >= 33) {
                                      status =
                                          await Permission.photos.request();
                                    } else {
                                      status =
                                          await Permission.storage.request();
                                    }

                                    if (status.isGranted) {
                                      setState(() {
                                        isDownloading = true;
                                      });
                                      final postType = state
                                          .eventNewsDetailData!
                                          .attachments![
                                              state.selectedAttachmentIndex]
                                          .attachmentFileType;
                                      final extension =
                                          postType == "Video" ? "mp4" : "jpeg";
                                      const String path =
                                          '/storage/emulated/0/Download';

                                      // Download video
                                      String downloadedFilepath =
                                          '$path/${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}_1.$extension';
                                      await Dio().download(
                                          state
                                              .eventNewsDetailData!
                                              .attachments![
                                                  state.selectedAttachmentIndex]
                                              .attachment!,
                                          downloadedFilepath);

                                      platform.invokeMethod('scanFile',
                                          {'path': downloadedFilepath});
                                      setState(() {
                                        isDownloading = false;
                                        showDownloadAnimation = true;
                                      });

                                      AppFunctions.showToast(
                                          '${extension == 'mp4' ? "Video" : "Photo"} Saved Successfully');
                                    }
                                  } else {
                                    setState(() {
                                      isDownloading = true;
                                    });
                                    PermissionStatus status =
                                        await Permission.storage.status;
                                    if (status.isGranted ||
                                        await Permission.storage
                                            .request()
                                            .isGranted) {
                                      await Permission.photos.request();
                                      Directory documents =
                                          await getApplicationDocumentsDirectory();
                                      // if (!(await documents.exists())) {
                                      //   await documents.create(recursive: true);
                                      // }
                                      Directory dir = Directory(documents.path);
                                      if (await dir.exists() == false) {
                                        await dir.create(recursive: true);
                                      }
                                      String path = dir.path;
                                      // File? downloadedFile;
                                      final postType = state
                                          .eventNewsDetailData!
                                          .attachments![
                                              state.selectedAttachmentIndex]
                                          .attachmentFileType;
                                      final extension =
                                          postType == "Video" ? "mp4" : "jpeg";
                                      String downloadedFilepath =
                                          '$path/${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}_1.$extension';
                                      debugPrint(
                                          'Downloading video to: $downloadedFilepath'); // Debug: Check download path
                                      await Dio().download(
                                          state
                                              .eventNewsDetailData!
                                              .attachments![
                                                  state.selectedAttachmentIndex]
                                              .attachment!,
                                          downloadedFilepath);
                                      await platform.invokeMethod(
                                          'saveVideoToGallery',
                                          {'path': downloadedFilepath});

                                      setState(() {
                                        isDownloading = false;
                                        showDownloadAnimation = true;
                                      });
                                      AppFunctions.showToast(
                                          '${extension == 'mp4' ? "Video" : "Photo"} Saved Successfully');

                                      // }
                                    } else {
                                      debugPrint(
                                          'Storage permission is not granted'); // Debug: Permission issue
                                    }
                                  }
                                } catch (e) {
                                  setState(() {
                                    isDownloading = false;
                                    showDownloadAnimation = false;
                                  });
                                  log("Error: $e");
                                }

                                // try {
                                //   if (Platform.isAndroid) {
                                //     PermissionStatus? status;
                                //     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                                //     AndroidDeviceInfo androidInfo =
                                //         await deviceInfo.androidInfo;
                                //     if (androidInfo.version.sdkInt >= 33) {
                                //       status = await Permission.photos.request();
                                //     } else {
                                //       status = await Permission.storage.request();
                                //     }
                                //     if (status.isGranted) {
                                //       isDownloading = true;
                                //       setState(() {});
                                //       const String path =
                                //           '/storage/emulated/0/Download';
                                //
                                //       String downloadedFilepath =
                                //           '$path/${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}_1.mp4';
                                //       await Dio().download(
                                //           state
                                //               .eventNewsDetailData!
                                //               .attachments![
                                //                   state.selectedAttachmentIndex]
                                //               .attachment!,
                                //           downloadedFilepath);
                                //       File? downloadedFile = File(downloadedFilepath);
                                //
                                //       // Directory tempDir =
                                //       //     await getTemporaryDirectory();
                                //       // if (await File(
                                //       //             '${tempDir.path}/awaz_watermark.png')
                                //       //         .exists() ==
                                //       //     false) {
                                //       //   ByteData byteData = await rootBundle
                                //       //       .load(Assets.icons.icWaterMarkAwaaz.path);
                                //       //   Uint8List uint8List =
                                //       //       byteData.buffer.asUint8List();
                                //       //   File wmImg = File(
                                //       //       '${tempDir.path}/awaz_watermark.png');
                                //       //   await wmImg.writeAsBytes(uint8List);
                                //       // }
                                //       // File watermarkImage =
                                //       //     File('${tempDir.path}/awaz_watermark.png');
                                //       //
                                //       // String overlayPosition =
                                //       //     getRandomOverlayPosition();
                                //       // String outputPath =
                                //       //     '$path/${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}_2.mp4';
                                //       // String command =
                                //       //     '-i ${downloadedFile.path} -i ${watermarkImage.path} -filter_complex "[1:v]scale=-1:160[wm];[0:v][wm]$overlayPosition" -c:v mpeg4 -q:v 2 -c:a copy $outputPath';
                                //       // await FFmpegKit.execute(command);
                                //       // File(downloadedFile.path).deleteSync();
                                //       // String newOutputPath =
                                //       //     '$path/${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.mp4';
                                //       // if (context
                                //       //     .read<GoLiveCubit>()
                                //       //     .getAddressWatermarkValue()) {
                                //       //   await context
                                //       //       .read<GoLiveCubit>()
                                //       //       .getAddressFromLatLang(
                                //       //         latitude: state
                                //       //             .eventNewsDetailData?.latitude
                                //       //             ?.toDouble(),
                                //       //         longitude: state
                                //       //             .eventNewsDetailData?.longitude
                                //       //             ?.toDouble(),
                                //       //       );
                                //       //   await Future.delayed(
                                //       //     Duration(seconds: 1),
                                //       //     () async {
                                //       //       RenderRepaintBoundary boundary = globalKey
                                //       //               .currentContext
                                //       //               ?.findRenderObject()
                                //       //           as RenderRepaintBoundary;
                                //       //       ui.Image image = await boundary.toImage();
                                //       //       ByteData? byteData =
                                //       //           await image.toByteData(
                                //       //               format: ui.ImageByteFormat.png);
                                //       //       Uint8List uint8List =
                                //       //           byteData!.buffer.asUint8List();
                                //       //       File wmImg =
                                //       //           File('${tempDir.path}/watermark.png');
                                //       //       await wmImg.writeAsBytes(uint8List);
                                //       //
                                //       //       String addCommand =
                                //       //           '-i $outputPath -i ${wmImg.path} -filter_complex "[1:v]scale=-1:200[wm];[0:v][wm]overlay=(W-w)/2:H-h-70" -c:v mpeg4 -q:v 2 -c:a copy $newOutputPath';
                                //       //
                                //       //       await FFmpegKit.execute(addCommand);
                                //       //       File(outputPath).deleteSync();
                                //       //     },
                                //       //   );
                                //       // }
                                //
                                //       isDownloading = false;
                                //       setState(() {});
                                //
                                //       AppFunctions.showToast(
                                //           'Video Saved Successfully');
                                //     }
                                //   }
                                // } catch (e) {
                                //   isDownloading = false;
                                //   setState(() {});
                                // }
                              },
                        child: CircleAvatar(
                          radius: 30.r,
                          backgroundColor: AppColors.actionBtnBgColor,
                          child: Padding(
                            padding: EdgeInsets.all(8.sp),
                            child: (isDownloading)
                                ? SizedBox(
                                    height: 20.0,
                                    width: 20.0,
                                    child: CircularProgressIndicator(
                                      color: AppColors.whiteColor,
                                    ),
                                  )
                                : showDownloadAnimation
                                    ? SizedBox(
                                        height: 30.0,
                                        width: 30.0,
                                        child: Lottie.asset(
                                            Assets.animation.done.path,
                                            fit: BoxFit.contain,
                                            repeat: false),
                                      )
                                    : Assets.icons.icDownloadPost.svg(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 20.h, right: 20.w, left: 20.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          isFullScreenMode
                              ? BlocBuilder<NewsDetailsScreenBlocCubit,
                                  NewsDetailsScreenBlocState>(
                                  buildWhen: (previous, current) =>
                                      previous.eventNewsDetailData !=
                                      current.eventNewsDetailData,
                                  builder: (context, state) {
                                    String date = '';
                                    String time = '';
                                    if (state.eventNewsDetailData != null &&
                                        state.eventNewsDetailData!.eventTime !=
                                            null) {
                                      date = DateFormat('dd MMM').format(state
                                          .eventNewsDetailData!.eventTime!
                                          .toLocal());
                                      time = timeAgo(
                                          state.eventNewsDetailData!.eventTime!
                                              .toLocal(),
                                          hideAgoSuffix: true);
                                    }
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            ClipOval(
                                              child: AppNetworkImageLoader(
                                                url: state
                                                        .eventNewsDetailData
                                                        ?.attachments?[state
                                                            .selectedAttachmentIndex]
                                                        .profilePicture ??
                                                    '',
                                                height: 37,
                                                width: 37,
                                                boxFit: BoxFit.cover,
                                              ),
                                            ),
                                            Gap(10),
                                            Expanded(
                                              child: Text(
                                                state
                                                        .eventNewsDetailData
                                                        ?.attachments?[state
                                                            .selectedAttachmentIndex]
                                                        .name ??
                                                    'Aawaz',
                                                style: TextStyles.semiBold(
                                                        textOverflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        fontColor: Colors.white,
                                                        24.sp,
                                                        fontFamily:
                                                            testTiemposHeadline)
                                                    .copyWith(shadows: [
                                                  Shadow(
                                                      offset: Offset(2.0, 2.0),
                                                      blurRadius: 4,
                                                      color: Colors.black
                                                          .withValues(
                                                              alpha: 0.2)),
                                                ]),
                                                maxLines: 2,
                                              ),
                                            ),
                                            Gap(35.w)
                                          ],
                                        ),
                                        Gap(5.h),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: Text(
                                            state.eventNewsDetailData?.title ??
                                                'Title',
                                            style: TextStyles.semiBold(
                                                    fontColor: Colors.white,
                                                    24.sp,
                                                    fontFamily:
                                                        testTiemposHeadline)
                                                .copyWith(shadows: [
                                              Shadow(
                                                  offset: Offset(2.0, 2.0),
                                                  blurRadius: 4,
                                                  color: Colors.black
                                                      .withValues(alpha: 0.2)),
                                            ]),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Gap(5.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    state.eventNewsDetailData
                                                            ?.distance ??
                                                        '0 km',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        TextStyles.light(18.sp)
                                                            .copyWith(shadows: [
                                                      Shadow(
                                                          offset:
                                                              Offset(2.0, 2.0),
                                                          blurRadius: 4,
                                                          color: Colors.black
                                                              .withValues(
                                                                  alpha: 0.2)),
                                                    ]),
                                                  ),
                                                  Gap(10.w),
                                                  Assets.icons.icDot.svg(
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                      Colors.white,
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                  Gap(10.w),
                                                  Text(
                                                    date,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        TextStyles.light(18.sp)
                                                            .copyWith(shadows: [
                                                      Shadow(
                                                          offset:
                                                              Offset(2.0, 2.0),
                                                          blurRadius: 4,
                                                          color: Colors.black
                                                              .withValues(
                                                                  alpha: 0.2)),
                                                    ]),
                                                  ),
                                                  Gap(10.w),
                                                  Assets.icons.icDot.svg(
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                      Colors.white,
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                  Gap(10.w),
                                                  Text(
                                                    time,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        TextStyles.light(18.sp)
                                                            .copyWith(shadows: [
                                                      Shadow(
                                                          offset:
                                                              Offset(2.0, 2.0),
                                                          blurRadius: 4,
                                                          color: Colors.black
                                                              .withValues(
                                                                  alpha: 0.2)),
                                                    ]),
                                                  ),
                                                  Gap(10.w),
                                                  Assets.icons.icDot.svg(),
                                                  Gap(10.w),
                                                  Expanded(
                                                    child: Text(
                                                      '${state.eventNewsDetailData?.notifiedUserCount.toString() ?? '0'} Notified',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyles.light(
                                                              18.sp)
                                                          .copyWith(shadows: [
                                                        Shadow(
                                                            offset: Offset(
                                                                2.0, 2.0),
                                                            blurRadius: 4,
                                                            color: Colors.black
                                                                .withValues(
                                                                    alpha:
                                                                        0.2)),
                                                      ]),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Gap(5.h),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: ReadMoreText(
                                            state.eventNewsDetailData
                                                    ?.description ??
                                                'Description',
                                            trimMode: TrimMode.Line,
                                            trimLines: 2,
                                            // textAlign: TextAlign.justify,
                                            style: TextStyles.semiBold(18.sp)
                                                .copyWith(shadows: [
                                              Shadow(
                                                  offset: Offset(2.0, 2.0),
                                                  blurRadius: 4,
                                                  color: Colors.black
                                                      .withValues(alpha: 0.2)),
                                            ]),
                                            colorClickableText: Colors.white,
                                            trimCollapsedText: '  Show more',
                                            trimExpandedText: '  Show less',
                                            moreStyle: TextStyle(
                                              color: Colors.white,
                                              // White text
                                              fontSize: 16.sp,
                                              fontFamily: robotoFont,
                                              fontWeight: FontWeight.bold,
                                              shadows: [
                                                Shadow(
                                                    offset: Offset(2, 2),
                                                    blurRadius: 4,
                                                    color: Colors.black.withValues(
                                                        alpha:
                                                            0.15) // Shadow color
                                                    ),
                                              ],
                                            ),
                                            lessStyle: TextStyle(
                                              color: Colors.white,
                                              // White text
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: robotoFont,

                                              shadows: [
                                                Shadow(
                                                    offset: Offset(2, 2),
                                                    blurRadius: 4,
                                                    color: Colors.black.withValues(
                                                        alpha:
                                                            0.15) // Shadow color
                                                    ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Gap(5.h),
                                        Visibility(
                                          visible: state.eventNewsDetailData
                                                  ?.hashTags?.isNotEmpty ??
                                              false,
                                          child: Text(
                                            state.eventNewsDetailData?.hashTags
                                                    ?.join(' ') ??
                                                '',
                                            style: TextStyles.semiBold(16.sp,
                                                    fontWeight: FontWeight.w500,
                                                    fontColor:
                                                        AppColors.whiteColor)
                                                .copyWith(shadows: [
                                              Shadow(
                                                  offset: Offset(2.0, 2.0),
                                                  blurRadius: 4,
                                                  color: Colors.black
                                                      .withValues(alpha: 0.2)),
                                            ]),
                                            maxLines: 3,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                )
                              : SizedBox(),
                          Gap(10),
                          CommonCommentTextField(
                            controller: sendCommentController,
                            hintText: "Share your view",
                            maxLines: 1,
                            fillColor: Color(0xff2C2C2E),
                            textStyle: TextStyles.regular(
                              17.sp,
                              fontColor: AppColors.whiteColor,
                              fontFamily: testTiemposHeadline,
                            ),
                            readOnly: true,
                            cursorColor: AppColors.whiteColor,
                            onTap: () {
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
                                                  fontColor:
                                                      AppColors.redColor),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    eventPostId: state.postId,
                                  ),
                                ),
                              );
                            },
                            suffixIcon: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 6.h, horizontal: 6.w),
                              child: CircleAvatar(
                                radius: 20.r,
                                backgroundColor:
                                    AppColors.commentTextFieldColor,
                                child: Assets.icons.icMessageSend.svg(
                                  colorFilter: ColorFilter.mode(
                                    AppColors.textHintGrayColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget watermarkWidget(BuildContext context) {
    return BlocBuilder<GoLiveCubit, GoLiveState>(
        buildWhen: (previous, current) {
      return previous.googleAddressData != current.googleAddressData;
    }, builder: (context, goLiveState) {
      return BlocBuilder<NewsDetailsScreenBlocCubit,
          NewsDetailsScreenBlocState>(
        builder: (context, state) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: RepaintBoundary(
              key: globalKey,

              /// =*=*=*=*=*=*= VARIENT-3 =*=*=*=*=*=*=
              child: (PrefService.getInt(PrefService.addressStampIndex) == 2)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 160.h,
                          width: 170.h,
                          padding: EdgeInsets.only(
                              top: 5.h, left: 10.w, bottom: 2.h, right: 5.w),
                          decoration: BoxDecoration(
                            color: AppColors.blackColor.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                                color: AppColors.whiteColor
                                    .withValues(alpha: 0.25)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                goLiveState.googleAddressData?.results?.first
                                        .addressComponents?[0].shortName ??
                                    '',
                                maxLines: 1,
                                style: TextStyles.semiBold(
                                  16.sp,
                                  fontColor: AppColors.whiteColor,
                                ),
                              ),
                              Divider(
                                color: AppColors.whiteColor,
                                thickness: 2.sp,
                                height: 10,
                              ),
                              Text(
                                goLiveState.googleAddressData?.results?.first
                                        .formattedAddress ??
                                    '',
                                maxLines: 5,
                                style: TextStyles.medium(
                                  16.sp,
                                  fontColor: AppColors.whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(10.w),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 160.h,
                              width: 160.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(Assets.images.map.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Gap(7.h),
                            Container(
                              height: 55.h,
                              width: 160.h,
                              decoration: BoxDecoration(
                                color:
                                    AppColors.blackColor.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                    color: AppColors.whiteColor
                                        .withValues(alpha: 0.25)),
                              ),
                              padding: EdgeInsets.only(left: 5.w),
                              child: Row(
                                children: [
                                  Assets.images.awazLogoWebp
                                      .image(height: 40.h, width: 40.h),
                                  Gap(6.w),
                                  Text(
                                    'Awaaz App',
                                    style: TextStyles.semiBold(
                                      16.sp,
                                      fontColor: AppColors.whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Gap(10.w),
                        Container(
                          height: 160.h,
                          width: 170.h,
                          padding: EdgeInsets.only(
                              top: 10.h, left: 10.w, bottom: 8.h, right: 8.w),
                          decoration: BoxDecoration(
                            color: AppColors.blackColor.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                                color: AppColors.whiteColor
                                    .withValues(alpha: 0.25)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Lat : ${state.eventNewsDetailData?.latitude ?? 0.0}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.medium(16.sp,
                                    fontColor: AppColors.whiteColor),
                              ),
                              Text(
                                'Lang : ${state.eventNewsDetailData?.longitude ?? 0.0}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.medium(16.sp,
                                    fontColor: AppColors.whiteColor),
                              ),
                              Divider(
                                color: AppColors.whiteColor,
                                thickness: 2.sp,
                                height: 10,
                              ),
                              Text(
                                DateFormat("EEEE").format(DateTime.now()),
                                style: TextStyles.medium(
                                  16.5.sp,
                                  fontColor: AppColors.whiteColor,
                                ),
                              ),
                              Text(
                                DateFormat("dd MMM yyyy")
                                    .format(DateTime.now()),
                                style: TextStyles.medium(
                                  16.5.sp,
                                  fontColor: AppColors.whiteColor,
                                ),
                              ),
                              Text(
                                DateFormat("hh:mm:ss a").format(DateTime.now()),
                                style: TextStyles.medium(
                                  16.5.sp,
                                  fontColor: AppColors.whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : (PrefService.getInt(PrefService.addressStampIndex) == 1)
                      ?

                      /// DON'T REMOVE IN ANY HOW
                      /// =*=*=*=*=*=*= VARIENT-2 =*=*=*=*=*=*=
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: 160.h,
                              width: 170.h,
                              padding: EdgeInsets.only(
                                  top: 5.h,
                                  left: 10.w,
                                  bottom: 2.h,
                                  right: 5.w),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.blackColor.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                    color: AppColors.whiteColor
                                        .withValues(alpha: 0.25)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    goLiveState
                                            .googleAddressData
                                            ?.results
                                            ?.first
                                            .addressComponents?[0]
                                            .shortName ??
                                        '',
                                    maxLines: 1,
                                    style: TextStyles.semiBold(
                                      16.sp,
                                      fontColor: AppColors.whiteColor,
                                    ),
                                  ),
                                  Divider(
                                    color: AppColors.whiteColor,
                                    thickness: 2.sp,
                                    height: 10,
                                  ),
                                  Text(
                                    goLiveState.googleAddressData?.results
                                            ?.first.formattedAddress ??
                                        '',
                                    maxLines: 5,
                                    style: TextStyles.medium(
                                      16.sp,
                                      fontColor: AppColors.whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Gap(10.w),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Assets.images.map.image(
                                  height: 150.h,
                                  width: 150.h,
                                ),
                                Gap(7.h),
                                Container(
                                  height: 55.h,
                                  width: 150.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.blackColor
                                        .withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                        color: AppColors.whiteColor
                                            .withValues(alpha: 0.25)),
                                  ),
                                  padding: EdgeInsets.only(left: 5.w),
                                  child: Row(
                                    children: [
                                      Assets.images.awazLogoWebp
                                          .image(height: 40.h, width: 40.h),
                                      Gap(6.w),
                                      Text(
                                        'Awaaz App',
                                        style: TextStyles.semiBold(
                                          16.sp,
                                          fontColor: AppColors.whiteColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Gap(10.w),
                            Container(
                              height: 160.h,
                              width: 170.h,
                              padding: EdgeInsets.only(
                                  top: 10.h,
                                  left: 10.w,
                                  bottom: 8.h,
                                  right: 8.w),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.blackColor.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                    color: AppColors.whiteColor
                                        .withValues(alpha: 0.25)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Lat : ${state.eventNewsDetailData?.latitude ?? 0.0}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyles.medium(16.sp,
                                        fontColor: AppColors.whiteColor),
                                  ),
                                  Text(
                                    'Lang : ${state.eventNewsDetailData?.longitude ?? 0.0}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyles.medium(16.sp,
                                        fontColor: AppColors.whiteColor),
                                  ),
                                  Divider(
                                    color: AppColors.whiteColor,
                                    thickness: 2.sp,
                                    height: 10,
                                  ),
                                  Text(
                                    DateFormat("EEEE").format(DateTime.now()),
                                    style: TextStyles.medium(
                                      16.5.sp,
                                      fontColor: AppColors.whiteColor,
                                    ),
                                  ),
                                  Text(
                                    DateFormat("dd MMM yyyy")
                                        .format(DateTime.now()),
                                    style: TextStyles.medium(
                                      16.5.sp,
                                      fontColor: AppColors.whiteColor,
                                    ),
                                  ),
                                  Text(
                                    DateFormat("hh:mm:ss a")
                                        .format(DateTime.now()),
                                    style: TextStyles.medium(
                                      16.5.sp,
                                      fontColor: AppColors.whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : (PrefService.getInt(PrefService.addressStampIndex) == 0)
                          ?

                          /// DON'T REMOVE IN ANY HOW
                          /// =*=*=*=*=*=*= VARIENT-1 =*=*=*=*=*=*=
                          Row(
                              children: [
                                Container(
                                  height: 160.h,
                                  width: 160.h,
                                  padding: EdgeInsets.only(
                                      top: 10.h,
                                      left: 10.w,
                                      bottom: 10.h,
                                      right: 10.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.blackColor
                                        .withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                        color: AppColors.whiteColor
                                            .withValues(alpha: 0.25)),
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Assets.images.awazLogoWebp.image(
                                                height: 45.h, width: 45.h),
                                            Gap(6.w),
                                            Text(
                                              'Awaaz',
                                              style: TextStyles.semiBold(
                                                20.sp,
                                                fontColor: AppColors.whiteColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Gap(13.h),
                                        Text(
                                          DateFormat("dd MMM yyyy")
                                              .format(DateTime.now()),
                                          style: TextStyles.medium(
                                            22.sp,
                                            fontColor: AppColors.whiteColor,
                                          ),
                                        ),
                                        Text(
                                          DateFormat("EEEE")
                                              .format(DateTime.now()),
                                          style: TextStyles.semiBold(
                                            16.sp,
                                            fontColor: AppColors.whiteColor,
                                          ),
                                        ),
                                        Text(
                                          DateFormat("hh:mm:ss a")
                                              .format(DateTime.now()),
                                          style: TextStyles.regular(
                                            18.sp,
                                            fontColor: AppColors.whiteColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Gap(8.w),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 100.h,
                                        width: 270.w,
                                        decoration: BoxDecoration(
                                          color: AppColors.blackColor
                                              .withValues(alpha: 0.5),
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                          border: Border.all(
                                              color: AppColors.whiteColor
                                                  .withValues(alpha: 0.25)),
                                        ),
                                        padding: EdgeInsets.only(
                                            top: 10.h,
                                            left: 10.w,
                                            right: 10.w,
                                            bottom: 10.h),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              goLiveState
                                                      .googleAddressData
                                                      ?.results
                                                      ?.first
                                                      .formattedAddress ??
                                                  '',
                                              maxLines: 4,
                                              style: TextStyles.medium(15.sp,
                                                  fontColor:
                                                      AppColors.whiteColor),
                                            ),
                                            Container(
                                              height: 65,
                                              width: 65,
                                              decoration: BoxDecoration(
                                                color: AppColors.blackColor
                                                    .withValues(alpha: 0.5),
                                                image: DecorationImage(
                                                    image: AssetImage(Assets
                                                        .images.map.path)),
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                            ),
                                            Gap(1.w),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Gap(4.h),
                                    Container(
                                      height: 60.h,
                                      width: 270.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.blackColor
                                            .withValues(alpha: 0.5),
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        border: Border.all(
                                            color: AppColors.whiteColor
                                                .withValues(alpha: 0.25)),
                                      ),
                                      padding: EdgeInsets.only(
                                          top: 10.h,
                                          left: 10.w,
                                          right: 10.w,
                                          bottom: 10.h),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Latitude\n${state.eventNewsDetailData?.latitude ?? 0.0}',
                                              style: TextStyles.medium(15.sp,
                                                  fontColor:
                                                      AppColors.whiteColor),
                                            ),
                                          ),
                                          Gap(10.w),
                                          VerticalDivider(
                                              color: AppColors.whiteColor),
                                          Gap(10.w),
                                          Text(
                                            'Longitude\n${state.eventNewsDetailData?.longitude ?? 0.0}',
                                            style: TextStyles.medium(15.sp,
                                                fontColor:
                                                    AppColors.whiteColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Container(),
            ),
          );
        },
      );
    });
  }
}

class NetworkImageScreen extends StatelessWidget {
  final String imageUrl;

  const NetworkImageScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppCommonAppBar(
        title: 'Image',
        centerTitle: true,
      ),
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return CircularProgressIndicator(
              color: AppColors.whiteColor,
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Text('Failed to load image');
          },
        ),
      ),
    );
  }
}
