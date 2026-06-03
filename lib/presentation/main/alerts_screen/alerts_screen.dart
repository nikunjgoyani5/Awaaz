import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/widget/common_app_bar.dart';
import 'package:eagle_eye/gen/assets.gen.dart';
import 'package:eagle_eye/presentation/main/alerts_screen/alerts_notification_widget.dart';
import 'package:eagle_eye/presentation/main/alerts_screen/bloc/alerts_screen_bloc_cubit.dart';
import 'package:eagle_eye/presentation/main/notification_settings_screen/bloc/notification_settings_cubit.dart';
import 'package:eagle_eye/routes/app_navigation.dart';
import 'package:eagle_eye/routes/app_routes.dart';
import 'package:eagle_eye/services/ads_service/ad_label.dart';
import 'package:eagle_eye/services/ads_service/banner_ads.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/constant/app_constant.dart';
import '../../../core/theme/text_styles.dart';
import '../news_details_screen/bloc/news_details_screen_bloc_cubit.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    FirebaseEvents.setFirebaseEvent('alert_screen', {});
    super.initState();
    fetchAlerts();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  fetchAlerts() {
    context.read<AlertsScreenBlocCubit>().init();
    // Fetch the first page of notifications when the screen loads
    context.read<AlertsScreenBlocCubit>().getNotificationAlerts(page: 1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll &&
        !context.read<AlertsScreenBlocCubit>().state.isBottomLoading &&
        context.read<AlertsScreenBlocCubit>().state.currentPage <
            context.read<AlertsScreenBlocCubit>().state.totalPages) {
      // Fetch the next page of notifications
      context.read<AlertsScreenBlocCubit>().loadMoreNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        centerTitle: true,
        title: Text(
          'Notification',
          style: TextStyles.semiBold(36.sp, fontFamily: testTiemposHeadline),
        ),
        action: [
          CircleAvatar(
            radius: 25.r,
            backgroundColor: AppColors.actionBtnBgColor,
            child: IconButton(
              icon: Assets.icons.icSetting.svg(),
              onPressed: () {
                FirebaseEvents.setFirebaseEvent(
                    'click_alert_setting_screen', {});
                context.read<NotificationSettingsCubit>().init();
                context.read<NotificationSettingsCubit>().defaultCameraView();
                NavigatorRoute.navigateTo(
                    context, AppRoutes.notificationSettings);
              },
            ),
          ),
          Gap(20.w),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BannerAdsWidget(adLbl: AdsLabel.newsDetailsScreenBanner),
        ],
      ),
      body: BlocBuilder<AlertsScreenBlocCubit, AlertsScreenBlocState>(
        builder: (context, state) {
          return state.isLoading
              ? AlertNotificationLoadingWidget()
              : state.notificationList != null &&
                      state.notificationList!.isNotEmpty
                  ? ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 20.h),
                      itemCount: state.notificationList!.length +
                          (state.isBottomLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.notificationList!.length) {
                          // Bottom loader
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.whiteColor,
                            ),
                          );
                        }
                        return AlertsNotificationWidget(
                          notificationData: state.notificationList![index],
                          onTapNotification: () {
                            FirebaseEvents.setFirebaseEvent(
                                'click_alert_notification', {});
                            context.read<NewsDetailsScreenBlocCubit>().init();
                            context
                                .read<NewsDetailsScreenBlocCubit>()
                                .getPostId(
                                    state.notificationList![index].eventId ??
                                        '');
                            context
                                .read<NewsDetailsScreenBlocCubit>()
                                .getEventNewsDetailData();
                            context
                                .read<NewsDetailsScreenBlocCubit>()
                                .getInThisAreaPostList();
                            NavigatorRoute.navigateTo(
                                context, AppRoutes.newsDetails,
                                args: {
                                  "isHome": true,
                                });
                          },
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No notification found',
                        style: TextStyles.regular(19.sp,
                            fontColor: AppColors.whiteColor),
                      ),
                    );
        },
      ),
    );
  }
}
