import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

class AreaPostLoaderWidget extends StatelessWidget {
  const AreaPostLoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Top video loader
          Shimmer.fromColors(
              baseColor: Colors.grey[600]!,
              highlightColor: Colors.grey[200]!,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  height: 200.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: Colors.black.withValues(alpha: 0.3)),
                ),
              )),
          // Detail loader
          Shimmer.fromColors(
            baseColor: Colors.grey[600]!,
            highlightColor: Colors.grey[200]!,
            child: Column(
              children: [
                Gap(5.h),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (index) {
                      return Container(
                        height: 6.h,
                        width: 12.w,
                        margin: EdgeInsets.symmetric(horizontal: 2.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(30.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                      height: 16.h,
                                      width: 50.w,
                                      color:
                                          Colors.black.withValues(alpha: 0.3)),
                                  Gap(10.w),
                                  Container(
                                      height: 16.h,
                                      width: 50.w,
                                      color:
                                          Colors.black.withValues(alpha: 0.3)),
                                ],
                              ),
                              Gap(10.h),
                              Container(
                                  height: 16.h,
                                  width: 100.w,
                                  color: Colors.black.withValues(alpha: 0.3)),
                            ],
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(21),
                            child: Container(
                                height: 60,
                                width: 60,
                                color: Colors.black.withValues(alpha: 0.3)),
                          ),
                        ],
                      ),
                      Gap(10.h),
                      Container(
                          height: 26.h,
                          width: double.infinity,
                          color: Colors.black.withValues(alpha: 0.3)),
                      Gap(10.h),
                      Container(
                          height: 16.h,
                          width: double.infinity,
                          color: Colors.black.withValues(alpha: 0.3)),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.w, top: 10),
                  child: Row(
                    children: [
                      Container(
                          height: 16.h,
                          width: 100.w,
                          color: Colors.black.withValues(alpha: 0.3)),
                      Gap(10.w),
                      Container(
                          height: 16.h,
                          width: 60.w,
                          color: Colors.black.withValues(alpha: 0.3)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Timeline loader
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 2, // Set a fixed count for shimmer placeholders
            itemBuilder: (context, index) {
              return Align(
                alignment: Alignment.topCenter,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[600]!,
                  highlightColor: Colors.grey[200]!,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              height: 16.h,
                              width: 50.w,
                              color: Colors.black.withValues(alpha: 0.3)),
                          Gap(10.w),
                          CircleAvatar(
                              radius: 12.r,
                              backgroundColor:
                                  Colors.black.withValues(alpha: 0.3)),
                        ],
                      ),
                      Gap(5.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: Container(
                            height: 16.h,
                            width: double.infinity,
                            color: Colors.black.withValues(alpha: 0.3)),
                      ),
                      Gap(10.h),
                      Container(
                        height: 30.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                      ),
                      if (index != 4) ...[
                        Gap(10.h),
                        Container(
                            height: 30.h,
                            width: 2.w,
                            color: Colors.black.withValues(alpha: 0.3)),
                        Gap(10.h),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
          // In this area loader
          Shimmer.fromColors(
              baseColor: Colors.grey[600]!,
              highlightColor: Colors.grey[200]!,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    height: 150.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: Colors.black.withValues(alpha: 0.3)),
                  );
                },
                separatorBuilder: (context, index) => Gap(10.h),
                itemCount: 2,
              )),
        ],
      ),
    );
  }
}

class InThisAreaPostLoader extends StatelessWidget {
  const InThisAreaPostLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[600]!,
        highlightColor: Colors.grey[200]!,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              height: 150.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Colors.black.withValues(alpha: 0.3)),
            );
          },
          separatorBuilder: (context, index) => Gap(10.h),
          itemCount: 2,
        ));
  }
}
