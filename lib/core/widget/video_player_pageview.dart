import 'dart:async';
import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/widget/common_app_bar.dart';
import 'package:eagle_eye/core/widget/common_app_image_show.dart';
import 'package:eagle_eye/core/widget/common_text_button.dart';
import 'package:eagle_eye/gen/assets.gen.dart';
import 'package:eagle_eye/presentation/main/go_live_screen/bloc/go_live_cubit.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../../presentation/main/general_go_live/bloc/general_post_cubit.dart';
import '../theme/text_styles.dart';
import 'common_button.dart';

class VideoPlayerPageView extends StatefulWidget {
  final String videoUrl;
  final bool isDraftVideo;
  final bool? sensetiveContent;
  final dynamic draftData;
  final String contentType;

  const VideoPlayerPageView({
    super.key,
    required this.videoUrl,
    this.isDraftVideo = false,
    this.sensetiveContent = false,
    this.draftData,
    required this.contentType,
  });

  @override
  State<VideoPlayerPageView> createState() => _VideoPlayerPageViewState();
}

class _VideoPlayerPageViewState extends State<VideoPlayerPageView> {
  late VideoPlayerController videoPlayerController;
  ChewieController? _chewieController;
  bool isMuted = false;
  bool isPortraitVideo = true;
  bool isPlaying = false;
  bool isControlsVisible = true;
  Timer? _hideControlsTimer;
  bool sensetiveContent = false;

  @override
  void initState() {
    FirebaseEvents.setFirebaseEvent('video_player_page_view_screen', {});
    super.initState();
    sensetiveContent = widget.sensetiveContent?? false;
    if (widget.contentType.toLowerCase() == 'video') {
      _initializeVideo();
      videoPlayerController.addListener(_updateState);

      // Show controls for 2 seconds on start, then hide
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startHideControlsTimer();
      });
    }
  }

  void _updateState() {
    setState(() {
      isPlaying = videoPlayerController.value.isPlaying;
    });
  }

  void _toggleControls() {
    setState(() {
      isControlsVisible = !isControlsVisible;
    });

    if (isControlsVisible) {
      _startHideControlsTimer();
    }
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(Duration(seconds: 2), () {
      setState(() {
        isControlsVisible = false;
      });
    });
  }

  Future<void> _initializeVideo() async {
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );

    await videoPlayerController.initialize();
    _setupChewieController();

    // Determine if the video is portrait or landscape
    final videoAspectRatio = videoPlayerController.value.aspectRatio;
    setState(() {
      isPortraitVideo = videoAspectRatio < 1.0;
    });
  }

  void _setupChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: widget.sensetiveContent == true ? false : true,
      autoInitialize: true,
      allowMuting: true,
      allowPlaybackSpeedChanging: false,
      allowFullScreen: false,
      showControls: false,
      looping: false,
      placeholder: Center(
        child: CircularProgressIndicator(color: AppColors.whiteColor),
      ),
      bufferingBuilder: (context) {
        return Center(
          child: CircularProgressIndicator(color: AppColors.whiteColor),
        );
      },
    );

    _chewieController?.setVolume(isMuted ? 0.0 : 1.0);
    setState(() {});
  }

  @override
  void dispose() {
    if (widget.contentType.toLowerCase() == 'video') {
      videoPlayerController.removeListener(_updateState);
      videoPlayerController.dispose();
      _chewieController?.dispose();
      _hideControlsTimer?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController == null &&
        widget.contentType.toLowerCase() == 'video') {
      return Scaffold(
        appBar: AppCommonAppBar(title: ''),
        body: Center(
          child: CircularProgressIndicator(color: AppColors.whiteColor),
        ),
      );
    }

    return Scaffold(
      appBar: AppCommonAppBar(title: ''),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: (widget.isDraftVideo)
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: CommonButton(
                onPressed: () {
                  FirebaseEvents.setFirebaseEvent(
                      'click_draft_video_post_btn', {});
                  if (widget.draftData.postType == "incident") {
                    context.read<GoLiveCubit>().setDraftData(
                        context: context, draftData: widget.draftData);
                  } else if (widget.draftData.postType == "general_category") {
                    context.read<GeneralPostCubit>().setDraftData(
                        context: context, draftData: widget.draftData);
                  }
                },
                color: AppColors.whiteColor,
                widget: Text(
                  'POST',
                  style: TextStyles.semiBold(18.sp, fontColor: Colors.black),
                ),
              ),
            )
          : null,
      body: (widget.contentType.toLowerCase() == 'video')
          ? Stack(
              children: [
                GestureDetector(
                  onTap: _toggleControls,
                  child: Stack(
                    children: [
                      videoPlayerController.value.aspectRatio < 1
                          ? Chewie(
                              controller: _chewieController!,
                            )
                          : Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.black,
                              child: FittedBox(
                                fit: BoxFit.cover,
                                // Use BoxFit.cover or BoxFit.fitWidth as needed
                                child: Container(
                                  color: Colors.black,
                                  width: videoPlayerController.value.size.width,
                                  height:
                                      videoPlayerController.value.size.height,
                                  child: Chewie(
                                    controller: _chewieController!,
                                  ),
                                ),
                              ),
                            ),
                      /*  SizedBox.expand(
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                    width: videoPlayerController.value.aspectRatio,
                                    height: videoPlayerController.value.aspectRatio,
                                    child:
                                        Chewie(controller: _chewieController!)))
                        ),*/
                      /*   LayoutBuilder(
                  builder: (context, constraints) {
                    return Center(
                      child: isPortraitVideo
                          ? Chewie(controller: _chewieController!)
                          : AspectRatio(
                              aspectRatio: videoPlayerController.value.aspectRatio,
                              child: Chewie(controller: _chewieController!),
                            ),
                    );
                  },
                ),*/
                      // Play/Pause Button (Centered, fades in/out with controls)
                      AnimatedOpacity(
                        opacity: isControlsVisible ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 300),
                        child: Visibility(
                          visible: isControlsVisible,
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isPlaying) {
                                    videoPlayerController.pause();
                                  } else {
                                    videoPlayerController.play();
                                  }
                                });
                                _startHideControlsTimer();
                              },
                              child: Icon(
                                isPlaying
                                    ? Icons.pause_circle_filled
                                    : Icons.play_circle_filled,
                                size: 70,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Bottom Controls (Seek Bar + Time + Fullscreen) with Fade Animation
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: AnimatedOpacity(
                          opacity: isControlsVisible ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 300),
                          child: Visibility(
                            visible: isControlsVisible,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withValues(alpha: 0.8),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              child: Column(
                                children: [
                                  // Custom Seek Bar
                                  VideoProgressIndicator(
                                    videoPlayerController,
                                    allowScrubbing: true,
                                    colors: VideoProgressColors(
                                      playedColor: Colors.blueAccent,
                                      bufferedColor:
                                          Colors.grey.withValues(alpha: 0.5),
                                      backgroundColor:
                                          Colors.white.withValues(alpha: 0.2),
                                    ),
                                  ),

                                  SizedBox(height: 5),
                                  // Space between seek bar and controls

                                  // Bottom Row: Time & Fullscreen
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Time Display
                                      Text(
                                        "${_formatDuration(videoPlayerController.value.position)} / ${_formatDuration(videoPlayerController.value.duration)}",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.sensetiveContent == true) ...[
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black.withValues(alpha: 0.6),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 40.h,
                                child: FittedBox(
                                  child: Assets.icons.icEyeOff.svg(),
                                )),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              'Sensitive content',
                              style: TextStyles.bold(18.sp),
                            ),
                            Text(
                              'This video may contain graphic or violent content. ',
                              style: TextStyles.medium(14.sp),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Divider(
                              indent: 50.w,
                              endIndent: 50.w,
                            ),
                            CommonTextButton(
                              onPressed: () {
                                setState(() {
                                  sensetiveContent = false;
                                  videoPlayerController.play();
                                });
                              },
                              widget: Text(
                                'Show Anyway',
                                style: TextStyles.semiBold(15.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            )
          : Center(
              child: AppImageViewer.showNetworkImage(url: widget.videoUrl)),
    );
  }

  String _formatDuration(Duration position) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(position.inMinutes.remainder(60));
    final seconds = twoDigits(position.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}

class CustomIOSControls extends StatefulWidget {
  final VideoPlayerController controller;

  const CustomIOSControls({
    super.key,
    required this.controller,
  });

  @override
  State<CustomIOSControls> createState() => _CustomIOSControlsState();
}

class _CustomIOSControlsState extends State<CustomIOSControls> {
  bool isPlaying = false;
  bool isControlsVisible = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateState);

    // Show controls for 2 seconds on start, then hide
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startHideControlsTimer();
    });
  }

  void _updateState() {
    setState(() {
      isPlaying = widget.controller.value.isPlaying;
    });
  }

  void _toggleControls() {
    setState(() {
      isControlsVisible = !isControlsVisible;
    });

    if (isControlsVisible) {
      _startHideControlsTimer();
    }
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(Duration(seconds: 2), () {
      setState(() {
        isControlsVisible = false;
      });
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateState);
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleControls,
      child: Stack(
        children: [
          // Play/Pause Button (Centered, fades in/out with controls)
          AnimatedOpacity(
            opacity: isControlsVisible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 300),
            child: Visibility(
              visible: isControlsVisible,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isPlaying) {
                        widget.controller.pause();
                      } else {
                        widget.controller.play();
                      }
                    });
                    _startHideControlsTimer();
                  },
                  child: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    size: 70,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ),
          ),
          // Bottom Controls (Seek Bar + Time + Fullscreen) with Fade Animation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: isControlsVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: Visibility(
                visible: isControlsVisible,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.8),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Custom Seek Bar
                      VideoProgressIndicator(
                        widget.controller,
                        allowScrubbing: true,
                        colors: VideoProgressColors(
                          playedColor: Colors.blueAccent,
                          bufferedColor: Colors.grey.withValues(alpha: 0.5),
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),

                      SizedBox(height: 5),
                      // Space between seek bar and controls

                      // Bottom Row: Time & Fullscreen
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Time Display
                          Text(
                            "${_formatDuration(widget.controller.value.position)} / ${_formatDuration(widget.controller.value.duration)}",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration position) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(position.inMinutes.remainder(60));
    final seconds = twoDigits(position.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
