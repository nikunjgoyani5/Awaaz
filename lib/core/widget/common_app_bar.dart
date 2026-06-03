import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/assets.gen.dart';
import '../../routes/app_navigation.dart';
import '../constant/app_constant.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final bool? centerTitle;
  final List<Widget> action;
  final double? titleSize;

  const HomeAppBar(
      {super.key,
      required this.title,
      required this.action,
      this.centerTitle,
      this.titleSize});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      centerTitle: centerTitle,
      actions: action,
      backgroundColor: AppColors.blackColor,
      scrolledUnderElevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class AppCommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? action;
  final bool? centerTitle;
  final Color? bgColor;
  final Widget? leading;
  final Widget? titleWidget;

  const AppCommonAppBar(
      {super.key,
      required this.title,
      this.action,
      this.centerTitle,
      this.bgColor,
      this.leading,
      this.titleWidget});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      centerTitle: centerTitle ?? false,
      automaticallyImplyLeading: false,
      leading: leading ??
          IconButton(
              onPressed: () {
                NavigatorRoute.navigateBack(context);
              },
              icon: Assets.icons.icBackArrowWhite.svg()),
      title: titleWidget ??
          Text(
            title,
            style: TextStyles.semiBold(28.sp, fontFamily: testTiemposHeadline),
          ),
      actions: action,
      backgroundColor: bgColor ?? AppColors.blackColor,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
