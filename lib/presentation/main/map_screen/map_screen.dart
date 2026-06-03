import 'dart:developer';
import 'dart:ui';
import 'package:eagle_eye/core/constant/app_constant.dart';
import 'package:eagle_eye/core/widget/app_common_loader_screen.dart';
import 'package:eagle_eye/presentation/main/map_screen/bloc/map_screen_cubit.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
import 'package:eagle_eye/services/socket_service/socket_service.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:sliding_up_panel_custom/sliding_up_panel_custom.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/map_utils.dart';
import '../../../core/widget/common_app_bar.dart';
import '../../../gen/assets.gen.dart';
import '../../../routes/app_navigation.dart';
import '../../../routes/app_routes.dart';
import '../home/bloc/home_screen_bloc_cubit.dart';
import '../news_details_screen/area_post_loader_loader.dart';
import '../news_details_screen/area_post_widget.dart';
import '../news_details_screen/bloc/news_details_screen_bloc_cubit.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class AnnotationClickListener extends OnPointAnnotationClickListener {
  final BuildContext context;
  bool isMapInit = false;
  AnnotationClickListener({
    required this.context,
  });

  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    log("onAnnotationClick, id: ${annotation.textField}}");
    FirebaseEvents.setFirebaseEvent('click_map_post_Annotation', {});
    context.read<NewsDetailsScreenBlocCubit>().init();
    context.read<NewsDetailsScreenBlocCubit>().getPostId(annotation.textField ?? '');
    context.read<NewsDetailsScreenBlocCubit>().getEventNewsDetailData();
    context.read<NewsDetailsScreenBlocCubit>().getInThisAreaPostList();
    if (Navigator.canPop(context)) {
      NavigatorRoute.navigateBack(context);
    }
    NavigatorRoute.navigateTo(context, AppRoutes.newsDetails, args: {
      "isHome": false,
    });
  }
}

class _MapScreenState extends State<MapScreen> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true; // This keeps the widget alive

  late MapScreenCubit _mapScreenCubit;
  final String customStyleURL = "mapbox://styles/rohitlogicgo/cm3wwtp4v00g801s88yp93j9j";
  // "mapbox://styles/rohitlogicgo/cm3y3qact00d601si02hx7bqb";

  late TabController tabController;
  int selectedIndex = 0;
  bool isLoading = false;
  CameraChangedEventData? cameraEventData;
  final List<String> events = ['Event', 'General', 'Rescue'];

  @override
  void initState() {
    FirebaseEvents.setFirebaseEvent('map_screen', {});
    super.initState();
    context.read<MapScreenCubit>().updateUserCurrentLocation();
    context.read<MapScreenCubit>().defaultCameraView();
    context.read<MapScreenCubit>().setProfilePic();
    tabController = TabController(length: 2, vsync: this);
  }

  // bool isOpenMapFullScreen = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<HomeScreenBlocCubit, HomeScreenBlocState>(
        buildWhen: (previous, current) => previous.isBottomHide != current.isBottomHide,
        builder: (context, homeState) {
          return Scaffold(
            appBar: HomeAppBar(
              title: BlocBuilder<MapScreenCubit, MapScreenState>(
                buildWhen: (previous, current) => previous.currentCity != current.currentCity,
                builder: (context, state) {
                  return Text(
                    state.currentCity,
                    style: TextStyles.semiBold(36.sp, fontFamily: testTiemposHeadline),
                  );
                },
              ),
              action: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 25.r,
                      backgroundColor: AppColors.actionBtnBgColor,
                      child: IconButton(
                        onPressed: () {
                          FirebaseEvents.setFirebaseEvent('click_map_screen_search', {});
                          if (!mounted) return;
                          // context.read<SearchScreenBlocCubit>().init();
                          NavigatorRoute.navigateTo(context, AppRoutes.search);
                        },
                        icon: Assets.icons.icSearchHome.svg(),
                      ),
                    ),
                  ],
                ),
                Gap(15.w),
                // GestureDetector(
                //   onTap: () {
                //     NavigatorRoute.navigateTo(context, AppRoutes.alerts);
                //   },
                //   child: CircleAvatar(
                //     radius: 25.r,
                //     backgroundColor: AppColors.actionBtnBgColor,
                //     child: Padding(
                //       padding: const EdgeInsets.all(8),
                //       child: Assets.icons.icAlertSelectedBottom.svg(),
                //     ),
                //   ),
                // ),
                // Gap(15.w),
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
                            flutter.Visibility(
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
            body: AppCommonLoaderScreen(
              inAsyncCall: isLoading,
              child: Stack(
                children: [
                  SlidingUpPanel(
                    key: const ValueKey("slidingPanel"),
                    controller: context.read<MapScreenCubit>().panelController,
                    panelBuilder: (sc) => _panel(sc),
                    options: SlidingUpPanelOptions(
                      color: AppColors.blackColor,
                      parallaxEnabled: true,
                      parallaxOffset: 0.9,
                      initialMaxHeight: homeState.isBottomHide ? 0.0 : MediaQuery.of(context).size.height * 0.7,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18.0),
                        topRight: Radius.circular(18.0),
                      ),
                      initialMinHeight: homeState.isBottomHide
                          ? 0.0
                          : (tabController.index == 0)
                              ? 150.h
                              : 0.h,
                    ),
                    body: Stack(
                      children: [
                        BlocBuilder<MapScreenCubit, MapScreenState>(
                          buildWhen: (previous, current) => previous.camera != current.camera,
                          builder: (context, state) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: MapWidget(
                                styleUri: customStyleURL,
                                onCameraChangeListener: (cameraChangedEventData) async {
                                  cameraEventData = cameraChangedEventData;
                                  // await context
                                  //     .read<MapScreenCubit>()
                                  //     .clearAllMarkers();
                                  context.read<MapScreenCubit>().onCameraChange(
                                      cameraChangedEventData,
                                      context,
                                      selectedType == 'event'
                                          ? 0
                                          : selectedType == 'general_category'
                                              ? 1
                                              : 2);
                                  context.read<MapScreenCubit>().isScrollingValueChange(true);
                                },
                                key: const ValueKey("mapWidget"),
                                cameraOptions: state.camera,
                                onMapCreated: (mapBox) {
                                  context.read<MapScreenCubit>().onMapCreated(mapBox, context);
                                },
                              ),
                            );
                          },
                        ),
                        BlocBuilder<MapScreenCubit, MapScreenState>(
                          buildWhen: (previous, current) => previous.mapboxMap != current.mapboxMap,
                          builder: (context, state) {
                            return Positioned(
                              bottom: homeState.isBottomHide ? 10 : 140,
                              right: 12,
                              child: Container(
                                height: 130.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.r),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        if (state.mapboxMap != null) {
                                          MapUtils.requestLocationPermission(context, isOnTap: true);
                                          context.read<MapScreenCubit>().navigateToPlaceView(
                                                lat: MapUtils.position?.latitude ?? defaultLat,
                                                long: MapUtils.position?.longitude ?? defaultLang,
                                                zoom: homeState.isBottomHide ? 14 : 16,
                                                bearing: 0,
                                                pitch: 0,
                                              );
                                        }
                                      },
                                      icon: Icon(
                                        Icons.my_location,
                                        color: AppColors.primaryColor,
                                        size: 25,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        // Set full screen transition flag
                                        context.read<MapScreenCubit>().setFullScreenTransitioning(true);
                                        Future.delayed(Duration(milliseconds: 200)).then((value) {
                                          context
                                              .read<HomeScreenBlocCubit>()
                                              .changeIsBottomHide(!homeState.isBottomHide);
                                          // Reset full screen transition flag after animation
                                          Future.delayed(Duration(milliseconds: 200), () {
                                            context.read<MapScreenCubit>().setFullScreenTransitioning(false);
                                          });
                                        });
                                      },
                                      icon: Icon(
                                        homeState.isBottomHide ? Icons.fullscreen_exit : Icons.fullscreen,
                                        color: AppColors.blackColor.withValues(alpha: 0.5),
                                        size: 35.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        BlocBuilder<MapScreenCubit, MapScreenState>(
                          builder: (context, state) {
                            if (state.focusedMarker.isNotEmpty &&
                                double.parse(state.markerPositions['y']?.toString() ?? "0.0").isNegative == false &&
                                !state.isScrolling) {
                              return Positioned(
                                top: state.markerPositions['y'] ?? 0.0 + 20,
                                left: state.markerPositions['x'] ?? 0.0 - 50,
                                child: GestureDetector(
                                  onTap: () {
                                    FirebaseEvents.setFirebaseEvent('click_map_info_window', {});
                                    if (!mounted) return;
                                    context.read<NewsDetailsScreenBlocCubit>().init();
                                    context
                                        .read<NewsDetailsScreenBlocCubit>()
                                        .getPostId(state.markerPositions['id'] ?? '');
                                    context.read<NewsDetailsScreenBlocCubit>().getEventNewsDetailData();
                                    context.read<NewsDetailsScreenBlocCubit>().getInThisAreaPostList();
                                    NavigatorRoute.navigateTo(context, AppRoutes.newsDetails, args: {
                                      "isHome": true,
                                    });
                                  },
                                  child: buildInfoWindow(
                                      eventTitle: state.markerPositions['title'] ?? '',
                                      time: state.markerPositions['time'] ?? '',
                                      views: state.markerPositions['views'] ?? '',
                                      reactionCount: state.markerPositions['reactionCount'] ?? ''),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 18,
                    left: 20,
                    right: 20,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: BlocBuilder<MapScreenCubit, MapScreenState>(
                        builder: (context, state) {
                          return buildSwitch(state);
                        },
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 44.h,
                  //   // width: 272.w,
                  //   child: tabbar.CupertinoTabBar(
                  //     innerHorizontalPadding: 14,
                  //     outerVerticalPadding: 2,
                  //     outerHorizontalPadding: 2,
                  //     borderRadius: BorderRadius.circular(50.r),
                  //     Colors.black.withValues(alpha: 0.50),
                  //     AppColors.whiteColor,
                  //     [
                  //       flutter.Padding(
                  //         padding: EdgeInsets.only(left: 5.w),
                  //         child: Text(
                  //           'Events',
                  //           style: TextStyles.bold(20.sp,
                  //               fontColor: eventTypeTabbarValue() == 0
                  //                   ? Colors.black.withValues(alpha: 0.70)
                  //                   : Colors.white,
                  //               fontFamily: alice),
                  //           textAlign: TextAlign.center,
                  //         ),
                  //       ),
                  //       Text(
                  //         'General',
                  //         style: TextStyles.bold(20.sp,
                  //             fontColor: eventTypeTabbarValue() == 1
                  //                 ? Colors.black.withValues(alpha: 0.70)
                  //                 : Colors.white,
                  //             fontFamily: alice),
                  //         textAlign: TextAlign.center,
                  //       ),
                  //       Text(
                  //         'Rescue',
                  //         style: TextStyles.bold(20.sp,
                  //             fontColor: eventTypeTabbarValue() == 2
                  //                 ? Colors.black.withValues(alpha: 0.70)
                  //                 : Colors.white,
                  //             fontFamily: alice),
                  //         textAlign: TextAlign.center,
                  //       ),
                  //     ],
                  //     eventTypeTabbarValue,
                  //     (int index) async {
                  //       if (index == 0) {
                  //         eventTypeValue = index;
                  //         selectedType = 'event';
                  //
                  //         await context
                  //             .read<MapScreenCubit>()
                  //             .onCameraChange(cameraEventData!, context, 0);
                  //         setState(() {});
                  //       } else if (index == 1) {
                  //         eventTypeValue = index;
                  //         selectedType = 'general_category';
                  //
                  //         await context
                  //             .read<MapScreenCubit>()
                  //             .onCameraChange(cameraEventData!, context, 1);
                  //         setState(() {});
                  //       } else if (index == 2) {
                  //         eventTypeValue = index;
                  //         selectedType = 'rescue';
                  //
                  //         await context
                  //             .read<MapScreenCubit>()
                  //             .onCameraChange(cameraEventData!, context, 2);
                  //         setState(() {});
                  //       }
                  //       await context
                  //           .read<MapScreenCubit>()
                  //           .isScrollingValueChange(true);
                  //       await context
                  //           .read<MapScreenCubit>()
                  //           .focusedMarkerEmpty();
                  //     },
                  //     useShadow: false,
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        });
  }

  Widget buildSwitch(state) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(events.length, (index) {
              final isSelected = eventTypeValue == index;
              return GestureDetector(
                onTap: () async {
                  // await context.read<MapScreenCubit>().clearAllMarkers();
                  eventTypeValue = index;
                  if (index == 0) {
                    selectedType = 'event';
                    await context.read<MapScreenCubit>().onCameraChange(cameraEventData!, context, 0);
                    setState(() {});
                  } else if (index == 1) {
                    selectedType = 'general_category';

                    await context.read<MapScreenCubit>().onCameraChange(cameraEventData!, context, 1);
                    setState(() {});
                  } else if (index == 2) {
                    selectedType = 'rescue';

                    await context.read<MapScreenCubit>().onCameraChange(cameraEventData!, context, 2);
                    setState(() {});
                  }
                  await context.read<MapScreenCubit>().isScrollingValueChange(true);
                  await context.read<MapScreenCubit>().focusedMarkerEmpty();
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

  // Bottom widget
  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: BlocBuilder<MapScreenCubit, MapScreenState>(
        builder: (context, state) {
          return SingleChildScrollView(
              controller: sc,
              padding: EdgeInsets.all(20.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Assets.icons.icBottomSheet.svg()),
                  SizedBox(height: 10.h),
                  flutter.Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'In this area',
                          style: TextStyles.bold(36.sp,
                              fontColor: AppColors.textWhiteColor, fontFamily: testTiemposHeadline),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          NavigatorRoute.navigateTo(context, AppRoutes.alerts);
                        },
                        child: CircleAvatar(
                          radius: 25.r,
                          backgroundColor: AppColors.actionBtnBgColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Assets.icons.icAlertSelectedBottom.svg(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${selectedType == 'event' ? state.eventCounts : selectedType == 'general_category' ? state.generalEventCounts : state.rescueEventCounts} alerts past 24hrs',
                      style: TextStyles.regular(
                        20.sp,
                        fontColor: AppColors.textHintGrayColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  state.isLoading
                      ? InThisAreaPostLoader()
                      : selectedType == 'rescue'
                          ? BlocBuilder<MapScreenCubit, MapScreenState>(
                              buildWhen: (previous, current) =>
                                  previous.selectedAreaRescuePostData != current.selectedAreaRescuePostData,
                              builder: (context, state) {
                                return flutter.Visibility(
                                  visible: state.selectedAreaRescuePostData != null &&
                                      state.selectedAreaRescuePostData!.isNotEmpty,
                                  replacement: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 50),
                                      child: Text('No Event found'),
                                    ),
                                  ),
                                  child: ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          FirebaseEvents.setFirebaseEvent('click_map_in_this_area_post', {});
                                          if (!mounted) return;
                                          context.read<NewsDetailsScreenBlocCubit>().init();
                                          context
                                              .read<NewsDetailsScreenBlocCubit>()
                                              .getPostId(state.selectedAreaRescuePostData![index].id ?? '');
                                          context.read<NewsDetailsScreenBlocCubit>().getEventNewsDetailData();
                                          context.read<NewsDetailsScreenBlocCubit>().getInThisAreaPostList();
                                          NavigatorRoute.navigateTo(context, AppRoutes.newsDetails, args: {
                                            "isHome": true,
                                          });
                                        },
                                        child: AreaPostWidget(
                                          inThisAreaEventData: state.selectedAreaRescuePostData![index],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) => Gap(10.h),
                                    itemCount: state.selectedAreaRescuePostData?.length ?? 0,
                                  ),
                                );
                              },
                            )
                          : selectedType == 'general_category'
                              ? BlocBuilder<MapScreenCubit, MapScreenState>(
                                  buildWhen: (previous, current) =>
                                      previous.selectedAreaGeneralPostData != current.selectedAreaGeneralPostData,
                                  builder: (context, state) {
                                    return flutter.Visibility(
                                      visible: state.selectedAreaGeneralPostData != null &&
                                          state.selectedAreaGeneralPostData!.isNotEmpty,
                                      replacement: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 50),
                                          child: Text('No Event found'),
                                        ),
                                      ),
                                      child: ListView.separated(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              FirebaseEvents.setFirebaseEvent('click_map_in_this_area_post', {});
                                              if (!mounted) return;
                                              context.read<NewsDetailsScreenBlocCubit>().init();
                                              context
                                                  .read<NewsDetailsScreenBlocCubit>()
                                                  .getPostId(state.selectedAreaGeneralPostData![index].id ?? '');
                                              context.read<NewsDetailsScreenBlocCubit>().getEventNewsDetailData();
                                              context.read<NewsDetailsScreenBlocCubit>().getInThisAreaPostList();
                                              NavigatorRoute.navigateTo(context, AppRoutes.newsDetails, args: {
                                                "isHome": true,
                                              });
                                            },
                                            child: AreaPostWidget(
                                              inThisAreaEventData: state.selectedAreaGeneralPostData![index],
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) => Gap(10.h),
                                        itemCount: state.selectedAreaGeneralPostData?.length ?? 0,
                                      ),
                                    );
                                  },
                                )
                              : BlocBuilder<MapScreenCubit, MapScreenState>(
                                  buildWhen: (previous, current) =>
                                      previous.selectedAreaEventPostData != current.selectedAreaEventPostData,
                                  builder: (context, state) {
                                    return flutter.Visibility(
                                      visible: state.selectedAreaEventPostData != null &&
                                          state.selectedAreaEventPostData!.isNotEmpty,
                                      replacement: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 50),
                                          child: Text('No Event found'),
                                        ),
                                      ),
                                      child: ListView.separated(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              FirebaseEvents.setFirebaseEvent('click_map_in_this_area_post', {});
                                              if (!mounted) return;
                                              context.read<NewsDetailsScreenBlocCubit>().init();
                                              context
                                                  .read<NewsDetailsScreenBlocCubit>()
                                                  .getPostId(state.selectedAreaEventPostData![index].id ?? '');
                                              context.read<NewsDetailsScreenBlocCubit>().getEventNewsDetailData();
                                              context.read<NewsDetailsScreenBlocCubit>().getInThisAreaPostList();
                                              NavigatorRoute.navigateTo(context, AppRoutes.newsDetails, args: {
                                                "isHome": true,
                                              });
                                            },
                                            child: AreaPostWidget(
                                              inThisAreaEventData: state.selectedAreaEventPostData![index],
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) => Gap(10.h),
                                        itemCount: state.selectedAreaEventPostData?.length ?? 0,
                                      ),
                                    );
                                  },
                                ),
                ],
              ));
        },
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Obtain the cubit reference
    _mapScreenCubit = context.read<MapScreenCubit>();
  }

  @override
  void dispose() {
    _mapScreenCubit.debounceTimerCancel();
    tabController.dispose();
    super.dispose();
  }

  Widget buildInfoWindow(
      {required String eventTitle, required String time, required String views, required String reactionCount}) {
    return Container(
      width: 170.w,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 5.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            eventTitle,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time,
                  style: TextStyles.medium(
                    14.sp,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.remove_red_eye_outlined,
                      size: 17,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      views,
                      style: TextStyles.medium(
                        14.sp,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      size: 17,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      reactionCount,
                      style: TextStyles.medium(
                        14.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String selectedType = 'event';

  int eventTypeTabbarValue() => eventTypeValue;
  int eventTypeValue = 0;

  Widget islandButton(String type) {
    bool isSelected = selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = type;
          log("Selected: $type");
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(type,
            style: TextStyles.bold(
              20.sp,
              fontColor: isSelected ? Colors.black : Colors.white,
            )),
      ),
    );
  }
}
