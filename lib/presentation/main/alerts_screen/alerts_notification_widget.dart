import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/theme/text_styles.dart';
import 'package:eagle_eye/data/models/notification_alert_list_model.dart';
import 'package:eagle_eye/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/widget/app_network_image_loader.dart';

/*class AlertsNotificationWidget extends StatefulWidget {
  const AlertsNotificationWidget({super.key});

  @override
  State<AlertsNotificationWidget> createState() =>
      _AlertsNotificationWidgetState();
}

class _AlertsNotificationWidgetState extends State<AlertsNotificationWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 10, left: 15.w),
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.redColor,
          ),
          child: Text('0.5m', style: TextStyles.regular(18.sp)),
        )),
        Gap(15.w),
        Expanded(
          flex: 5,
          child: GestureDetector(
            onTap: () {
              if (!mounted) return;
              context.read<NewsDetailsScreenBlocCubit>().init();
              NavigatorRoute.navigateTo(
                context,
                AppRoutes.newsDetails,
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(10.h),
                Container(
                  margin: EdgeInsets.only(right: 15.w),
                  height: 160.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    image: DecorationImage(
                        image: AssetImage(Assets.images.news.path),
                        fit: BoxFit.cover),
                  ),
                ),
                Gap(15.h),
                Padding(
                  padding: EdgeInsets.only(right: 15.w),
                  child: Text(
                    'Car Accident at Andheri West.',
                    style: TextStyles.bold(20.sp),
                    maxLines: 2,
                  ),
                ),
                Gap(5.h),
                Padding(
                  padding: EdgeInsets.only(right: 15.w),
                  child: Text(
                    'A car accident on Andheri West Station Road is causing a traffic jam. Avoid the area.',
                    style: TextStyles.light(
                      18.sp,
                      fontColor: AppColors.textHintGrayColor,
                    ),
                    maxLines: 5,
                  ),
                ),
                Gap(10.h),
                Padding(
                  padding: EdgeInsets.only(right: 15.w),
                  child: Row(
                    children: [
                      Assets.icons.icWatch.svg(),
                      Gap(5.w),
                      Text(
                        '5:30 PM',
                        style: TextStyles.light(
                          18.sp,
                          fontColor: AppColors.textHintGrayColor,
                        ),
                      ),
                      Gap(20.w),
                      Assets.icons.icVideo.svg(),
                      Gap(5.w),
                      Text(
                        '1 Video',
                        style: TextStyles.light(
                          18.sp,
                          fontColor: AppColors.textHintGrayColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(10.h),
                Padding(
                  padding: EdgeInsets.only(right: 15.w),
                  child: Row(
                    children: [
                      Assets.icons.icLocation.svg(),
                      Gap(5.w),
                      Text(
                        'Mumbai',
                        style: TextStyles.light(
                          18.sp,
                          fontColor: AppColors.textHintGrayColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(10.h),
                Divider(
                  color: AppColors.actionBtnBgColor,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}*/

class AlertsNotificationWidget extends StatelessWidget {
  final NotificationData notificationData;
  final Function onTapNotification;

  const AlertsNotificationWidget(
      {super.key,
      required this.notificationData,
      required this.onTapNotification});

  @override
  Widget build(BuildContext context) {
    String dateTime = '0:00 AM';
    if (notificationData.notificationSendTime != null) {
      dateTime = DateFormat('dd-MMM hh:mm a')
          .format(notificationData.notificationSendTime!.toLocal());
    }
    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: () {
        onTapNotification.call();
      },
      child: Padding(
        padding: EdgeInsets.all(18.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 15.w),
                    child: Text(
                      notificationData.title ?? 'Title',
                      style: TextStyles.bold(20.sp),
                      maxLines: 2,
                    ),
                  ),
                  Gap(5.h),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 7.w, vertical: 1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.redColor,
                        ),
                        child: Text(notificationData.distance ?? '0.0m',
                            style: TextStyles.regular(11.sp)),
                      ),
                      Gap(5.w),
                      Assets.icons.icWatch.svg(height: 15, width: 15),
                      Gap(5.w),
                      Text(
                        dateTime,
                        style: TextStyles.light(
                          14.sp,
                          fontColor: AppColors.textHintGrayColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Gap(15.w),
            SizedBox(
              height: 80.h,
              width: 80.w,
              child: AppNetworkImageLoader(
                url: notificationData.thumbnail ?? '',
                borderRadius: 5.r,
                boxFit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlertNotificationLoadingWidget extends StatelessWidget {
  const AlertNotificationLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[600]!,
        highlightColor: Colors.grey[200]!,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              height: 100.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Colors.black.withValues(alpha: 0.3)),
            );
          },
          separatorBuilder: (context, index) => Gap(10.h),
          itemCount: 7,
        ));
  }
}
