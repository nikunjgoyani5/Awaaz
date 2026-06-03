import 'dart:developer';

import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/theme/text_styles.dart';
import 'package:eagle_eye/core/utils/app_functions.dart';
import 'package:eagle_eye/core/utils/app_prefrence.dart';
import 'package:eagle_eye/core/widget/app_network_image_loader.dart';
import 'package:eagle_eye/core/widget/common_app_bar.dart';
import 'package:eagle_eye/core/widget/common_text_button.dart';
import 'package:eagle_eye/core/widget/common_textfield.dart';
import 'package:eagle_eye/data/models/other_user_profile_model.dart';
import 'package:eagle_eye/data/models/user_chat_list_model.dart';
import 'package:eagle_eye/presentation/main/chat_screen/chat_details_screen.dart';
import 'package:eagle_eye/presentation/main/chat_screen/request_chat_list_screen.dart';
import 'package:eagle_eye/services/socket_service/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../services/firebase_analytics_service.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final TextEditingController searchMessageController = TextEditingController();
  final List<Map<String, String>> chats = [
    {
      "name": "John Doe",
      "message": "Hey! What's up?",
      "time": "2m ago",
      "imageUrl": "https://reqres.in/img/faces/1-image.jpg"
    },
    {
      "name": "Jane Smith",
      "message": "Let's catch up tomorrow!",
      "time": "10m ago",
      "imageUrl": "https://reqres.in/img/faces/2-image.jpg"
    },
    {
      "name": "Alex Johnson",
      "message": "Sent you a photo",
      "time": "1h ago",
      "imageUrl": "https://reqres.in/img/faces/3-image.jpg"
    },
  ];

  @override
  void initState() {
    FirebaseEvents.setFirebaseEvent('chat_list_screen', {});
    log(PrefService.getString(PrefService.userId));
    fetchUserChat();
    super.initState();
  }

  fetchUserChat() async {
    SocketService.fetchUserChats(requestType: 'chat');
  }

  final ValueNotifier<String> searchQuery = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppCommonAppBar(
        title: '@${PrefService.getString(PrefService.userName)}',
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            Gap(20.h),
            CommonTextField(
              hintText: 'Search',
              controller: searchMessageController,
              onChanged: (value) {
                searchQuery.value = value.trim().toLowerCase();
                setState(() {});
              },
              prefixIcon: Icon(Icons.search),
              suffixIcon: searchMessageController.text.trim().isEmpty
                  ? null
                  : GestureDetector(
                      onTap: () {
                        searchMessageController.clear();
                        searchQuery.value = '';
                        closeKeyboard();
                        setState(() {});
                      },
                      child: Icon(
                        Icons.close,
                        color: AppColors.blackColor,
                        size: 22.sp,
                      ),
                    ),
              contentPadding: EdgeInsets.only(left: 20.w, bottom: 0.w),
              hintTextStyle: TextStyles.regular(
                18.sp,
                fontColor: AppColors.textHintGrayColor,
              ),
            ),
            Gap(20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Messages',
                  style: TextStyles.bold(
                    20.sp,
                    fontColor: AppColors.whiteColor,
                  ),
                ),
                CommonTextButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestChatListScreen(),
                      ),
                    );
                    fetchUserChat();
                  },
                  widget: Text(
                    'Requests',
                    style: TextStyles.medium(
                      20.sp,
                      fontColor: Colors.blueAccent,
                    ),
                  ),
                )
              ],
            ),
            Gap(20.h),
            ValueListenableBuilder<String>(
              valueListenable: searchQuery,
              builder: (context, query, _) {
                return ValueListenableBuilder<List<UserChatListModel>>(
                  valueListenable: SocketService.userChatListNotifier,
                  builder: (context, chatList, _) {
                    // Filter logic
                    final filteredList = query.isEmpty
                        ? chatList
                        : chatList.where((chat) {
                            final name = chat.toUser?.name?.toLowerCase() ?? '';
                            final username =
                                chat.toUser?.username?.toLowerCase() ?? '';
                            return name.contains(query) ||
                                username.contains(query);
                          }).toList();

                    if (filteredList.isEmpty) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.60,
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
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final chat = filteredList[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: AppNetworkImageLoader(
                            boxFit: BoxFit.cover,
                            height: 55.h,
                            width: 50.w,
                            borderRadius: 50.r,
                            url: chat.toUser?.profilePicture ?? '',
                          ),
                          title: Text(
                            chat.toUser?.name ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyles.semiBold(
                              18.sp,
                              fontColor: AppColors.whiteColor,
                            ),
                          ),
                          subtitle: Text(
                            chat.messages?.last.message ?? "",
                            style: chat.messages?.last.read == false
                                ? TextStyles.medium(14.sp,
                                    fontColor: AppColors.whiteColor)
                                : TextStyles.light(14.sp,
                                    fontColor: AppColors.whiteColor),
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (chat.messages?.last.read == false &&
                                  chat.messages?.last.sender?.senderId !=
                                      PrefService.getString(PrefService.userId))
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10.h),
                                  child: CircleAvatar(
                                    radius: 5.r,
                                    backgroundColor: AppColors.primaryColor,
                                  ),
                                ),
                              Text(
                                timeago.format(chat.messages?.last.createdAt ??
                                    DateTime.now()),
                                style: TextStyles.light(14.sp),
                              ),
                            ],
                          ),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatDetailsScreen(
                                  toUserData: OtherUserProfileData(
                                    id: chat.toUser?.toUserId,
                                    name: chat.toUser?.name,
                                    username: chat.toUser?.username,
                                    profilePicture: chat.toUser?.profilePicture,

                                  ),
                                  isRequestPage: false,
                                ),
                              ),
                            );
                            fetchUserChat();
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
