import 'dart:developer';

import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/theme/text_styles.dart';
import 'package:eagle_eye/core/widget/app_network_image_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/widget/common_app_bar.dart';
import '../../../data/models/get_supports_model.dart';

class SupportDetailScreen extends StatefulWidget {
  const SupportDetailScreen({super.key});

  @override
  State<SupportDetailScreen> createState() => _SupportDetailScreenState();
}

class _SupportDetailScreenState extends State<SupportDetailScreen> {
  // String? _imageUrl;
  // String? submittedEmail;
  // String? submittedSubject;
  // String? submittedDescription;
  // String? submittedImageUrl;
  SupportData? supportData;
  dynamic args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    log("-+-+-+-+-+-+-+-+-+${args?['support']}");
    // log("-+-+-+-+-+-+-+-+-+${}");
    log("Args data: $args");
    supportData = args?['support'];
  }

  @override
  // void initState() {
  //   args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
  //
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppCommonAppBar(
        title: 'Support',
        centerTitle: true,
      ),
      body: Padding(
          padding: EdgeInsets.all(20.sp),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Email',
                        style: TextStyles.semiBold(18.sp,
                            fontColor: AppColors.blackColor),
                      ),
                      Text(
                        supportData?.email ?? "N/A",
                        style: TextStyles.regular(16.sp,
                            fontColor: AppColors.blackColor),
                      ),
                    ],
                  ),
                ),
                Gap(20.h),
                Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subject',
                        style: TextStyles.semiBold(18.sp,
                            fontColor: AppColors.blackColor),
                      ),
                      Text(
                        supportData?.subject ?? "N/A",
                        style: TextStyles.regular(16.sp,
                            fontColor: AppColors.blackColor),
                      ),
                    ],
                  ),
                ),
                Gap(20.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: TextStyles.semiBold(18.sp,
                            fontColor: AppColors.blackColor),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        supportData?.description ?? "N/A",
                        style: TextStyles.regular(16.sp,
                            fontColor: AppColors.blackColor),
                      ),
                    ],
                  ),
                ),
                Gap(20.h),
                supportData?.attachments == null ||
                        supportData!.attachments!.isEmpty
                    ? SizedBox()
                    : Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Image',
                              style: TextStyles.semiBold(18.sp,
                                  fontColor: AppColors.blackColor),
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              children: supportData?.attachments?.map(
                                    (e) {
                                      return AppNetworkImageLoader(
                                        url: e,
                                        height: 80,
                                        width: 80,
                                      );
                                    },
                                  ).toList() ??
                                  [],
                            ),
                          ],
                        ),
                      ),
                // You might add more UI elements below this
              ],
            ),
          )),
    );
  }
}
