import 'package:chewie/chewie.dart';
import 'package:eagle_eye/core/constant/app_constant.dart';
import 'package:eagle_eye/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../../gen/assets.gen.dart';
import '../../routes/app_navigation.dart';
import '../constant/app_assets.dart';
import '../utils/app_functions.dart';

class AuthBackgroundWidget extends StatefulWidget {
  final String titleText;
  final String subTitleText;
  final Widget authBody;
  final Widget bottomWidget;
  final bool? backButtonShow;

  const AuthBackgroundWidget({
    super.key,
    required this.titleText,
    required this.subTitleText,
    required this.authBody,
    required this.bottomWidget,
    this.backButtonShow,
  });

  @override
  State<AuthBackgroundWidget> createState() => _AuthBackgroundWidgetState();
}

class _AuthBackgroundWidgetState extends State<AuthBackgroundWidget> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    initVideoPlayer();
    super.initState();
  }

  initVideoPlayer() async {
    videoPlayerController =
        VideoPlayerController.asset(AppVideoAsset.authBgVideo);
    await Future.wait([videoPlayerController.initialize()]);
    _createChewieController();
    setState(() {});
  }

  _createChewieController() {
    chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        looping: true,
        showControls: false,
        showControlsOnInitialize: false,
        aspectRatio: 9 / 16,
        allowedScreenSleep: false,
        showOptions: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
             chewieController != null &&
                  chewieController!.videoPlayerController.value.isInitialized
              ? Center(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: videoPlayerController.value.size.width,
                        height: videoPlayerController.value.size.height,
                        child: Chewie(
                          controller: chewieController!,
                        ),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text('Loading'),
                    ],
                  ),
                ),
       /*   Image.asset(
            AppImageAsset.authBgImg,
            fit: BoxFit.contain,
          ),*/
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: widget.bottomWidget),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 120.h,
                      ),
                      Text(
                        'Awaaz',
                        style: TextStyles.semiBold(
                          40.sp,
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      Text(
                        widget.titleText,
                        style: TextStyles.bold(34.sp,
                            fontFamily: testTiemposHeadline),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        widget.subTitleText,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyles.medium(
                          14.sp,
                        ),
                      ),
                      widget.authBody,
                    ],
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: widget.backButtonShow ?? false,
            child: Padding(
              padding: const EdgeInsets.only(top: 50, left: 15),
              child: IconButton(
                  onPressed: () {
                    closeKeyboard();
                    NavigatorRoute.navigateBack(context);
                  },
                  icon: Assets.icons.icBackArrowWhite.svg()),
            ),
          ),
        ],
      ),
    );
  }
}
