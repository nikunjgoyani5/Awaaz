import 'package:eagle_eye/core/widget/common_textfield.dart';
import 'package:eagle_eye/presentation/main/blocked_users/bloc/blocked_users_cubit.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/constant/app_constant.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widget/common_app_bar.dart';
import '../../../gen/assets.gen.dart';
import '../add_friend_screen/friend_tile_widget.dart';

class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({super.key});

  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  @override
  initState() {
    FirebaseEvents.setFirebaseEvent('blocked_user_screen', {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return BlocBuilder<BlockedUsersCubit, BlockedUsersState>(
        builder: (context, state) {
      return Scaffold(
          appBar: HomeAppBar(
            title: Text(
              "Blocked Users",
              style:
                  TextStyles.semiBold(30.sp, fontFamily: testTiemposHeadline),
            ),
            centerTitle: true,
            titleSize: 26.sp,
            action: [
              (state.blockedUserList.isNotEmpty)
                  ? Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: CircleAvatar(
                        radius: 25.r,
                        backgroundColor: AppColors.actionBtnBgColor,
                        child: IconButton(
                          onPressed: () {
                            context.read<BlockedUsersCubit>().toggleSearch();
                          },
                          icon: Assets.icons.icSearchHome.svg(),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              state.isSearch
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CommonTextField(
                        prefixIcon: Assets.icons.icSearchHome.svg(),
                        fillColor: AppColors.actionBtnBgColor,
                        cursorColor: AppColors.whiteColor,
                        suffixIcon: (searchController.text.isEmpty)
                            ? null
                            : IconButton(
                                onPressed: () {
                                  searchController.clear();
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: AppColors.whiteColor,
                                )),
                        onChanged: (value) {
                          context
                              .read<BlockedUsersCubit>()
                              .searchBlockedUsers(value);
                        },
                        hintText: "Search User",
                        textColor: AppColors.whiteColor,
                        hintColor: AppColors.textHintGrayColor,
                        controller: searchController,
                      ),
                    )
                  : SizedBox.shrink(),
              state.isLoading
                  ? Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    )
                  : state.blockedUserList.isNotEmpty
                      ? Expanded(
                          child: (searchController.text.isNotEmpty &&
                                  state.filteredBlockedUserList.isEmpty)
                              ? Center(
                                  child: Text(
                                      'No users found matching your search.'),
                                )
                              : ListView.separated(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  itemBuilder: (context, index) =>
                                      BlockedUserTileWidget(
                                    blockedUserData: (searchController
                                            .text.isNotEmpty)
                                        ? state.filteredBlockedUserList[index]
                                        : state.blockedUserList[index],
                                  ),
                                  separatorBuilder: (context, index) =>
                                      Gap(10.h),
                                  itemCount: (searchController.text.isNotEmpty)
                                      ? state.filteredBlockedUserList.length
                                      : state.blockedUserList.length,
                                ),
                        )
                      : Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 0.h),
                            child: Center(
                              child: Text('No blocked users found.'),
                            ),
                          ),
                        ),
            ],
          ));
    });
  }
}
