import 'package:eagle_eye_admin/model/reported_comments_model.dart';
import 'package:eagle_eye_admin/model/reported_post_model.dart';
import 'package:eagle_eye_admin/model/reported_users_model.dart';
import 'package:eagle_eye_admin/page/reports_screen/components/report_dailoges.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/widget/app_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ProfileReportTileView extends StatelessWidget {
  const ProfileReportTileView(
      {super.key, required this.reportedUSer, required this.onDelete});

  final ReportedUser reportedUSer;
  final VoidCallback onDelete;

  @override

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        showDialog(
          context: context,
          routeSettings: const RouteSettings(name: '/report/reportedProfile'),
          builder: (context) {
            return ProfileReportDialog(
                reportedUser: reportedUSer, onDelete: onDelete);
          },
        );
      },
      child: SizedBox(
        height: 75.h,
        child: Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: AppNetworkImageLoader(
                    url: reportedUSer.reportedUserProfilePicture ?? "",
                    width: 50.w,
                    height: 50.h,
                  ),
                ),
                const Gap(10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (reportedUSer.reports?.isNotEmpty ?? false)
                          ? "${reportedUSer.reports?[0].name ?? 'User'} Reported this Profile"
                          : 'User Reported this Profile',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.grey909090,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      reportedUSer.reportedUserName ?? '',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.white, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      (reportedUSer.reports?.isNotEmpty ?? false)
                          ? "${reportedUSer.reports?[0].reason ?? ''} "
                          : '',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.grey909090,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
            // const Spacer(),
            // DropdownButtonHideUnderline(
            //   child: DropdownButton2<int>(
            //     customButton: Assets.icons.icMenu.svg(),
            //     buttonStyleData: ButtonStyleData(
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(50.r),
            //       ),
            //     ),
            //     items: [
            //       DropdownMenuItem<int>(
            //         value: 0,
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //           child: Text(
            //             "All",
            //             style: Theme
            //                 .of(context)
            //                 .textTheme
            //                 .labelLarge!
            //                 .copyWith(
            //               fontWeight: FontWeight.w600,
            //               color: AppColors.white,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //     onChanged: (value) {
            //       if (value == 0) {}
            //     },
            //     dropdownStyleData: DropdownStyleData(
            //       padding: EdgeInsets.zero,
            //       maxHeight: 200.h,
            //       width: 120.w,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(12),
            //         color: AppColors.textFeildBorderColor,
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.black.withOpacity(0.1),
            //             blurRadius: 8,
            //             offset: const Offset(0, 2),
            //           ),
            //         ],
            //       ),
            //       offset: const Offset(-80, -2),
            //       elevation: 4,
            //       useRootNavigator: true,
            //       scrollbarTheme: ScrollbarThemeData(
            //         thumbColor: WidgetStateProperty.all(AppColors.borderColor),
            //         radius: const Radius.circular(20),
            //         thickness: WidgetStateProperty.all(4),
            //       ),
            //     ),
            //     menuItemStyleData: const MenuItemStyleData(
            //       padding:
            //       EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class ProfileReportCardView extends StatelessWidget {
  const ProfileReportCardView(
      {super.key, required this.reportedUser, required this.onDelete});

  final ReportedUser reportedUser;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        showDialog(
          context: context,
          routeSettings: const RouteSettings(name: '/report/reportedProfile'),
          builder: (context) {
            return ProfileReportDialog(
              reportedUser: reportedUser,
              onDelete: onDelete,
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(15.sp),
        decoration: BoxDecoration(
          color: AppColors.borderColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: AppNetworkImageLoader(
                    url: (reportedUser.reports?.isNotEmpty ?? false)
                        ? (reportedUser.reports?[0].profilePicture ?? '')
                        : '',
                    height: 25,
                    width: 25,
                  ),
                ),

                Gap(5.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (reportedUser.reports?.isNotEmpty ?? false)
                            ? "${reportedUser.reports?[0].name ?? 'User'} Reported this Profile"
                            : 'User Reported this Profile',
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        (reportedUser.reports?.isNotEmpty ?? false)
                            ? "${reportedUser.reports?[0].reason ?? ''} "
                            : '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: AppColors.grey909090,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),

                // DropdownButtonHideUnderline(
                //   child: DropdownButton2<int>(
                //     customButton: Assets.icons.icMenu.svg(),
                //     buttonStyleData: ButtonStyleData(
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(50.r),
                //       ),
                //     ),
                //     items: [
                //       DropdownMenuItem<int>(
                //         value: 0,
                //         child: Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 10.0),
                //           child: Text(
                //             "All",
                //             style: Theme
                //                 .of(context)
                //                 .textTheme
                //                 .labelMedium!
                //                 .copyWith(
                //               fontWeight: FontWeight.w600,
                //               color: AppColors.white,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //     onChanged: (value) {
                //       if (value == 0) {}
                //     },
                //     dropdownStyleData: DropdownStyleData(
                //       padding: EdgeInsets.zero,
                //       maxHeight: 200.h,
                //       width: 120.w,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(12),
                //         color: AppColors.textFeildBorderColor,
                //         boxShadow: [
                //           BoxShadow(
                //             color: Colors.black.withOpacity(0.1),
                //             blurRadius: 8,
                //             offset: const Offset(0, 2),
                //           ),
                //         ],
                //       ),
                //       offset: const Offset(-80, -2),
                //       elevation: 4,
                //       useRootNavigator: true,
                //       scrollbarTheme: ScrollbarThemeData(
                //         thumbColor:
                //         WidgetStateProperty.all(AppColors.borderColor),
                //         radius: const Radius.circular(20),
                //         thickness: WidgetStateProperty.all(4),
                //       ),
                //     ),
                //     menuItemStyleData: const MenuItemStyleData(
                //       padding:
                //       EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                //     ),
                //   ),
                // ),
              ],
            ),
            Gap(25.h),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: AppNetworkImageLoader(
                      url: reportedUser.reportedUserProfilePicture ?? '',
                      height: 50,
                      width: 50,
                    ),
                  ),
                  Gap(10.h),
                  Text(
                    reportedUser.reportedUserName ?? '',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: AppColors.white, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CommentReportTileView extends StatelessWidget {
  const CommentReportTileView({
    super.key,
    required this.reportedComments,
  });

  final ReportedComments reportedComments;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {

        showDialog(
          context: context,
            routeSettings:
            const RouteSettings(name: '/report/reportedComment'),
          builder: (context) {
            return CommentReportDialog(
              reportedComments: reportedComments,
            );
          },
        );




      },
      child: SizedBox(
        height: 65.h,
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: AppNetworkImageLoader(
                url: reportedComments.thumbnail ?? "",
                width: 50.w,
                height: 50.h,
              ),
            ),
            Gap(5.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${reportedComments.firstReportedUserName ?? 'User'} Reported this Comment",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.white, fontWeight: FontWeight.w500),
                ),
                Text(
                  reportedComments.firstReportedReason ?? '',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: AppColors.grey909090, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            // const Spacer(),
            // DropdownButtonHideUnderline(
            //   child: DropdownButton2<int>(
            //     customButton: Assets.icons.icMenu.svg(),
            //     buttonStyleData: ButtonStyleData(
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(50.r),
            //       ),
            //     ),
            //     items: [
            //       DropdownMenuItem<int>(
            //         value: 0,
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //           child: Text(
            //             "All",
            //             style: Theme
            //                 .of(context)
            //                 .textTheme
            //                 .labelLarge!
            //                 .copyWith(
            //               fontWeight: FontWeight.w600,
            //               color: AppColors.white,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //     onChanged: (value) {
            //       if (value == 0) {}
            //     },
            //     dropdownStyleData: DropdownStyleData(
            //       padding: EdgeInsets.zero,
            //       maxHeight: 200.h,
            //       width: 120.w,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(12),
            //         color: AppColors.textFeildBorderColor,
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.black.withOpacity(0.1),
            //             blurRadius: 8,
            //             offset: const Offset(0, 2),
            //           ),
            //         ],
            //       ),
            //       offset: const Offset(-80, -2),
            //       elevation: 4,
            //       useRootNavigator: true,
            //       scrollbarTheme: ScrollbarThemeData(
            //         thumbColor: WidgetStateProperty.all(AppColors.borderColor),
            //         radius: const Radius.circular(20),
            //         thickness: WidgetStateProperty.all(4),
            //       ),
            //     ),
            //     menuItemStyleData: const MenuItemStyleData(
            //       padding:
            //       EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class CommentReportCardView extends StatelessWidget {
  const CommentReportCardView({
    super.key,
    required this.reportedComments,
  });

  final ReportedComments reportedComments;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {

        showDialog(
          context: context,
          routeSettings:
          const RouteSettings(name: '/report/reportedComment'),
          builder: (context) {
            return CommentReportDialog(
              reportedComments: reportedComments,
            );
          },
        );




      },
      child: Container(
        padding: EdgeInsets.all(15.sp),
        decoration: BoxDecoration(
          color: AppColors.borderColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                    child: AppNetworkImageLoader(
                  url: reportedComments.firstReportedUserImage ?? "",
                  height: 25,
                  width: 25,
                  boxFit: BoxFit.cover,
                )),

                Gap(5.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${reportedComments.firstReportedUserName ?? 'User'} Reported this Comment',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        reportedComments.firstReportedReason ?? '',
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: AppColors.grey909090,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                // const Spacer(),
                // DropdownButtonHideUnderline(
                //   child: DropdownButton2<int>(
                //     customButton: Assets.icons.icMenu.svg(),
                //     buttonStyleData: ButtonStyleData(
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(50.r),
                //       ),
                //     ),
                //     items: [
                //       DropdownMenuItem<int>(
                //         value: 0,
                //         child: Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 10.0),
                //           child: Text(
                //             "All",
                //             style: Theme
                //                 .of(context)
                //                 .textTheme
                //                 .labelMedium!
                //                 .copyWith(
                //               fontWeight: FontWeight.w600,
                //               color: AppColors.white,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //     onChanged: (value) {
                //       if (value == 0) {}
                //     },
                //     dropdownStyleData: DropdownStyleData(
                //       padding: EdgeInsets.zero,
                //       maxHeight: 200.h,
                //       width: 120.w,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(12),
                //         color: AppColors.textFeildBorderColor,
                //         boxShadow: [
                //           BoxShadow(
                //             color: Colors.black.withOpacity(0.1),
                //             blurRadius: 8,
                //             offset: const Offset(0, 2),
                //           ),
                //         ],
                //       ),
                //       offset: const Offset(-80, -2),
                //       elevation: 4,
                //       useRootNavigator: true,
                //       scrollbarTheme: ScrollbarThemeData(
                //         thumbColor:
                //         WidgetStateProperty.all(AppColors.borderColor),
                //         radius: const Radius.circular(20),
                //         thickness: WidgetStateProperty.all(4),
                //       ),
                //     ),
                //     menuItemStyleData: const MenuItemStyleData(
                //       padding:
                //       EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                //     ),
                //   ),
                // ),
              ],
            ),
            Gap(20.h),
            Container(
                width: 200.w,
                height: 110.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: AppNetworkImageLoader(
                  url: reportedComments.thumbnail ?? '',
                  width: 200.w,
                  height: 110.h,
                  boxFit: BoxFit.cover,
                )),
          ],
        ),
      ),
    );
  }
}

class PostReportTileView extends StatelessWidget {
  const PostReportTileView(
      {super.key, required this.reportedPost, required this.onDelete});

  final ReportedPost reportedPost;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {

        showDialog(
          context: context,
          routeSettings:
          const RouteSettings(name: '/report/reportedPost'),
          builder: (context) {
            return PostReportDialog(
              reportedPost: reportedPost,
              onDelete: onDelete,
            );
          },
        );


      },
      child: SizedBox(
        height: 65.h,
        child: Row(
          children: [
            Container(
              width: 80.w,
              height: 60.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: AppNetworkImageLoader(
                  url: reportedPost.thumbnail ?? "", width: 80.w, height: 60.h),
            ),
            Gap(10.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (reportedPost.reports?.isNotEmpty ?? false)
                      ? "${reportedPost.reports?[0].name ?? 'User'} Reported this Comment"
                      : 'User Reported this Comment',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.white, fontWeight: FontWeight.w500),
                ),
                Text(
                  (reportedPost.reports?.isNotEmpty ?? false)
                      ? "${reportedPost.reports?[0].reason ?? ''} "
                      : '',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: AppColors.grey909090, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            // const Spacer(),
            // DropdownButtonHideUnderline(
            //   child: DropdownButton2<int>(
            //     customButton: Assets.icons.icMenu.svg(),
            //     buttonStyleData: ButtonStyleData(
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(50.r),
            //       ),
            //     ),
            //     items: [
            //       DropdownMenuItem<int>(
            //         value: 0,
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //           child: Text(
            //             "All",
            //             style: Theme
            //                 .of(context)
            //                 .textTheme
            //                 .labelLarge!
            //                 .copyWith(
            //               fontWeight: FontWeight.w600,
            //               color: AppColors.white,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //     onChanged: (value) {
            //       if (value == 0) {}
            //     },
            //     dropdownStyleData: DropdownStyleData(
            //       padding: EdgeInsets.zero,
            //       maxHeight: 200.h,
            //       width: 120.w,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(12),
            //         color: AppColors.textFeildBorderColor,
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.black.withOpacity(0.1),
            //             blurRadius: 8,
            //             offset: const Offset(0, 2),
            //           ),
            //         ],
            //       ),
            //       offset: const Offset(-80, -2),
            //       elevation: 4,
            //       useRootNavigator: true,
            //       scrollbarTheme: ScrollbarThemeData(
            //         thumbColor: WidgetStateProperty.all(AppColors.borderColor),
            //         radius: const Radius.circular(20),
            //         thickness: WidgetStateProperty.all(4),
            //       ),
            //     ),
            //     menuItemStyleData: const MenuItemStyleData(
            //       padding:
            //       EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class PostReportCardView extends StatelessWidget {
  const PostReportCardView(
      {super.key, required this.reportedPost, required this.onDelete});

  final ReportedPost reportedPost;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        showDialog(
          context: context,
          routeSettings: const RouteSettings(name: '/report/reportedPost'),
          builder: (context) {
            return PostReportDialog(
              onDelete: onDelete,
              reportedPost: reportedPost,
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(15.sp),
        decoration: BoxDecoration(
          color: AppColors.borderColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: AppNetworkImageLoader(
                    url: (reportedPost.reports?.isNotEmpty ?? false)
                        ? (reportedPost.reports?[0].profilePicture ?? '')
                        : '',
                    width: 30.w,
                    height: 30.h,
                    boxFit: BoxFit.cover,
                  ),
                ),
                Gap(5.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (reportedPost.reports?.isNotEmpty ?? false)
                            ? "${reportedPost.reports?[0].name ?? 'User'} Reported this Profile"
                            : 'User Reported this Profile',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        (reportedPost.reports?.isNotEmpty ?? false)
                            ? "${reportedPost.reports?[0].reason ?? ''} "
                            : '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: AppColors.grey909090,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                // DropdownButtonHideUnderline(
                //   child: DropdownButton2<int>(
                //     customButton: Assets.icons.icMenu.svg(),
                //     buttonStyleData: ButtonStyleData(
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(50.r),
                //       ),
                //     ),
                //     items: [
                //       DropdownMenuItem<int>(
                //         value: 0,
                //         child: Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 10.0),
                //           child: Text(
                //             "All",
                //             style: Theme
                //                 .of(context)
                //                 .textTheme
                //                 .labelMedium!
                //                 .copyWith(
                //               fontWeight: FontWeight.w600,
                //               color: AppColors.white,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //     onChanged: (value) {
                //       if (value == 0) {}
                //     },
                //     dropdownStyleData: DropdownStyleData(
                //       padding: EdgeInsets.zero,
                //       maxHeight: 200.h,
                //       width: 120.w,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(12),
                //         color: AppColors.textFeildBorderColor,
                //         boxShadow: [
                //           BoxShadow(
                //             color: Colors.black.withOpacity(0.1),
                //             blurRadius: 8,
                //             offset: const Offset(0, 2),
                //           ),
                //         ],
                //       ),
                //       offset: const Offset(-80, -2),
                //       elevation: 4,
                //       useRootNavigator: true,
                //       scrollbarTheme: ScrollbarThemeData(
                //         thumbColor:
                //         WidgetStateProperty.all(AppColors.borderColor),
                //         radius: const Radius.circular(20),
                //         thickness: WidgetStateProperty.all(4),
                //       ),
                //     ),
                //     menuItemStyleData: const MenuItemStyleData(
                //       padding:
                //       EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                //     ),
                //   ),
                // ),
              ],
            ),
            Gap(20.h),
            Container(
              width: 200.w,
              height: 110.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: AppNetworkImageLoader(
                url: reportedPost.thumbnail ?? "",
                width: 200.w,
                height: 110.h,
                boxFit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
