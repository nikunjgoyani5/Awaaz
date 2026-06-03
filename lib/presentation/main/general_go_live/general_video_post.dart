import 'dart:io';
import 'dart:math';

// import 'dart:ui' as ui;

import 'package:country_code_picker/country_code_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:light_compressor_v2/light_compressor_v2.dart' as light;
import 'dart:developer' as developer;
import 'package:eagle_eye/core/constant/app_constant.dart';
import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/utils/app_functions.dart';
import 'package:eagle_eye/core/utils/app_prefrence.dart';
import 'package:eagle_eye/core/widget/app_common_loader_screen.dart';
import 'package:eagle_eye/core/widget/common_app_bar.dart';
import 'package:eagle_eye/core/widget/common_app_image_show.dart';
import 'package:eagle_eye/core/widget/common_button.dart';
import 'package:eagle_eye/data/models/draft_event_model.dart';
import 'package:eagle_eye/gen/assets.gen.dart';
import 'package:eagle_eye/presentation/main/go_live_screen/local_video_play_screen.dart';
import 'package:eagle_eye/routes/app_navigation.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';

// import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lottie/lottie.dart';

import '../../../core/theme/text_styles.dart';
import '../../../core/widget/common_alert_dialogue.dart';
import '../../../core/widget/common_textfield.dart';
import '../../../data/models/general_category_model.dart';
import '../../../routes/app_routes.dart';
import 'bloc/general_post_cubit.dart';

///temp//
// TextEditingController locationControllerGen = TextEditingController();
// num? lat;
// num? log;

class GeneralVideoPostScreen extends StatefulWidget {
  // final File? state.videoFile;
  // final File? state.videoThumbImageFile;
  final DraftData? draftData;
  final XFile? videoFile;

  const GeneralVideoPostScreen(
      {super.key,
      // this.state.videoFile,
      // this.state.videoThumbImageFile,
      this.draftData,
      this.videoFile});

  @override
  State<GeneralVideoPostScreen> createState() => _GeneralVideoPostScreenState();
}

class _GeneralVideoPostScreenState extends State<GeneralVideoPostScreen> {
  bool isLoading = false;
  bool isSubmitPostLoading = false;
  bool showDownloadAnimation = false;
  final light.LightCompressor _lightCompressor = light.LightCompressor();
  bool isVideoCompressed = false;
  XFile? videoFile;
  File? _videoThumbnailImageFile;
  bool isVideoCompressing = false;
  final platform = MethodChannel('com.example.app/media_scanner');

  ///////////////////////////

  // TextEditingController titleController = TextEditingController();
  // TextEditingController descriptionController = TextEditingController();
  // TextEditingController phoneNumberController = TextEditingController();

  // String? countryCode;
  // List<CategorysModel>? categorysModel;
  // List<SubCategory>? subCategoryList;
  // CategorysModel? selectedMainCat;
  // SubCategory? selectedSubCat;

  // Future<void> getCategory() async {
  //   try {
  //     ResponseModel response = await MainRepository.generalEventCat();
  //     if (response.status == true) {
  //       GeneralCategoryModel generalCategoryModel =
  //           GeneralCategoryModel.fromJson(response.toJson());
  //       categorysModel = generalCategoryModel.categorysModel ?? [];
  //       setState(() {});
  //       print("-+-+-+-+-+-+-+-+-+-+-+-+-${generalCategoryModel.toJson()}");
  //       print("-+-+-+-+-+-+-+-+-+-+-+-+-85${categorysModel}");
  //       AppFunctions.showToast(response.message);
  //     } else {
  //       AppFunctions.showToast(response.message);
  //     }
  //   } catch (e) {
  //     AppFunctions.showToast(e.toString());
  //     debugPrint('Cache Error ${e.toString()}');
  //   }
  // }

  // Future<ResponseModel?> generalPostCreate() async {
  //   try {
  //     final response = await MainRepository.generalAddPostApi(data: {
  //       "postType": "general_category",
  //       "latitude": lat,
  //       "longitude": log,
  //       "title": titleController.text,
  //       "additionalDetails": descriptionController.text,
  //       "eventTime": DateTime.now().toIso8601String(),
  //       "address": locationControllerGen.text,
  //       "countryCode": countryCode,
  //       "additionMobileNumber": phoneNumberController.text,

  //       "hashTags[]": "",
  //       "shareAnonymous": false,
  //       "mainCategoryId": selectedMainCat?.id,
  //       "subCategoryId": selectedSubCat?.id,
  //     });
  //     AppFunctions.showToast(response.message);
  //     return response;
  //   } catch (e) {
  //     AppFunctions.showToast(e.toString());
  //     // log("Check Username error is here :- $e");
  //     return null;
  //   }
  // }

  // Future<ResponseModel?> generalPostDraft() async {
  //   try {
  //     final response = await MainRepository.generalPostDraft(data: {
  //       "postType": "general_category",
  //       "latitude": lat,
  //       "longitude": log,
  //       "title": titleController.text,
  //       "additionalDetails": descriptionController.text,
  //       "eventTime": DateTime.now().toIso8601String(),
  //       "address": locationControllerGen.text,
  //       "countryCode": countryCode,
  //       "additionMobileNumber": phoneNumberController.text,

  //       "hashTags[]": "",
  //       "shareAnonymous": false,
  //       "mainCategoryId": selectedMainCat?.id,
  //       "subCategoryId": selectedSubCat?.id,
  //     });
  //     if (response.status == true) {
  //       NavigatorRoute.navigateToRemoveUntil(context, AppRoutes.home);
  //     }
  //     AppFunctions.showToast(response.message);
  //     return response;
  //   } catch (e) {
  //     AppFunctions.showToast(e.toString());
  //     return null;
  //   }
  // }

  @override
  void dispose() {
    if (isVideoCompressing) {
      _lightCompressor.cancelCompression();
    }
    super.dispose();
  }

  @override
  void initState() {
    if (widget.draftData == null) {
      context.read<GeneralPostCubit>().getCategory();
    }

    if (widget.videoFile != null) {
      Future.delayed(
        Duration.zero,
        () async {
          if (!mounted) return;
          setState(() {
            isVideoCompressing = true;
          });
          Directory tempDir = await getTemporaryDirectory();
          final light.Result response = await _lightCompressor.compressVideo(
            path: widget.videoFile!.path,
            videoQuality: light.VideoQuality.medium,
            isMinBitrateCheckEnabled: false,
            video: light.Video(videoName: "${DateTime.now().millisecondsSinceEpoch}"),
            android: light.AndroidConfig(isSharedStorage: false),
            ios: light.IOSConfig(saveInGallery: false),
          );

          if (!mounted) return;
          String finalPath = '${tempDir.path}/${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.mp4';
          if (response is light.OnSuccess) {
            String finalDesPath = "";
            if (!mounted) return;
            setState(() {
              finalDesPath = response.destinationPath;
            });
            developer.log("Original File Size: ${getVideoSize(file: File(widget.videoFile!.path))} bytes");
            developer.log("After Compress File Size: ${getVideoSize(file: File(finalDesPath))} bytes");
            File finalFile = await File(finalPath).writeAsBytes(await File(finalDesPath).readAsBytes());
            File(finalDesPath).deleteSync();
            videoFile = XFile(File(finalFile.path).path);
            if (!mounted) return;
            await generateThumbnail(File(videoFile?.path ?? ''));
          } else {
            if (!mounted) return;
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
      context.read<GeneralPostCubit>().setVideoFile(File(videoFile!.path), _videoThumbnailImageFile!);
      if (mounted) setState(() {});
      setState(() {
        isVideoCompressing = false;
      });
    } catch (e) {
      setState(() {
        isVideoCompressing = false;
      });
      debugPrint('Error generating thumbnail: $e');
    }
  }

  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeneralPostCubit, GeneralPostState>(
      builder: (context, state) {
        return PopScope(
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
                  dialogWidget: BlocBuilder<GeneralPostCubit, GeneralPostState>(
                    buildWhen: (previous, current) => current.videoThumbImageFile != previous.videoThumbImageFile,
                    builder: (context, state) {
                      return DraftPostDialog(
                        draftOnTap: () {
                          if (state.videoThumbImageFile != null) {
                            NavigatorRoute.navigateBack(context); // Pop the dialog
                            context.read<GeneralPostCubit>().generalPostDraft(context);
                          } else {
                            AppFunctions.showToast('Right now the video is being processing, please wait.');
                          }
                        },
                        cancelOnTap: () async {
                          if (!mounted) return;
                          if (isVideoCompressing) {
                            _lightCompressor.cancelCompression();
                          }
                          NavigatorRoute.navigateBack(context); // Pop the dialog
                          NavigatorRoute.navigateBack(context); // Pop the current screen
                        },
                      );
                    },
                  ),
                ),
                dismissDialog: true,
              );
            } else {
              Future.delayed(Duration(milliseconds: 200), () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context); // Manually pop the current screen after delay
                }
              });
            }
          },
          canPop: isSubmitPostLoading,

          // onWillPop: () async {
          //   if (!isSubmitPostLoading) {
          //     closeKeyboard();
          //     if (widget.draftData == null) {
          //       showAppDialog(
          //           context,
          //           CommonAlertDialogue(
          //               dialogWidget:
          //                   BlocBuilder<GeneralPostCubit, GeneralPostState>(
          //                       buildWhen: (previous, current) =>
          //                           current.videoThumbImageFile !=
          //                           previous.videoThumbImageFile,
          //                       builder: (context, state) {
          //                         return DraftPostDialog(
          //                           draftOnTap: () {
          //                             if (state.videoThumbImageFile != null) {
          //                               NavigatorRoute.navigateBack(context);
          //                               context
          //                                   .read<GeneralPostCubit>()
          //                                   .generalPostDraft(context);
          //                             } else {
          //                               AppFunctions.showToast(
          //                                   'Right now the video is being processing, please wait.');
          //                             }
          //                           },
          //                           cancelOnTap: () async {
          //                             if (!mounted) return;
          //                             if (isVideoCompressing) {
          //                               _lightCompressor.cancelCompression();
          //                             }
          //                             NavigatorRoute.navigateBack(context);
          //                             NavigatorRoute.navigateBack(context);
          //                           },
          //                         );
          //                       })),
          //           dismissDialog: true);
          //       return false;
          //     } else {
          //       Future.delayed(Duration(milliseconds: 200), () {
          //         if (Navigator.canPop(context)) {
          //           Navigator.pop(context);
          //         }
          //       });
          //       return false;
          //     }
          //   }
          //   return isSubmitPostLoading ? false : true;
          // },
          child: Scaffold(
            appBar: AppCommonAppBar(
              leading: BlocBuilder<GeneralPostCubit, GeneralPostState>(builder: (context, state) {
                return IconButton(
                    onPressed: () {
                      closeKeyboard();
                      if (widget.draftData == null) {
                        showAppDialog(
                            context,
                            CommonAlertDialogue(
                                dialogWidget: BlocBuilder<GeneralPostCubit, GeneralPostState>(
                                    buildWhen: (previous, current) =>
                                        current.videoThumbImageFile != previous.videoThumbImageFile,
                                    builder: (context, state) {
                                      return DraftPostDialog(
                                        draftOnTap: () {
                                          if (state.videoThumbImageFile != null) {
                                            NavigatorRoute.navigateBack(context);
                                            context.read<GeneralPostCubit>().generalPostDraft(context);
                                          } else {
                                            AppFunctions.showToast(
                                                'Right now the video is being processing, please wait.');
                                          }
                                        },
                                        cancelOnTap: () async {
                                          if (!mounted) return;
                                          if (isVideoCompressing) {
                                            _lightCompressor.cancelCompression();
                                          }
                                          setState(() {});
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
                if (state.videoThumbImageFile != null || widget.draftData != null)
                  IconButton(
                    onPressed: isLoading || showDownloadAnimation
                        ? null
                        : () async {
                            FirebaseEvents.setFirebaseEvent('click_video_download', {});
                            setState(() {
                              isLoading = true;
                              showDownloadAnimation = false;
                            });

                            try {
                              if (Platform.isAndroid) {
                                // Android code
                                PermissionStatus? status;
                                DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                                AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                                if (androidInfo.version.sdkInt >= 33) {
                                  status = await Permission.photos.request();
                                } else {
                                  status = await Permission.storage.request();
                                }
                                if (status.isGranted) {
                                  const String path = '/storage/emulated/0/Download';
                                  File? downloadedFile;
                                  String downloadedFilepath = "";
                                  if (widget.draftData != null) {
                                    if (widget.draftData?.attachment != null) {
                                      downloadedFilepath =
                                          '$path/${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}_1.mp4';
                                      await Dio().download(widget.draftData!.attachment!, downloadedFilepath);
                                      downloadedFile = File(downloadedFilepath);
                                    }
                                  } else {
                                    downloadedFilepath =
                                        '$path/${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}_1.mp4';
                                    downloadedFile = File(downloadedFilepath);
                                    await downloadedFile.writeAsBytes(await state.videoFile!.readAsBytes());
                                  }
                                  // Directory tempDir =
                                  //     await getTemporaryDirectory();
                                  // if (await File(
                                  //             '${tempDir.path}/awaz_watermark.png')
                                  //         .exists() ==
                                  //     false) {
                                  //   ByteData byteData = await rootBundle
                                  //       .load(Assets.icons.icWaterMarkAwaaz.path);
                                  //   Uint8List uint8List =
                                  //       byteData.buffer.asUint8List();
                                  //   File wmImg = File(
                                  //       '${tempDir.path}/awaz_watermark.png');
                                  //   await wmImg.writeAsBytes(uint8List);
                                  // }
                                  // File watermarkImage =
                                  //     File('${tempDir.path}/awaz_watermark.png');

                                  // String overlayPosition =
                                  //     getRandomOverlayPosition();
                                  // String outputPath =
                                  //     '$path/${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}_2.mp4';
                                  // String command =
                                  //     '-i ${downloadedFile?.path} -i ${watermarkImage.path} -filter_complex "[1:v]scale=-1:160[wm];[0:v][wm]$overlayPosition" -c:v mpeg4 -q:v 2 -c:a copy $outputPath';
                                  // await FFmpegKit.execute(command);
                                  // File(downloadedFile!.path).deleteSync();
                                  // String newOutputPath =
                                  //     '$path/${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.mp4';
                                  // if (context
                                  //     .read<GoLiveCubit>()
                                  //     .getAddressWatermarkValue()) {
                                  if (widget.draftData != null) {
                                    await context.read<GeneralPostCubit>().getAddressFromLatLang(
                                        latitude: widget.draftData?.latitude, longitude: widget.draftData?.longitude);
                                  }
                                  platform.invokeMethod('scanFile', {'path': downloadedFilepath});
                                  setState(() {
                                    isLoading = false;
                                    showDownloadAnimation = true;
                                  });

                                  AppFunctions.showToast('Video Saved Successfully to Downloads/Awaaz');
                                }
                              } else {
                                setState(() {
                                  isLoading = true;
                                });
                                // Ios code
                                PermissionStatus status = await Permission.storage.status;
                                if (status.isGranted || await Permission.storage.request().isGranted) {
                                  await Permission.photos.request();
                                  Directory documents = await getApplicationDocumentsDirectory();
                                  // if (!(await documents.exists())) {
                                  //   await documents.create(recursive: true);
                                  // }
                                  Directory dir = Directory(documents.path);
                                  if (await dir.exists() == false) {
                                    await dir.create(recursive: true);
                                  }
                                  String path = dir.path;
                                  File? downloadedFile;
                                  String downloadedFilepath = "";
                                  if (widget.draftData != null) {
                                    if (widget.draftData?.attachment != null) {
                                      downloadedFilepath =
                                          '$path/${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}_1.mp4';
                                      debugPrint(
                                          'Downloading video to: $downloadedFilepath'); // Debug: Check download path
                                      await Dio().download(widget.draftData!.attachment!, downloadedFilepath);
                                      downloadedFile = File(downloadedFilepath);
                                    }
                                  } else {
                                    downloadedFilepath =
                                        '$path/${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}_1.mp4';
                                    downloadedFile =
                                        File('$path/${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}_1.mp4');
                                    await downloadedFile.writeAsBytes(await state.videoFile!.readAsBytes());
                                  }

                                  if (widget.draftData != null) {
                                    await context.read<GeneralPostCubit>().getAddressFromLatLang(
                                        latitude: widget.draftData?.latitude, longitude: widget.draftData?.longitude);
                                  }
                                  await platform.invokeMethod('saveVideoToGallery', {'path': downloadedFilepath});
                                  setState(() {
                                    isLoading = false;
                                    showDownloadAnimation = true;
                                  });
                                  AppFunctions.showToast('Video Saved Successfully');
                                  // }
                                } else {
                                  debugPrint('Storage permission is not granted'); // Debug: Permission issue
                                }
                              }
                            } catch (e) {
                              debugPrint(e.toString());
                              setState(() {
                                isLoading = false;
                                showDownloadAnimation = false;
                              });
                              // cubit.updateState(
                              //     cubit.state.copyWith(isLoading: false));
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
                                child: Lottie.asset(
                                  Assets.animation.done.path,
                                  fit: BoxFit.contain,
                                  repeat: false,
                                ),
                              )
                            : Assets.icons.icDownloadPost.svg(),
                  )
              ],
            ),
            body: BlocBuilder<GeneralPostCubit, GeneralPostState>(
              buildWhen: (previous, current) => previous.isLoading != current.isLoading,
              builder: (context, state) {
                return Stack(
                  children: [
                    BlocBuilder<GeneralPostCubit, GeneralPostState>(
                      builder: (context, state) {
                        return Align(alignment: Alignment(0, 0), child: watermarkWidget(context));
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
                                BlocBuilder<GeneralPostCubit, GeneralPostState>(
                                  builder: (context, state) {
                                    return GestureDetector(
                                      onTap: () {
                                        if (widget.draftData != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LocalVideoPlayerScreen(
                                                videoPath: widget.draftData?.attachment ?? '',
                                                isDraft: true,
                                              ),
                                            ),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LocalVideoPlayerScreen(
                                                videoPath: state.videoFile?.path ?? '',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: SizedBox(
                                        height: 200,
                                        width: 150,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(9),
                                          child: (widget.draftData == null)
                                              ? state.videoThumbImageFile != null
                                                  ? Stack(
                                                      alignment: Alignment.center,
                                                      children: [
                                                        SizedBox(
                                                            width: MediaQuery.of(context).size.width,
                                                            child: AppImageViewer.showFileImage(
                                                              file: state.videoThumbImageFile!,
                                                              boxFit: BoxFit.cover,
                                                            )),
                                                        Icon(
                                                          Icons.play_circle_fill,
                                                          size: 30,
                                                          color: AppColors.whiteColor,
                                                        )
                                                      ],
                                                    )
                                                  : StreamBuilder<double>(
                                                      stream: _lightCompressor.onProgressUpdated,
                                                      builder: (context, AsyncSnapshot<dynamic> snapshot) {
                                                        return Stack(
                                                          children: [
                                                            Shimmer.fromColors(
                                                              baseColor: AppColors.actionBtnBgColor,
                                                              highlightColor:
                                                                  AppColors.whiteColor.withValues(alpha: 0.2),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  color: AppColors.actionBtnBgColor,
                                                                  borderRadius: BorderRadius.circular(9),
                                                                ),
                                                              ),
                                                            ),
                                                            if (snapshot.hasData)
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                  color:
                                                                      AppColors.actionBtnBgColor.withValues(alpha: 0.5),
                                                                  borderRadius: BorderRadius.circular(9),
                                                                ),
                                                                child: Center(
                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      CircularProgressIndicator(
                                                                        value: (snapshot.data ?? 0) / 100,
                                                                        color: AppColors.whiteColor,
                                                                        backgroundColor: AppColors.actionBtnBgColor,
                                                                      ),
                                                                      SizedBox(height: 10.h),
                                                                      Text(
                                                                        '${snapshot.data.toStringAsFixed(0)}%',
                                                                        style: TextStyles.medium(
                                                                          16.sp,
                                                                          fontColor: AppColors.whiteColor,
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
                                                      width: MediaQuery.of(context).size.width,
                                                      child: AppImageViewer.showNetworkImage(
                                                        url: widget.draftData?.thumbnail ?? '',
                                                        boxFit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.play_circle_fill,
                                                      size: 30,
                                                      color: AppColors.whiteColor,
                                                    )
                                                  ],
                                                ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 20.h),
                                Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                                      child: Text(
                                        'Fill us in with the details of this event.',
                                        textAlign: TextAlign.center,
                                        style: TextStyles.bold(27.sp, fontFamily: testTiemposHeadline),
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                    BlocBuilder<GeneralPostCubit, GeneralPostState>(
                                      builder: (context, state) {
                                        return DropdownButtonHideUnderline(
                                          child: DropdownButton2<CategorysModel>(
                                            isExpanded: true,
                                            hint: Text(
                                              'Category',
                                              style: TextStyles.regular(18.sp, fontColor: AppColors.textHintGrayColor),
                                            ),
                                            items: state.categoryList
                                                .map(
                                                  (item) => DropdownMenuItem(
                                                    value: item,
                                                    child: Row(
                                                      children: [
                                                        AppImageViewer.showNetworkImage(
                                                            url: item.eventIcon ?? '', height: 30.h, width: 30.h),
                                                        SizedBox(width: 10.w),
                                                        Text(
                                                          item.eventName ?? '',
                                                          style:
                                                              TextStyles.medium(20.sp, fontColor: AppColors.whiteColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                            value: state.selectedCategory != null &&
                                                    state.categoryList.contains(state.selectedCategory)
                                                ? state.selectedCategory
                                                : null,
                                            onChanged: (value) {
                                              // if (widget.draftData != null) {
                                              context.read<GeneralPostCubit>().clearSubCat();
                                              // }
                                              context.read<GeneralPostCubit>().selectCat(value!);
                                              setState(() {});
                                            },
                                            buttonStyleData: ButtonStyleData(
                                              height: 65.h,
                                              decoration: BoxDecoration(
                                                color: AppColors.actionBtnBgColor,
                                                borderRadius: BorderRadius.circular(10.r),
                                              ),
                                            ),
                                            dropdownStyleData: DropdownStyleData(
                                              maxHeight: 300.h,
                                              offset: const Offset(0, -5),
                                              decoration: BoxDecoration(
                                                color: AppColors.actionBtnBgColor,
                                                borderRadius: BorderRadius.circular(10.r),
                                              ),
                                              scrollbarTheme: ScrollbarThemeData(
                                                thumbColor: WidgetStateProperty.all(
                                                  AppColors.actionBtnBgColor.withValues(alpha: 0.5),
                                                ),
                                                radius: Radius.circular(10.r),
                                                thickness: WidgetStateProperty.all(4),
                                              ),
                                            ),
                                            menuItemStyleData: MenuItemStyleData(
                                              height: 50.h,
                                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(height: 20.h),
                                    BlocBuilder<GeneralPostCubit, GeneralPostState>(
                                      builder: (context, state) {
                                        return DropdownButtonHideUnderline(
                                          child: DropdownButton2<SubCategory>(
                                            isExpanded: true,
                                            hint: Text(
                                              'Subcategory',
                                              style: TextStyles.regular(18.sp, fontColor: AppColors.textHintGrayColor),
                                            ),
                                            items: state.subCategoryList
                                                .map(
                                                  (item) => DropdownMenuItem(
                                                    value: item,
                                                    child: Row(
                                                      children: [
                                                        AppImageViewer.showNetworkImage(
                                                            url: item.eventIcon ?? '', height: 30.h, width: 30.h),
                                                        SizedBox(width: 10.w),
                                                        Text(
                                                          item.eventName ?? '',
                                                          style:
                                                              TextStyles.medium(20.sp, fontColor: AppColors.whiteColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                            value: state.selectedSubCategory != null &&
                                                    state.subCategoryList.contains(state.selectedSubCategory)
                                                ? state.selectedSubCategory
                                                : null,
                                            onChanged: (value) {
                                              context.read<GeneralPostCubit>().selectSub(value!);
                                            },
                                            buttonStyleData: ButtonStyleData(
                                              height: 65.h,
                                              decoration: BoxDecoration(
                                                color: AppColors.actionBtnBgColor,
                                                borderRadius: BorderRadius.circular(10.r),
                                              ),
                                            ),
                                            dropdownStyleData: DropdownStyleData(
                                              maxHeight: 300.h,
                                              offset: const Offset(0, -5),
                                              decoration: BoxDecoration(
                                                color: AppColors.actionBtnBgColor,
                                                borderRadius: BorderRadius.circular(10.r),
                                              ),
                                              scrollbarTheme: ScrollbarThemeData(
                                                thumbColor: WidgetStateProperty.all(
                                                  AppColors.actionBtnBgColor.withValues(alpha: 0.5),
                                                ),
                                                radius: Radius.circular(10.r),
                                                thickness: WidgetStateProperty.all(4),
                                              ),
                                            ),
                                            menuItemStyleData: MenuItemStyleData(
                                              height: 50.h,
                                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(height: 20.h),
                                    BlocBuilder<GeneralPostCubit, GeneralPostState>(
                                      // buildWhen: (previous, current) =>
                                      //     previous.titleController !=
                                      //     current.titleController,
                                      builder: (context, state) {
                                        return CommonMainTextField(
                                          labelText: "Title",
                                          hintText: 'Enter title',
                                          controller: state.titleController!,
                                          radius: BorderRadius.circular(10.r),
                                          // labelText: 'Title',
                                        );
                                      },
                                    ),
                                    SizedBox(height: 20.h),
                                    BlocBuilder<GeneralPostCubit, GeneralPostState>(
                                      buildWhen: (previous, current) =>
                                          previous.titleController != current.titleController,
                                      builder: (context, state) {
                                        return CommonMainTextField(
                                          labelText: "Description",
                                          hintText: 'Enter Description',
                                          textInputAction: TextInputAction.newline,
                                          keyboardType: TextInputType.multiline,
                                          controller: state.descriptionController!,
                                          radius: BorderRadius.circular(10.r),
                                          // labelText: 'Title',
                                        );
                                      },
                                    ),
                                    SizedBox(height: 20.h),
                                    BlocBuilder<GeneralPostCubit, GeneralPostState>(
                                      // buildWhen: (previous, current) =>
                                      //     previous.locationController !=
                                      //     current.locationController,
                                      builder: (context, state) {
                                        return CommonMainTextField(
                                          maxLines: 2,
                                          hintText: 'Location',
                                          readOnly: true,
                                          onTap: () {
                                            NavigatorRoute.navigateTo(context, AppRoutes.searchLocation);
                                          },
                                          suffixIcon: Icon(
                                            Icons.location_on,
                                            color: AppColors.whiteColor,
                                          ),
                                          controller: state.addressController!,
                                          radius: BorderRadius.circular(10.r),
                                          labelText: 'Location',
                                        );
                                      },
                                    ),
                                    SizedBox(height: 20.h),
                                    BlocBuilder<GeneralPostCubit, GeneralPostState>(
                                      buildWhen: (previous, current) =>
                                          previous.titleController != current.titleController,
                                      builder: (context, state) {
                                        return CommonMainTextField(
                                          inputFormatters: <TextInputFormatter>[
                                            LengthLimitingTextInputFormatter(10),
                                          ],
                                          prefixIcon: SizedBox(
                                            height: 50,
                                            width: 80,
                                            child: CountryCodePicker(
                                              onChanged: (code) {
                                                if (code.dialCode != null && code.dialCode!.isNotEmpty) {
                                                  context
                                                      .read<GeneralPostCubit>()
                                                      .selectCountryCode(code.dialCode ?? '');
                                                  // countryCode =
                                                  //       code.dialCode ?? "";
                                                  // log(code.dialCode.toString());
                                                  // context
                                                  //     .read<SendAlertCubit>()
                                                  //     .getPhoneCode(code.dialCode ?? '');
                                                }
                                              },
                                              showDropDownButton: true,
                                              dialogBackgroundColor: Colors.black,
                                              initialSelection: 'IN',
                                              showFlag: false,
                                              padding: EdgeInsets.zero,
                                              textStyle: TextStyles.medium(16.sp, fontColor: Colors.grey),
                                            ),
                                          ),
                                          hintText: 'Enter phone number',
                                          controller: state.phoneNumberController!,
                                          keyboardType: TextInputType.phone,
                                          radius: BorderRadius.circular(10.r),
                                          labelText: 'Phone Number',
                                        );
                                      },
                                    ),
                                    SizedBox(height: 20.h),
                                    if (_videoThumbnailImageFile != null || widget.draftData != null)
                                      CommonButton(
                                          onPressed: isSubmitPostLoading
                                              ? null
                                              : () {
                                                  isSubmitPostLoading = true;
                                                  setState(() {});
                                                  if (widget.draftData == null) {
                                                    context.read<GeneralPostCubit>().generalPostCreate(context, (val) {
                                                      isSubmitPostLoading = val;
                                                      setState(() {});
                                                    });
                                                  } else {
                                                    context.read<GeneralPostCubit>().createDraftToPost(
                                                        draftData: widget.draftData!,
                                                        context: context,
                                                        onSubmit: (val) {
                                                          isSubmitPostLoading = val;
                                                          setState(() {});
                                                        });
                                                  }
                                                },
                                          color: AppColors.whiteColor,
                                          widget: isSubmitPostLoading
                                              ? SizedBox(
                                                  height: 20.0,
                                                  width: 20.0,
                                                  child: CircularProgressIndicator(
                                                    color: AppColors.whiteColor,
                                                  ),
                                                )
                                              : Text(
                                                  'Submit',
                                                  style: TextStyles.semiBold(18.sp, fontColor: Colors.black),
                                                ))
                                  ],
                                ),
                                Gap(15),
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
    return BlocBuilder<GeneralPostCubit, GeneralPostState>(buildWhen: (previous, current) {
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
                        padding: EdgeInsets.only(top: 5.h, left: 10.w, bottom: 2.h, right: 5.w),
                        decoration: BoxDecoration(
                          color: AppColors.blackColor.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: AppColors.whiteColor.withValues(alpha: 0.25)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.googleAddressData?.results?.first.addressComponents?[0].shortName ?? '',
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
                              state.googleAddressData?.results?.first.formattedAddress ?? '',
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
                              color: AppColors.blackColor.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: AppColors.whiteColor.withValues(alpha: 0.25)),
                            ),
                            padding: EdgeInsets.only(left: 5.w),
                            child: Row(
                              children: [
                                Assets.images.awazLogoWebp.image(height: 40.h, width: 40.h),
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
                        padding: EdgeInsets.only(top: 10.h, left: 10.w, bottom: 8.h, right: 8.w),
                        decoration: BoxDecoration(
                          color: AppColors.blackColor.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: AppColors.whiteColor.withValues(alpha: 0.25)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lat : ${widget.draftData?.latitude ?? state.userLatitude}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.medium(16.sp, fontColor: AppColors.whiteColor),
                            ),
                            Text(
                              'Lang : ${widget.draftData?.longitude ?? state.userLongitude}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.medium(16.sp, fontColor: AppColors.whiteColor),
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
                            padding: EdgeInsets.only(top: 5.h, left: 10.w, bottom: 2.h, right: 5.w),
                            decoration: BoxDecoration(
                              color: AppColors.blackColor.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: AppColors.whiteColor.withValues(alpha: 0.25)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.googleAddressData?.results?.first.addressComponents?[0].shortName ?? '',
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
                                  state.googleAddressData?.results?.first.formattedAddress ?? '',
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
                                  color: AppColors.blackColor.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(color: AppColors.whiteColor.withValues(alpha: 0.25)),
                                ),
                                padding: EdgeInsets.only(left: 5.w),
                                child: Row(
                                  children: [
                                    Assets.images.awazLogoWebp.image(height: 40.h, width: 40.h),
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
                            padding: EdgeInsets.only(top: 10.h, left: 10.w, bottom: 8.h, right: 8.w),
                            decoration: BoxDecoration(
                              color: AppColors.blackColor.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: AppColors.whiteColor.withValues(alpha: 0.25)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lat : ${widget.draftData?.latitude ?? state.userLatitude}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyles.medium(16.sp, fontColor: AppColors.whiteColor),
                                ),
                                Text(
                                  'Lang : ${widget.draftData?.longitude ?? state.userLongitude}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyles.medium(16.sp, fontColor: AppColors.whiteColor),
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
                    : (PrefService.getInt(PrefService.addressStampIndex) == 0)
                        ?

                        /// DON'T REMOVE IN ANY HOW
                        /// =*=*=*=*=*=*= VARIENT-1 =*=*=*=*=*=*=
                        Row(
                            children: [
                              Container(
                                height: 170.h,
                                width: 170.h,
                                padding: EdgeInsets.only(top: 10.h, left: 10.w, bottom: 10.h, right: 10.w),
                                decoration: BoxDecoration(
                                  color: AppColors.blackColor.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(color: AppColors.whiteColor.withValues(alpha: 0.25)),
                                ),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Assets.images.awazLogoWebp.image(height: 45.h, width: 45.h),
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
                                        DateFormat("dd MMM yyyy").format(DateTime.now()),
                                        style: TextStyles.medium(
                                          24.sp,
                                          fontColor: AppColors.whiteColor,
                                        ),
                                      ),
                                      Text(
                                        DateFormat("EEEE").format(DateTime.now()),
                                        style: TextStyles.semiBold(
                                          17.sp,
                                          fontColor: AppColors.whiteColor,
                                        ),
                                      ),
                                      Text(
                                        DateFormat("hh:mm:ss a").format(DateTime.now()),
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
                                      color: AppColors.blackColor.withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(color: AppColors.whiteColor.withValues(alpha: 0.25)),
                                    ),
                                    padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w, bottom: 10.h),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            state.googleAddressData?.results?.first.formattedAddress ?? '',
                                            maxLines: 4,
                                            style: TextStyles.medium(15.sp, fontColor: AppColors.whiteColor),
                                          ),
                                        ),
                                        Container(
                                          height: 65,
                                          width: 65,
                                          decoration: BoxDecoration(
                                            color: AppColors.blackColor.withValues(alpha: 0.5),
                                            image: DecorationImage(image: AssetImage(Assets.images.map.path)),
                                            borderRadius: BorderRadius.circular(8.r),
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
                                      color: AppColors.blackColor.withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(color: AppColors.whiteColor.withValues(alpha: 0.25)),
                                    ),
                                    padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w, bottom: 10.h),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Latitude\n${widget.draftData?.latitude ?? state.userLatitude}',
                                          style: TextStyles.medium(15.sp, fontColor: AppColors.whiteColor),
                                        ),
                                        Gap(10.w),
                                        VerticalDivider(color: AppColors.whiteColor),
                                        Gap(10.w),
                                        Text(
                                          'Longitude\n${widget.draftData?.longitude ?? state.userLongitude}',
                                          style: TextStyles.medium(15.sp, fontColor: AppColors.whiteColor),
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

  String getVideoSize({required File file}) => formatBytes(file.lengthSync(), 2);

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
