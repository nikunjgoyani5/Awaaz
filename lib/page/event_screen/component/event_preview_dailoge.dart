import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/widget/button.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:video_player/video_player.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EventPreviewDailoge extends StatefulWidget {
  const EventPreviewDailoge({super.key, required this.videoPath});

  final String videoPath;

  @override
  State<EventPreviewDailoge> createState() => _EventPreviewDailogeState();
}

class _EventPreviewDailogeState extends State<EventPreviewDailoge> {
  GlobalKey key = GlobalKey();

  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoPath))
          ..initialize().then((_) {
            setState(() {
              videoPlayerController.play();
            });
          });
  }

  void downloadVideo(String url) {
    XFile(url).saveTo("video.mp4");
  }

  @override
  void dispose() {
    onCloseVideoDialog();
    super.dispose();
  }

  void onCloseVideoDialog() {
    if (videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
    }
    videoPlayerController.dispose();
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
      child: !videoPlayerController.value.isInitialized
          ? Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.white38,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white)),
              alignment: Alignment.center,
              child: Lottie.asset('assets/animation/loader.json',
                  height: 70, width: 70),
            )
          : Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.6,
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: videoPlayerController.value.aspectRatio,
                          child: VideoPlayer(videoPlayerController),
                        ),
                        IconButton(
                          color: Colors.black,
                          onPressed: () {
                            setState(() {
                              videoPlayerController.value.isPlaying
                                  ? videoPlayerController.pause()
                                  : videoPlayerController.play();
                            });
                          },
                          icon: Icon(
                            videoPlayerController.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            NavigatorRoute.navigateBack(context: context);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.white,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 50.h,
                          width: 150.w,
                          child: CommonButton(
                            color: AppColors.green,
                            radius: 5.r,
                            onPressed: () async {
                              downloadVideo(widget.videoPath);
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
              ),
            ),
    );
  }
}
