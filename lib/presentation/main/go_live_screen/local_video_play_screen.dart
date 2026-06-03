import 'package:eagle_eye/core/widget/common_app_bar.dart';
import 'package:eagle_eye/gen/assets.gen.dart';
import 'package:eagle_eye/routes/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'dart:io'; // To handle File

class LocalVideoPlayerScreen extends StatefulWidget {
  const LocalVideoPlayerScreen({super.key, required this.videoPath, this.isDraft = false});
  final String videoPath; // Local file path
  final bool isDraft;
  @override
  LocalVideoPlayerScreenState createState() => LocalVideoPlayerScreenState();
}

class LocalVideoPlayerScreenState extends State<LocalVideoPlayerScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    if (widget.isDraft) {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoPath));
    } else {
      _videoPlayerController = VideoPlayerController.file(File(widget.videoPath));
    }

    await _videoPlayerController!.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: false,
      allowFullScreen: false,
      allowMuting: true,
    );

    setState(() {}); // Refresh the screen after initialization
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppCommonAppBar(
        leading: IconButton(
            onPressed: () {
              NavigatorRoute.navigateBack(context);
            },
            icon: Assets.icons.icBackArrowWhite.svg()),
        title: '',
      ),
      body: _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
          ? Chewie(controller: _chewieController!)
          : Center(child: CircularProgressIndicator()),
    );
  }
}
