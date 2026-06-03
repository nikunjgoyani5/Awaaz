import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/theme/text_styles.dart';
import 'package:eagle_eye/core/widget/app_network_image_loader.dart';
import 'package:eagle_eye/core/widget/common_app_bar.dart';
import 'package:eagle_eye/data/models/other_user_profile_model.dart';
import 'package:eagle_eye/data/models/user_chat_list_model.dart';
import 'package:eagle_eye/presentation/main/chat_screen/chat_details_screen.dart';
import 'package:eagle_eye/services/socket_service/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:timeago/timeago.dart' as timeago;

class RequestChatListScreen extends StatefulWidget {
  const RequestChatListScreen({super.key});

  @override
  State<RequestChatListScreen> createState() => _RequestChatListScreenState();
}

class _RequestChatListScreenState extends State<RequestChatListScreen> {
  fetchUserChat() async {
    SocketService.fetchUserChats(requestType: 'request');
  }

  @override
  void initState() {
    fetchUserChat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppCommonAppBar(
        title: 'Message requests',
        centerTitle: true,
        action: [],
      ),
      // bottomNavigationBar: !isChatEmpty
      //     ? Container(
      //         margin: EdgeInsets.all(15.r),
      //         height: 50.h,
      //         decoration: BoxDecoration(
      //           color: AppColors.redColor.withValues(alpha: 0.3),
      //           border: Border.all(
      //             color: AppColors.redColor.withValues(alpha: 0.3),
      //           ),
      //           borderRadius: BorderRadius.circular(10.r),
      //         ),
      //         alignment: Alignment.center,
      //         child: Text(
      //           'Delete All',
      //           style: TextStyles.regular(
      //             18.sp,
      //             fontColor: AppColors.redColor,
      //           ),
      //         ),
      //       )
      //     : SizedBox.shrink(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            Gap(20.h),
            ValueListenableBuilder<List<UserChatListModel>>(
                valueListenable: SocketService.userRequestListNotifier,
                builder: (context, chatList, child) {
                  if (chatList.isEmpty) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/ic_no_message.svg'),
                          Gap(10.h),
                          Text(
                            "No message requests",
                            style: TextStyles.bold(
                              26.sp,
                              fontColor: AppColors.whiteColor,
                            ),
                          ),
                          Gap(5.h),
                          Text(
                            "You don't have any message requests.",
                            style: TextStyles.regular(
                              17.sp,
                              fontColor: AppColors.whiteColor,
                            ),
                            textAlign: TextAlign.center,
                          ).paddingSymmetric(horizontal: 80.w),
                        ],
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        Text(
                          'Open a chat to get more info about who\'s messaging you. They won\'t know that you\'ve seen it until you accept.',
                          style: TextStyles.light(
                            18.sp,
                            fontColor: AppColors.whiteColor,
                          ),
                          textAlign: TextAlign.center,
                        ).paddingSymmetric(horizontal: 40.w),
                        Gap(20.h),
                        Divider(
                          color: AppColors.actionBtnBgColor,
                        ),
                        Gap(5.h),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: chatList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: AppNetworkImageLoader(
                                boxFit: BoxFit.cover,
                                height: 55.h,
                                width: 50.w,
                                borderRadius: 50.r,
                                url: chatList[index].fromUser?.profilePicture ??
                                    '',
                              ),
                              title: Text(
                                chatList[index].fromUser?.name ?? "",
                                style: TextStyles.medium(
                                  18.sp,
                                  fontColor: AppColors.whiteColor,
                                ),
                              ),
                              subtitle: Text(
                                chatList[index].messages?.last.message ?? "",
                                style: TextStyles.light(
                                  14.sp,
                                  fontColor: AppColors.whiteColor,
                                ),
                              ),
                              trailing: Text(
                                  timeago.format(chatList[index]
                                          .messages
                                          ?.last
                                          .createdAt ??
                                      DateTime.now()),
                                  style: TextStyle(fontSize: 12)),
                              onTap: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatDetailsScreen(
                                        toUserData: OtherUserProfileData(
                                          id: chatList[index]
                                              .fromUser
                                              ?.fromUserId,
                                          name: chatList[index].fromUser?.name,
                                          username: chatList[index]
                                              .fromUser
                                              ?.username,
                                          profilePicture: chatList[index]
                                              .fromUser
                                              ?.profilePicture,
                                        ),
                                        isRequestPage: true,
                                        requestId: chatList[index].id,
                                      ),
                                    ));
                                fetchUserChat();
                              },
                            );
                          },
                        ),
                      ],
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
