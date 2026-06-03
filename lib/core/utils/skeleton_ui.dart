import 'package:flutter/material.dart';

class SkeletonUI extends StatelessWidget {
  final double? height;
  final double? width;

  const SkeletonUI({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
      ),
    );
  }
}
