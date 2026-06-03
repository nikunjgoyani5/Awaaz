import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
import '../theme/text_styles.dart';
import '../theme/colors.dart';

class RatingDialogBox extends StatelessWidget {
  final Function(RatingDialogResponse) onSubmit;
  final Function(RatingDialogResponse) onCancel;

  const RatingDialogBox({
    super.key,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          dialogTheme: const DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      )),
      child: RatingDialog(
        initialRating: 4.0,
        enableComment: false,
        starSize: 36,
        title: Text(
          'Rate Us',
          textAlign: TextAlign.center,
          style: TextStyles.bold(30.sp, fontColor: AppColors.blackColor),
        ),
        message: Text(
          'Rate your experience with a sprinkle of sweetness! 🌟',
          textAlign: TextAlign.center,
          style: TextStyles.regular(20.sp, fontColor: AppColors.blackColor),
        ),
        // your app's logo?
        image: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Assets.images.awazLogoWebp.image(height: 100, width: 100),
        ),
        submitButtonText: 'Submit',
        submitButtonTextStyle:
            TextStyles.bold(24.sp, fontColor: AppColors.blackColor),
        onCancelled: onCancel,
        onSubmitted: onSubmit,
      ),
    );
  }
}
