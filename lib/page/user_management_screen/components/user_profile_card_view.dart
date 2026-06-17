import 'package:eagle_eye_admin/model/get_all_user_model.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/widget/app_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CurrentUserView extends StatelessWidget {
  const CurrentUserView({super.key, required this.userData});

  final UserData userData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.sp),
      decoration: BoxDecoration(
        color: AppColors.borderColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                    child: AppNetworkImageLoader(
                  url: userData.profilePicture ?? '',
                  height: 70,
                  width: 70,
                  boxFit: BoxFit.cover,
                )),
                Gap(10.h),
                Text(
                  userData.name ?? '',
                  maxLines: 2,overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: AppColors.white, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
