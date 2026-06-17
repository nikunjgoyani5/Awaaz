import 'package:cross_file/cross_file.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/widget/app_network_image.dart';
import 'package:eagle_eye_admin/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventImagePreviewDialog extends StatelessWidget {
  const EventImagePreviewDialog({super.key, required this.imageURL});
final String imageURL ;
  void downloadImage(String url) {
    XFile(url).saveTo("image.png");
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      key: key,
      alignment: Alignment.center,
      insetPadding: EdgeInsets.zero,
      backgroundColor: AppColors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.3,
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [

              AppNetworkImageLoader(url:

                imageURL

,          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.3,
                boxFit: BoxFit.cover,
              ),


              Column(

                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          NavigatorRoute.navigateBack(context:  context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50.h,
                        width: 150.w,
                        child: CommonButton(
                          color: AppColors.green,
                          radius: 5.r,
                          onPressed: () async {
                            NavigatorRoute.navigateBack(context:  context);
                            downloadImage(imageURL);
                          },
                          widget: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Save",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
