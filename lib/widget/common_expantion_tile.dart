import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonExpansionTile extends StatelessWidget {
  final Widget? title;
  final List<Widget> childrenItems;
  final bool? initiallyOpenTile;

  const CommonExpansionTile({
    super.key,
    this.title,
    required this.childrenItems,
    this.initiallyOpenTile,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: AppColors.black,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
      ),
      child: SizedBox(
        width: double.infinity, // Makes sure the tile spans full width
        child: ExpansionTile(
          onExpansionChanged: (value) {},
          visualDensity: VisualDensity.comfortable,
          tilePadding: const EdgeInsets.symmetric(
              horizontal: 0), // Removes extra padding
          minTileHeight: 40.h,
          collapsedShape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          trailing: const SizedBox.shrink(),
          initiallyExpanded: initiallyOpenTile ?? false,
          title: title ?? const SizedBox.shrink(),
          children: childrenItems,
        ),
      ),
    );
  }
}
