import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

class NewsLoadingWidget extends StatelessWidget {
  const NewsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[600]!,
          highlightColor: Colors.grey[200]!,
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Column(
                spacing: 10.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 250.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: Colors.black.withValues(alpha: 0.3)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        Container(
                          height: 40.h,
                          width: 40.w,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withValues(alpha: 0.3)),
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          spacing: 10.h,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: 5,
                                width: 150,
                                color: Colors.black.withValues(alpha: 0.3)),
                            Container(
                                height: 5,
                                width: 100,
                                color: Colors.black.withValues(alpha: 0.3)),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Container(
                        height: 5,
                        width: 100,
                        color: Colors.black.withValues(alpha: 0.3)),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Container(
                        height: 10,
                        width: 100,
                        color: Colors.black.withValues(alpha: 0.3)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Container(
                        height: 5,
                        width: 50,
                        color: Colors.black.withValues(alpha: 0.3)),
                  ),
                  Row(
                    children: List.generate(
                      4,
                      (index) {
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: Column(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.black.withValues(alpha: 0.3),
                                ),
                                SizedBox(height: 5.h),
                                Container(
                                    height: 5,
                                    width: 30,
                                    color: Colors.black.withValues(alpha: 0.3)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            },
            separatorBuilder: (context, index) => Gap(30.h),
            itemCount: 3,
          )),
    );
  }
}
