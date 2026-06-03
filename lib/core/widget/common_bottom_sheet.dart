import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:eagle_eye/core/constant/app_constant.dart';
import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/theme/text_styles.dart';
import 'package:eagle_eye/core/utils/app_functions.dart';
import 'package:eagle_eye/core/widget/common_button.dart';
import 'package:eagle_eye/core/widget/common_expension_tile.dart';
import 'package:eagle_eye/core/widget/common_text_button.dart';
import 'package:eagle_eye/core/widget/common_textfield.dart';
import 'package:eagle_eye/presentation/authentication/auth_screen/bloc/auth_screen_cubit.dart';
import 'package:eagle_eye/presentation/main/news_screen/bloc/news_screen_bloc_cubit.dart';
import 'package:eagle_eye/presentation/main/user_profile_screen/bloc/user_profile_cubit.dart';
import 'package:eagle_eye/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

import '../../data/models/event_news_detail_model.dart';
import '../../gen/assets.gen.dart';
import '../../presentation/main/news_details_screen/bloc/news_details_screen_bloc_cubit.dart';
import '../../presentation/main/send_alert/bloc/send_alert_cubit.dart';
import '../../routes/app_navigation.dart';
import '../constant/app_assets.dart';
import '../utils/app_prefrence.dart';
import 'app_network_image_loader.dart';
import 'common_app_image_show.dart';
import 'common_radio_list_tile.dart';

class AppCommonBottomSheet extends StatelessWidget {
  final Widget body;
  final BorderRadius? borderRadius;
  final Color? sheetBGColor;
  final bool isOpenWithGradient;
  final bool isPaddingNotShow;
  final Gradient? gradient;

  const AppCommonBottomSheet({
    super.key,
    required this.body,
    this.borderRadius,
    this.sheetBGColor,
    this.isPaddingNotShow = false,
    required this.isOpenWithGradient,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: sheetBGColor ?? AppColors.actionBtnBgColor,
        borderRadius: borderRadius,
        gradient: (isOpenWithGradient == false)
            ? null
            : gradient ??
                LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryColor.withValues(alpha: 0.4),
                    AppColors.primaryColor.withValues(alpha: 0.0),
                    AppColors.primaryColor.withValues(alpha: 0.0),
                  ],
                ),
      ),
      padding: isPaddingNotShow
          ? EdgeInsets.symmetric(vertical: 12.h)
          : EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      margin: EdgeInsets.only(bottom: 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.icons.icBottomSheet.svg(),
            body,
          ],
        ),
      ),
    );
  }
}

class ForgotPasswordSheet extends StatelessWidget {
  const ForgotPasswordSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              SizedBox(
                height: 15.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.close_sharp,
                        color: Colors.transparent,
                      )),
                  Text(
                    'Forget password',
                    style:
                        TextStyles.bold(28.sp, fontFamily: testTiemposHeadline),
                  ),
                  IconButton(
                      onPressed: () {
                        NavigatorRoute.navigateBack(context);
                      },
                      icon: Icon(Icons.close_sharp))
                ],
              ),
              Text(
                'Enter your registered email below to receive password reset instruction',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyles.regular(16.sp,
                    fontColor: AppColors.textHintGrayColor),
              ),
              spaceH(60.h),
              BlocBuilder<AuthScreenCubit, AuthScreenState>(
                builder: (context, state) {
                  return CommonTextField(
                    hintText: 'Enter Email',
                    fillColor: AppColors.popUpTextFieldBlackColor,
                    textStyle: TextStyles.medium(18.sp,
                        fontColor: AppColors.whiteColor),
                    cursorColor: AppColors.whiteColor,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      child: Assets.icons.icEmail.svg(),
                    ),
                    controller: state.forgotPasswordEmailController!,
                    radius: BorderRadius.circular(10.r),
                    onChanged: (p0) {
                      setState.call(() {});
                    },
                  );
                },
              ),
              spaceH(120.h),
              BlocBuilder<AuthScreenCubit, AuthScreenState>(
                builder: (context, state) {
                  return CommonButton(
                      color: state.forgotPasswordEmailController!.text
                                  .isNotEmpty &&
                              state.forgotPasswordEmailController!.text.isEmail
                          ? AppColors.whiteColor
                          : AppColors.popUpTextFieldBlackColor,
                      onPressed: () {
                        context.read<AuthScreenCubit>().onSubmitForgotPassword(
                            context, state.forgotPasswordEmailController!.text);
                      },
                      widget: Text(
                        'Send OTP',
                        style: TextStyles.medium(
                          18.sp,
                          fontColor: state.forgotPasswordEmailController!.text
                                      .isNotEmpty &&
                                  state.forgotPasswordEmailController!.text
                                      .isEmail
                              ? AppColors.blackColor
                              : AppColors.textHintGrayColor,
                        ),
                      ));
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class EmailNotifier with ChangeNotifier {
  String _email = '';

  String get email => _email;

  void updateEmail(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }
}

class NewsCommentBottomSheet extends StatefulWidget {
  final Widget bottomButton;
  final String eventPostId;

  const NewsCommentBottomSheet(
      {super.key, required this.bottomButton, required this.eventPostId});

  @override
  State<NewsCommentBottomSheet> createState() => _NewsCommentBottomSheetState();
}

class _NewsCommentBottomSheetState extends State<NewsCommentBottomSheet>
    with TickerProviderStateMixin {
  bool isOpenReply = false;
  TextEditingController sendCommentController = TextEditingController();
  FocusNode sendCommentFocusNode = FocusNode();
  bool isBottomShow = false;
  String selectedCommentId = '';
  String selectedCommentUserName = '';
  String replySelectedCommentId = '';
  String commentPostUserId = '';
  String replyCommentPostUserId = '';
  bool isReplyComment = false;

/*  late TabController tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }*/

  Widget commentWidget(int index) {
    return BlocBuilder<NewsScreenBlocCubit, NewsScreenBlocState>(
      buildWhen: (previous, current) =>
          previous.eventPostCommentList != current.eventPostCommentList,
      builder: (context, state) {
        String time = '';
        if (state.eventPostCommentList![index].timestamp != null) {
          time = timeAgo(state.eventPostCommentList![index].timestamp!,
              hideAgoSuffix: true);
        }
        return SingleChildScrollView(
          child: GestureDetector(
            onLongPress: () {
              selectedCommentId = state.eventPostCommentList![index].id ?? '';
              commentPostUserId =
                  state.eventPostCommentList![index].userId ?? '';
              setState(() {
                isBottomShow = !isBottomShow;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15.w),
              decoration: BoxDecoration(
                  color:
                      selectedCommentId == state.eventPostCommentList![index].id
                          ? AppColors.selectedCommentColor
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r)),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.read<UserProfileCubit>().getUserId(
                                state.eventPostCommentList![index].userId ?? '',
                              );
                          context.read<UserProfileCubit>().getUserInfo();
                          NavigatorRoute.navigateTo(
                              context, AppRoutes.userProfile);
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.actionBtnBgColor,
                          ),
                          child: AppNetworkImageLoader(
                            url: state.eventPostCommentList![index]
                                    .profileImage ??
                                '',
                            boxFit: BoxFit.cover,
                            placeHolderIMAGE: Assets.images.imgUserPlc,
                            borderRadius: 300.r,
                          ),
                        ),
                      ),
                      Gap(10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Text(
                                    state.eventPostCommentList![index].name ??
                                        '',
                                    maxLines: 1,
                                    style: TextStyles.semiBold(18.sp,
                                        textOverflow: TextOverflow.ellipsis),
                                  ),
                                ),
                              ],
                            ),
                            Gap(2.h),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                state.eventPostCommentList![index].comment ??
                                    '',
                                style: TextStyles.medium(18.sp),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 10,
                              ),
                            ),
                            Gap(7.h),
                            Row(
                              children: [
                                Text(
                                  "${state.eventPostCommentList![index].totalLikes ?? '0'} likes  ",
                                  style: TextStyles.regular(17.sp,
                                      fontColor: AppColors.textHintGrayColor),
                                  maxLines: 2,
                                ),
                                InkWell(
                                  onTap: () {
                                    context
                                        .read<NewsScreenBlocCubit>()
                                        .changeReplyCommentStatus(true);
                                    setState(() {
                                      selectedCommentId = state
                                              .eventPostCommentList![index]
                                              .id ??
                                          '';
                                      selectedCommentUserName = state
                                              .eventPostCommentList![index]
                                              .name ??
                                          '';
                                      sendCommentFocusNode.requestFocus();
                                    });
                                  },
                                  child: Text(
                                    'Reply',
                                    style: TextStyles.regular(17.sp,
                                        fontColor: AppColors.textHintGrayColor),
                                    maxLines: 2,
                                  ),
                                ),
                                Gap(7.w),
                                Text(
                                  time,
                                  style: TextStyles.medium(17.sp,
                                      fontColor: AppColors.textHintGrayColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Gap(20.w),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: (state.eventPostCommentList![index].isLiked ??
                                false)
                            ? InkWell(
                                onTap: () {
                                  context
                                      .read<NewsScreenBlocCubit>()
                                      .unLikeComment(
                                          eventPostId: widget.eventPostId,
                                          userId:
                                              PrefService.getString(
                                                  PrefService.userId),
                                          commentId: state
                                                  .eventPostCommentList![index]
                                                  .id ??
                                              '');
                                },
                                child: Assets.icons.icFillThumbUp.svg(),
                              )
                            : InkWell(
                                onTap: () {
                                  context
                                      .read<NewsScreenBlocCubit>()
                                      .likeComment(
                                          eventPostId: widget.eventPostId,
                                          userId: PrefService.getString(
                                              PrefService.userId),
                                          commentId: state
                                                  .eventPostCommentList![index]
                                                  .id ??
                                              '');
                                },
                                child: Assets.icons.icThumbUpOutline.svg(),
                              ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: state
                            .eventPostCommentList![index].replies?.isNotEmpty ??
                        false,
                    child: Padding(
                      padding: EdgeInsets.only(left: 50.w, right: 10.w),
                      child: CommonExpansionTile(
                        initiallyOpenTile: (state
                                    .eventPostCommentList![index].replies
                                    ?.any(
                                  (element) =>
                                      element.userId ==
                                      PrefService.getString(PrefService.userId),
                                ) ??
                                false)
                            ? true
                            : isOpenReply,
                        title: Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "View replies(${state.eventPostCommentList![index].totalReplies ?? '0'})",
                                style: TextStyles.semiBold(16.sp),
                                maxLines: 2,
                              ),
                              Gap(10.w),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 22.sp,
                                color: AppColors.whiteColor,
                              ),
                            ],
                          ),
                        ),
                        childrenItems: List.generate(
                          state.eventPostCommentList![index].replies?.length ??
                              0,
                          (replyIndex) => Padding(
                            padding: EdgeInsets.only(bottom: 10.h, right: 0),
                            child: commentReplayWidget(index, replyIndex),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget commentReplayWidget(int index, int replyIndex) {
    return BlocBuilder<NewsScreenBlocCubit, NewsScreenBlocState>(
      builder: (context, state) {
        String time = '';
        if (state.eventPostCommentList![index].replies![replyIndex].timestamp !=
            null) {
          time = timeAgo(
              state
                  .eventPostCommentList![index].replies![replyIndex].timestamp!,
              hideAgoSuffix: true);
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                context.read<UserProfileCubit>().getUserId(
                      state.eventPostCommentList![index].replies![replyIndex]
                              .userId ??
                          '',
                    );
                context.read<UserProfileCubit>().getUserInfo();
                NavigatorRoute.navigateTo(context, AppRoutes.userProfile);
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.actionBtnBgColor,
                ),
                child: AppNetworkImageLoader(
                  url: state.eventPostCommentList![index].replies![replyIndex]
                          .profileImage ??
                      '',
                  boxFit: BoxFit.cover,
                  placeHolderIMAGE: Assets.images.imgUserPlc,
                  borderRadius: 300.r,
                ),
              ),
            ),
            Gap(10.w),
            Expanded(
              child: GestureDetector(
                onLongPress: () {
                  selectedCommentId =
                      state.eventPostCommentList![index].id ?? '';
                  commentPostUserId =
                      state.eventPostCommentList![index].userId ?? '';
                  replySelectedCommentId = state.eventPostCommentList![index]
                          .replies![replyIndex].id ??
                      '';
                  replyCommentPostUserId = state.eventPostCommentList![index]
                          .replies![replyIndex].userId ??
                      '';
                  setState(() {
                    isBottomShow = !isBottomShow;
                    isReplyComment = !isReplyComment;
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.eventPostCommentList![index].name ?? '',
                      style: TextStyles.semiBold(16.sp),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      state.eventPostCommentList![index].replies![replyIndex]
                              .comment ??
                          '',
                      style: TextStyles.regular(16.sp),
                      maxLines: 2,
                    ),
                    Gap(5.h),
                    Row(
                      children: [
                        Text(
                          "${state.eventPostCommentList![index].replies![replyIndex].totalLikes ?? '0'} likes  ",
                          style: TextStyles.regular(14.sp,
                              fontColor: AppColors.textHintGrayColor),
                          maxLines: 2,
                        ),
                        Gap(5.h),
                        Text(
                          time,
                          style: TextStyles.semiBold(16.sp,
                              fontColor: AppColors.textHintGrayColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Gap(10.w),
            (state.eventPostCommentList![index].replies![replyIndex].isLiked ??
                    false)
                ? InkWell(
                    onTap: () {
                      context.read<NewsScreenBlocCubit>().unLikeReplyComment(
                          eventPostId: widget.eventPostId,
                          userId: PrefService.getString(PrefService.userId),
                          commentId:
                              state.eventPostCommentList![index].id ?? '',
                          replyCommentId: state.eventPostCommentList![index]
                                  .replies![replyIndex].id ??
                              '');
                    },
                    child: Assets.icons.icFillThumbUp.svg(),
                  )
                : InkWell(
                    onTap: () {
                      context.read<NewsScreenBlocCubit>().likeReplyComment(
                          eventPostId: widget.eventPostId,
                          userId: PrefService.getString(PrefService.userId),
                          commentId:
                              state.eventPostCommentList![index].id ?? '',
                          replyCommentId: state.eventPostCommentList![index]
                                  .replies![replyIndex].id ??
                              '');
                    },
                    child: Assets.icons.icThumbUpOutline.svg(),
                  ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    context
        .read<NewsScreenBlocCubit>()
        .connectSocketIo(context, widget.eventPostId);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        closeKeyboard();
        setState(() {
          selectedCommentId = '';
          commentPostUserId = '';
          replySelectedCommentId = '';
          selectedCommentUserName = '';
          isBottomShow = false;
          isReplyComment = false;
        });
        context.read<NewsScreenBlocCubit>().changeReplyCommentStatus(false);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(50.w),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Text(
                  'Comments',
                  style: TextStyles.semiBold(26.sp,
                      fontFamily: testTiemposHeadline),
                  maxLines: 2,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  NavigatorRoute.navigateBack(context);
                },
                icon: Icon(Icons.close),
              ),
            ],
          ),
          Gap(10.h),
          SizedBox(
            height: MediaQuery.of(context).size.height / 2.5,
            child: BlocBuilder<NewsScreenBlocCubit, NewsScreenBlocState>(
              builder: (context, state) {
                return state.isCommentLoading
                    ? commentShimmer()
                    : (state.eventPostCommentList != null &&
                            state.eventPostCommentList!.isNotEmpty)
                        ? ListView.separated(
                            padding: EdgeInsets.only(top: 20.h),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return commentWidget(index);
                            },
                            separatorBuilder: (context, index) => Gap(10.h),
                            itemCount: state.eventPostCommentList?.length ?? 0,
                          )
                        : Center(
                            child: Text('No comments found.'),
                          );
              },
            ),
          ),
          Gap(20.h),
          isBottomShow
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      Divider(
                        color: AppColors.tabbarIndicatorColor,
                        thickness: 1.3,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          if (isReplyComment) {
                            if (commentPostUserId !=
                                PrefService.getString(PrefService.userId)) {
                              // Delete reply comment  function
                              context
                                  .read<NewsScreenBlocCubit>()
                                  .deleteReplyComment(
                                      eventPostId: widget.eventPostId,
                                      userId: PrefService.getString(
                                          PrefService.userId),
                                      commentId: selectedCommentId,
                                      replyCommentId: replySelectedCommentId);
                            } else {
                              // Report reply comment function
                              context
                                  .read<NewsDetailsScreenBlocCubit>()
                                  .clearReason();
                              showAppBottomSheet(
                                context,
                                AppCommonBottomSheet(
                                  sheetBGColor: AppColors.actionBtnBgColor,
                                  body: ReportCommentsBottomSheet(
                                    commentId: selectedCommentId,
                                    replyCommentId: replySelectedCommentId,
                                    isReplyComment: true,
                                    postId: widget.eventPostId,
                                  ),
                                  isOpenWithGradient: false,
                                ),
                              );
                            }
                          } else {
                            if (commentPostUserId ==
                                PrefService.getString(PrefService.userId)) {
                              // Delete comment function
                              context.read<NewsScreenBlocCubit>().deleteComment(
                                  eventPostId: widget.eventPostId,
                                  userId:
                                      PrefService.getString(PrefService.userId),
                                  commentId: selectedCommentId);
                            } else {
                              // Report comment function
                              context
                                  .read<NewsDetailsScreenBlocCubit>()
                                  .clearReason();
                              showAppBottomSheet(
                                context,
                                AppCommonBottomSheet(
                                  sheetBGColor: AppColors.actionBtnBgColor,
                                  body: ReportCommentsBottomSheet(
                                    isReplyComment: false,
                                    commentId: selectedCommentId,
                                    replyCommentId: '',
                                    postId: widget.eventPostId,
                                  ),
                                  isOpenWithGradient: false,
                                ),
                              );
                            }
                          }
                          setState(() {
                            selectedCommentId = '';
                            commentPostUserId = '';
                            replySelectedCommentId = '';
                            isBottomShow = false;
                            isReplyComment = false;
                          });
                        },
                        child: Text(
                          commentPostUserId !=
                                  PrefService.getString(PrefService.userId)
                              ? 'Report'
                              : 'Delete',
                          style: TextStyles.semiBold(20.sp,
                              fontColor: commentPostUserId !=
                                      PrefService.getString(PrefService.userId)
                                  ? AppColors.textHintGrayColor
                                  : AppColors.redColor),
                        ),
                      ),
                    ],
                  ))
              : BlocBuilder<NewsScreenBlocCubit, NewsScreenBlocState>(
                  builder: (context, state) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: state.isReplyComment,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      "Replying to $selectedCommentUserName comment",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyles.medium(17.sp,
                                          fontColor: AppColors.whiteColor),
                                    ),
                                  ),
                                ),
                                CloseButton(
                                  onPressed: () {
                                    context
                                        .read<NewsScreenBlocCubit>()
                                        .changeReplyCommentStatus(false);
                                    setState(() {
                                      selectedCommentId = '';
                                      selectedCommentUserName = '';
                                      sendCommentFocusNode.unfocus();
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                          CommonCommentTextField(
                            controller: sendCommentController,
                            hintText: "Share your view",
                            maxLength: 500,
                            maxLines: 2,
                            fillColor: Color(0xff2C2C2E),
                            textStyle: TextStyles.regular(17.sp,
                                fontColor: AppColors.whiteColor,
                                fontFamily: testTiemposHeadline),
                            cursorColor: AppColors.whiteColor,
                            focusNode: sendCommentFocusNode,
                            onChanged: (value) {
                              setState(() {});
                            },
                            suffixIcon: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 6.h, horizontal: 6.w),
                              child: InkWell(
                                onTap: () async {
                                  if (sendCommentController.text.isNotEmpty) {
                                    if (state.isReplyComment) {
                                      context
                                          .read<NewsScreenBlocCubit>()
                                          .sendReplyComment(
                                              eventPostId: widget.eventPostId,
                                              userId: PrefService.getString(
                                                  PrefService.userId),
                                              comment:
                                                  sendCommentController.text,
                                              commentId: selectedCommentId);
                                      sendCommentController.clear();
                                      context
                                          .read<NewsScreenBlocCubit>()
                                          .changeReplyCommentStatus(false);
                                      setState(() {
                                        selectedCommentId = '';
                                        selectedCommentUserName = '';
                                      });
                                    } else {
                                      try {
                                        await context
                                            .read<NewsScreenBlocCubit>()
                                            .sendComment(
                                                eventPostId: widget.eventPostId,
                                                userId: PrefService.getString(
                                                    PrefService.userId),
                                                comment:
                                                    sendCommentController.text);
                                        // Clear the comment input
                                        sendCommentController.clear();

                                        // Refresh comments list with correct method name
                                        await context
                                            .read<NewsScreenBlocCubit>()
                                            .getPostComments(
                                                widget.eventPostId);
                                      } catch (e) {
                                        log("comment error: $e");
                                      }
                                    }
                                  } else {
                                    AppFunctions.showToast(
                                        'Please enter comment');
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 20.r,
                                  backgroundColor:
                                      AppColors.commentTextFieldColor,
                                  child: Assets.icons.icMessageSend.svg(
                                      colorFilter: ColorFilter.mode(
                                    (sendCommentController.text.isNotEmpty &&
                                            sendCommentController.text
                                                .trim()
                                                .isNotEmpty)
                                        ? AppColors.whiteColor
                                        : AppColors.textHintGrayColor,
                                    BlendMode.srcIn,
                                  )),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
        ],
      ),
    );
  }

  commentShimmer() {
    return Shimmer.fromColors(
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50.h,
                        width: 50.w,
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
                              height: 10.h,
                              width: 100.w,
                              color: Colors.black.withValues(alpha: 0.3)),
                          Container(
                              height: 10.h,
                              width: 140.w,
                              color: Colors.black.withValues(alpha: 0.3)),
                          Container(
                              height: 10.h,
                              width: 180.w,
                              color: Colors.black.withValues(alpha: 0.3)),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) => Gap(30.h),
          itemCount: 5,
        ));
  }
}

class EndLiveBottomSheet extends StatelessWidget {
  final Function onTapOk;
  final File videoThumbImageFile;

  const EndLiveBottomSheet(
      {super.key, required this.onTapOk, required this.videoThumbImageFile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Gap(10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(50.w),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Text(
                'Live video ended',
                style: TextStyles.bold(26.sp, fontFamily: testTiemposHeadline),
                maxLines: 2,
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                onTapOk.call();
              },
              icon: Icon(Icons.close),
            ),
          ],
        ),
        Gap(30.h),
        SizedBox(
            height: 200,
            width: 150,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: AppImageViewer.showFileImage(
                  boxFit: BoxFit.cover,
                  file: videoThumbImageFile,
                ))),
        Gap(30.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.sp),
          child: Text(
            "Operator will verify this event soon and alert the near by users.",
            textAlign: TextAlign.center,
            style: TextStyles.medium(18.sp),
          ),
        ),
        Gap(50.h),
        CommonButton(
            color: AppColors.whiteColor,
            onPressed: () {
              onTapOk.call();
            },
            widget: Text(
              "OK",
              style: TextStyles.medium(18.sp, fontColor: Colors.black),
            ))
      ],
    );
  }
}

class EventBottomSheet extends StatelessWidget {
  final Function onTapOk;

  const EventBottomSheet({super.key, required this.onTapOk});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(5.h),
          Text(
            'Events',
            style: TextStyles.bold(26.sp,
                fontFamily: testTiemposHeadline, fontWeight: FontWeight.w900),
          ),
          Gap(10.h),
          Text(
            'Live updates of incidents happening around you in real-time.',
            textAlign: TextAlign.justify,
            style: TextStyles.regular(18.sp),
          ),
          Gap(30.h),
          AppImageViewer.showAssetImage(path: AppImageAsset.appEventBanner),
          Gap(30.h),
          Text(
            'Use Awaaz App to capture and share live events like accidents, fires, or unusual activity around you. Your updates will notify others in the area instantly. Users who witness the same event can respond by sending live video alerts for better awareness and quicker action.',
            textAlign: TextAlign.justify,
            style: TextStyles.regular(18.sp),
          ),
          Gap(50.h),
          CommonButton(
              width: 200.w,
              color: AppColors.whiteColor,
              onPressed: () {
                onTapOk.call();
              },
              widget: Text(
                "OK",
                style: TextStyles.semiBold(18.sp, fontColor: Colors.black),
              ))
        ],
      ),
    );
  }
}

class RescueBottomSheet extends StatelessWidget {
  final Function onTapOk;

  const RescueBottomSheet({super.key, required this.onTapOk});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(5.h),
          Text(
            'Rescue',
            style: TextStyles.bold(26.sp,
                fontFamily: testTiemposHeadline, fontWeight: FontWeight.w900),
          ),
          Gap(10.h),
          Text(
            // 'Use Awaaz App to find your Essentials & Missing Persons.',
            'Find your lost items or missing loved ones with the help from nearby users.',
            textAlign: TextAlign.justify,
            style: TextStyles.regular(18.sp),
          ),
          Gap(30.h),
          AppImageViewer.showAssetImage(path: AppImageAsset.appRescueBanner),
          Gap(30.h),
          Text(
            'Use Awaaz App to alert nearby users by sharing images or videos of your missing essentials or loved ones. If anyone in your area spots or finds them, they can immediately respond by sending a live video as an alert to help with the rescue.',
            textAlign: TextAlign.justify,
            style: TextStyles.regular(18.sp),
          ),
          Gap(50.h),
          CommonButton(
              width: 200.w,
              color: AppColors.whiteColor,
              onPressed: () {
                onTapOk.call();
              },
              widget: Text(
                "OK",
                style: TextStyles.semiBold(18.sp, fontColor: Colors.black),
              ))
        ],
      ),
    );
  }
}

class GeneralBottomSheet extends StatelessWidget {
  final Function onTapOk;

  const GeneralBottomSheet({super.key, required this.onTapOk});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(5.h),
          Text(
            'General',
            style: TextStyles.bold(26.sp,
                fontFamily: testTiemposHeadline, fontWeight: FontWeight.w900),
          ),
          Gap(10.h),
          Text(
            'Share any local needs, services, or promotions with your community.',
            textAlign: TextAlign.justify,
            style: TextStyles.regular(18.sp),
          ),
          Gap(30.h),
          AppImageViewer.showAssetImage(path: AppImageAsset.appGeneralBanner),
          Gap(30.h),
          Text(
            'Use Awaaz App to post about your requirements, services, or local promotions. Add images or videos to make your post more visible. People in your area can engage by commenting directly to connect, respond, or offer help.',
            textAlign: TextAlign.justify,
            style: TextStyles.regular(18.sp),
          ),
          Gap(50.h),
          CommonButton(
              width: 200.w,
              color: AppColors.whiteColor,
              onPressed: () {
                onTapOk.call();
              },
              widget: Text(
                "OK",
                style: TextStyles.semiBold(18.sp, fontColor: Colors.black),
              ))
        ],
      ),
    );
  }
}

class ShareEventBottomSheet extends StatelessWidget {
  final EventNewsDetailData eventNewsDetailData;

  const ShareEventBottomSheet({super.key, required this.eventNewsDetailData});

  @override
  Widget build(BuildContext context) {
    // ProgressLoader pl = ProgressLoader(context, isDismissible: true);
    String date = '';
    String time = '';
    if (eventNewsDetailData.eventTime != null) {
      date =
          DateFormat('dd MMM').format(eventNewsDetailData.eventTime!.toLocal());
      time = timeAgo(eventNewsDetailData.eventTime!.toLocal());
    }
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 15.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              spaceW(40.w),
              Text(
                'Share Incident',
                style: TextStyles.bold(28.sp,
                    fontFamily: testTiemposHeadline,
                    fontColor: AppColors.whiteColor),
              ),
              IconButton(
                  onPressed: () {
                    NavigatorRoute.navigateBack(context);
                  },
                  icon: Icon(
                    Icons.close_sharp,
                    color: AppColors.whiteColor,
                  )),
            ],
          ),
          spaceH(25.h),
          SizedBox(
            height: 220.h,
            width: MediaQuery.of(context).size.width,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(7.0)),
              child: AppNetworkImageLoader(
                width: MediaQuery.of(context).size.width,
                url: eventNewsDetailData.attachments![0].attachmentFileType ==
                        'Image'
                    ? eventNewsDetailData.attachments![0].thumbnailImage ?? ''
                    : eventNewsDetailData.attachments![0].thumbnailImage ?? '',
                boxFit: BoxFit.cover,
              ),
            ),
          ),
          // AppNetworkImageLoader(url: ''),
          spaceH(20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        eventNewsDetailData.distance ?? '0.0 km',
                        style: TextStyles.regular(18.sp,
                            fontColor: AppColors.whiteColor),
                      ),
                      Gap(10.w),
                      Assets.icons.icDot.svg(
                          colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      )),
                      Gap(10.w),
                      Text(
                        date,
                        style: TextStyles.regular(18.sp,
                            fontColor: AppColors.whiteColor),
                      ),
                      Gap(10.w),
                      Assets.icons.icDot.svg(
                          colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      )),
                      Gap(10.w),
                      Text(
                        time,
                        style: TextStyles.regular(18.sp,
                            fontColor: AppColors.whiteColor),
                      ),
                    ],
                  ),
                  Gap(10.w),
                  Text(
                    '${eventNewsDetailData.notifiedUserCount} Notified',
                    style: TextStyles.regular(18.sp,
                        fontColor: AppColors.whiteColor),
                  ),
                ],
              ),
              // SizedBox(
              //     height: 60,
              //     width: 60,
              //     child: ClipRRect(
              //         borderRadius: BorderRadius.circular(21),
              //         child:
              //             Image.asset(Assets.images.mapLocationAction.path))),
            ],
          ),
          Gap(10.h),
          Text(
            eventNewsDetailData.title ?? 'Title',
            style: TextStyles.semiBold(28.sp,
                fontFamily: testTiemposHeadline,
                fontColor: AppColors.whiteColor),
            maxLines: 2,
          ),
          Gap(5.h),
          Text(
            eventNewsDetailData.description ?? 'Description',
            style: TextStyles.regular(
              18.sp,
              fontColor: AppColors.whiteColor,
            ),
            maxLines: 3,
          ),
          Gap(50.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: AppColors.commentTextFieldColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                        onPressed: () async {
                          // await pl.show();
                          // String shareUrl =
                          //     await DeepLinkingUtils.generateShortUrl(
                          //           eventNewsDetailData.id ?? '',
                          //           eventNewsDetailData.title ?? '',
                          //           eventNewsDetailData.description ?? '',
                          //         ) ??
                          //         '';
                          //
                          // String filePath = '';
                          // String? thumbnailUrl =
                          //     (eventNewsDetailData.attachments != null &&
                          //             eventNewsDetailData
                          //                 .attachments!.isNotEmpty)
                          //         ? eventNewsDetailData
                          //             .attachments![0].thumbnailImage
                          //         : null;
                          //
                          // if (thumbnailUrl != null && thumbnailUrl.isNotEmpty) {
                          //   filePath = await AppFunctions.downloadImageToCache(
                          //       thumbnailUrl);
                          // } else {
                          //   // Copy app logo to cache before sharing
                          //   final ByteData data = await rootBundle
                          //       .load('assets/images/awaz-logo.png');
                          //   final String tempPath =
                          //       (await getTemporaryDirectory()).path;
                          //   final String fullPath = '$tempPath/app_logo.png';
                          //   File(fullPath)
                          //       .writeAsBytesSync(data.buffer.asUint8List());
                          //   filePath = fullPath;
                          // }
                          //
                          // AppFunctions.sharePost(
                          //     title: eventNewsDetailData.title ?? 'Title',
                          //     description: eventNewsDetailData.description ??
                          //         'Description',
                          //     imagePath: filePath,
                          //     url: shareUrl);
                          // await pl.hide();

                          String shareUrl =
                              'Awaaz:Real Time City Alert \n https://news.awaazeye.com/${eventNewsDetailData.id ?? ''}';
                          AppFunctions.sharePostText(
                            url: shareUrl,
                          );
                        },
                        icon: Icon(
                          Icons.link,
                          color: AppColors.whiteColor,
                          size: 30,
                        )),
                  ),
                  Gap(5.h),
                  Text(
                    'Copy Link',
                    style: TextStyles.semiBold(
                      16.sp,
                      fontColor: AppColors.whiteColor,
                    ),
                  ),
                ],
              ),
              spaceW(30.w),
              Column(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: AppColors.commentTextFieldColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () async {
                        // await pl.show();
                        // // NavigatorRoute.navigateBack(context);
                        // String filePath = '';
                        // if (eventNewsDetailData.attachments?.isNotEmpty ??
                        //     false) {
                        //   if (eventNewsDetailData
                        //               .attachments![0].thumbnailImage !=
                        //           null &&
                        //       eventNewsDetailData
                        //           .attachments![0].thumbnailImage!.isNotEmpty) {
                        //     filePath = await AppFunctions.downloadImageToCache(
                        //         eventNewsDetailData
                        //             .attachments![0].thumbnailImage!);
                        //   } else {
                        //     // Copy app logo to cache before sharing
                        //     final ByteData data = await rootBundle
                        //         .load('assets/images/awaz-logo.png');
                        //     final String tempPath =
                        //         (await getTemporaryDirectory()).path;
                        //     final String fullPath = '$tempPath/app_logo.png';
                        //     File(fullPath)
                        //         .writeAsBytesSync(data.buffer.asUint8List());
                        //     filePath = fullPath;
                        //   }
                        // } else {
                        //   // Copy app logo when no attachments
                        //   final ByteData data = await rootBundle
                        //       .load('assets/images/awaz-logo.png');
                        //   final String tempPath =
                        //       (await getTemporaryDirectory()).path;
                        //   final String fullPath = '$tempPath/app_logo.png';
                        //   File(fullPath)
                        //       .writeAsBytesSync(data.buffer.asUint8List());
                        //   filePath = fullPath;
                        // }
                        // AppFunctions.sharePost(
                        //   title: eventNewsDetailData.title ?? 'Title',
                        //   description:
                        //       eventNewsDetailData.description ?? 'Description',
                        //   imagePath: filePath,
                        //   url: eventNewsDetailData.attachments?[0].attachment ??
                        //       '',
                        // );
                        // await pl.hide();
                        NavigatorRoute.navigateBack(context);
                        String shareUrl =
                            'Awaaz:Real Time City Alert \n https://news.awaazeye.com/${eventNewsDetailData.id ?? ''}';
                        AppFunctions.sharePostText(
                          url: shareUrl,
                        );
                      },
                      icon: Assets.icons.icMenu.svg(
                        height: 25,
                        width: 25,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  Gap(5.h),
                  Text(
                    'More',
                    style: TextStyles.semiBold(
                      16.sp,
                      fontColor: AppColors.whiteColor,
                    ),
                  ),
                ],
              )
            ],
          ),
          Gap(40.h),
        ],
      ),
    );
  }
}

class GeneralPersonInfoBottomSheet extends StatefulWidget {
  final EventNewsDetailModel? data;
  final String? status;

  const GeneralPersonInfoBottomSheet(
      {super.key, required this.data, required this.status});

  @override
  State<GeneralPersonInfoBottomSheet> createState() =>
      _GeneralPersonInfoBottomSheetState();
}

class _GeneralPersonInfoBottomSheetState
    extends State<GeneralPersonInfoBottomSheet> {
  final Map<int, ChewieController> _chewieControllers = {};
  List<VideoPlayerController?> attachmentVideoControllers = [];
  int attachmentCurrentIndex = 0;
  int selectedAttachmentIndex = 0;
  bool isMuted = false;

  @override
  void dispose() {
    _chewieControllers.forEach((key, controller) => controller.dispose());
    _chewieControllers.clear();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.data!.body!.attachments!.isNotEmpty) {
      initializeControllers(widget.data!.body!.attachments!);
    }
    super.initState();
  }

  void initializeControllers(List<Attachment> attachments) {
    if (attachments.isEmpty) return;

    List<VideoPlayerController?> tempList =
        List.generate(attachments.length, (index) => null);

    attachmentVideoControllers = tempList;
    setState(() {});

    // Ensure the first video is initialized only if the attachment is not null or empty
    if (attachments[0].attachment != null &&
        attachments[0].attachment!.isNotEmpty) {
      _initializeControllerAtIndex(0, attachments[0]);
      setState(() {});
    }
  }

  Future<void> _initializeControllerAtIndex(
      int index, Attachment attachment) async {
    if (index < 0 || index >= attachmentVideoControllers.length) return;
    if (attachmentVideoControllers[index] != null) return;

    final controller = VideoPlayerController.networkUrl(
      Uri.parse(attachment.attachment ?? ''),
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true,
      ),
    );

    await controller.initialize().then((_) {
      // if (index == state.attachmentCurrentIndex) {
      //   controller.play();
      // }

      // Ensure the state is properly updated
      final newControllers =
          List<VideoPlayerController?>.from(attachmentVideoControllers);

      if (index < newControllers.length) {
        newControllers[index] = controller;
        attachmentVideoControllers = newControllers;
      }
      setState(() {});
    }).catchError((error) {
      debugPrint("Error initializing video controller at index $index: $error");
    });
  }

  void onPageChanged(int index, CarouselPageChangedReason reason) {
    final prevIndex = attachmentCurrentIndex;
    if (attachmentVideoControllers[prevIndex]?.value.isPlaying ?? false) {
      attachmentVideoControllers[prevIndex]?.pause();
    }

    // Initialize controller if not exists
    if (attachmentVideoControllers[index] == null) {
      final attachment = widget.data!.body!.attachments![index];
      _initializeControllerAtIndex(index, attachment);
      setState(() {});
    } else {
      attachmentVideoControllers[index]!.play();
      setState(() {});
    }

    attachmentCurrentIndex = index;

    // Preload next and previous videos
    _preloadAdjacentVideos(index);
  }

  void _preloadAdjacentVideos(int currentIndex) {
    final attachments = widget.data!.body!.attachments!;
    final indicesToPreload = [
      currentIndex - 1,
      currentIndex + 1,
    ].where((i) => i >= 0 && i < attachments.length).toList();

    for (final index in indicesToPreload) {
      if (attachmentVideoControllers[index] == null) {
        _initializeControllerAtIndex(index, attachments[index]);
        setState(() {});
      }
    }
  }

  void disposeControllers() {
    for (var controller in attachmentVideoControllers) {
      if (controller != null) {
        controller.dispose();
      }
    }
    attachmentVideoControllers = [];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.80,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                //   decoration: BoxDecoration(
                //       color: AppColors.yellowColor.withValues(alpha: 0.1),
                //       borderRadius: BorderRadius.circular(4)),
                //   child: Text(
                //     widget.status ?? '',
                //     style: TextStyles.medium(16.sp,
                //         fontColor: AppColors.yellowColor),
                //   ),
                // ),
                IconButton(
                    onPressed: () {
                      NavigatorRoute.navigateBack(context);
                    },
                    icon: Icon(Icons.close)),
              ],
            ),
            SizedBox(height: 15.h),
            (attachmentVideoControllers.isNotEmpty && widget.data != null)
                ? CarouselSlider.builder(
                    itemCount: widget.data?.body?.attachments?.length ?? 0,
                    itemBuilder: (context, index, realIndex) {
                      if (widget.data?.body?.attachments![index]
                              .attachmentFileType ==
                          "Video") {
                        VideoPlayerController? videoController =
                            attachmentVideoControllers[index];
                        if (videoController != null) {
                          if (!_chewieControllers.containsKey(index)) {
                            _chewieControllers[index] = ChewieController(
                              videoPlayerController: videoController,
                              autoPlay: widget.data?.body?.attachments?.first
                                          .isSensitiveContent ==
                                      true
                                  ? false
                                  : index == attachmentCurrentIndex,
                              autoInitialize: true,
                              allowMuting: true,
                              placeholder: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.whiteColor,
                                ),
                              ),
                              allowPlaybackSpeedChanging: false,
                              allowFullScreen: true,
                              showControls: false,
                              showControlsOnInitialize: false,
                              looping: true,
                              aspectRatio: 9 / 16,
                              // aspectRatio:
                              // 16 / 9,
                              // videoController.value.aspectRatio,
                              bufferingBuilder: (context) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.whiteColor,
                                  ),
                                );
                              },
                            );
                          }
                        }
                        return _chewieControllers[index] != null
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      context
                                          .read<NewsDetailsScreenBlocCubit>()
                                          .setAttachmentIndex(index);
                                    },
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      // height: isFullScreenMode  ? MediaQuery.of(
                                      //     context)
                                      //     .size
                                      //     .height : null,
                                      child: Chewie(
                                          controller:
                                              _chewieControllers[index]!),
                                    ),
                                  ),
                                  Positioned(
                                    top: 2,
                                    right: 5,
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isMuted = !isMuted;
                                          _chewieControllers[index]!
                                              .setVolume(isMuted ? 0.0 : 1.0);
                                          log("isMuted :- $isMuted");
                                        });
                                      },
                                      icon: isMuted == true
                                          ? Icon(Icons.volume_off)
                                          : Icon(Icons.volume_up),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10.h,
                                    left: 10.w,
                                    child: Row(
                                      children: [
                                        Assets.icons.icEye.svg(
                                          colorFilter: const ColorFilter.mode(
                                            Colors.white,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        Gap(5.w),
                                        Text(
                                          widget.data?.body?.viewCounts
                                                  ?.toString() ??
                                              '0',
                                          style: TextStyles.semiBold(16.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (widget.data?.body?.attachments?.first
                                          .isSensitiveContent ==
                                      true) ...[
                                    Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      color:
                                          Colors.black.withValues(alpha: 0.6),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 15, sigmaY: 15),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  height: 40.h,
                                                  child: FittedBox(
                                                    child: Assets.icons.icEyeOff
                                                        .svg(),
                                                  )),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Text(
                                                'Sensitive content',
                                                style: TextStyles.bold(18.sp),
                                              ),
                                              Text(
                                                'This video may contain graphic or violent content. ',
                                                style: TextStyles.medium(14.sp),
                                              ),
                                              SizedBox(
                                                height: 20.h,
                                              ),
                                              Divider(
                                                indent: 50.w,
                                                endIndent: 50.w,
                                              ),
                                              CommonTextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    widget
                                                            .data
                                                            ?.body
                                                            ?.attachments
                                                            ?.first
                                                            .isSensitiveContent =
                                                        false;
                                                    _chewieControllers[
                                                            selectedAttachmentIndex]!
                                                        .play();
                                                  });
                                                },
                                                widget: Text(
                                                  'Show Anyway',
                                                  style: TextStyles.semiBold(
                                                      15.sp),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.whiteColor,
                                ),
                              );
                      } else {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(7.0)),
                            child: AppNetworkImageLoader(
                              width: MediaQuery.of(context).size.width,
                              url: widget.data?.body!.attachments![index]
                                      .attachment ??
                                  '',
                              boxFit: BoxFit.cover,
                            ),
                          ),
                        );
                      }
                    },
                    options: CarouselOptions(
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      initialPage: 0,
                      autoPlay: false,
                      viewportFraction: 0.92,
                      enlargeFactor: 0.15,
                      onPageChanged: (index, reason) {
                        context
                            .read<NewsDetailsScreenBlocCubit>()
                            .onPageChanged(index, reason);
                      },
                    ),
                  )
                : SizedBox.shrink(),
            SizedBox(height: 30.h),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.popUpTextFieldBlackColor),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category',
                    style: TextStyles.regular(16.sp,
                        fontColor: AppColors.textHintGrayColor),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    widget.data?.body?.mainCategory?.eventName.toString() ?? "",
                    style: TextStyles.medium(18.sp,
                        fontColor: AppColors.whiteColor),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.popUpTextFieldBlackColor),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subcategory',
                    style: TextStyles.regular(16.sp,
                        fontColor: AppColors.textHintGrayColor),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    widget.data?.body?.subCategory?.eventName.toString() ?? "",
                    style: TextStyles.medium(18.sp,
                        fontColor: AppColors.whiteColor),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.popUpTextFieldBlackColor),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title',
                    style: TextStyles.regular(16.sp,
                        fontColor: AppColors.textHintGrayColor),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    widget.data?.body?.title.toString() ?? "",
                    style: TextStyles.medium(18.sp,
                        fontColor: AppColors.whiteColor),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.popUpTextFieldBlackColor),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: TextStyles.regular(16.sp,
                        fontColor: AppColors.textHintGrayColor),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    widget.data?.body?.description.toString() ?? "",
                    style: TextStyles.medium(18.sp,
                        fontColor: AppColors.whiteColor),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.popUpTextFieldBlackColor),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location ',
                    style: TextStyles.regular(16.sp,
                        fontColor: AppColors.textHintGrayColor),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    widget.data?.body?.address.toString() ?? '',
                    style: TextStyles.medium(18.sp,
                        fontColor: AppColors.whiteColor),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.popUpTextFieldBlackColor),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hashtag',
                    style: TextStyles.regular(16.sp,
                        fontColor: AppColors.textHintGrayColor),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    widget.data?.body?.hashTags
                            .toString()
                            .replaceAll('[', "")
                            .replaceAll("]", "") ??
                        'No HashTag',
                    style: TextStyles.medium(18.sp,
                        fontColor: AppColors.whiteColor),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}

class RescuePersonInfoBottomSheet extends StatefulWidget {
  final EventNewsDetailModel? data;
  final String? status;

  const RescuePersonInfoBottomSheet({super.key, this.data, this.status});

  @override
  State<RescuePersonInfoBottomSheet> createState() =>
      _RescuePersonInfoBottomSheetState();
}

class _RescuePersonInfoBottomSheetState
    extends State<RescuePersonInfoBottomSheet> {
  final Map<int, ChewieController> _chewieControllers = {};
  List<VideoPlayerController?> attachmentVideoControllers = [];
  int attachmentCurrentIndex = 0;
  int selectedAttachmentIndex = 0;
  bool isMuted = false;

  @override
  void dispose() {
    _chewieControllers.forEach((key, controller) => controller.dispose());
    _chewieControllers.clear();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.data!.body!.attachments!.isNotEmpty) {
      initializeControllers(widget.data!.body!.attachments!);
    }
    super.initState();
  }

  void initializeControllers(List<Attachment> attachments) {
    if (attachments.isEmpty) return;

    List<VideoPlayerController?> tempList =
        List.generate(attachments.length, (index) => null);

    attachmentVideoControllers = tempList;
    setState(() {});

    // Ensure the first video is initialized only if the attachment is not null or empty
    if (attachments[0].attachment != null &&
        attachments[0].attachment!.isNotEmpty) {
      _initializeControllerAtIndex(0, attachments[0]);
      setState(() {});
    }
  }

  Future<void> _initializeControllerAtIndex(
      int index, Attachment attachment) async {
    if (index < 0 || index >= attachmentVideoControllers.length) return;
    if (attachmentVideoControllers[index] != null) return;

    final controller = VideoPlayerController.networkUrl(
      Uri.parse(attachment.attachment ?? ''),
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true,
      ),
    );

    await controller.initialize().then((_) {
      // if (index == state.attachmentCurrentIndex) {
      //   controller.play();
      // }

      // Ensure the state is properly updated
      final newControllers =
          List<VideoPlayerController?>.from(attachmentVideoControllers);

      if (index < newControllers.length) {
        newControllers[index] = controller;
        attachmentVideoControllers = newControllers;
      }
      setState(() {});
    }).catchError((error) {
      debugPrint("Error initializing video controller at index $index: $error");
    });
  }

  void onPageChanged(int index, CarouselPageChangedReason reason) {
    final prevIndex = attachmentCurrentIndex;
    if (attachmentVideoControllers[prevIndex]?.value.isPlaying ?? false) {
      attachmentVideoControllers[prevIndex]?.pause();
    }

    // Initialize controller if not exists
    if (attachmentVideoControllers[index] == null) {
      final attachment = widget.data!.body!.attachments![index];
      _initializeControllerAtIndex(index, attachment);
      setState(() {});
    } else {
      attachmentVideoControllers[index]!.play();
      setState(() {});
    }

    attachmentCurrentIndex = index;

    // Preload next and previous videos
    _preloadAdjacentVideos(index);
  }

  void _preloadAdjacentVideos(int currentIndex) {
    final attachments = widget.data!.body!.attachments!;
    final indicesToPreload = [
      currentIndex - 1,
      currentIndex + 1,
    ].where((i) => i >= 0 && i < attachments.length).toList();

    for (final index in indicesToPreload) {
      if (attachmentVideoControllers[index] == null) {
        _initializeControllerAtIndex(index, attachments[index]);
        setState(() {});
      }
    }
  }

  void disposeControllers() {
    for (var controller in attachmentVideoControllers) {
      if (controller != null) {
        controller.dispose();
      }
    }
    attachmentVideoControllers = [];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.80,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                      color: AppColors.yellowColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4)),
                  child: Text(
                    widget.status ?? '',
                    style: TextStyles.medium(16.sp,
                        fontColor: AppColors.yellowColor),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      NavigatorRoute.navigateBack(context);
                    },
                    icon: Icon(Icons.close)),
              ],
            ),
            SizedBox(height: 15.h),
            (attachmentVideoControllers.isNotEmpty && widget.data != null)
                ? CarouselSlider.builder(
                    itemCount: widget.data?.body?.attachments?.length ?? 0,
                    itemBuilder: (context, index, realIndex) {
                      if (widget.data?.body?.attachments![index]
                              .attachmentFileType ==
                          "Video") {
                        VideoPlayerController? videoController =
                            attachmentVideoControllers[index];
                        if (videoController != null) {
                          if (!_chewieControllers.containsKey(index)) {
                            _chewieControllers[index] = ChewieController(
                              videoPlayerController: videoController,
                              autoPlay: widget.data?.body?.attachments?.first
                                          .isSensitiveContent ==
                                      true
                                  ? false
                                  : index == attachmentCurrentIndex,
                              autoInitialize: true,
                              allowMuting: true,
                              placeholder: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.whiteColor,
                                ),
                              ),
                              allowPlaybackSpeedChanging: false,
                              allowFullScreen: true,
                              showControls: false,
                              showControlsOnInitialize: false,
                              looping: true,
                              aspectRatio: 9 / 16,
                              // aspectRatio:
                              // 16 / 9,
                              // videoController.value.aspectRatio,
                              bufferingBuilder: (context) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.whiteColor,
                                  ),
                                );
                              },
                            );
                          }
                        }
                        return _chewieControllers[index] != null
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      context
                                          .read<NewsDetailsScreenBlocCubit>()
                                          .setAttachmentIndex(index);
                                    },
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      // height: isFullScreenMode  ? MediaQuery.of(
                                      //     context)
                                      //     .size
                                      //     .height : null,
                                      child: Chewie(
                                          controller:
                                              _chewieControllers[index]!),
                                    ),
                                  ),
                                  Positioned(
                                    top: 2,
                                    right: 5,
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isMuted = !isMuted;
                                          _chewieControllers[index]!
                                              .setVolume(isMuted ? 0.0 : 1.0);
                                          log("isMuted :- $isMuted");
                                        });
                                      },
                                      icon: isMuted == true
                                          ? Icon(Icons.volume_off)
                                          : Icon(Icons.volume_up),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10.h,
                                    left: 10.w,
                                    child: Row(
                                      children: [
                                        Assets.icons.icEye.svg(
                                          colorFilter: const ColorFilter.mode(
                                            Colors.white,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        Gap(5.w),
                                        Text(
                                          widget.data?.body?.viewCounts
                                                  ?.toString() ??
                                              '0',
                                          style: TextStyles.semiBold(16.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (widget.data?.body?.attachments?.first
                                          .isSensitiveContent ==
                                      true) ...[
                                    Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      color:
                                          Colors.black.withValues(alpha: 0.6),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 15, sigmaY: 15),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  height: 40.h,
                                                  child: FittedBox(
                                                    child: Assets.icons.icEyeOff
                                                        .svg(),
                                                  )),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Text(
                                                'Sensitive content',
                                                style: TextStyles.bold(18.sp),
                                              ),
                                              Text(
                                                'This video may contain graphic or violent content. ',
                                                style: TextStyles.medium(14.sp),
                                              ),
                                              SizedBox(
                                                height: 20.h,
                                              ),
                                              Divider(
                                                indent: 50.w,
                                                endIndent: 50.w,
                                              ),
                                              CommonTextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    widget
                                                            .data
                                                            ?.body
                                                            ?.attachments
                                                            ?.first
                                                            .isSensitiveContent =
                                                        false;
                                                    _chewieControllers[
                                                            selectedAttachmentIndex]!
                                                        .play();
                                                  });
                                                },
                                                widget: Text(
                                                  'Show Anyway',
                                                  style: TextStyles.semiBold(
                                                      15.sp),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.whiteColor,
                                ),
                              );
                      } else {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(7.0)),
                            child: AppNetworkImageLoader(
                              width: MediaQuery.of(context).size.width,
                              url: widget.data?.body!.attachments![index]
                                      .attachment ??
                                  '',
                              boxFit: BoxFit.cover,
                            ),
                          ),
                        );
                      }
                    },
                    options: CarouselOptions(
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      initialPage: 0,
                      autoPlay: false,
                      viewportFraction: 0.92,
                      enlargeFactor: 0.15,
                      onPageChanged: (index, reason) {
                        context
                            .read<NewsDetailsScreenBlocCubit>()
                            .onPageChanged(index, reason);
                      },
                    ),
                  )
                : SizedBox.shrink(),
            SizedBox(height: 30.h),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.popUpTextFieldBlackColor),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Full Name',
                    style: TextStyles.regular(16.sp,
                        fontColor: AppColors.textHintGrayColor),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    widget.data?.body?.attachments?.first.name ?? '',
                    style: TextStyles.medium(18.sp,
                        fontColor: AppColors.whiteColor),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.popUpTextFieldBlackColor),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Location ',
                    style: TextStyles.regular(16.sp,
                        fontColor: AppColors.textHintGrayColor),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    widget.data?.body?.address ?? '',
                    style: TextStyles.medium(18.sp,
                        fontColor: AppColors.whiteColor),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.popUpTextFieldBlackColor),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: TextStyles.regular(16.sp,
                        fontColor: AppColors.textHintGrayColor),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    widget.data?.body?.description ?? '',
                    style: TextStyles.medium(18.sp,
                        fontColor: AppColors.whiteColor),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.popUpTextFieldBlackColor),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date & Time',
                    style: TextStyles.regular(16.sp,
                        fontColor: AppColors.textHintGrayColor),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    DateFormat("d MMM, y, h:mm a").format(
                        widget.data?.body?.eventTime?.toLocal() ??
                            DateTime.now().toLocal()),
                    style: TextStyles.medium(18.sp,
                        fontColor: AppColors.whiteColor),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.popUpTextFieldBlackColor),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Phone Number',
                    style: TextStyles.regular(16.sp,
                        fontColor: AppColors.textHintGrayColor),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    "${widget.data?.body?.countryCode ?? ''}${widget.data?.body?.mobileNumber ?? ''}",
                    style: TextStyles.medium(18.sp,
                        fontColor: AppColors.whiteColor),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}

class RescuePersonFoundBottomSheet extends StatelessWidget {
  final String postId;

  const RescuePersonFoundBottomSheet({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            children: [
              spaceH(40.h),
              BlocBuilder<SendAlertCubit, SendAlertState>(
                builder: (context, state) {
                  return Container(
                    height: 140.h,
                    width: 130.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: AppColors.actionBtnBgColor,
                    ),
                    child: (state.profilePicture != null)
                        ? InkWell(
                            onTap: () {
                              context
                                  .read<SendAlertCubit>()
                                  .onTapProfile(context);
                            },
                            borderRadius: BorderRadius.circular(15.r),
                            child: SizedBox(
                                height: 140.h,
                                width: 130.w,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: Image.file(
                                      state.profilePicture!,
                                      fit: BoxFit.cover,
                                    ))),
                          )
                        : InkWell(
                            onTap: () {
                              context
                                  .read<SendAlertCubit>()
                                  .onTapProfile(context);
                            },
                            borderRadius: BorderRadius.circular(15.r),
                            child: Container(
                              height: 140.h,
                              width: 130.w,
                              padding: EdgeInsets.all(30.sp),
                              decoration: BoxDecoration(
                                color: AppColors.popUpTextFieldBlackColor,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.r),
                                child: Assets.icons.icUpload.svg(),
                              ),
                            ),
                          ),
                  );
                },
              ),
              spaceH(10.h),
              Text(
                'Upload image',
                style: TextStyles.semiBold(
                  20.sp,
                ),
              ),
              spaceH(1.h),
              Text(
                'Size should be below 50 MB',
                style: TextStyles.bold(16.sp,
                    fontColor: AppColors.textHintGrayColor),
              ),
              // spaceH(15.h),
              // GestureDetector(
              //   onTap: () {
              //     context.read<SendAlertCubit>().onTapProfile(context);
              //   },
              //   child: Container(
              //     width: 130.w,
              //     height: 40.h,
              //     alignment: Alignment.center,
              //     decoration: BoxDecoration(
              //         gradient: LinearGradient(colors: [
              //       Color(0xff1FA9FF),
              //       Color(0xff1C7EFF),
              //     ])),
              //     child: Text(
              //       'Upload Image',
              //       style: TextStyles.bold(
              //         18.sp,
              //       ),
              //     ),
              //   ),
              // ),
              BlocBuilder<SendAlertCubit, SendAlertState>(
                buildWhen: (previous, current) =>
                    previous.profilePicture != current.profilePicture,
                builder: (context, state) {
                  return Visibility(
                    visible: state.profilePicture != null,
                    child: IconButton(
                        onPressed: () {
                          context.read<SendAlertCubit>().clearProfilePhoto();
                        },
                        icon: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 7.h),
                          decoration: BoxDecoration(
                              color: AppColors.redColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(5.r),
                              border: Border.all(color: AppColors.redColor)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Assets.icons.icDeleteRed.svg(height: 20.h),
                              spaceW(2.w),
                              Text(
                                'Delete photo',
                                style: TextStyles.semiBold(14.sp,
                                    fontColor: AppColors.redColorColor),
                              )
                            ],
                          ),
                        )),
                  );
                },
              ),
              spaceH(20.h),
              BlocBuilder<SendAlertCubit, SendAlertState>(
                buildWhen: (previous, current) =>
                    previous.descriptionController !=
                    current.descriptionController,
                builder: (context, state) {
                  return CommonMainTextField(
                    fillColor: AppColors.popUpTextFieldBlackColor,
                    hintText: 'Provide Update & Approx. Time:',
                    controller: state.descriptionController!,
                    radius: BorderRadius.circular(10.r),
                    labelText: 'Provide Update',
                  );
                },
              ),
              spaceH(15.h),
              BlocBuilder<SendAlertCubit, SendAlertState>(
                buildWhen: (previous, current) =>
                    previous.locationController != current.locationController,
                builder: (context, state) {
                  return CommonMainTextField(
                    fillColor: AppColors.popUpTextFieldBlackColor,
                    onTap: () {
                      NavigatorRoute.navigateTo(
                          context, AppRoutes.searchLocation);
                    },
                    readOnly: true,
                    suffixIcon: Icon(
                      Icons.location_on,
                      color: AppColors.whiteColor,
                    ),
                    hintText: 'Select location',
                    controller: state.locationController!,
                    radius: BorderRadius.circular(10.r),
                    labelText: 'Location',
                  );
                },
              ),
              spaceH(15.h),
              BlocBuilder<SendAlertCubit, SendAlertState>(
                buildWhen: (previous, current) =>
                    previous.phoneNumberController !=
                    current.phoneNumberController,
                builder: (context, state) {
                  return CommonMainTextField(
                    fillColor: AppColors.popUpTextFieldBlackColor,
                    hintText: 'Enter phone number',
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(10),
                    ],
                    keyboardType: TextInputType.phone,
                    controller: state.phoneNumberController!,
                    radius: BorderRadius.circular(10.r),
                    labelText: 'Phone Number',
                  );
                },
              ),
              spaceH(60.h),
              CommonButton(
                color: Colors.white,
                widget: Text(
                  'POST',
                  style: TextStyles.semiBold(19.sp,
                      fontColor: AppColors.blackColor),
                ),
                onPressed: () async {
                  await context
                      .read<SendAlertCubit>()
                      .validateField(context, isUpdate: true, postId: postId);
                },
              ),
              spaceH(20.h),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportPostBottomSheet extends StatefulWidget {
  const ReportPostBottomSheet({super.key});

  @override
  State<ReportPostBottomSheet> createState() => _ReportPostBottomSheetState();
}

class _ReportPostBottomSheetState extends State<ReportPostBottomSheet> {
  // Variable to store the selected option
  int? selectedIndex;
  final ScrollController scrollController = ScrollController();
  final TextEditingController reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(children: [
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // SizedBox(height: 40.w),
                  SizedBox(),
                  Text(
                    'Report',
                    style: TextStyles.bold(28.sp,
                        fontFamily: testTiemposHeadline,
                        fontColor: AppColors.whiteColor),
                  ),
                  SizedBox(),
                ],
              ),
            ),
            SizedBox(height: 25.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'Why are you reporting this post?',
                textAlign: TextAlign.center,
                style:
                    TextStyles.semiBold(27.sp, fontColor: AppColors.whiteColor),
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'We check all the post & ensure that they are the within guidelines so do not worry about reporting this post.',
                textAlign: TextAlign.center,
                style:
                    TextStyles.regular(18.sp, fontColor: AppColors.whiteColor),
              ),
            ),
            SizedBox(height: 14.h),
            Divider(),
            SizedBox(height: 14.h),
            SizedBox(
              height: 350.h,
              child: Scrollbar(
                thumbVisibility: true,
                controller: scrollController,
                radius: Radius.circular(10),
                thickness: 2,
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: postReportOptionList.length + 1,
                  // padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemBuilder: (context, index) {
                    if (index == postReportOptionList.length) {
                      return Column(
                        children: [
                          CommonRadioListTile(
                            title: 'Other',
                            onChanged: (int? value) {
                              setState(() {
                                selectedIndex = value;
                              });
                            },
                            value: index,
                            groupValue: selectedIndex,
                          ),
                          Visibility(
                            visible:
                                (selectedIndex == postReportOptionList.length),
                            child: CommonMainTextField(
                              hintText: 'Report Here',
                              controller: reasonController,
                              fillColor: AppColors.whiteColor,
                              cursorColor: AppColors.textHintGrayColor,
                              textStyle: TextStyles.regular(18.sp,
                                  fontColor: AppColors.textHintGrayColor),
                            ),
                          ),
                          Gap(2.h),
                        ],
                      );
                    }
                    return CommonRadioListTile(
                      title: postReportOptionList[index].title,
                      onChanged: (int? value) {
                        reasonController.clear();
                        setState(() {
                          selectedIndex = value;
                        });
                      },
                      value: index,
                      groupValue: selectedIndex,
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 40.h),
            CommonButton(
              color: Colors.white,
              onPressed: () {
                if (selectedIndex != null) {
                  if (selectedIndex == 7 && reasonController.text.isEmpty) {
                    AppFunctions.showToast(
                        'Please select a reason to report the post');
                  } else {
                    context.read<NewsDetailsScreenBlocCubit>().getReason(
                          (reasonController.text.isNotEmpty)
                              ? reasonController.text
                              : userReportOptionList[selectedIndex!].title,
                        );
                    context.read<NewsDetailsScreenBlocCubit>().reportPost();
                    NavigatorRoute.navigateBack(context);
                    showAppBottomSheet(
                      context,
                      AppCommonBottomSheet(
                        sheetBGColor: AppColors.actionBtnBgColor,
                        body: ReportSuccessBottomSheet(),
                        isOpenWithGradient: false,
                      ),
                    );
                  }
                } else {
                  AppFunctions.showToast(
                      'Please select a reason to report the post');
                }
              },
              widget: Text(
                'Report',
                style:
                    TextStyles.semiBold(19.sp, fontColor: AppColors.blackColor),
              ),
            ),
          ]),
          Positioned(
            right: 0,
            top: 20.h,
            child: InkWell(
                onTap: () {
                  NavigatorRoute.navigateBack(context);
                },
                child: Icon(
                  Icons.close_sharp,
                  color: AppColors.whiteColor,
                )),
          )
        ],
      ),
    );
  }
}

class ReportCommentsBottomSheet extends StatefulWidget {
  final bool isReplyComment;
  final String commentId;
  final String postId;
  final String replyCommentId;

  const ReportCommentsBottomSheet({
    super.key,
    required this.isReplyComment,
    required this.commentId,
    required this.replyCommentId,
    required this.postId,
  });

  @override
  State<ReportCommentsBottomSheet> createState() =>
      _ReportCommentsBottomSheetState();
}

class _ReportCommentsBottomSheetState extends State<ReportCommentsBottomSheet> {
  // Variable to store the selected option
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        SizedBox(
          height: 15.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 40.w),
            Text(
              'Report ',
              style: TextStyles.bold(28.sp,
                  fontFamily: testTiemposHeadline,
                  fontColor: AppColors.whiteColor),
            ),
            IconButton(
                onPressed: () {
                  NavigatorRoute.navigateBack(context);
                },
                icon: Icon(
                  Icons.close_sharp,
                  color: AppColors.whiteColor,
                )),
          ],
        ),
        SizedBox(height: 25.h),
        Text(
          'Why are you reporting this Comment ?',
          textAlign: TextAlign.center,
          style: TextStyles.semiBold(27.sp, fontColor: AppColors.whiteColor),
        ),
        SizedBox(height: 10.h),
        Text(
          "We'll check for all Community Guidelines, so don't worry about making the perfect choice.",
          textAlign: TextAlign.center,
          style: TextStyles.regular(18.sp, fontColor: AppColors.whiteColor),
        ),
        SizedBox(height: 40.h),
        SizedBox(
          height: 350.h,
          child: ListView.builder(
            itemCount: commentsReportOptionList.length,
            itemBuilder: (context, index) {
              return CommonRadioListTile(
                title: commentsReportOptionList[index].title,
                onChanged: (int? value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
                value: index,
                groupValue: selectedIndex,
              );
            },
          ),
        ),
        SizedBox(height: 40.h),
        CommonButton(
          color: Colors.white,
          onPressed: () {
            if (selectedIndex != null) {
              if (widget.isReplyComment) {
                context.read<NewsDetailsScreenBlocCubit>().reportCommentReply(
                      commentId: widget.commentId,
                      replyCommentId: widget.replyCommentId,
                      postId: widget.postId,
                      reason:
                          commentsReportOptionList[selectedIndex ?? 0].title,
                    );
              } else {
                context.read<NewsDetailsScreenBlocCubit>().reportComment(
                    widget.commentId,
                    widget.postId,
                    commentsReportOptionList[selectedIndex ?? 0].title);
              }
              NavigatorRoute.navigateBack(context);
              showAppBottomSheet(
                context,
                AppCommonBottomSheet(
                  sheetBGColor: AppColors.actionBtnBgColor,
                  body: ReportSuccessBottomSheet(),
                  isOpenWithGradient: false,
                ),
              );
            } else {
              AppFunctions.showToast(
                  'Please select a reason to report the post');
            }
          },
          widget: Text(
            'Report',
            style: TextStyles.semiBold(19.sp, fontColor: AppColors.blackColor),
          ),
        ),
      ]),
    );
  }
}

class ReportUserMainBottomSheet extends StatelessWidget {
  const ReportUserMainBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        SizedBox(
          height: 15.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 40.w),
            Text(
              'Report Account',
              style: TextStyles.bold(28.sp,
                  fontFamily: testTiemposHeadline,
                  fontColor: AppColors.whiteColor),
            ),
            IconButton(
                onPressed: () {
                  NavigatorRoute.navigateBack(context);
                },
                icon: Icon(
                  Icons.close_sharp,
                  color: AppColors.whiteColor,
                )),
          ],
        ),
        SizedBox(height: 25.h),
        Text(
          'Why are you reporting this account?',
          textAlign: TextAlign.center,
          style: TextStyles.semiBold(27.sp, fontColor: AppColors.whiteColor),
        ),
        SizedBox(height: 10.h),
        Text(
          "Your report is anonymous. except if you're reporting an intellectual property infringement. If someone is in immediate danger, call the emergency service - don't wait.",
          textAlign: TextAlign.center,
          style: TextStyles.regular(18.sp, fontColor: AppColors.whiteColor),
        ),
        SizedBox(height: 40.h),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'They are pretending to be someone else',
            style: TextStyles.regular(17.sp, fontColor: AppColors.whiteColor),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: AppColors.textHintGrayColor,
            size: 16,
          ),
          onTap: () {
            NavigatorRoute.navigateBack(context);
            showAppBottomSheet(
              context,
              AppCommonBottomSheet(
                sheetBGColor: AppColors.actionBtnBgColor,
                body: ReportUserSecondBottomSheet(),
                isOpenWithGradient: false,
              ),
            );
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'They may be under the age of 13',
            style: TextStyles.regular(17.sp, fontColor: AppColors.whiteColor),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: AppColors.textHintGrayColor,
            size: 16,
          ),
          onTap: () {
            context
                .read<UserProfileCubit>()
                .getReason('They may be under the age of 13');
            context.read<UserProfileCubit>().reportUser();
            NavigatorRoute.navigateBack(context);
            showAppBottomSheet(
              context,
              AppCommonBottomSheet(
                sheetBGColor: AppColors.actionBtnBgColor,
                body: ReportSuccessBottomSheet(),
                isOpenWithGradient: false,
              ),
            );
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Someone Else',
            style: TextStyles.regular(17.sp, fontColor: AppColors.whiteColor),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: AppColors.textHintGrayColor,
            size: 16,
          ),
          onTap: () {
            NavigatorRoute.navigateBack(context);
            showAppBottomSheet(
              context,
              AppCommonBottomSheet(
                sheetBGColor: AppColors.actionBtnBgColor,
                body: ReportUserOptionBottomSheet(),
                isOpenWithGradient: false,
              ),
            );
          },
        ),
        SizedBox(height: 40.h),
      ]),
    );
  }
}

class ReportUserSecondBottomSheet extends StatelessWidget {
  const ReportUserSecondBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        SizedBox(
          height: 15.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 40.w),
            Text(
              'Report Account',
              style: TextStyles.bold(28.sp,
                  fontFamily: testTiemposHeadline,
                  fontColor: AppColors.whiteColor),
            ),
            IconButton(
                onPressed: () {
                  NavigatorRoute.navigateBack(context);
                },
                icon: Icon(
                  Icons.close_sharp,
                  color: AppColors.whiteColor,
                )),
          ],
        ),
        SizedBox(height: 25.h),
        Text(
          'Why are you reporting this account?',
          textAlign: TextAlign.center,
          style: TextStyles.semiBold(27.sp, fontColor: AppColors.whiteColor),
        ),
        SizedBox(height: 10.h),
        Text(
          "Your report is anonymous. except if you're reporting an intellectual property infringement. If someone is in immediate danger, call the emergency service - don't wait.",
          textAlign: TextAlign.center,
          style: TextStyles.regular(18.sp, fontColor: AppColors.whiteColor),
        ),
        SizedBox(height: 40.h),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Who are they pretending to be?',
            textAlign: TextAlign.center,
            style: TextStyles.semiBold(22.sp, fontColor: AppColors.whiteColor),
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Me',
            style: TextStyles.regular(17.sp, fontColor: AppColors.whiteColor),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: AppColors.textHintGrayColor,
            size: 16,
          ),
          onTap: () {
            context
                .read<UserProfileCubit>()
                .getReason('Who are they pretending to be? Me');
            context.read<UserProfileCubit>().reportUser();
            NavigatorRoute.navigateBack(context);
            showAppBottomSheet(
              context,
              AppCommonBottomSheet(
                sheetBGColor: AppColors.actionBtnBgColor,
                body: ReportSuccessBottomSheet(),
                isOpenWithGradient: false,
              ),
            );
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Someone Else',
            style: TextStyles.regular(17.sp, fontColor: AppColors.whiteColor),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: AppColors.textHintGrayColor,
            size: 16,
          ),
          onTap: () {
            context
                .read<UserProfileCubit>()
                .getReason('Who are they pretending to be? Someone Else');
            context.read<UserProfileCubit>().reportUser();
            NavigatorRoute.navigateBack(context);
            showAppBottomSheet(
              context,
              AppCommonBottomSheet(
                sheetBGColor: AppColors.actionBtnBgColor,
                body: ReportSuccessBottomSheet(),
                isOpenWithGradient: false,
              ),
            );
          },
        ),
        SizedBox(height: 40.h),
      ]),
    );
  }
}

class ReportUserOptionBottomSheet extends StatefulWidget {
  const ReportUserOptionBottomSheet({super.key});

  @override
  State<ReportUserOptionBottomSheet> createState() =>
      _ReportUserOptionBottomSheetState();
}

class _ReportUserOptionBottomSheetState
    extends State<ReportUserOptionBottomSheet> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        SizedBox(
          height: 15.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 40.w),
            Text(
              'Report Account',
              style: TextStyles.bold(28.sp,
                  fontFamily: testTiemposHeadline,
                  fontColor: AppColors.whiteColor),
            ),
            IconButton(
                onPressed: () {
                  NavigatorRoute.navigateBack(context);
                },
                icon: Icon(
                  Icons.close_sharp,
                  color: AppColors.whiteColor,
                )),
          ],
        ),
        SizedBox(height: 25.h),
        Text(
          'Why are you reporting this account?',
          textAlign: TextAlign.center,
          style: TextStyles.semiBold(27.sp, fontColor: AppColors.whiteColor),
        ),
        SizedBox(height: 10.h),
        Text(
          "Your report is anonymous. except if you're reporting an intellectual property infringement. If someone is in immediate danger, call the emergency service - don't wait.",
          textAlign: TextAlign.center,
          style: TextStyles.regular(18.sp, fontColor: AppColors.whiteColor),
        ),
        SizedBox(height: 40.h),
        SizedBox(
          height: 350.h,
          child: ListView.builder(
            itemCount: userReportOptionList.length,
            itemBuilder: (context, index) {
              return CommonRadioListTile(
                title: userReportOptionList[index].title,
                onChanged: (int? value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
                value: index,
                groupValue: selectedIndex,
              );
            },
          ),
        ),
        SizedBox(height: 40.h),
        CommonButton(
          color: Colors.white,
          onPressed: () {
            if (selectedIndex != null) {
              context
                  .read<UserProfileCubit>()
                  .getReason(userReportOptionList[selectedIndex!].title);
              context.read<UserProfileCubit>().reportUser();
              NavigatorRoute.navigateBack(context);
              showAppBottomSheet(
                context,
                AppCommonBottomSheet(
                  sheetBGColor: AppColors.actionBtnBgColor,
                  body: ReportSuccessBottomSheet(),
                  isOpenWithGradient: false,
                ),
              );
            } else {
              AppFunctions.showToast(
                  'Please select a reason to report the post');
            }
          },
          widget: Text(
            'Report',
            style: TextStyles.semiBold(19.sp, fontColor: AppColors.blackColor),
          ),
        ),
      ]),
    );
  }
}

class ReportSuccessBottomSheet extends StatelessWidget {
  const ReportSuccessBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 15.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 40.w),
              Text(
                'Report ',
                style: TextStyles.bold(28.sp,
                    fontFamily: testTiemposHeadline,
                    fontColor: AppColors.whiteColor),
              ),
              IconButton(
                  onPressed: () {
                    NavigatorRoute.navigateBack(context);
                  },
                  icon: Icon(
                    Icons.close_sharp,
                    color: AppColors.whiteColor,
                  )),
            ],
          ),
          SizedBox(height: 25.h),
          Assets.icons.icReportSubmited.svg(),
          Text(
            'Thanks for helping our community',
            textAlign: TextAlign.center,
            style: TextStyles.semiBold(27.sp, fontColor: AppColors.whiteColor),
          ),
          SizedBox(height: 10.h),
          Text(
            'Your report helps us protect the community from harmful content',
            style: TextStyles.regular(18.sp, fontColor: AppColors.whiteColor),
          ),
          SizedBox(height: 20.h),
          Text(
            'If you think someone is in immediate danger, please contact local law enforcement.',
            style: TextStyles.regular(18.sp, fontColor: AppColors.whiteColor),
          ),
          SizedBox(height: 33.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'What you can expect',
              style:
                  TextStyles.semiBold(27.sp, fontColor: AppColors.whiteColor),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(
                Icons.block_flipped,
                color: AppColors.whiteColor,
              ),
              spaceW(10.w),
              Expanded(
                child: Text(
                  'if this commenter has serious or repeated violations, we may temporarily restrict their ability to leave comments.',
                  style: TextStyles.regular(18.sp,
                      fontColor: AppColors.whiteColor),
                ),
              )
            ],
          ),
          SizedBox(height: 60.h),
          CommonButton(
            color: Colors.white,
            onPressed: () {
              NavigatorRoute.navigateBack(context);
            },
            widget: Text(
              'OK',
              style:
                  TextStyles.semiBold(19.sp, fontColor: AppColors.blackColor),
            ),
          ),
        ],
      ),
    );
  }
}

class VideoPickerBottomSheet extends StatelessWidget {
  final Function(File) onVideoSelected;

  const VideoPickerBottomSheet({
    super.key,
    required this.onVideoSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 15.sp, top: 20.h),
          child: Text(
            'Choose Video!',
            style: TextStyles.semiBold(25.sp, fontColor: AppColors.whiteColor),
          ),
        ),
        spaceH(40.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () async {
                      NavigatorRoute.navigateBack(context);
                      // final status = await Permission.videos.request();
                      // if (status.isGranted) {
                      final XFile? video = await ImagePicker().pickVideo(
                        source: ImageSource.gallery,
                        maxDuration: const Duration(minutes: 5),
                      );
                      if (video != null) {
                        int sizeInBytes = await video.length();
                        double sizeInMB = sizeInBytes / (1024 * 1024);
                        if (sizeInMB > 50) {
                          AppFunctions.showToast(
                              'Size should not exceed 50MB. Please try again.');
                        } else {
                          onVideoSelected(File(video.path));
                        }
                      }
                      // }
                    },
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primaryColor,
                      child: Icon(
                        Icons.add_photo_alternate,
                        color: AppColors.textWhiteColor,
                      ),
                    ),
                  ),
                  spaceH(10.h),
                  Text(
                    'From Gallery',
                    style: TextStyles.semiBold(16.sp),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () async {
                      NavigatorRoute.navigateBack(context);
                      final status = await Permission.camera.request();
                      if (status.isGranted) {
                        final XFile? video = await ImagePicker().pickVideo(
                          source: ImageSource.camera,
                          maxDuration: const Duration(minutes: 5),
                        );
                        if (video != null) {
                          onVideoSelected(File(video.path));
                        }
                      }
                    },
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primaryColor,
                      child: Icon(
                        Icons.add_a_photo,
                        color: AppColors.textWhiteColor,
                      ),
                    ),
                  ),
                  spaceH(10.h),
                  Text(
                    'From Camera',
                    style: TextStyles.semiBold(16.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
