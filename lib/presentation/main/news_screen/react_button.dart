import 'package:eagle_eye/core/widget/app_network_image_loader.dart';
import 'package:flutter/material.dart';


class ReactButton extends StatelessWidget {
  const ReactButton({
    super.key,
    this.hasReacted = false,
    // required this.toggleReact,
    required this.reactionIcon,
    this.size,
    this.bgColor,
  });

  final bool hasReacted;
  final String reactionIcon;
  final double? size;
  final Color? bgColor;
  // final GestureTapCallback toggleReact;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: hasReacted ? 1 : 0),
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeInOut,
        builder: (context, value, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Circular background fill with animation
              Container(
                height: size ?? 35,
                width: size ?? 35,
                decoration: BoxDecoration(
                  color: bgColor ?? Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: value,
                      child: Container(
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),
              ),

              // Reaction icon

              ///old
              // CachedNetworkImage(
              //   height: 30,
              //   width: 30,
              //   fit: BoxFit.contain,
              //   errorWidget: (context, url, error) {
              //     return Image.asset(Assets.images.fire.path);
              //   },
              //   imageUrl: reactionIcon,
              // ),
              ///new
              AppNetworkImageLoader(
                url: reactionIcon,
                height: 28,
                width: 28,
                boxFit: BoxFit.contain,
              )
            ],
          );
        },
      ),
    );
  }
}
