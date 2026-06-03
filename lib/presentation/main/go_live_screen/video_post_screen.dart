import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/utils/app_functions.dart';
import 'package:eagle_eye/core/utils/app_prefrence.dart';
import 'package:eagle_eye/core/widget/app_common_loader_screen.dart';
import 'package:eagle_eye/core/widget/common_alert_dialogue.dart';
import 'package:eagle_eye/core/widget/common_app_bar.dart';
import 'package:eagle_eye/core/widget/common_app_image_show.dart';
import 'package:eagle_eye/core/widget/common_button.dart';
import 'package:eagle_eye/data/models/draft_event_model.dart';
import 'package:eagle_eye/gen/assets.gen.dart';
import 'package:eagle_eye/presentation/main/go_live_screen/local_video_play_screen.dart';
import 'package:eagle_eye/routes/app_navigation.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:intl/intl.dart';
import 'package:light_compressor_v2/light_compressor_v2.dart' as light;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constant/app_constant.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/hashtag_formatter.dart';
import '../../../core/widget/app_check_box.dart';
import '../../../core/widget/category_model.dart';
import '../../../core/widget/common_textfield.dart';
import 'bloc/go_live_cubit.dart';

class VideoPostScreen extends StatefulWidget {
  // final File? state.videoFile;
  // final File? state.videoThumbImageFile;
  final DraftData? draftData;

  final XFile? videoFile;

  const VideoPostScreen(
      {super.key,
      // this.state.videoFile,
      // this.state.videoThumbImageFile,
      this.draftData,
      this.videoFile});

  @override
  State<VideoPostScreen> createState() => _VideoPostScreenState();
}

class _VideoPostScreenState extends State<VideoPostScreen> {
  bool isLoading = false;
  bool isSubmitPostLoading = false;
  bool showDownloadAnimation = false;
  final platform = MethodChannel('com.example.app/media_scanner');

  // Timer? _timer1;
  bool isVideoCompressing = false;
  XFile? videoFile;
  File? _videoThumbnailImageFile;
  final light.LightCompressor _lightCompressor = light.LightCompressor();

  final GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    if (widget.videoFile != null) {
      Future.delayed(
        Duration.zero,
        () async {
          setState(() {
            isVideoCompressing = true;
          });
          Directory tempDir = await getTemporaryDirectory();
          final light.Result response = await _lightCompressor.compressVideo(
            path: widget.videoFile!.path,
            videoQuality: light.VideoQuality.medium,
            isMinBitrateCheckEnabled: false,
            video: light.Video(
                videoName: "${DateTime.now().millisecondsSinceEpoch}"),
            android: light.AndroidConfig(isSharedStorage: false),
            ios: light.IOSConfig(saveInGallery: false),
          );

          // MediaInfo? mediaInfo = await VideoCompress.compressVideo(
          //   newFile.path,
          //   quality: VideoQuality.DefaultQuality,
          //   deleteOrigin: false,
          // );

          String finalPath =
              '${tempDir.path}/${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.mp4';
          if (response is light.OnSuccess) {
            String finalDesPath = "";
            setState(() {
              finalDesPath = response.destinationPath;
            });
            dev.log(
                "Original File Size: ${getVideoSize(file: File(widget.videoFile!.path))} bytes");
            dev.log(
                "After Compress File Size: ${getVideoSize(file: File(finalDesPath))} bytes");
            File finalFile = await File(finalPath)
                .writeAsBytes(await File(finalDesPath).readAsBytes());
            File(finalDesPath).deleteSync();
            videoFile = XFile(File(finalFile.path).path);
            await generateThumbnail(File(videoFile?.path ?? ''));
            // context.read<GoLiveCubit>().getAddressFromLatLang();
            FirebaseEvents.setFirebaseEvent('video_post_screen', {});
          } else {
            setState(() {
              isVideoCompressing = false;
            });
          }
        },
      );
    }

    super.initState();
  }

  Future<void> generateThumbnail(File videoFileMain) async {
    try {
      // 1. Generate thumbnail bytes from video
      final thumbnail = await VideoThumbnail.thumbnailData(
        video: videoFileMain.path,
        quality: 85, // Thumbnail image quality
      );

      // if (thumbnail == null) {
      //   debugPrint('Thumbnail generation failed.');
      //   return;
      // }

      // 2. Save thumbnail to file
      final int number = Random().nextInt(100000);
      final Directory tempDir = await getTemporaryDirectory();
      final String thumbnailPath = '${tempDir.path}/thumbnail_$number.png';
      final File thumbnailFile = File(thumbnailPath);
      await thumbnailFile.writeAsBytes(thumbnail);

      // 3. You can use `thumbnailFile` now
      _videoThumbnailImageFile = thumbnailFile;
      context
          .read<GoLiveCubit>()
          .setVideoFile(File(videoFile!.path), _videoThumbnailImageFile!);
      FirebaseEvents.setFirebaseEvent('video_post_screen', {});
      setState(() {
        isVideoCompressing = false;
      });
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Error generating thumbnail: $e');
      setState(() {
        isVideoCompressing = false;
      });
    }
  }

  @override
  void dispose() {
    if (isVideoCompressing) {
      _lightCompressor.cancelCompression();
    }
    // if (VideoCompress.isCompressing) {
    //   VideoCompress.cancelCompression();
    //   VideoCompress.deleteAllCache();
    //   VideoCompress.dispose();
    //   _timer1?.cancel();
    //   _timer1 = null;
    // }
    // _stopLoading();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoLiveCubit, GoLiveState>(
      builder: (context, state) {
        return PopScope(
          canPop: isSubmitPostLoading,

          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) {
              return;
            }

            if (isSubmitPostLoading) {
              return;
            }

            closeKeyboard();
            if (widget.draftData == null) {
              showAppDialog(
                context,
                CommonAlertDialogue(
                  dialogWidget: BlocBuilder<GoLiveCubit, GoLiveState>(
                    buildWhen: (previous, current) =>
                        current.videoThumbImageFile !=
                        previous.videoThumbImageFile,
                    builder: (context, state) {
                      return DraftPostDialog(
                        draftOnTap: () {
                          if (state.videoThumbImageFile != null) {
                            NavigatorRoute.navigateBack(context);
                            context.read<GoLiveCubit>().saveDraftPost(context);
                          } else {
                            AppFunctions.showToast(
                                'Right now the video is being processing, please wait.');
                          }
                        },
                        cancelOnTap: () {
                          if (!mounted) return;
                          if (isVideoCompressing) {
                            _lightCompressor.cancelCompression();
                          }
                          NavigatorRoute.navigateBack(context);
                          NavigatorRoute.navigateBack(context);
                        },
                      );
                    },
                  ),
                ),
                dismissDialog: true,
              );
            } else {
              Future.delayed(const Duration(milliseconds: 200), () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(
                      context); // Manually pop the current screen after delay
                }
              });
            }
          },
          // onWillPop: () async {
          //   if (!isSubmitPostLoading) {
          //     closeKeyboard();
          //     if (widget.draftData == null) {
          //       showAppDialog(
          //           context,
          //           CommonAlertDialogue(
          //               dialogWidget: BlocBuilder<GoLiveCubit, GoLiveState>(
          //                   buildWhen: (previous, current) =>
          //                       current.videoThumbImageFile !=
          //                       previous.videoThumbImageFile,
          //                   builder: (context, state) {
          //                     return DraftPostDialog(
          //                       draftOnTap: () {
          //                         if (state.videoThumbImageFile != null) {
          //                           NavigatorRoute.navigateBack(context);
          //                           context
          //                               .read<GoLiveCubit>()
          //                               .saveDraftPost(context);
          //                         } else {
          //                           AppFunctions.showToast(
          //                               'Right now the video is being processing, please wait.');
          //                         }
          //                       },
          //                       cancelOnTap: () {
          //                         if (!mounted) return;
          //                         if (isVideoCompressing) {
          //                           _lightCompressor.cancelCompression();
          //                         }
          //                         NavigatorRoute.navigateBack(context);
          //                         NavigatorRoute.navigateBack(context);
          //                       },
          //                     );
          //                   })),
          //           dismissDialog: true);
          //     } else {
          //       Future.delayed(Duration(milliseconds: 200), () {
          //         if (Navigator.canPop(context)) {
          //           Navigator.pop(context);
          //         }
          //       });
          //       return false;
          //     }
          //   }
          //
          //   return isSubmitPostLoading ? false : true;
          // },
          child: Scaffold(
            appBar: AppCommonAppBar(
              leading: BlocBuilder<GoLiveCubit, GoLiveState>(
                  builder: (context, state) {
                return IconButton(
                    onPressed: () {
                      closeKeyboard();
                      if (widget.draftData == null) {
                        showAppDialog(
                            context,
                            CommonAlertDialogue(
                                dialogWidget: BlocBuilder<GoLiveCubit,
                                        GoLiveState>(
                                    buildWhen: (previous, current) =>
                                        current.videoThumbImageFile !=
                                        previous.videoThumbImageFile,
                                    builder: (context, state) {
                                      return DraftPostDialog(
                                        draftOnTap: () {
                                          if (state.videoThumbImageFile !=
                                              null) {
                                            NavigatorRoute.navigateBack(
                                                context);
                                            context
                                                .read<GoLiveCubit>()
                                                .saveDraftPost(context);
                                          } else {
                                            AppFunctions.showToast(
                                                'Right now the video is being processing, please wait.');
                                          }
                                        },
                                        cancelOnTap: () async {
                                          if (!mounted) return;
                                          if (isVideoCompressing) {
                                            _lightCompressor
                                                .cancelCompression();
                                          }
                                          NavigatorRoute.navigateBack(context);
                                          NavigatorRoute.navigateBack(context);
                                        },
                                      );
                                    })),
                            dismissDialog: true);
                      } else {
                        NavigatorRoute.navigateBack(context);
                      }
                    },
                    icon: Assets.icons.icBackArrowWhite.svg());
              }),
              title: '',
              action: [
                if (state.videoThumbImageFile != null ||
                    widget.draftData != null)
                  IconButton(
                    onPressed: isLoading || showDownloadAnimation
                        ? null
                        : () async {
                            FirebaseEvents.setFirebaseEvent(
                                'click_video_download', {});

                            setState(() {
                              isLoading = true;
                              showDownloadAnimation = false;
                            });

                            try {
                              if (Platform.isAndroid) {
                                // Android code
                                PermissionStatus? status;
                                DeviceInfoPlugin deviceInfo =
                                    DeviceInfoPlugin();
                                AndroidDeviceInfo androidInfo =
                                    await deviceInfo.androidInfo;
                                if (androidInfo.version.sdkInt >= 33) {
                                  status = await Permission.photos.request();
                                } else {
                                  status = await Permission.storage.request();
                                }
                                if (status.isGranted) {
                                  const String path =
                                      '/storage/emulated/0/Download';
                                  File? downloadedFile;
                                  String downloadedFilepath = "";
                                  if (widget.draftData != null) {
                                    if (widget.draftData?.attachment != null) {
                                      downloadedFilepath =
                                          '$path/${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}_1.mp4';
                                      await Dio().download(
                                          widget.draftData!.attachment!,
                                          downloadedFilepath);
                                      downloadedFile = File(downloadedFilepath);
                                    }
                                  } else {
                                    downloadedFilepath =
                                        '$path/${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}_1.mp4';
                                    downloadedFile = File(downloadedFilepath);
                                    await downloadedFile.writeAsBytes(
                                        await state.videoFile!.readAsBytes());
                                  }
                                  if (widget.draftData != null) {
                                    await context
                                        .read<GoLiveCubit>()
                                        .getAddressFromLatLang(
                                            latitude:
                                                widget.draftData?.latitude,
                                            longitude:
                                                widget.draftData?.longitude);
                                  }
                                  platform.invokeMethod(
                                      'scanFile', {'path': downloadedFilepath});
                                  setState(() {
                                    isLoading = false;
                                    showDownloadAnimation = true;
                                  });

                                  AppFunctions.showToast(
                                      'Video Saved Successfully to Downloads/Awaaz');
                                }
                              } else {
                                // iOS code
                                setState(() {
                                  isLoading = true;
                                  showDownloadAnimation = false;
                                });

                                PermissionStatus status =
                                    await Permission.storage.status;
                                if (status.isGranted ||
                                    await Permission.storage
                                        .request()
                                        .isGranted) {
                                  await Permission.photos.request();

                                  // Get the documents directory
                                  Directory documents =
                                      await getApplicationDocumentsDirectory();
                                  Directory dir =
                                      Directory('${documents.path}/Awaaz');
                                  if (!await dir.exists()) {
                                    await dir.create(recursive: true);
                                  }

                                  String fileName =
                                      '${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.mp4';
                                  String filePath = '${dir.path}/$fileName';

                                  File? downloadedFile;
                                  if (widget.draftData != null) {
                                    if (widget.draftData?.attachment != null) {
                                      await Dio().download(
                                        widget.draftData!.attachment!,
                                        filePath,
                                      );
                                      downloadedFile = File(filePath);
                                    }
                                  } else {
                                    downloadedFile = File(filePath);
                                    await downloadedFile.writeAsBytes(
                                        await state.videoFile!.readAsBytes());
                                  }
                                  await platform.invokeMethod(
                                      'saveVideoToGallery', {'path': filePath});
                                  setState(() {
                                    isLoading = false;
                                    showDownloadAnimation = true;
                                  });

                                  AppFunctions.showToast(
                                      'Video Saved Successfully');
                                } else {
                                  AppFunctions.showToast(
                                      'Storage permission denied');
                                  setState(() {
                                    isLoading = false;
                                    showDownloadAnimation = false;
                                  });
                                }
                              }
                            } catch (e) {
                              debugPrint(e.toString());
                              setState(() {
                                isLoading = false;
                                showDownloadAnimation = false;
                              });
                              AppFunctions.showToast('Failed to save video');
                            }
                          },
                    icon: isLoading
                        ? SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(
                              color: AppColors.whiteColor,
                            ),
                          )
                        : showDownloadAnimation
                            ? SizedBox(
                                height: 30.0,
                                width: 30.0,
                                child: Lottie.asset(Assets.animation.done.path,
                                    fit: BoxFit.contain, repeat: false),
                              )
                            : Assets.icons.icDownloadPost.svg(),
                  )
              ],
            ),
            body: BlocBuilder<GoLiveCubit, GoLiveState>(
              buildWhen: (previous, current) =>
                  previous.isLoading != current.isLoading,
              builder: (context, state) {
                return Stack(
                  children: [
                    BlocBuilder<GoLiveCubit, GoLiveState>(
                      buildWhen: (previous, current) {
                        return previous.googleAddressData !=
                            current.googleAddressData;
                      },
                      builder: (context, state) {
                        return Align(
                            alignment: Alignment(0, 0),
                            child: watermarkWidget(context));
                      },
                    ),
                    Align(
                      alignment: Alignment(0, 0),
                      child: Container(
                        height: 230.h,
                        width: double.infinity,
                        color: AppColors.blackColor,
                      ),
                    ),
                    AppCommonLoaderScreen(
                      inAsyncCall: state.isLoading,
                      child: SingleChildScrollView(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              children: [
                                SizedBox(height: 10.h),
                                BlocBuilder<GoLiveCubit, GoLiveState>(
                                  builder: (context, state) {
                                    return GestureDetector(
                                      onTap: () {
                                        if (widget.draftData != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LocalVideoPlayerScreen(
                                                videoPath:
                                                    widget.draftData?.address ??
                                                        '',
                                              ),
                                            ),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LocalVideoPlayerScreen(
                                                videoPath:
                                                    state.videoFile?.path ?? '',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: SizedBox(
                                        height: 200,
                                        width: 150,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(9),
                                          child: (widget.draftData == null)
                                              ? state.videoThumbImageFile !=
                                                      null
                                                  ? Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        SizedBox(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: AppImageViewer
                                                                .showFileImage(
                                                              file: state
                                                                  .videoThumbImageFile!,
                                                              boxFit:
                                                                  BoxFit.cover,
                                                            )),
                                                        Icon(
                                                          Icons
                                                              .play_circle_fill,
                                                          size: 30,
                                                          color: AppColors
                                                              .whiteColor,
                                                        )
                                                      ],
                                                    )
                                                  : StreamBuilder<double>(
                                                      stream: _lightCompressor
                                                          .onProgressUpdated,
                                                      builder: (context,
                                                          AsyncSnapshot<dynamic>
                                                              snapshot) {
                                                        return Stack(
                                                          children: [
                                                            Shimmer.fromColors(
                                                              baseColor: AppColors
                                                                  .actionBtnBgColor,
                                                              highlightColor:
                                                                  AppColors
                                                                      .whiteColor
                                                                      .withValues(
                                                                          alpha:
                                                                              0.2),
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: AppColors
                                                                      .actionBtnBgColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              9),
                                                                ),
                                                              ),
                                                            ),
                                                            if (snapshot
                                                                .hasData)
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: AppColors
                                                                      .actionBtnBgColor
                                                                      .withValues(
                                                                          alpha:
                                                                              0.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              9),
                                                                ),
                                                                child: Center(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      CircularProgressIndicator(
                                                                        value: (snapshot.data ??
                                                                                0) /
                                                                            100,
                                                                        color: AppColors
                                                                            .whiteColor,
                                                                        backgroundColor:
                                                                            AppColors.actionBtnBgColor,
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              10.h),
                                                                      Text(
                                                                        '${snapshot.data.toStringAsFixed(0)}%',
                                                                        style: TextStyles
                                                                            .medium(
                                                                          16.sp,
                                                                          fontColor:
                                                                              AppColors.whiteColor,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                          ],
                                                        );
                                                      })
                                              : Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: AppImageViewer
                                                          .showNetworkImage(
                                                        url: widget.draftData
                                                                ?.thumbnail ??
                                                            '',
                                                        boxFit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.play_circle_fill,
                                                      size: 30,
                                                      color:
                                                          AppColors.whiteColor,
                                                    )
                                                  ],
                                                ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 20.h),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  child: Text(
                                    'Let us know what is happening in this video',
                                    textAlign: TextAlign.center,
                                    style: TextStyles.bold(27.sp,
                                        fontFamily: testTiemposHeadline),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  child: Text(
                                    '(Optionally, submit it blank & let our operator fill it in for you later)',
                                    textAlign: TextAlign.center,
                                    style: TextStyles.bold(
                                      16.sp,
                                      fontColor: AppColors.textWhiteColor,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                BlocBuilder<GoLiveCubit, GoLiveState>(
                                  builder: (context, state) {
                                    return DropdownButtonHideUnderline(
                                      child: DropdownButton2<Category>(
                                        isExpanded: true,
                                        hint: Text(
                                          'Select Reaction',
                                          style: TextStyles.regular(18.sp,
                                              fontColor:
                                                  AppColors.textHintGrayColor),
                                        ),
                                        items: state.categoryList
                                            .map(
                                              (item) => DropdownMenuItem(
                                                value: item,
                                                child: Row(
                                                  children: [
                                                    AppImageViewer
                                                        .showNetworkImage(
                                                            url:
                                                                item.eventIcon ??
                                                                    '',
                                                            height: 30.h,
                                                            width: 30.h),
                                                    SizedBox(width: 10.w),
                                                    Text(
                                                      item.eventName ?? '',
                                                      style: TextStyles.medium(
                                                          20.sp,
                                                          fontColor: AppColors
                                                              .whiteColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        value: state.selectedPostCategory !=
                                                    null &&
                                                state.categoryList.contains(
                                                    state.selectedPostCategory)
                                            ? state.selectedPostCategory
                                            : null,
                                        onChanged: (value) {
                                          context
                                              .read<GoLiveCubit>()
                                              .updateSelectedEventCategory(
                                                  value);
                                        },
                                        buttonStyleData: ButtonStyleData(
                                          height: 65.h,
                                          decoration: BoxDecoration(
                                            color: AppColors.actionBtnBgColor,
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                          ),
                                        ),
                                        dropdownStyleData: DropdownStyleData(
                                          maxHeight: 300.h,
                                          offset: const Offset(0, -5),
                                          decoration: BoxDecoration(
                                            color: AppColors.actionBtnBgColor,
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                          ),
                                          scrollbarTheme: ScrollbarThemeData(
                                            thumbColor: WidgetStateProperty.all(
                                              AppColors.actionBtnBgColor
                                                  .withValues(alpha: 0.5),
                                            ),
                                            radius: Radius.circular(10.r),
                                            thickness:
                                                WidgetStateProperty.all(4),
                                          ),
                                        ),
                                        menuItemStyleData: MenuItemStyleData(
                                          height: 50.h,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 10.h),
                                BlocBuilder<GoLiveCubit, GoLiveState>(
                                  buildWhen: (previous, current) =>
                                      previous.titleController !=
                                      current.titleController,
                                  builder: (context, state) {
                                    return CommonMainTextField(
                                      height: 65.h,
                                      hintText: 'Enter title',
                                      controller: state.titleController!,
                                      radius: BorderRadius.circular(10.r),
                                      // labelText: 'Title',
                                    );
                                  },
                                ),
                                /*spaceH(10.h),
                              BlocBuilder<GoLiveCubit, GoLiveState>(
                                buildWhen: (previous, current) =>
                                    previous.addressController !=
                                    current.addressController,
                                builder: (context, state) {
                                  return CommonMainTextField(
                                    height:
                                        (state.addressController?.text.isEmpty ?? true)
                                            ? null
                                            : 120.h,
                                    hintText: 'Enter address',
                                    controller: state.addressController!,
                                    radius: BorderRadius.circular(10.r),
                                    // labelText: 'Address',
                                  );
                                },
                              ),*/
                                SizedBox(height: 10.h),
                                BlocBuilder<GoLiveCubit, GoLiveState>(
                                  buildWhen: (previous, current) =>
                                      previous.descriptionController !=
                                      current.descriptionController,
                                  builder: (context, state) {
                                    return CommonMainTextField(
                                      height: 80.h,
                                      hintText: 'Enter additional details',
                                      controller: state.descriptionController!,
                                      radius: BorderRadius.circular(10.r),
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.newline,
                                      minLines: 1,
                                      maxLines: 2,
                                      // labelText: 'Additional Details',
                                      textFieldAlignment: Alignment.topCenter,
                                    );
                                  },
                                ),
                                SizedBox(height: 10.h),
                                BlocBuilder<GoLiveCubit, GoLiveState>(
                                  buildWhen: (previous, current) =>
                                      previous.hashTagController !=
                                      current.hashTagController,
                                  builder: (context, state) {
                                    return CommonMainTextField(
                                      height: 80.h,
                                      hintText:
                                          'Enter #Hashtags Separated by Space',
                                      controller: state.hashTagController!,
                                      radius: BorderRadius.circular(10.r),
                                      minLines: 1,
                                      maxLines: 2,
                                      // labelText: '#Hashtag',
                                      textFieldAlignment: Alignment.topCenter,
                                      inputFormatters: [
                                        HashtagInputFormatter()
                                      ],
                                    );
                                  },
                                ),
                                SizedBox(height: 10.h),
                                Row(
                                  children: [
                                    BlocBuilder<GoLiveCubit, GoLiveState>(
                                      buildWhen: (previous, current) =>
                                          previous.shareAnonymous !=
                                          current.shareAnonymous,
                                      builder: (context, state) {
                                        return Row(
                                          children: [
                                            AppCheckBox(
                                              isChecked: state.shareAnonymous,
                                              onChanged: (val) {
                                                context
                                                    .read<GoLiveCubit>()
                                                    .changeShareAnonymouslyValue(
                                                        val ?? false);
                                              },
                                            ),
                                            InkWell(
                                              onTap: () {
                                                context
                                                    .read<GoLiveCubit>()
                                                    .changeShareAnonymouslyValue(
                                                        !state.shareAnonymous);
                                              },
                                              child: Text(
                                                'Share Anonymously',
                                                style:
                                                    TextStyles.regular(16.sp),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15.h),
                                BlocBuilder<GoLiveCubit, GoLiveState>(
                                    buildWhen: (previous, current) {
                                  return previous.totalUsers !=
                                      current.totalUsers;
                                }, builder: (context, state) {
                                  return Text(
                                    'Your post will only go live on map, Once our oprator will review it. It may take 1-2 minitues no time.',
                                    style: TextStyles.medium(16.sp),
                                  );
                                }),
                                SizedBox(height: 20.h),
                                BlocBuilder<GoLiveCubit, GoLiveState>(
                                    builder: (context, state) {
                                  if (state.videoThumbImageFile != null ||
                                      widget.draftData != null) {
                                    return Column(
                                      children: [
                                        CommonButton(
                                            onPressed: isSubmitPostLoading
                                                ? null
                                                : () {
                                                    isSubmitPostLoading = true;
                                                    setState(() {});
                                                    FirebaseEvents
                                                        .setFirebaseEvent(
                                                            'click_video_post_btn',
                                                            {});
                                                    if (widget.draftData ==
                                                        null) {
                                                      context
                                                          .read<GoLiveCubit>()
                                                          .validatePostFields(
                                                              attachmentVideo:
                                                                  state
                                                                      .videoFile!,
                                                              context: context,
                                                              attachmentThumbnailImageFile:
                                                                  state
                                                                      .videoThumbImageFile!,
                                                              onSubmit: (val) {
                                                                isSubmitPostLoading =
                                                                    val;
                                                                setState(() {});
                                                              });
                                                    } else {
                                                      context
                                                          .read<GoLiveCubit>()
                                                          .createDraftToPost(
                                                              draftData: widget
                                                                  .draftData!,
                                                              context: context,
                                                              onSubmit: (val) {
                                                                isSubmitPostLoading =
                                                                    val;
                                                                setState(() {});
                                                              });
                                                    }
                                                  },
                                            color: AppColors.whiteColor,
                                            widget: isSubmitPostLoading
                                                ? SizedBox(
                                                    height: 20.0,
                                                    width: 20.0,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color:
                                                          AppColors.whiteColor,
                                                    ),
                                                  )
                                                : Text(
                                                    'POST',
                                                    style: TextStyles.semiBold(
                                                        18.sp,
                                                        fontColor:
                                                            Colors.black),
                                                  )),
                                        // SizedBox(height: 20.h),
                                        // widget.draftData == null &&
                                        //         !isSubmitPostLoading
                                        //     ? CommonButton(
                                        //         onPressed: isSubmitDraftLoading
                                        //             ? null
                                        //             : () {
                                        //                 setState(() {
                                        //                   isSubmitDraftLoading =
                                        //                       true;
                                        //                 });
                                        //                 FirebaseEvents
                                        //                     .setFirebaseEvent(
                                        //                         'click_video_draft_btn',
                                        //                         {});
                                        //                 context
                                        //                     .read<GoLiveCubit>()
                                        //                     .saveDraftPost(
                                        //                         attachmentVideo:
                                        //                             state
                                        //                                 .videoFile!,
                                        //                         context:
                                        //                             context,
                                        //                         attachmentThumbnailImageFile:
                                        //                             state
                                        //                                 .videoThumbImageFile!,
                                        //                         onSubmit:
                                        //                             (val) {
                                        //                           isSubmitPostLoading =
                                        //                               val;
                                        //                           setState(
                                        //                               () {});
                                        //                         });
                                        //               },
                                        //         color: AppColors.redColor,
                                        //         widget: isSubmitDraftLoading
                                        //             ? SizedBox(
                                        //                 height: 20.0,
                                        //                 width: 20.0,
                                        //                 child:
                                        //                     CircularProgressIndicator(
                                        //                   color: AppColors
                                        //                       .whiteColor,
                                        //                 ),
                                        //               )
                                        //             : Text(
                                        //                 'DRAFT',
                                        //                 style:
                                        //                     TextStyles.semiBold(
                                        //                         18.sp,
                                        //                         fontColor:
                                        //                             Colors
                                        //                                 .white),
                                        //               ))
                                        //     : SizedBox(),
                                      ],
                                    );
                                  } else {
                                    return SizedBox.shrink();
                                  }
                                }),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget watermarkWidget(BuildContext context) {
    return BlocBuilder<GoLiveCubit, GoLiveState>(
        buildWhen: (previous, current) {
      return previous.googleAddressData != current.googleAddressData;
    }, builder: (context, state) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: RepaintBoundary(
            key: globalKey,

            /// =*=*=*=*=*=*= VARIENT-3 =*=*=*=*=*=*=
            child: (PrefService.getInt(PrefService.addressStampIndex) == 2)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 160.h,
                        width: 170.h,
                        padding: EdgeInsets.only(
                            top: 5.h, left: 10.w, bottom: 2.h, right: 5.w),
                        decoration: BoxDecoration(
                          color: AppColors.blackColor.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                              color:
                                  AppColors.whiteColor.withValues(alpha: 0.25)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.googleAddressData?.results?.first
                                      .addressComponents?[0].shortName ??
                                  '',
                              maxLines: 1,
                              style: TextStyles.semiBold(
                                16.sp,
                                fontColor: AppColors.whiteColor,
                              ),
                            ),
                            Divider(
                              color: AppColors.whiteColor,
                              thickness: 2.sp,
                              height: 10,
                            ),
                            Text(
                              state.googleAddressData?.results?.first
                                      .formattedAddress ??
                                  '',
                              maxLines: 5,
                              style: TextStyles.medium(
                                16.sp,
                                fontColor: AppColors.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(10.w),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 160.h,
                            width: 160.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(Assets.images.map.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Gap(7.h),
                          Container(
                            height: 55.h,
                            width: 160.h,
                            decoration: BoxDecoration(
                              color:
                                  AppColors.blackColor.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                  color: AppColors.whiteColor
                                      .withValues(alpha: 0.25)),
                            ),
                            padding: EdgeInsets.only(left: 5.w),
                            child: Row(
                              children: [
                                Assets.images.awazLogoWebp
                                    .image(height: 40.h, width: 40.h),
                                Gap(6.w),
                                Text(
                                  'Awaaz App',
                                  style: TextStyles.semiBold(
                                    16.sp,
                                    fontColor: AppColors.whiteColor,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Gap(10.w),
                      Container(
                        height: 160.h,
                        width: 170.h,
                        padding: EdgeInsets.only(
                            top: 10.h, left: 10.w, bottom: 8.h, right: 8.w),
                        decoration: BoxDecoration(
                          color: AppColors.blackColor.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                              color:
                                  AppColors.whiteColor.withValues(alpha: 0.25)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lat : ${widget.draftData?.latitude ?? state.userLatitude}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.medium(16.sp,
                                  fontColor: AppColors.whiteColor),
                            ),
                            Text(
                              'Lang : ${widget.draftData?.longitude ?? state.userLongitude}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.medium(16.sp,
                                  fontColor: AppColors.whiteColor),
                            ),
                            Divider(
                              color: AppColors.whiteColor,
                              thickness: 2.sp,
                              height: 10,
                            ),
                            Text(
                              DateFormat("EEEE").format(DateTime.now()),
                              style: TextStyles.medium(
                                16.5.sp,
                                fontColor: AppColors.whiteColor,
                              ),
                            ),
                            Text(
                              DateFormat("dd MMM yyyy").format(DateTime.now()),
                              style: TextStyles.medium(
                                16.5.sp,
                                fontColor: AppColors.whiteColor,
                              ),
                            ),
                            Text(
                              DateFormat("hh:mm:ss a").format(DateTime.now()),
                              style: TextStyles.medium(
                                16.5.sp,
                                fontColor: AppColors.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : (PrefService.getInt(PrefService.addressStampIndex) == 1)
                    ?

                    /// DON'T REMOVE IN ANY HOW
                    /// =*=*=*=*=*=*= VARIENT-2 =*=*=*=*=*=*=
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 160.h,
                            width: 170.h,
                            padding: EdgeInsets.only(
                                top: 5.h, left: 10.w, bottom: 2.h, right: 5.w),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.blackColor.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                  color: AppColors.whiteColor
                                      .withValues(alpha: 0.25)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.googleAddressData?.results?.first
                                          .addressComponents?[0].shortName ??
                                      '',
                                  maxLines: 1,
                                  style: TextStyles.semiBold(
                                    16.sp,
                                    fontColor: AppColors.whiteColor,
                                  ),
                                ),
                                Divider(
                                  color: AppColors.whiteColor,
                                  thickness: 2.sp,
                                  height: 10,
                                ),
                                Text(
                                  state.googleAddressData?.results?.first
                                          .formattedAddress ??
                                      '',
                                  maxLines: 5,
                                  style: TextStyles.medium(
                                    16.sp,
                                    fontColor: AppColors.whiteColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Gap(10.w),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Assets.images.map.image(
                                height: 150.h,
                                width: 150.h,
                              ),
                              Gap(7.h),
                              Container(
                                height: 55.h,
                                width: 150.h,
                                decoration: BoxDecoration(
                                  color: AppColors.blackColor
                                      .withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                      color: AppColors.whiteColor
                                          .withValues(alpha: 0.25)),
                                ),
                                padding: EdgeInsets.only(left: 5.w),
                                child: Row(
                                  children: [
                                    Assets.images.awazLogoWebp
                                        .image(height: 40.h, width: 40.h),
                                    Gap(6.w),
                                    Text(
                                      'Awaaz App',
                                      style: TextStyles.semiBold(
                                        16.sp,
                                        fontColor: AppColors.whiteColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Gap(10.w),
                          Container(
                            height: 160.h,
                            width: 170.h,
                            padding: EdgeInsets.only(
                                top: 10.h, left: 10.w, bottom: 8.h, right: 8.w),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.blackColor.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                  color: AppColors.whiteColor
                                      .withValues(alpha: 0.25)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lat : ${widget.draftData?.latitude ?? state.userLatitude}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyles.medium(16.sp,
                                      fontColor: AppColors.whiteColor),
                                ),
                                Text(
                                  'Lang : ${widget.draftData?.longitude ?? state.userLongitude}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyles.medium(16.sp,
                                      fontColor: AppColors.whiteColor),
                                ),
                                Divider(
                                  color: AppColors.whiteColor,
                                  thickness: 2.sp,
                                  height: 10,
                                ),
                                Text(
                                  DateFormat("EEEE").format(DateTime.now()),
                                  style: TextStyles.medium(
                                    16.5.sp,
                                    fontColor: AppColors.whiteColor,
                                  ),
                                ),
                                Text(
                                  DateFormat("dd MMM yyyy")
                                      .format(DateTime.now()),
                                  style: TextStyles.medium(
                                    16.5.sp,
                                    fontColor: AppColors.whiteColor,
                                  ),
                                ),
                                Text(
                                  DateFormat("hh:mm:ss a")
                                      .format(DateTime.now()),
                                  style: TextStyles.medium(
                                    16.5.sp,
                                    fontColor: AppColors.whiteColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : (PrefService.getInt(PrefService.addressStampIndex) == 0)
                        ?

                        /// DON'T REMOVE IN ANY HOW
                        /// =*=*=*=*=*=*= VARIENT-1 =*=*=*=*=*=*=
                        Row(
                            children: [
                              Container(
                                height: 170.h,
                                width: 170.h,
                                padding: EdgeInsets.only(
                                    top: 10.h,
                                    left: 10.w,
                                    bottom: 10.h,
                                    right: 10.w),
                                decoration: BoxDecoration(
                                  color: AppColors.blackColor
                                      .withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                      color: AppColors.whiteColor
                                          .withValues(alpha: 0.25)),
                                ),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Assets.images.awazLogoWebp
                                              .image(height: 45.h, width: 45.h),
                                          Gap(6.w),
                                          Text(
                                            'Awaaz',
                                            style: TextStyles.semiBold(
                                              20.sp,
                                              fontColor: AppColors.whiteColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Gap(16.h),
                                      Text(
                                        DateFormat("dd MMM yyyy")
                                            .format(DateTime.now()),
                                        style: TextStyles.medium(
                                          24.sp,
                                          fontColor: AppColors.whiteColor,
                                        ),
                                      ),
                                      Text(
                                        DateFormat("EEEE")
                                            .format(DateTime.now()),
                                        style: TextStyles.semiBold(
                                          17.sp,
                                          fontColor: AppColors.whiteColor,
                                        ),
                                      ),
                                      Text(
                                        DateFormat("hh:mm:ss a")
                                            .format(DateTime.now()),
                                        style: TextStyles.regular(
                                          19.sp,
                                          fontColor: AppColors.whiteColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Gap(8.w),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 102.h,
                                    width: 300.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.blackColor
                                          .withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                          color: AppColors.whiteColor
                                              .withValues(alpha: 0.25)),
                                    ),
                                    padding: EdgeInsets.only(
                                        top: 10.h,
                                        left: 10.w,
                                        right: 10.w,
                                        bottom: 10.h),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            state.googleAddressData?.results
                                                    ?.first.formattedAddress ??
                                                '',
                                            maxLines: 4,
                                            style: TextStyles.medium(15.sp,
                                                fontColor:
                                                    AppColors.whiteColor),
                                          ),
                                        ),
                                        Container(
                                          height: 65,
                                          width: 65,
                                          decoration: BoxDecoration(
                                            color: AppColors.blackColor
                                                .withValues(alpha: 0.5),
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    Assets.images.map.path)),
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                        ),
                                        Gap(3.w),
                                      ],
                                    ),
                                  ),
                                  Gap(5.h),
                                  Container(
                                    height: 62.h,
                                    width: 300.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.blackColor
                                          .withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                          color: AppColors.whiteColor
                                              .withValues(alpha: 0.25)),
                                    ),
                                    padding: EdgeInsets.only(
                                        top: 10.h,
                                        left: 10.w,
                                        right: 10.w,
                                        bottom: 10.h),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Latitude\n${widget.draftData?.latitude ?? state.userLatitude}',
                                            style: TextStyles.medium(15.sp,
                                                fontColor:
                                                    AppColors.whiteColor),
                                          ),
                                        ),
                                        Gap(10.w),
                                        VerticalDivider(
                                            color: AppColors.whiteColor),
                                        Gap(10.w),
                                        Text(
                                          'Longitude\n${widget.draftData?.longitude ?? state.userLongitude}',
                                          style: TextStyles.medium(15.sp,
                                              fontColor: AppColors.whiteColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Container()),
      );
    });
  }

  String getVideoSize({required File file}) =>
      formatBytes(file.lengthSync(), 2);

  /// Formats bytes and returns a string
  String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) {
      return '0 B';
    }
    const List<String> suffixes = <String>[
      'B',
      'KB',
      'MB',
      'GB',
      'TB',
      'PB',
      'EB',
      'ZB',
      'YB',
    ];
    final int i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}
