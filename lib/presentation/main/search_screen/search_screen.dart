import 'dart:async';

import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/theme/text_styles.dart';
import 'package:eagle_eye/core/utils/app_functions.dart';
import 'package:eagle_eye/core/widget/common_textfield.dart';
import 'package:eagle_eye/data/models/response_model.dart';
import 'package:eagle_eye/data/models/search_user_model.dart';
import 'package:eagle_eye/data/repositories/main_repo.dart';
import 'package:eagle_eye/gen/assets.gen.dart';
import 'package:eagle_eye/presentation/main/map_screen/bloc/map_screen_cubit.dart';
import 'package:eagle_eye/presentation/main/search_screen/bloc/search_screen_bloc_cubit.dart';
import 'package:eagle_eye/presentation/main/user_profile_screen/bloc/user_profile_cubit.dart';
import 'package:eagle_eye/routes/app_navigation.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/widget/app_network_image_loader.dart';
import '../../../routes/app_routes.dart';
import '../news_details_screen/bloc/news_details_screen_bloc_cubit.dart';
// import 'package:speech_to_text/speech_to_text.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();

  // final SpeechToText speech = SpeechToText();
  Timer? _debounce;
  int currentIndex = 0;
  late TabController tabController;
  List<SearchUserData> searchUserDataList = [];
  bool isLoadingUser = false;

  Future<void> searchUserByUsername(
      {required BuildContext context, required String searchQuery}) async {
    setState(() {
      isLoadingUser = true;
    });
    try {
      ResponseModel response =
          await MainRepository.getUsersByUsername(searchValue: searchQuery);
      if (response.status == true) {
        FetchSearchUserList fetchSearchUserList =
            FetchSearchUserList.fromJson(response.toJson());
        searchUserDataList = fetchSearchUserList.body ?? [];
        isLoadingUser = false;
        setState(() {});
      } else {
        setState(() {
          isLoadingUser = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingUser = false;
      });
      debugPrint('Cache Error ${e.toString()}');
    }
  }

  @override
  void initState() {
    FirebaseEvents.setFirebaseEvent('search_screen', {});
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // bool isOpenKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return GestureDetector(
      onTap: closeKeyboard,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.blackColor,
          title: Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: BlocBuilder<SearchScreenBlocCubit, SearchScreenBlocState>(
              builder: (context, state) {
                return CommonTextField(
                  prefixIcon: IconButton(
                      onPressed: () {
                        NavigatorRoute.navigateBack(context);
                        searchUserDataList.clear();
                        setState(() {});
                        context.read<SearchScreenBlocCubit>().clearSearchList();
                      },
                      icon: Assets.icons.icBackArrow.svg(height: 30)),
                  fillColor: AppColors.actionBtnBgColor,
                  cursorColor: AppColors.whiteColor,
                  suffixIcon: (searchController.text.isEmpty)
                      ? null
                      : IconButton(
                          onPressed: () {
                            searchController.clear();
                            searchUserDataList.clear();
                            setState(() {});
                            context
                                .read<SearchScreenBlocCubit>()
                                .clearSearchList();
                          },
                          icon: Icon(
                            Icons.close,
                            color: AppColors.whiteColor,
                          )),
                  onChanged: (value) {
                    // Cancel any existing timer to prevent multiple API calls
                    if (_debounce?.isActive ?? false) _debounce?.cancel();
                    // Set a new timer to call API after 500ms
                    _debounce =
                        Timer(const Duration(milliseconds: 500), () async {
                      // Call API after the user stops typing for 500ms
                      if (value.isNotEmpty) {
                        if (currentIndex == 1) {
                          context.read<SearchScreenBlocCubit>().searchEventPost(
                              context: context, searchQuery: value);
                        } else if (currentIndex == 0) {
                          context
                              .read<SearchScreenBlocCubit>()
                              .searchAddress(value);
                        } else if (currentIndex == 2) {
                          if (value.trim().isEmpty) {
                            searchUserDataList.clear();
                            setState(() {});
                          } else {
                            await searchUserByUsername(
                                context: context, searchQuery: value);
                          }
                        }
                      } else {
                        searchUserDataList.clear();
                        setState(() {});
                        context.read<SearchScreenBlocCubit>().clearSearchList();
                      }
                    });
                  },
                  hintText: currentIndex == 0
                      ? "Search location"
                      : currentIndex == 1
                          ? "Search post with hashtag"
                          : currentIndex == 2
                              ? "Search user with username"
                              : '',
                  textColor: AppColors.whiteColor,
                  hintColor: AppColors.textHintGrayColor,
                  controller: searchController,
                );
              },
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.symmetric(
                      horizontal: BorderSide(
                    color: AppColors.actionBtnBgColor,
                  )),
                ),
                child: TabBar(
                    controller: tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    labelColor: AppColors.whiteColor,
                    unselectedLabelColor: AppColors.textHintGrayColor,
                    dividerColor: Colors.transparent,
                    indicatorColor: Colors.black,
                    labelPadding: EdgeInsets.symmetric(vertical: 1),
                    onTap: (value) {
                      setState(() {
                        currentIndex = value;
                        searchUserDataList.clear();
                        searchController.clear();
                        setState(() {});
                        if (currentIndex == 0) {
                          FirebaseEvents.setFirebaseEvent('search_location_tab_click', {});
                          context.read<SearchScreenBlocCubit>().changeIsPostValue(false);
                        } else if (currentIndex == 1) {
                          FirebaseEvents.setFirebaseEvent('search_posts_tab_click', {});
                          context
                              .read<SearchScreenBlocCubit>()
                              .changeIsPostValue(true);
                        }else{
                          FirebaseEvents.setFirebaseEvent('search_user_tab_click', {});
                        }
                      });
                    },
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Assets.icons.icLocation.svg(
                                colorFilter: ColorFilter.mode(
                              currentIndex == 0
                                  ? AppColors.whiteColor
                                  : AppColors.textHintGrayColor,
                              BlendMode.srcIn,
                            )),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              'Location',
                              style: TextStyles.regular(20.sp,
                                  fontColor: currentIndex == 0
                                      ? AppColors.whiteColor
                                      : AppColors.textHintGrayColor),
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Assets.icons.icAllBroadcasts.svg(
                                colorFilter: ColorFilter.mode(
                              currentIndex == 1
                                  ? AppColors.whiteColor
                                  : AppColors.textHintGrayColor,
                              BlendMode.srcIn,
                            )),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              'Post',
                              style: TextStyles.regular(20.sp,
                                  fontColor: currentIndex == 1
                                      ? AppColors.whiteColor
                                      : AppColors.textHintGrayColor),
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person,
                              color: currentIndex == 2
                                  ? AppColors.whiteColor
                                  : AppColors.textHintGrayColor,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              'User',
                              style: TextStyles.regular(20.sp,
                                  fontColor: currentIndex == 2
                                      ? AppColors.whiteColor
                                      : AppColors.textHintGrayColor),
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
              Gap(
                10.h,
              ),
              BlocBuilder<SearchScreenBlocCubit, SearchScreenBlocState>(
                buildWhen: (previous, current) =>
                    previous.isSearchLoading != current.isSearchLoading,
                builder: (context, state) {
                  return Visibility(
                      visible: state.isSearchLoading,
                      child: LinearProgressIndicator(
                        color: AppColors.whiteColor,
                      ));
                },
              ),
              Gap(15.h),
              Expanded(
                child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: tabController,
                    children: [
                      // Location
                      Visibility(
                        visible: currentIndex == 0,
                        child: BlocBuilder<SearchScreenBlocCubit,
                            SearchScreenBlocState>(
                          buildWhen: (previous, current) =>
                              previous.searchAddressList !=
                              current.searchAddressList,
                          builder: (context, state) {
                            return Visibility(
                              visible:
                                  state.searchAddressList?.isNotEmpty ?? false,
                              replacement: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 50),
                                  child: Text('Have you searched anything ?'),
                                ),
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.searchAddressList?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          FirebaseEvents.setFirebaseEvent(
                                              'click_search_location', {});
                                          searchController.text = state
                                                  .searchAddressList?[index]
                                                  .formattedAddress ??
                                              '';
                                          context
                                              .read<MapScreenCubit>()
                                              .navigateToPlaceView(
                                                  lat: state
                                                          .searchAddressList?[
                                                              index]
                                                          .latitude ??
                                                      0.0,
                                                  long: state
                                                          .searchAddressList?[
                                                              index]
                                                          .longitude ??
                                                      0.0,
                                                  zoom: 14);
                                          NavigatorRoute.navigateBack(context);
                                        },
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Text(
                                            //   state.searchAddressList?[index]
                                            //       .state ??
                                            //       '',
                                            //   style: TextStyles.regular(18.sp,
                                            //       fontColor: AppColors.whiteColor),
                                            // ),
                                            // Text(
                                            //   state.searchAddressList?[index]
                                            //       .street ??
                                            //       '',
                                            //   style: TextStyles.regular(18.sp,
                                            //       fontColor: AppColors.whiteColor),
                                            // ),
                                            // Text(
                                            //   state.searchAddressList?[index]
                                            //       .addressLabel ??
                                            //       '',
                                            //   style: TextStyles.regular(18.sp,
                                            //       fontColor: AppColors.whiteColor),
                                            // ),
                                            Text(
                                              state.searchAddressList?[index]
                                                      .placeLabel ??
                                                  ' ',
                                              style: TextStyles.regular(18.sp,
                                                  fontColor:
                                                      AppColors.whiteColor),
                                            ),
                                            Text(
                                              state.searchAddressList?[index]
                                                      .formattedAddress ??
                                                  '',
                                              style: TextStyles.regular(18.sp,
                                                  fontColor:
                                                      AppColors.whiteColor),
                                            ),
                                            Text(
                                              "${state.searchAddressList?[index].city ?? ''} ${state.searchAddressList?[index].stateCode ?? ''}",
                                              style: TextStyles.regular(16.sp,
                                                  fontColor: AppColors
                                                      .textHintGrayColor),
                                            ),
                                          ],
                                        ),
                                        leading:
                                            Icon(Icons.share_location_outlined),
                                      ),
                                      Divider(
                                        color: AppColors.textHintGrayColor
                                            .withValues(alpha: 0.3),
                                      )
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      // Post
                      Visibility(
                        visible: currentIndex == 1,
                        child: BlocBuilder<SearchScreenBlocCubit,
                            SearchScreenBlocState>(
                          buildWhen: (previous, current) =>
                              previous.inThisAreaEventDataList !=
                              current.inThisAreaEventDataList,

                          builder: (context, state) {

                            return Visibility(
                                visible: state.inThisAreaEventDataList !=
                                        null &&
                                    state.inThisAreaEventDataList!.isNotEmpty,
                                replacement: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 50),
                                    child: Text('Have you searched anything ?'),
                                  ),
                                ),
                                child: GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4.w, vertical: 7.h),
                                  itemCount:
                                      state.inThisAreaEventDataList?.length ??
                                          0,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          childAspectRatio: 0.83,
                                          crossAxisSpacing: 8,
                                          mainAxisSpacing: 8,
                                          crossAxisCount: 3),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        FirebaseEvents.setFirebaseEvent(
                                            'click_search_post', {});
                                        if (!mounted) return;
                                        context
                                            .read<NewsDetailsScreenBlocCubit>()
                                            .init();
                                        context
                                            .read<NewsDetailsScreenBlocCubit>()
                                            .getPostId(state
                                                    .inThisAreaEventDataList![
                                                        index]
                                                    .id ??
                                                '');
                                        context
                                            .read<NewsDetailsScreenBlocCubit>()
                                            .getEventNewsDetailData();
                                        context
                                            .read<NewsDetailsScreenBlocCubit>()
                                            .getInThisAreaPostList();
                                        NavigatorRoute.navigateTo(
                                            context, AppRoutes.newsDetails,
                                            args: {
                                              "isHome": true,
                                            });
                                      },
                                      child: AppNetworkImageLoader(
                                        url: state
                                                .inThisAreaEventDataList![index]
                                                .thumbnail ??
                                            '',
                                        boxFit: BoxFit.cover,
                                        borderRadius: 0,
                                      ),
                                    );
                                  },
                                ));
                          },
                        ),
                      ),
                      // User
                      Visibility(
                          visible: currentIndex == 2 /*&&
                              searchUserDataList.isNotEmpty*/,
                          replacement: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: Text('Have you searched anything ?'),
                            ),
                          ),
                          child: isLoadingUser
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.whiteColor,
                                  ),
                                )
                              :
                          searchUserDataList.isNotEmpty ?
                          ListView.separated(
                                  itemCount: searchUserDataList.length,
                                  separatorBuilder: (context, index) => Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    child: Divider(
                                      color: AppColors.buttonDisabledColor,
                                    ),
                                  ),
                                  itemBuilder: (context, index) {
                                    final user = searchUserDataList[index];

                                    return ListTile(
                                      minTileHeight: 50.h,
                                      contentPadding: EdgeInsets.zero,
                                      leading: AppNetworkImageLoader(
                                        boxFit: BoxFit.cover,
                                        height: 50.h,
                                        width: 45.w,
                                        borderRadius: 50.r,
                                        url: user.profilePicture ?? "",
                                      ),
                                      title: Text(
                                        user.name ?? 'Aawaz',
                                        style: TextStyles.medium(
                                          18.sp,
                                          fontColor: AppColors.whiteColor
                                              .withValues(alpha: 0.9),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Text(
                                        '@${user.username ?? 'username'}',
                                        style: TextStyles.light(
                                          16.sp,
                                          fontColor: Colors.grey,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onTap: () {
                                        FirebaseEvents.setFirebaseEvent(
                                            'click_view_profile_chat_details',
                                            {});
                                        if (user.id != null) {
                                          context
                                              .read<UserProfileCubit>()
                                              .getUserId(
                                                user.id ?? '',
                                              );
                                          context
                                              .read<UserProfileCubit>()
                                              .getUserInfo();
                                          NavigatorRoute.navigateTo(
                                              context, AppRoutes.userProfile);
                                        }
                                      },
                                    );
                                  },
                                )
                      : Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: Text('Have you searched anything ?'),
                            ),
                          ),
                      )
                    ]),
              ),
              /*if (!isOpenKeyboard)
                SizedBox(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context
                                .read<SearchScreenBlocCubit>()
                                .startListening();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(8.h),
                            decoration: BoxDecoration(
                              color: AppColors.blackColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.actionBtnBgColor,
                                width: 8.sp,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 40.r,
                              backgroundColor: AppColors.actionBtnBgColor,
                              child: Assets.icons.icMic.svg(height: 35),
                            ),
                          ),
                        ),
                        Gap(15.h),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Tap to Talk',
                            style: TextStyles.medium(18.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                )*/
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
