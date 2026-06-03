import 'dart:developer';

import 'package:eagle_eye/core/constant/app_strings.dart';
import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/theme/text_styles.dart';
import 'package:eagle_eye/core/utils/app_prefrence.dart';
import 'package:eagle_eye/core/widget/app_network_image_loader.dart';
import 'package:eagle_eye/core/widget/common_app_bar.dart';
import 'package:eagle_eye/core/widget/common_textfield.dart';
import 'package:eagle_eye/data/models/other_user_profile_model.dart';
import 'package:eagle_eye/presentation/main/user_profile_screen/bloc/user_profile_cubit.dart';
import 'package:eagle_eye/routes/app_navigation.dart';
import 'package:eagle_eye/routes/app_routes.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
import 'package:eagle_eye/services/socket_service/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:lottie/lottie.dart';

import '../../../data/models/single_user_chat_list_model.dart';
import '../../../gen/assets.gen.dart';

class ChatDetailsScreen extends StatefulWidget {
  final OtherUserProfileData toUserData;
  final bool isRequestPage;
  final String? requestId;

  const ChatDetailsScreen({
    super.key,
    required this.toUserData,
    required this.isRequestPage,
    this.requestId,
  });

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  final TextEditingController sendMessageController = TextEditingController();
  bool isUserRequest = false;

  fetchSingleUserChat() async {
    SocketService.fetchSingleChat(toUserId: widget.toUserData.id ?? '');
    setState(() {
      isUserRequest = widget.isRequestPage;
    });
  }

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    fetchSingleUserChat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        title: GestureDetector(
          onTap: () {
            FirebaseEvents.setFirebaseEvent(
                'click_view_profile_chat_details', {});
            if (widget.toUserData.id != null) {
              context.read<UserProfileCubit>().getUserId(
                    widget.toUserData.id ?? '',
                  );
              context.read<UserProfileCubit>().getUserInfo();
              NavigatorRoute.navigateTo(context, AppRoutes.userProfile);
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppNetworkImageLoader(
                boxFit: BoxFit.cover,
                height: 50.h,
                width: 45.w,
                borderRadius: 50.r,
                url: widget.toUserData.profilePicture ?? "",
              ),
              Gap(20.w),
              SizedBox(
                width: 180.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.toUserData.name ?? 'Aawaz',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.medium(
                        18.sp,
                        fontColor: AppColors.whiteColor.withValues(alpha: 0.9),
                      ),
                    ),
                    Gap(1.h),
                    Text(
                      '@${widget.toUserData.username ?? 'username'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.light(
                        16.sp,
                        fontColor: Colors.grey,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        titleSize: 50.h,
        centerTitle: false,
        action: [],
      ),
      bottomNavigationBar: isUserRequest
          ? ValueListenableBuilder(
              valueListenable: SocketService.isUserRequested,
              builder: (context, isUserRequested, _) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Divider(
                      color: AppColors.actionBtnBgColor,
                    ),
                    Gap(10.h),
                    Text(
                      "Accept message request from ${widget.toUserData.name ?? ''} (${widget.toUserData.username ?? ''})?",
                      style: TextStyles.regular(
                        18.sp,
                        fontColor: AppColors.whiteColor,
                      ),
                      textAlign: TextAlign.center,
                    ).paddingSymmetric(horizontal: 50.w),
                    Gap(4.h),
                    Text(
                      "If you accept, they will also be able to see info such as your activity status and when you've read messages.",
                      style: TextStyles.light(
                        16.sp,
                        fontColor: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ).paddingSymmetric(horizontal: 20.w),
                    Gap(10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            SocketService.handleRequestStatus(
                              userId: widget.toUserData.id ?? '',
                              requestId: widget.requestId ?? '',
                              status: 'accept',
                            );
                            setState(() {
                              isUserRequest = isUserRequested;
                            });
                          },
                          borderRadius: BorderRadius.circular(10.r),
                          child: Container(
                            margin: EdgeInsets.all(15.r),
                            height: 50.h,
                            width: 160.w,
                            decoration: BoxDecoration(
                              color:
                                  AppColors.greenColor.withValues(alpha: 0.3),
                              border: Border.all(
                                color:
                                    AppColors.greenColor.withValues(alpha: 0.3),
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Accept',
                              style: TextStyles.regular(
                                18.sp,
                                fontColor: AppColors.greenColor,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            SocketService.handleRequestStatus(
                              userId: widget.toUserData.id ?? '',
                              requestId: widget.requestId ?? '',
                              status: 'reject',
                            );
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(10.r),
                          child: Container(
                            margin: EdgeInsets.all(15.r),
                            height: 50.h,
                            width: 160.w,
                            decoration: BoxDecoration(
                              color: AppColors.redColor.withValues(alpha: 0.3),
                              border: Border.all(
                                color:
                                    AppColors.redColor.withValues(alpha: 0.3),
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Decline',
                              style: TextStyles.regular(
                                18.sp,
                                fontColor: AppColors.redColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              })
          : Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: CommonTextField(
                  height: 50.h,
                  textStyle: TextStyles.regular(18.sp),
                  fillColor: AppColors.actionBtnBgColor,
                  hintText: 'Message...',
                  cursorColor: AppColors.whiteColor,
                  controller: sendMessageController,
                  onChanged: (p0) {
                    SocketService.startTypingEvent(
                      toUserId: widget.toUserData.id ?? '',
                    );
                    if (p0.isEmpty) {
                      SocketService.stopTypingEvent(
                        toUserId: widget.toUserData.id ?? '',
                      );
                    }
                    Future.delayed(Duration(seconds: 4), () {
                      SocketService.stopTypingEvent(
                        toUserId: widget.toUserData.id ?? '',
                      );
                    });
                    setState(() {});
                  },
                  onSubmitted: (p0) {
                    SocketService.stopTypingEvent(
                      toUserId: widget.toUserData.id ?? '',
                    );
                  },
                  suffixIcon: GestureDetector(
                    onTap: () {
                      if (sendMessageController.text.trim().isNotEmpty) {
                        SocketService.sendMessage(
                            fromUserId:
                                PrefService.getString(PrefService.userId),
                            toUserId: widget.toUserData.id ?? '',
                            message: sendMessageController.text);
                        SocketService.stopTypingEvent(
                          toUserId: widget.toUserData.id ?? '',
                        );
                        try {
                          final currentModel =
                              SocketService.singleUserChatNotifier.value;

                          final newMessage = ChatMessage(
                            sender: Receiver(
                              senderId:
                                  PrefService.getString(PrefService.userId),
                            ),
                            receiver: Receiver(
                              receiverId: widget.toUserData.id ?? '',
                            ),
                            message: sendMessageController.text,
                            createdAt: DateTime.now(),
                          );

                          final updatedMessage = <ChatMessage>[
                            ...(currentModel.messages ?? <ChatMessage>[]),
                            newMessage,
                          ];

                          final updatedModel = SingleUserChatListModel(
                            chatId: currentModel.chatId,
                            messages: updatedMessage,
                            requestTab: currentModel.requestTab,
                            requestStatus: currentModel.requestStatus,
                            createdAt: currentModel.createdAt,
                            updatedAt: DateTime.now(),
                          );

                          SocketService.singleUserChatNotifier.value =
                              updatedModel;
                        } catch (e) {
                          log('❌ Error adding sent message to local chat list: $e');
                        }

                        sendMessageController.clear();
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8.h),
                      padding: EdgeInsets.only(
                          top: 12.h, right: 5.w, left: 5.w, bottom: 8.h),
                      height: 35.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                          color: sendMessageController.text.trim().isEmpty
                              ? AppColors.buttonDisabledColor
                              : AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(20.r)),
                      child: Assets.icons.icMessanger.svg(),
                    ),
                  ),
                ),
              ),
            ),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  instagramChatHeader(),
                  ValueListenableBuilder(
                    valueListenable: SocketService.singleUserChatNotifier,
                    builder: (context, singleChat, _) {
                      final messages = singleChat.messages ?? [];

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (scrollController.hasClients) {
                          scrollController.jumpTo(
                              scrollController.position.maxScrollExtent);
                        }
                      });

                      // if (messages.isEmpty) {
                      //   return const Center(child: Text("No messages yet."));
                      // }
                      return ListView.builder(
                        reverse: false,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(10),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return Builder(
                            builder: (context) {
                              if (message.sender?.senderId ==
                                  PrefService.getString(PrefService.userId)) {
                                return Align(
                                  alignment: message.sender?.senderId ==
                                          PrefService.getString(
                                              PrefService.userId)
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 10),
                                    margin: EdgeInsets.symmetric(vertical: 5.h),
                                    decoration: BoxDecoration(
                                      color: message.sender?.senderId ==
                                              PrefService.getString(
                                                  PrefService.userId)
                                          ? Colors.blueAccent
                                          : AppColors.tabbarIndicatorColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      message.message ?? '',
                                      style: TextStyles.medium(18.sp),
                                    ),
                                  ),
                                );
                              } else if (message.sender?.senderId ==
                                  widget.toUserData.id) {
                                return Align(
                                  alignment: message.sender?.senderId ==
                                          PrefService.getString(
                                              PrefService.userId)
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 10),
                                    margin: EdgeInsets.symmetric(vertical: 5.h),
                                    decoration: BoxDecoration(
                                      color: message.sender?.senderId ==
                                              PrefService.getString(
                                                  PrefService.userId)
                                          ? Colors.blueAccent
                                          : AppColors.tabbarIndicatorColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      message.message ?? '',
                                      style: TextStyles.medium(18.sp),
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: SocketService.typingUserNotifier,
                    builder: (context, typingUser, child) {
                      if (typingUser != null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Future.delayed(Duration(microseconds: 500), () {
                            if (scrollController.hasClients) {
                              scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            }
                          });
                        });
                      }
                      if (typingUser == null) {
                        return SizedBox.shrink();
                      } else if (typingUser.userId == widget.toUserData.id) {
                        return Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 5.h),
                            height: 45.h,
                            width: 80.w,
                            decoration: BoxDecoration(
                              color: AppColors.tabbarIndicatorColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Transform.scale(
                              scale: 2.2,
                              child: Lottie.asset(
                                AppStrings.typingAnimationJson,
                                repeat: true,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget instagramChatHeader() {
    return Container(
      padding: EdgeInsets.only(right: 20.w, left: 20.w, bottom: 120.h),
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Gap(20.h),
          AppNetworkImageLoader(
            boxFit: BoxFit.cover,
            height: 120.h,
            width: 115.w,
            borderRadius: 100.r,
            url: widget.toUserData.profilePicture ?? '',
          ),
          Gap(20.h),
          Container(
            alignment: Alignment.center,
            width: 180.w,
            child: Text(widget.toUserData.name ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyles.bold(18.sp)),
          ),
          Gap(5.h),
          Container(
            alignment: Alignment.center,
            width: 180.w,
            child: Text("@${widget.toUserData.username ?? 'username'}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.regular(16.sp, fontColor: Colors.grey)),
          ),
          Gap(10.h),
          OutlinedButton(
            onPressed: () {
              FirebaseEvents.setFirebaseEvent(
                  'click_view_profile_chat_details', {});
              if (widget.toUserData.id != null) {
                context.read<UserProfileCubit>().getUserId(
                      widget.toUserData.id ?? '',
                    );
                context.read<UserProfileCubit>().getUserInfo();
                NavigatorRoute.navigateTo(context, AppRoutes.userProfile);
              }
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: AppColors.popUpTextFieldBlackColor,
              side: BorderSide.none,
              shape: BeveledRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.circular(5.r)),
              fixedSize: Size(130.w, 40.h),
              minimumSize: Size(130.w, 40.h),
              padding: EdgeInsets.symmetric(horizontal: 15.w),
            ),
            child: Text(
              "View profile",
              style: TextStyles.semiBold(18.sp),
            ),
          ),
        ],
      ),
    );
  }
}
