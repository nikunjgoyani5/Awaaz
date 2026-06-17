import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:eagle_eye_admin/controller/report_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/model/reported_comments_model.dart';
import 'package:eagle_eye_admin/model/reported_post_model.dart';
import 'package:eagle_eye_admin/model/reported_users_model.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/widget/app_network_image.dart';
import 'package:eagle_eye_admin/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CommentReportDialog extends StatefulWidget {
  const CommentReportDialog({
    super.key,
    required this.reportedComments,
  });

  final ReportedComments reportedComments;

  @override
  State<CommentReportDialog> createState() => _CommentReportDialogState();
}

class _CommentReportDialogState extends State<CommentReportDialog> {
  GlobalKey key = GlobalKey();
  bool isOpenReply = false;
  ScrollController commentScrollController = ScrollController();
  ReportController reportController = Get.find();

  Widget commentWidget(ReportOfComment report) {
    final ProgressLoader pl = ProgressLoader(context, isDismissible: true);
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {},
                child: ClipOval(child: AppNetworkImageLoader(url: report.commentedUserImage??'', height: 40,width: 40,))
              ),
              Gap(10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          report.commentedUserName??"User",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w500),
                        ),
                        // Gap(5.w),
                        // Text(
                        //   '30m',
                        //   style: Theme.of(context)
                        //       .textTheme
                        //       .bodySmall!
                        //       .copyWith(
                        //           color: AppColors.grey909090,
                        //           fontWeight: FontWeight.w500),
                        // ),
                      ],
                    ),
                    Text(
                      report.comment??"",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.white, fontWeight: FontWeight.w100),
                      maxLines: 2,
                    ),
                    Gap(5.h),
                    Row(
                      children: [
                        Text(
                          '${report.totalLikes??0} likes',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: AppColors.grey909090,
                                  fontWeight: FontWeight.w500),
                          maxLines: 2,
                        ),
                        Gap(10.w),
                        GestureDetector(
                          onTap:  () {

                            showDialog(
                              context: context,


                              builder: (context) {
                                return  ReportedCommentReasonDialog(
                                reportedCommentUserList: report.reportedUsers??[],
                                );
                              },
                            );
                          },

                          child: Text(
                            '${report.reportCount?.toString()??'0'} Reported',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: AppColors.grey909090,
                                    fontWeight: FontWeight.w500),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Gap(10.w),
              const Spacer(),
              DropdownButtonHideUnderline(
                child: DropdownButton2<int>(
                  customButton: Assets.icons.icMenu.svg(),
                  buttonStyleData: ButtonStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                  ),
                  items: [
                    DropdownMenuItem<int>(
                      value: 0,
                      onTap: () async {
                        await reportController.deleteCommentApi(
                            commentId: report.commentId ?? '',
                            context: context,
                            pl: pl,
                            postId: widget.reportedComments.postId ?? '',
                            reportId: report.reportId ?? '');

                        // await  commonDialog(
                        //     subtitle: 'Are you sure want to delete comment?',
                        //     title: 'Delete Comment',
                        //     onTap: () async {
                        // NavigatorRoute.navigateBack(context: context);
                        // await   reportController.deleteCommentApi(commentId: report.commentId??'', context: context, pl: pl, postId: widget.reportedComments.postId??'', reportId: report.reportId??'');
                        //
                        //     },
                        //   );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "Delete",
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                  ),
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == 0) {}
                  },
                  dropdownStyleData: DropdownStyleData(
                    padding: EdgeInsets.zero,
                    maxHeight: 200.h,
                    width: 120.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.textFeildBorderColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha:0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    offset: const Offset(-80, -2),
                    elevation: 4,
                    useRootNavigator: true,
                    scrollbarTheme: ScrollbarThemeData(
                      thumbColor:
                          WidgetStateProperty.all(AppColors.borderColor),
                      radius: const Radius.circular(20),
                      thickness: WidgetStateProperty.all(4),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                  ),
                ),
              ),
              Gap(10.w),
            ],
          ),
          // Padding(
          //   padding: EdgeInsets.only(left: 50.w, right: 10.w),
          //   child: CommonExpansionTile(
          //     initiallyOpenTile: isOpenReply,
          //     title: Padding(
          //       padding: EdgeInsets.only(bottom: 10.h),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             'View replies(1)',
          //             style: Theme.of(context).textTheme.bodySmall!.copyWith(
          //                 color: AppColors.white, fontWeight: FontWeight.w500),
          //             maxLines: 2,
          //           ),
          //           Gap(10.w),
          //           Icon(
          //             Icons.keyboard_arrow_down,
          //             size: 15.sp,
          //             color: AppColors.white,
          //           ),
          //         ],
          //       ),
          //     ),
          //     childrenItems: List.generate(
          //       3,
          //       (index) => Padding(
          //         padding: EdgeInsets.only(bottom: 10.h),
          //         child: commentReplayWidget(),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget commentReplayWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20.r,
          child: Image.asset(Assets.image.rescueProfilePic.path),
        ),
        Gap(10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Ruben Levin',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: AppColors.white, fontWeight: FontWeight.w500),
                  ),
                  Gap(5.w),
                  Text(
                    '30m',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: AppColors.grey909090,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Text(
                'I pray that the fire is extinguished quickly.',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: AppColors.white, fontWeight: FontWeight.w100),
                maxLines: 2,
              ),
              Gap(5.h),
              Text(
                '1,579 likes',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: AppColors.grey909090, fontWeight: FontWeight.w500),
                maxLines: 2,
              ),
            ],
          ),
        ),
        Gap(10.w),
        const Spacer(),
        DropdownButtonHideUnderline(
          child: DropdownButton2<int>(
            customButton: Assets.icons.icMenu.svg(),
            buttonStyleData: ButtonStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.r),
              ),
            ),
            items: [
              DropdownMenuItem<int>(
                value: 0,
                child: InkWell(
                  onTap: () async {
                    NavigatorRoute.navigateBack(context: context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      "Delete",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                    ),
                  ),
                ),
              ),
            ],
            onChanged: (value) {},
            dropdownStyleData: DropdownStyleData(
              padding: EdgeInsets.zero,
              maxHeight: 200.h,
              width: 120.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.textFeildBorderColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              offset: const Offset(-80, -2),
              elevation: 4,
              useRootNavigator: true,
              scrollbarTheme: ScrollbarThemeData(
                thumbColor: WidgetStateProperty.all(AppColors.borderColor),
                radius: const Radius.circular(20),
                thickness: WidgetStateProperty.all(4),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            ),
          ),
        ),
        Gap(10.w),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      key: key,
      alignment: Alignment.topCenter,
      insetPadding: EdgeInsets.only(top: 40.h, bottom: 40.h),
      backgroundColor: AppColors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 1536
              ? MediaQuery.of(context).size.width * 0.30
              : MediaQuery.of(context).size.width > 1024
                  ? MediaQuery.of(context).size.width * 0.30
                  : MediaQuery.of(context).size.width > 600
                      ? MediaQuery.of(context).size.width * 0.2
                      : MediaQuery.of(context).size.width * 0.1,
        ),
        decoration: BoxDecoration(
          color: AppColors.borderColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [

                Text(
                  "Reported Comments",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w600, color: AppColors.white),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    NavigatorRoute.navigateBack(context: context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            Gap(20.h),
            Expanded(
              child: Theme(
                data: ThemeData(
                  scrollbarTheme: ScrollbarThemeData(
                    trackColor: WidgetStateProperty.all(
                        AppColors.textFeildBorderColor.withValues(alpha:0.5)),
                    thumbColor: WidgetStateProperty.all(
                        AppColors.white.withValues(alpha:0.2)),
                  ),
                ),
                child: Scrollbar(
                  radius: const Radius.circular(0),
                  trackVisibility: true,
                  scrollbarOrientation: ScrollbarOrientation.right,
                  thumbVisibility: true,
                  interactive: true,
                  controller: commentScrollController,
                  child: ListView.separated(
                    controller: commentScrollController,
                    padding: EdgeInsets.only(top: 20.h, right: 20.w),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return commentWidget(
                          widget.reportedComments.reports?[index] ??
                              ReportOfComment());

                    },
                    separatorBuilder: (context, index) => Gap(10.h),
                    itemCount: widget.reportedComments.reports?.length ?? 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileReportDialog extends StatefulWidget {
  const ProfileReportDialog(
      {super.key, required this.reportedUser, required this.onDelete});

  final ReportedUser reportedUser;
  final VoidCallback onDelete;

  @override
  State<ProfileReportDialog> createState() => _ProfileReportDialogState();
}

class _ProfileReportDialogState extends State<ProfileReportDialog> {
  GlobalKey key = GlobalKey();
  bool isOpenReply = false;
  ScrollController commentScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      key: key,
      alignment: Alignment.topCenter,
      insetPadding: EdgeInsets.only(top: 40.h, bottom: 40.h),
      backgroundColor: AppColors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 1536
              ? MediaQuery.of(context).size.width * 0.30
              : MediaQuery.of(context).size.width > 1024
                  ? MediaQuery.of(context).size.width * 0.30
                  : MediaQuery.of(context).size.width > 600
                      ? MediaQuery.of(context).size.width * 0.2
                      : MediaQuery.of(context).size.width * 0.1,
        ),
        decoration: BoxDecoration(
          color: AppColors.borderColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  "Reported Profile",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w600, color: AppColors.white),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    NavigatorRoute.navigateBack(context: context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            Gap(20.h),
            Expanded(
              child: Theme(
                data: ThemeData(
                  scrollbarTheme: ScrollbarThemeData(
                    trackColor: WidgetStateProperty.all(
                        AppColors.textFeildBorderColor.withValues(alpha:0.5)),
                    thumbColor: WidgetStateProperty.all(
                        AppColors.white.withValues(alpha:0.2)),
                  ),
                ),
                child: Scrollbar(
                  radius: const Radius.circular(0),
                  trackVisibility: true,
                  scrollbarOrientation: ScrollbarOrientation.right,
                  thumbVisibility: true,
                  interactive: true,
                  controller: commentScrollController,
                  child: ListView.separated(
                    controller: commentScrollController,
                    padding: EdgeInsets.only(top: 20.h, right: 20.w),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipOval(
                                child: AppNetworkImageLoader(
                                  url: widget.reportedUser.reports?[index]
                                          .profilePicture ??
                                      '',
                                  height: 30,
                                  width: 30,
                                  boxFit: BoxFit.cover,
                                ),
                              ),
                              Gap(10.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.reportedUser.reports?[index].name ??
                                        '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    widget.reportedUser.reports?[index]
                                            .reason ??
                                        '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                            color: AppColors.grey909090,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => Gap(10.h),
                    itemCount: widget.reportedUser.reports?.length ?? 0,
                  ),
                ),
              ),
            ),
            Gap(40.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                widget.reportedUser.isBlocked
                    ? SizedBox(
                        width: 130,
                        height: 40,
                        child: CommonButton(
                            color: AppColors.green,
                            radius: 5,
                            widget: Text(
                              'Unblock',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w600),
                            ),
                            onPressed: widget.onDelete),
                      )
                    : SizedBox(
                        width: 130,
                        height: 40,
                        child: CommonButton(
                            color: AppColors.red,
                            radius: 5,
                            widget: Text(
                              'Block',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w600),
                            ),
                            onPressed: widget.onDelete),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PostReportDialog extends StatefulWidget {
  const PostReportDialog(
      {super.key, required this.reportedPost, required this.onDelete});

  final ReportedPost reportedPost;
  final VoidCallback onDelete;

  @override
  State<PostReportDialog> createState() => _PostReportDialogState();
}

class _PostReportDialogState extends State<PostReportDialog> {
  GlobalKey key = GlobalKey();
  bool isOpenReply = false;
  ScrollController commentScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      key: key,
      alignment: Alignment.topCenter,
      insetPadding: EdgeInsets.only(top: 40.h, bottom: 40.h),
      backgroundColor: AppColors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 1536
              ? MediaQuery.of(context).size.width * 0.30
              : MediaQuery.of(context).size.width > 1024
                  ? MediaQuery.of(context).size.width * 0.30
                  : MediaQuery.of(context).size.width > 600
                      ? MediaQuery.of(context).size.width * 0.2
                      : MediaQuery.of(context).size.width * 0.1,
        ),
        decoration: BoxDecoration(
          color: AppColors.borderColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  "Reported Posts",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w600, color: AppColors.white),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    NavigatorRoute.navigateBack(context: context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            Gap(20.h),
            Expanded(
              child: Theme(
                data: ThemeData(
                  scrollbarTheme: ScrollbarThemeData(
                    trackColor: WidgetStateProperty.all(
                        AppColors.textFeildBorderColor.withValues(alpha:0.5)),
                    thumbColor: WidgetStateProperty.all(
                        AppColors.white.withValues(alpha:0.2)),
                  ),
                ),
                child: Scrollbar(
                  radius: const Radius.circular(0),
                  trackVisibility: true,
                  scrollbarOrientation: ScrollbarOrientation.right,
                  thumbVisibility: true,
                  interactive: true,
                  controller: commentScrollController,
                  child: ListView.separated(
                    controller: commentScrollController,
                    padding: EdgeInsets.only(top: 20.h, right: 20.w),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipOval(
                                child: AppNetworkImageLoader(
                                  url: widget.reportedPost.reports?[index]
                                          .profilePicture ??
                                      '',
                                  height: 30,
                                  width: 30,
                                  boxFit: BoxFit.cover,
                                ),
                              ),
                              Gap(10.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.reportedPost.reports?[index].name ??
                                        '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    widget.reportedPost.reports?[index]
                                            .reason ??
                                        '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                            color: AppColors.grey909090,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => Gap(10.h),
                    itemCount: widget.reportedPost.reports?.length ?? 0,
                  ),
                ),
              ),
            ),
            Gap(40.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 130,
                  height: 40,
                  child: CommonButton(
                      color: AppColors.red,
                      radius: 5,
                      widget: Text(
                        'Delete',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: widget.onDelete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReportedCommentReasonDialog extends StatefulWidget {
  const ReportedCommentReasonDialog({super.key, required this.reportedCommentUserList});
final List<ReportedCommentUser> reportedCommentUserList ;
  @override
  State<ReportedCommentReasonDialog> createState() => _ReportedCommentReasonDialogState();
}

class _ReportedCommentReasonDialogState extends State<ReportedCommentReasonDialog> {
  ScrollController commentScrollController = ScrollController();
  ReportController reportController = Get.find();

  @override
  Widget build(BuildContext context) {
    return  Dialog(

      alignment: Alignment.topCenter,
      insetPadding: EdgeInsets.only(top: 40.h, bottom: 40.h),
      backgroundColor: AppColors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 1536
              ? MediaQuery.of(context).size.width * 0.30
              : MediaQuery.of(context).size.width > 1024
              ? MediaQuery.of(context).size.width * 0.30
              : MediaQuery.of(context).size.width > 600
              ? MediaQuery.of(context).size.width * 0.2
              : MediaQuery.of(context).size.width * 0.1,
        ),
        decoration: BoxDecoration(
          color: AppColors.borderColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [

                Text(
                  "Reported Comments Reason",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w600, color: AppColors.white),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    NavigatorRoute.navigateBack(context: context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            Gap(20.h),
            Expanded(
              child: Theme(
                data: ThemeData(
                  scrollbarTheme: ScrollbarThemeData(
                    trackColor: WidgetStateProperty.all(
                        AppColors.textFeildBorderColor.withValues(alpha:0.5)),
                    thumbColor: WidgetStateProperty.all(
                        AppColors.white.withValues(alpha:0.2)),
                  ),
                ),
                child: Scrollbar(
                  radius: const Radius.circular(0),
                  trackVisibility: true,
                  scrollbarOrientation: ScrollbarOrientation.right,
                  thumbVisibility: true,
                  interactive: true,
                  controller: commentScrollController,
                  child: ListView.separated(
                    controller: commentScrollController,
                    padding: EdgeInsets.only(top: 20.h, right: 20.w),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return reasonWidget(
reportedCommentUser: widget.reportedCommentUserList[index]
                            );

                    },
                    separatorBuilder: (context, index) => Gap(10.h),
                    itemCount: widget.reportedCommentUserList.length ,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget reasonWidget({required ReportedCommentUser reportedCommentUser}) {
    // final ProgressLoader pl = ProgressLoader(context, isDismissible: true);
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () {},
                  child:  ClipOval(child: AppNetworkImageLoader(url: reportedCommentUser.profilePicture??"", height: 40,width: 40,))
              ),
              Gap(10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          reportedCommentUser.name??"",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w500),
                        ),

                      ],
                    ),
                    Text(
    reportedCommentUser.reason??"",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.white, fontWeight: FontWeight.w100),
                      maxLines: 2,
                    ),

                  ],
                ),
              ),


            ],
          ),

        ],
      ),
    );
  }



}

