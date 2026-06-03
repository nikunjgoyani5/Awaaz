import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class PostLoadingShimmerWidget extends StatelessWidget {
  const PostLoadingShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[600]!,
      highlightColor: Colors.grey[200]!,
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 7.h),
        itemCount: 9,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.75,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            crossAxisCount: 3),
        itemBuilder: (context, index) {
          return Container(
            color: Colors.black.withValues(alpha: 0.3),
          );
        },
      ),
    );
  }
}
