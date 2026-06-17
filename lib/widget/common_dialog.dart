import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';


commonDialog({
  required String title,
  required String subtitle,
  required BuildContext context,
  VoidCallback? onTap,
  VoidCallback? onTapCancel,
}){
  return

    showDialog(
      context: context,

      builder: (context) {
        return  AlertDialog(
          insetPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          title: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  Text(
                    title,
                    style: TextStyles.bold(25, fontColor: Colors.black),
                  ),
                  const Gap(30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Text(subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyles.semiBold(18,fontColor: Colors.black),),
                  ),
                  const Gap(40),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: ElevatedButton(

                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(8),
                                ),
                                overlayColor:
                                AppColors.black.withValues(alpha:0.2),
                                shadowColor: Colors.black,
                                backgroundColor: Colors.black12,
                              ),
                              onPressed: onTapCancel??() {
                                NavigatorRoute.navigateBack(context:  context);
                              },


                              child: Text(
                                'Cancel',
                                style: TextStyles.semiBold(17,
                                    fontColor: Colors.white),
                              )),
                        ),
                      ),
                      const Gap(15),
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(8),
                                ),
                                overlayColor:
                                AppColors.black.withValues(alpha:0.2),
                                shadowColor:
                                Colors.black,
                                backgroundColor:
                                Colors.black,
                              ),
                              onPressed:onTap?? () {

                              },
                              child: Text(
                                'Yes',
                                style: TextStyles.semiBold(17,
                                    fontColor: Colors.white),
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        );
      },
    );

}