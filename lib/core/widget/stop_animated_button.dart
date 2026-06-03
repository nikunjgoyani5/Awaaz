import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class StopAnimated extends StatefulWidget {
  const StopAnimated({
    super.key,
    required this.label,
    required this.remainingTime,
    required this.totalDuration,
    required this.onTap,
  });

  final String label;
  final int remainingTime;
  final int totalDuration;
  final VoidCallback onTap;

  @override
  State<StopAnimated> createState() => _StopAnimatedState();
}

class _StopAnimatedState extends State<StopAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.totalDuration),
    );
    // Set the initial value based on the remaining time
    _updateAnimationValue(widget.remainingTime);
  }

  @override
  void didUpdateWidget(covariant StopAnimated oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update animation value when remainingTime changes
    if (widget.remainingTime != oldWidget.remainingTime) {
      _updateAnimationValue(widget.remainingTime);
    }
    // Update animation duration if totalDuration changes (though likely constant here)
    if (widget.totalDuration != oldWidget.totalDuration) {
      _animationController.duration = Duration(seconds: widget.totalDuration);
      _updateAnimationValue(
          widget.remainingTime); // Recalculate value for new duration
    }
  }

  void _updateAnimationValue(int remainingTime) {
    if (widget.totalDuration > 0) {
      double progress =
          (widget.totalDuration - remainingTime) / widget.totalDuration;
      _animationController.value = progress.clamp(0.0, 1.0);
    } else {
      _animationController.value = 0.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double buttonHeight = 55.sp;

    return GestureDetector(
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(buttonHeight / 2), // Fully rounded corners
        child: Container(
          height: buttonHeight,
          width: 235.w,
          color: AppColors.whiteColor, // White background
          child: Stack(
            children: [
              // Progress Indicator (Red Fill)
              Align(
                alignment: Alignment.centerLeft,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FractionallySizedBox(
                        heightFactor: 1,
                        widthFactor: _animationController.value,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.redColorColor, // Red fill color
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(buttonHeight / 2),
                              bottomLeft: Radius.circular(buttonHeight / 2),
                              topRight: Radius.circular(_animationController
                                          .value ==
                                      1
                                  ? buttonHeight / 2
                                  : 0), // Round right corner only when fully filled
                              bottomRight: Radius.circular(_animationController
                                          .value ==
                                      1
                                  ? buttonHeight / 2
                                  : 0), // Round right corner only when fully filled
                            ),
                          ), // Red fill color
                        ));
                  },
                ),
              ),
              // Text
              Center(
                child: Text(
                  widget.label,
                  style: TextStyles.medium(
                    22.sp,
                    fontColor: AppColors.blackColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
