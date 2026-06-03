import 'package:eagle_eye/core/widget/app_custom_loader.dart';
import 'package:eagle_eye/presentation/main/get_support_screen/bloc/get_support_cubit.dart';
import 'package:eagle_eye/presentation/main/get_support_screen/support_detail_screen.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widget/common_app_bar.dart';
import '../../../data/models/get_supports_model.dart';
import '../../../routes/app_routes.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  void initState() {
    FirebaseEvents.setFirebaseEvent('support_screen', {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppCommonAppBar(
        title: 'Get Support',
        centerTitle: true,
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          FirebaseEvents.setFirebaseEvent('click_support_request_btn', {});
          context.read<GetSupportCubit>().init();
          Navigator.pushNamed(context, AppRoutes.addSupport);
        },
        child: Container(
          height: 50.h,
          width: 200.w,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Support Requests',
                  style: TextStyles.medium(
                    18.sp,
                    fontColor: AppColors.blackColor,
                  ),
                ),
                Gap(3.w),
                Icon(
                  Icons.add,
                  size: 20.sp,
                  color: AppColors.blackColor,
                )
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Column(
            children: [
              Gap(20.h),
              Row(
                children: [
                  BlocBuilder<GetSupportCubit, GetSupportState>(
                    buildWhen: (previous, current) =>
                        previous.selectedSupportIndex !=
                        current.selectedSupportIndex,
                    builder: (context, state) {
                      return Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            context
                                .read<GetSupportCubit>()
                                .updateCurrentIndex(0);
                            await context
                                .read<GetSupportCubit>()
                                .getSupportTicketList();
                          },
                          child: Container(
                            height: 40.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.r),
                              color: (state.selectedSupportIndex == 0)
                                  ? AppColors.whiteColor
                                  : AppColors.actionBtnBgColor,
                            ),
                            child: Center(
                              child: Text(
                                'Open Tickets',
                                style: TextStyles.semiBold(
                                  16.sp,
                                  fontColor: (state.selectedSupportIndex == 0)
                                      ? AppColors.blackColor
                                      : AppColors.whiteColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Gap(18.w),
                  BlocBuilder<GetSupportCubit, GetSupportState>(
                    buildWhen: (previous, current) =>
                        previous.selectedSupportIndex !=
                        current.selectedSupportIndex,
                    builder: (context, state) {
                      return Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            context
                                .read<GetSupportCubit>()
                                .updateCurrentIndex(1);
                            await context
                                .read<GetSupportCubit>()
                                .getSupportTicketList();
                          },
                          child: Container(
                            height: 40.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.r),
                              color: (state.selectedSupportIndex == 1)
                                  ? AppColors.whiteColor
                                  : AppColors.actionBtnBgColor,
                            ),
                            child: Center(
                              child: Text(
                                'Closed Tickets',
                                style: TextStyles.semiBold(
                                  16.sp,
                                  fontColor: (state.selectedSupportIndex == 1)
                                      ? AppColors.blackColor
                                      : AppColors.whiteColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Gap(26.h),
              BlocBuilder<GetSupportCubit, GetSupportState>(
                  builder: (context, state) {
                return Expanded(
                  child: state.isLoading
                      ? AppCustomLoader()
                      : (state.supportDataList != null &&
                              state.supportDataList!.isNotEmpty)
                          ? ListView.separated(
                              itemCount: state.supportDataList?.length ?? 0,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      Gap(10.h),
                              padding: EdgeInsets.only(bottom: 80.h),
                              itemBuilder: (BuildContext context, int index) {
                                SupportData supportData =
                                    state.supportDataList?[index] ??
                                        SupportData();
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SupportDetailScreen(),
                                        settings: RouteSettings(
                                          arguments: {
                                            'support':
                                                state.supportDataList?[index],
                                          },
                                        ),
                                      ),
                                    );
                                    // NavigatorRoute.navigateTo(
                                    //     context, AppRoutes.supportDetailScreen,
                                    //     args: {
                                    //       "support":
                                    //           state.supportDataList?[index]
                                    //     });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(18.sp),
                                    decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          supportData.subject ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyles.semiBold(
                                            18.sp,
                                            fontColor: AppColors.blackColor,
                                          ),
                                        ),
                                        Text(
                                          supportData.description ?? '',
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyles.medium(
                                            14.sp,
                                            fontColor: AppColors.blackColor,
                                          ),
                                        ),
                                        Gap(10.h),
                                        supportData.status == 'open'
                                            ? Row(
                                                children: [
                                                  Text(
                                                    'Status:  ',
                                                    style: TextStyles.semiBold(
                                                      14.sp,
                                                      fontColor:
                                                          AppColors.blackColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Open',
                                                    style: TextStyles.semiBold(
                                                      14.sp,
                                                      fontColor:
                                                          AppColors.blackColor,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  Text(
                                                    'Status:  ',
                                                    style: TextStyles.semiBold(
                                                      14.sp,
                                                      fontColor:
                                                          AppColors.blackColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Close',
                                                    style: TextStyles.semiBold(
                                                      14.sp,
                                                      fontColor:
                                                          AppColors.blackColor,
                                                    ),
                                                  ),
                                                ],
                                              )
                                        //  Container(
                                        //   height: 26.h,
                                        //   width: 64.w,
                                        //   decoration: BoxDecoration(
                                        //     color: AppColors.redColor,
                                        //     borderRadius:
                                        //         BorderRadius.circular(4.r),
                                        //   ),
                                        //   child: Center(
                                        //     child: Text(
                                        //       'Close',
                                        //       style: TextStyles.semiBold(
                                        //         14.sp,
                                        //         fontColor:
                                        //             AppColors.whiteColor,
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Text('No ticket found.'),
                            ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
