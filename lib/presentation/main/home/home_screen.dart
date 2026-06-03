import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/utils/app_prefrence.dart';
import 'package:eagle_eye/presentation/main/home/bloc/home_screen_bloc_cubit.dart';
import 'package:eagle_eye/presentation/main/map_screen/map_screen.dart';
import 'package:eagle_eye/presentation/main/my_profile_screen/my_profile_screen.dart';
import 'package:eagle_eye/presentation/main/news_details_screen/bloc/news_details_screen_bloc_cubit.dart';
import 'package:eagle_eye/presentation/main/news_screen/news_screen.dart';
import 'package:eagle_eye/routes/app_navigation.dart';
import 'package:eagle_eye/routes/app_routes.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
import 'package:eagle_eye/services/socket_service/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../core/constant/app_constant.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/app_functions.dart';
import '../../../core/utils/map_utils.dart';
import '../../../core/widget/app_network_image_loader.dart';
import '../../../core/widget/common_alert_dialogue.dart';
import '../../../gen/assets.gen.dart';
import '../../../services/one_signal_notification_service.dart';
import '../live_categories/live_categories_screen.dart';
import '../map_screen/bloc/map_screen_cubit.dart';
import '../my_profile_screen/bloc/bloc/my_profile_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class AnnotationClickListener extends OnPointAnnotationClickListener {
  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    log("onAnnotationClick, id: ${annotation.id}");
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> pages = [
    NewsScreen(),
    MapScreen(),
    LiveCategoriesScreen(),
    MyProfileScreen(),
  ];

  final GlobalKey goLiveKey = GlobalKey();
  bool isShowTutorial = true;
  final List<int> _navigationHistory = []; // Initialize empty

  // Helper to update navigation history
  void _updateNavigationHistory(int currentIndex, int newIndex) {
    if (newIndex != currentIndex) {
      // Only add to history if it's a different page
      if (_navigationHistory.isEmpty || _navigationHistory.last != newIndex) {
        _navigationHistory.add(newIndex);
        log('Navigation History Updated: $_navigationHistory'); // Debug print
      }
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseEvents.setFirebaseEvent('home_screen', {});
    SocketService.connect();
    Future.delayed(Duration.zero).then(
      (value) async {
        if (notificationPayload != null) {
          OneSignalNotificationService.handlePendingNotification(notificationPayload);
        }
        await openDeepLinkEventDetails();
        await requestATTPermission();
        await locationPermissionGet();
        await notificationPermission();
        await updatePushToken();
        await updateUserLocation();
      },
    );
    if (PrefService.getBool(PrefService.goLiveTutorial) == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase([goLiveKey]);
      });
    }

    // Redirect to the Map Screen (Second tab) after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        if (context.read<HomeScreenBlocCubit>().state.currentPageIndex == 0) {
          _navigationHistory.add(0); // Add initial page to history
          _navigationHistory.add(1); // Add map page to history
          context.read<HomeScreenBlocCubit>().changePageIndex(1);
        }
      }
    });
  }

  notificationRedirection() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final additionalData = jsonDecode(notificationPayload!);
        String eventId = additionalData['eventId'] ?? "";
        if (eventId != "") {
          final newsDetailsCubit = context.read<NewsDetailsScreenBlocCubit>();
          newsDetailsCubit.init();
          newsDetailsCubit.getPostId(eventId);
          newsDetailsCubit.getEventNewsDetailData();
          newsDetailsCubit.getInThisAreaPostList();
          NavigatorRoute.navigateTo(context, AppRoutes.newsDetails, args: {"isHome": true});
        } else {
          return;
          // NavigatorRoute.navigateTo(context!, AppRoutes.splash);
        }
        setState(() {
          notificationPayload = null;
        });
      } catch (e) {
        log('Error navigating to news details: $e');
      }
    });
  }

  openDeepLinkEventDetails() async {
    if (PrefService.getString(PrefService.eventDetailsId) != '') {
      if (!mounted) return;
      context.read<NewsDetailsScreenBlocCubit>().init();
      context.read<NewsDetailsScreenBlocCubit>().getPostId(PrefService.getString(PrefService.eventDetailsId));
      context.read<NewsDetailsScreenBlocCubit>().getEventNewsDetailData();
      context.read<NewsDetailsScreenBlocCubit>().getInThisAreaPostList();
      await NavigatorRoute.navigateTo(context, AppRoutes.newsDetails, args: {
        "isHome": false,
      });
    }
  }

  Future notificationPermission() async {
    await OneSignalNotificationService.requestNotificationPermission();
  }

  Future updatePushToken() async {
    await context.read<HomeScreenBlocCubit>().updatePushToken();
  }

  Future locationPermissionGet() async {
    await MapUtils.requestLocationPermission(context);
  }

  Future updateUserLocation() async {
    await MapUtils.getUserCurrentLocation(context);
  }

  Future<void> requestATTPermission() async {
    final trackingStatus = await AppTrackingTransparency.trackingAuthorizationStatus;

    if (trackingStatus == TrackingStatus.notDetermined) {
      final status = await AppTrackingTransparency.requestTrackingAuthorization();
      log('Tracking permission: $status');
    }

    final idfa = await AppTrackingTransparency.getAdvertisingIdentifier();
    log('Advertising Identifier: $idfa');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenBlocCubit, HomeScreenBlocState>(
      buildWhen: (previous, current) =>
          previous.currentPageIndex != current.currentPageIndex || previous.isBottomHide != current.isBottomHide,
      builder: (context, state) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (_navigationHistory.length > 1) {
              if (state.isBottomHide) {
                Future.delayed(Duration(milliseconds: 500)).then((value) {
                  context.read<HomeScreenBlocCubit>().changeIsBottomHide(!state.isBottomHide);
                });
              } else {
                _navigationHistory.removeLast();
                int previousIndex = _navigationHistory.last;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final homeBloc = context.read<HomeScreenBlocCubit>();
                  homeBloc.changePageIndex(previousIndex);
                });
              }
            } else {
              // Show exit dialog when no more history
              showAppDialog(
                context,
                CommonAlertDialogue(
                  dialogWidget: ExitDialog(
                    exitOnTap: () async {
                      Navigator.pop(context);
                      SystemNavigator.pop();
                    },
                  ),
                ),
              );
            }
          },
          child: Scaffold(
            // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            // floatingActionButton:
            //     firebaseRemoteConfigService.isShowTutorialPlayBtn == true
            //         ? Stack(
            //             children: [
            //               Column(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   SizedBox(
            //                     height: 10.h,
            //                   ),
            //                   GestureDetector(
            //                     onTap: () {
            //                       showDialog(
            //                         context: context,
            //                         builder: (context) => HelpVideoDialog(
            //                           videoId: firebaseRemoteConfigService
            //                                   .tutorialVideoId ??
            //                               'Hu6rI-RVsuo',
            //                           subTitleText: 'How to use Awaaz ?',
            //                         ),
            //                       );
            //                     },
            //                     child: Lottie.asset(
            //                         Assets.animation.tutorial.path,
            //                         height: 80.h),
            //                   ),
            //                   SizedBox(
            //                     height: 10.h,
            //                   ),
            //                 ],
            //               ),
            //               Positioned(
            //                 right: 0.w,
            //                 top: 0.h,
            //                 child: InkWell(
            //                   onTap: () {
            //                     setState(() {
            //                       firebaseRemoteConfigService
            //                           .isShowTutorialPlayBtn = false;
            //                     });
            //                   },
            //                   child: CircleAvatar(
            //                     radius: 10.r,
            //                     backgroundColor:
            //                         AppColors.whiteColor.withValues(alpha: 0.7),
            //                     child: Icon(
            //                       Icons.close,
            //                       size: 12.sp,
            //                       color: AppColors.blackColor,
            //                     ),
            //                   ),
            //                 ),
            //               )
            //             ],
            //           )
            //         : SizedBox.shrink(),
            body: IndexedStack(
              index: state.currentPageIndex,
              children: pages,
            ),
            bottomNavigationBar: state.isBottomHide
                ? null
                : Theme(
                    data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      height: Platform.isIOS ? 150.h : 90.h,
                      child: BlocBuilder<HomeScreenBlocCubit, HomeScreenBlocState>(
                          buildWhen: (previous, current) =>
                              previous.currentPageIndex != current.currentPageIndex ||
                              previous.isBottomHide != current.isBottomHide,
                          builder: (context, state) {
                            return BottomNavigationBar(
                              backgroundColor: AppColors.blackColor,
                              type: BottomNavigationBarType.fixed,
                              currentIndex: state.currentPageIndex,
                              onTap: (index) async {
                                // Only update history if we're actually changing pages
                                if (index != state.currentPageIndex) {
                                  _updateNavigationHistory(state.currentPageIndex, index);
                                }

                                if (index == 0) {
                                  context.read<HomeScreenBlocCubit>().changePageIndex(index);
                                  FirebaseEvents.setFirebaseEvent('click_news_screen_click', {});
                                } else if (index == 1) {
                                  context.read<HomeScreenBlocCubit>().changePageIndex(index);
                                  FirebaseEvents.setFirebaseEvent('click_map_screen_tab', {});
                                  context.read<MapScreenCubit>().closeSlidePanel();
                                  setState(() {});
                                  await MapUtils.requestLocationPermission(context, isOnTap: true);
                                  updateUserLocation();
                                  context.read<MapScreenCubit>().navigateToPlaceView(
                                        lat: MapUtils.position?.latitude ?? defaultLat,
                                        long: MapUtils.position?.longitude ?? defaultLang,
                                        zoom: 16,
                                        bearing: 0,
                                        pitch: 0,
                                      );
                                } else if (index == 2) {
                                  if (!Navigator.of(context).userGestureInProgress) {
                                    context.read<HomeScreenBlocCubit>().changePageIndex(index);
                                    FirebaseEvents.setFirebaseEvent('click_bottombar_go_live', {});
                                  } else {
                                    if (mounted) {
                                      context.read<HomeScreenBlocCubit>().changePageIndex(0);
                                    }
                                  }
                                  MapUtils.requestLocationPermission(context, isOnTap: true);
                                } else if (index == 3) {
                                  context.read<HomeScreenBlocCubit>().changePageIndex(index);
                                  FirebaseEvents.setFirebaseEvent('click_news_profile_click', {});
                                  context.read<MyProfileCubit>().init();
                                }
                              },
                              showUnselectedLabels: true,
                              unselectedItemColor: AppColors.textHintGrayColor,
                              selectedItemColor: AppColors.textWhiteColor,
                              unselectedLabelStyle: TextStyles.regular(
                                16.sp,
                              ),
                              selectedLabelStyle: TextStyles.regular(
                                16.sp,
                              ),
                              items: [
                                BottomNavigationBarItem(
                                    icon: Assets.icons.icNewsBottom.svg(),
                                    label: 'News',
                                    activeIcon: Assets.icons.icNewsSelectedBottom.svg()),
                                BottomNavigationBarItem(
                                    icon: Assets.icons.icMapBottom.svg(),
                                    label: 'Map',
                                    activeIcon: Assets.icons.icMapSelectedBottom.svg()),
                                BottomNavigationBarItem(
                                    icon: Showcase(
                                      key: goLiveKey,
                                      description:
                                          'You can record videos within the app and post them globally for instant sharing and engagement.',
                                      title: 'Go Live',
                                      titleTextStyle: TextStyles.semiBold(
                                        26.sp,
                                        fontColor: AppColors.blackColor,
                                      ),
                                      descTextStyle: TextStyles.regular(
                                        18.sp,
                                        fontColor: AppColors.blackColor,
                                      ),
                                      disposeOnTap: true,
                                      titleAlignment: Alignment.centerLeft,
                                      onToolTipClick: () {
                                        PrefService.setValue(PrefService.goLiveTutorial, true);
                                      },
                                      onTargetClick: () async {
                                        PrefService.setValue(PrefService.goLiveTutorial, true);
                                      },
                                      child: Assets.icons.icGoLiveBottom.svg(),
                                    ),
                                    label: 'Go Live',
                                    activeIcon: Assets.icons.icGoLiveSelecteedBottom.svg()),
                                BottomNavigationBarItem(
                                    icon: BlocBuilder<MyProfileCubit, MyProfileState>(
                                      buildWhen: (previous, current) {
                                        return previous.myProfile != current.myProfile;
                                      },
                                      builder: (context, state) {
                                        return SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: AppNetworkImageLoader(
                                            url: PrefService.getString(PrefService.profileUrl),
                                            boxFit: BoxFit.cover,
                                            borderRadius: 80.r,
                                          ),
                                        );
                                      },
                                    ),
                                    label: 'Profile',
                                    activeIcon: BlocBuilder<MyProfileCubit, MyProfileState>(
                                      buildWhen: (previous, current) {
                                        return previous.myProfile != current.myProfile;
                                      },
                                      builder: (context, state) {
                                        return SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: AppNetworkImageLoader(
                                            url: PrefService.getString(PrefService.profileUrl),
                                            boxFit: BoxFit.cover,
                                            borderRadius: 80.r,
                                          ),
                                        );
                                      },
                                    )),
                              ],
                            );
                          }),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
