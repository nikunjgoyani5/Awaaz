import 'package:eagle_eye/routes/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HelpVideoDialog extends StatefulWidget {
  final String subTitleText;
  final String videoId;
  final double? videoHeight;

  const HelpVideoDialog(
      {super.key,
      required this.subTitleText,
      required this.videoId,
      this.videoHeight});

  @override
  State<HelpVideoDialog> createState() => _HelpVideoDialogState();
}

class _HelpVideoDialogState extends State<HelpVideoDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      iconPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.symmetric(horizontal: 50.w),
      backgroundColor: Colors.transparent,
      content: YoutubeGuidDialog(
        videoId: widget.videoId,
        videoHeight: widget.videoHeight,
      ),
    );
  }
}

class YoutubeGuidDialog extends StatefulWidget {
  final String videoId;
  final double? videoHeight;

  const YoutubeGuidDialog({super.key, this.videoHeight, required this.videoId});

  @override
  State<YoutubeGuidDialog> createState() => _YoutubeGuidDialogState();
}

class _YoutubeGuidDialogState extends State<YoutubeGuidDialog> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        hideControls: false,
        hideThumbnail: true,
        enableCaption: false,
        controlsVisibleAtStart: true,
        disableDragSeek: false,
        loop: true,
        // forceHD: true,
        showLiveFullscreenButton: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          },
          child: _controller.value.isPlaying
              ? null
              : const Icon(Icons.play_circle_fill_sharp),
        ),
        Stack(
          children: [
            SizedBox(
              height: widget.videoHeight ?? 730.h,
              width: 350.w,
              child: YoutubePlayer(
                aspectRatio: 16 / 9,
                actionsPadding: EdgeInsets.zero,
                onEnded: (metaData) {
                  _controller.play();
                },
                controller: _controller,
              ),
            ),
            Positioned(
              right: 0,
              child: IconButton(
                onPressed: () {
                  NavigatorRoute.navigateBack(context);
                },
                icon: Icon(Icons.close),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
