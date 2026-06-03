

import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/theme/text_styles.dart';
import 'package:eagle_eye/core/widget/app_network_image_loader.dart';
import 'package:eagle_eye/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart' as m;
import '../../../core/constant/app_constant.dart';
import '../../../data/models/selected_area_event_post_model.dart';

class AreaPostWidget extends StatelessWidget {
  final SelectedAreaEventPostData inThisAreaEventData;
  const AreaPostWidget({super.key, required this.inThisAreaEventData});

  @override
  Widget build(BuildContext context) {
    String date = '';
    String time = '';
    if (inThisAreaEventData.eventTime != null) {
      date =
          DateFormat('dd MMM').format(inThisAreaEventData.eventTime!.toLocal());
      time = timeAgo(inThisAreaEventData.eventTime!.toLocal());
    }

    return Container(
      padding: EdgeInsets.all(15.sp),
      decoration: BoxDecoration(
        color: AppColors.areaPostBgColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${inThisAreaEventData.distance}',
                      style: TextStyles.light(17.sp,
                          fontColor: AppColors.textHintGrayColor),
                    ),
                    Gap(10.w),
                    Assets.icons.icDot.svg(
                        colorFilter: const ColorFilter.mode(
                      AppColors.textHintGrayColor,
                      BlendMode.srcIn,
                    )),
                    Gap(10.w),
                    Text(
                      date,
                      style: TextStyles.light(17.sp,
                          fontColor: AppColors.textHintGrayColor),
                    ),
                    Gap(10.w),
                    Assets.icons.icDot.svg(
                        colorFilter: const ColorFilter.mode(
                      AppColors.textHintGrayColor,
                      BlendMode.srcIn,
                    )),
                    Gap(10.w),
                    Expanded(
                      child: Text(
                        time,
                        style: TextStyles.light(17.sp,
                            fontColor: AppColors.textHintGrayColor),
                      ),
                    ),
                  ],
                ),
                Gap(10.h),
                Text(
                  inThisAreaEventData.title ?? 'Event',
                  // textAlign: TextAlign.justify,
                  style: TextStyles.semiBold(18.sp),
                  maxLines: 3,
                ),
                Gap(10.h),
                Text(
                  inThisAreaEventData.description ?? 'Description',
                  // textAlign: TextAlign.justify,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.light(16.sp),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          Gap(20.w),
          SizedBox(
            height: 90.h,
            width: 90.w,
            child: AppNetworkImageLoader(
              url: inThisAreaEventData.thumbnail ?? '',
              borderRadius: 10.r,
              boxFit: BoxFit.cover,
            ),
          )
        ],
      ),
    );
  }
}

class CustomJustifyText extends StatelessWidget {
  final String text;

  const CustomJustifyText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final textStyle = TextStyles.light(16.sp);
        final span = TextSpan(text: text, style: textStyle);

        final tp = TextPainter(
          text: span,
          textDirection: m.TextDirection.ltr, // Still valid for nullable param
          maxLines: 3,
        )..layout(maxWidth: constraints.maxWidth);

        final lineMetrics = tp.computeLineMetrics();
        final isLastLineShort = lineMetrics.length == 3 &&
            lineMetrics.last.width < constraints.maxWidth * 0.9;

        return Text(
          text,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: isLastLineShort ? TextAlign.left : TextAlign.justify,
          style: textStyle,
        );
      },
    );
  }
}
