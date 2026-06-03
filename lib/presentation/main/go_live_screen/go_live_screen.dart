import 'dart:async';
import 'package:camera/camera.dart';
import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/utils/map_utils.dart';
import 'package:eagle_eye/core/widget/common_alert_dialogue.dart';
import 'package:eagle_eye/core/widget/common_button.dart';
import 'package:eagle_eye/gen/fonts.gen.dart';
import 'package:eagle_eye/presentation/main/go_live_screen/bloc/go_live_cubit.dart';
import 'package:eagle_eye/presentation/main/go_live_screen/video_post_screen.dart';
import 'package:eagle_eye/presentation/main/home/bloc/home_screen_bloc_cubit.dart';
import 'package:eagle_eye/presentation/main/map_screen/bloc/map_screen_cubit.dart';
import 'package:eagle_eye/routes/app_navigation.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/app_functions.dart';
import '../../../core/utils/app_prefrence.dart';
import '../../../core/widget/app_common_loader_screen.dart';
import '../../../core/widget/common_snack_bar.dart';
import '../../../core/widget/stop_animated_button.dart';
import '../../../services/camera_services.dart';

class GoLiveScreen extends StatefulWidget {
  const GoLiveScreen({super.key});

  @override
  State<GoLiveScreen> createState() => _GoLiveScreenState();
}

int currentIndex = 0;

class _GoLiveScreenState extends State<GoLiveScreen>
    with WidgetsBindingObserver {
  CameraController? controller;
  late Future<void> _initializeControllerFuture;
  bool isLocked = false;
  bool _isRecording = false;
  bool _isControllerInit = false;
  int selectedCameraIndex = 0;
  int remainingTime = 120;
  bool isActive = false;
  bool isLoading = false;
  Timer? timer;
  GlobalKey startRecordingKey = GlobalKey();
  bool _isCountdownActive = false;
  int _countdownValue = 3;
  bool _isShowingAudioDialog = false;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = Future.value();
    WidgetsBinding.instance.addObserver(this);
    FirebaseEvents.setFirebaseEvent('go_live_screen', {});
    checkCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // App came back from background, check permissions again
      if (mounted) {
        if (!_isRecording && !_isControllerInit) {
          var newCameraStatus = await Permission.camera.status;
          if (newCameraStatus.isGranted) {
            var mic = await Permission.microphone.status;
            if (mic.isGranted && _isShowingAudioDialog) {
              NavigatorRoute.navigateBack(context);
            }
            if (!_isShowingAudioDialog) {
              await _initializeCameraController();
            }
          } else {
            checkCameraPermission();
          }
        }
      }
    }
    if (state == AppLifecycleState.paused) {
      if (_isRecording && _isControllerInit) {
        stopTimer();
        await _stopRecording(false);
      }
    }
  }

  Future<void> checkCameraPermission() async {
    var cameraStatus = await Permission.camera.status;

    if (cameraStatus.isGranted) {
      // Camera permission granted, initialize camera
      await _initializeCameraController();
      if (PrefService.getBool(PrefService.startLiveTutorial) == false) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ShowCaseWidget.of(context).startShowCase([startRecordingKey]);
        });
      }
    } else {
      // Check camera permission
      if (cameraStatus.isPermanentlyDenied) {
        // Show dialog to open settings for camera
        if (mounted) {
          showAppDialog(
            context,
            CommonAlertDialogue(
              dialogWidget: CameraPermissionDialog(
                onOpenSettings: () async {
                  _openAppSettings();
                },
                onCancel: () {
                  NavigatorRoute.navigateBack(context);
                  NavigatorRoute.navigateBack(context);
                  WidgetsBinding.instance.removeObserver(this);
                  // checkCameraPermission();
                },
              ),
            ),
            dismissDialog: false,
          );
        }
        return;
      } else {
        // Request camera permission
        cameraStatus = await Permission.camera.request();
        if (!cameraStatus.isGranted) {
          if (mounted) {
            showCustomSnackBar(
                message: 'Camera permission is required to use this feature');
          }
        } else {
          await _initializeCameraController();
          if (PrefService.getBool(PrefService.startLiveTutorial) == false) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ShowCaseWidget.of(context).startShowCase([startRecordingKey]);
            });
          }
        }
      }
    }
  }

  // Initialize the camera
  Future<void> _initializeCameraController() async {
    try {
      final CameraController cameraController = CameraController(
        CameraService.cameras[selectedCameraIndex],
        ResolutionPreset.high,
      );

      controller = cameraController;

      // If the controller is updated then update the UI.
      cameraController.addListener(() {
        if (mounted) {
          setState(() {});
        }
        if (cameraController.value.hasError) {
          showCustomSnackBar(
              message:
                  'Camera error ${cameraController.value.errorDescription}');
        }
      });
      _initializeControllerFuture = cameraController.initialize();
      await _initializeControllerFuture;
      await cameraController
          .lockCaptureOrientation(DeviceOrientation.portraitUp);

      setState(() {
        _isControllerInit = true;
      });
    } on CameraException catch (e) {
      setState(() {
        _isControllerInit = false;
      });
      switch (e.code) {
        case 'CameraAccessDenied':
          showCustomSnackBar(message: 'You have denied camera access.');
        case 'CameraAccessDeniedWithoutPrompt':
          showCustomSnackBar(
              message: 'Please go to Settings app to enable camera access.');
        case 'CameraAccessRestricted':
          showCustomSnackBar(message: 'Camera access is restricted.');
        case 'AudioAccessDenied':
        case 'AudioAccessDeniedWithoutPrompt':
        case 'AudioAccessRestricted':
          // Show audio permission dialog only if not already showing
          if (mounted && !_isShowingAudioDialog) {
            _isShowingAudioDialog = true;
            showAppDialog(
              context,
              CommonAlertDialogue(
                dialogWidget: MicrophonePermissionDialog(
                  onOpenSettings: () async {
                    _isShowingAudioDialog = false;
                    _openAppSettings();
                  },
                  onCancel: () {
                    _isShowingAudioDialog = false;
                    WidgetsBinding.instance.removeObserver(this);
                    NavigatorRoute.navigateBack(context);
                    NavigatorRoute.navigateBack(context);
                    // checkCameraPermission();
                  },
                ),
              ),
              dismissDialog: false,
            );
          }
          break;
        default:
          _showCameraException(e);
          break;
      }
    }
  }

  _openAppSettings() async {
    Navigator.of(AppFunctions.navigatorKey.currentContext!).pop();
    await openAppSettings();
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      if (await Permission.camera.isGranted) {
        var micStatus = await Permission.microphone.status;
        if (await Permission.camera.isGranted && micStatus.isGranted) {
          await _initializeCameraController();
          if (PrefService.getBool(PrefService.startLiveTutorial) == false) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ShowCaseWidget.of(context).startShowCase([startRecordingKey]);
            });
          }
          break;
        }
      }
    }
  }

  void _logError(String code, String? message) {
    debugPrint(
        'Error: $code${message == null ? '' : '\nError Message: $message'}');
  }

  void _showCameraException(CameraException e) {
    _logError(e.code, e.description);
    showCustomSnackBar(message: 'Error: ${e.code}\n${e.description}');
  }

  // Recording
  XFile? videoFile;

  void _startCountdown() {
    setState(() {
      _isCountdownActive = true;
      _countdownValue = 3;
    });

    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_countdownValue > 1) {
        setState(() {
          _countdownValue--;
        });
      } else {
        timer.cancel();
        await _startRecording();
      }
    });
  }

  Future<void> prepareForRecording() async {
    // Optional delay for smoothness
    await Future.delayed(Duration(milliseconds: 100));

    if (controller?.value.isInitialized == true &&
        !controller!.value.isRecordingVideo) {
      // Just a warm-up — accessing this can sometimes trigger native pre-setup
      final previewSize = controller!.value.previewSize;
      debugPrint('Preview size: $previewSize');
    }
  }

  Future _startRecording() async {
    if (controller?.value.isRecordingVideo == true) {
      return;
    }
    try {
      await controller!.startVideoRecording();
      setState(() => _isCountdownActive = false);
      setState(() => _isRecording = true);
      startTimer();
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  /// IMPROVE SOME THING (DATE 13-03-2025)
  Future<void> _stopRecording(bool isDiscard) async {
    if (controller?.value.isRecordingVideo == true) {
      if (isDiscard) {
        await controller!.stopVideoRecording();
      } else {
        if (mounted) {
          setState(() {
            isLoading = true;
          });
        }
        try {
          context.read<GoLiveCubit>().loading(true);
          context.read<GoLiveCubit>().clearPostValue();
          context.read<GoLiveCubit>().getReactionList();
          context.read<GoLiveCubit>().getUsersCount(
              latitude:
                  context.read<GoLiveCubit>().state.userLatitude.toDouble(),
              longitude:
                  context.read<GoLiveCubit>().state.userLongitude.toDouble(),
              kmRadius: PrefService.getInt(PrefService.userRadius));
          context.read<GoLiveCubit>().loading(false);
          final XFile file = await controller!.stopVideoRecording();
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  VideoPostScreen(
                videoFile: file,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                var tween =
                    Tween(begin: const Offset(1.0, 0.0), end: Offset.zero);
                return SlideTransition(
                    position: animation.drive(tween), child: child);
              },
              transitionDuration: const Duration(milliseconds: 200),
            ),
          );
          if (mounted) {
            setState(() {
              _isRecording = false;
              isLoading = false;
            });
          }
        } catch (e) {
          if (mounted) {
            setState(() {
              _isRecording = false;
              isLoading = false;
            });
          }
          debugPrint(e.toString());
        }
      }
    }
    if (mounted) {
      setState(() {
        _isRecording = false;
        isLoading = false;
      });
    }
    resetTimer();
  }

  void startTimer() {
    if (isActive) return;
    setState(() {
      isActive = true;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (remainingTime > 0) {
        setState(() {
          remainingTime = remainingTime - 1;
        });
      } else {
        stopTimer();
        Future.delayed(Duration(milliseconds: 1000));
        await _stopRecording(false);
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      isActive = false;
    });
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      isActive = false;
      remainingTime = 120;
      timer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppCommonLoaderScreen(
      inAsyncCall: isLoading,
      child: PopScope(
        canPop: ((_isRecording == false) && (_isCountdownActive == false))
            ? true
            : false,
        onPopInvokedWithResult: (didPop, result) {
          if (_isRecording) {
            showAppDialog(
                context,
                CommonAlertDialogue(
                    dialogWidget: EndLiveVideoDialog(
                  onEndTap: () async {
                    FirebaseEvents.setFirebaseEvent('go_live_end_btn', {});
                    NavigatorRoute.navigateBack(context);
                    await _stopRecording(true);
                    stopTimer();
                  },
                  onCancelTap: () {
                    NavigatorRoute.navigateBack(context);
                  },
                  buttonText: 'Discard',
                )));
          } else {
            context.read<HomeScreenBlocCubit>().changePageIndex(2);
            if (_isCountdownActive != true) {
              controller?.dispose();
            }
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        controller != null) {
                      return GestureDetector(
                        child: Stack(
                          children: [
                            // Camera view
                            SizedBox.expand(
                                child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: SizedBox(
                                        width: controller
                                                ?.value.previewSize?.height ??
                                            0,
                                        height: controller
                                                ?.value.previewSize?.width ??
                                            0,
                                        child: CameraPreview(controller!)))),

                            // Countdown overlay
                            if (_isCountdownActive)
                              Container(
                                color: Colors.black.withValues(alpha: 0.7),
                                child: Center(
                                  child: Text(
                                    '$_countdownValue',
                                    style: TextStyles.bold(
                                      120.sp,
                                      fontColor: AppColors.whiteColor,
                                    ),
                                  ),
                                ),
                              ),

                            // Live text view
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 60.h, left: 20.w, right: 20.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 85.h,
                                            height: 35.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.r),
                                              color: AppColors.redColorColor,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Live',
                                              style: TextStyles.medium(
                                                19.sp,
                                                fontColor: AppColors.whiteColor,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Text(
                                            '$remainingTime Second',
                                            style: TextStyles.medium(
                                              20.sp,
                                              fontColor: AppColors.whiteColor,
                                            ),
                                          )
                                        ],
                                      ),
                                      IconButton(
                                          onPressed: _isCountdownActive
                                              ? null
                                              : () {
                                                  FirebaseEvents
                                                      .setFirebaseEvent(
                                                          'go_live_close_btn',
                                                          {});
                                                  if (_isRecording) {
                                                    showAppDialog(
                                                        context,
                                                        CommonAlertDialogue(
                                                            dialogWidget:
                                                                EndLiveVideoDialog(
                                                          onEndTap: () async {
                                                            FirebaseEvents
                                                                .setFirebaseEvent(
                                                                    'go_live_end_btn',
                                                                    {});
                                                            NavigatorRoute
                                                                .navigateBack(
                                                                    context);
                                                            await _stopRecording(
                                                                true);
                                                          },
                                                          buttonText: 'Discard',
                                                          onCancelTap: () {
                                                            NavigatorRoute
                                                                .navigateBack(
                                                                    context);
                                                          },
                                                        )));
                                                  } else {
                                                    Future.delayed(
                                                        Duration(
                                                            milliseconds: 300),
                                                        () {
                                                      if (mounted) {
                                                        NavigatorRoute
                                                            .navigateBack(
                                                                context);
                                                        context
                                                            .read<
                                                                HomeScreenBlocCubit>()
                                                            .changePageIndex(2);
                                                      }
                                                    });
                                                    controller?.dispose();
                                                  }
                                                },
                                          icon: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 32.sp,
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Visibility(
                                    visible: !_isRecording,
                                    child: BlocBuilder<MapScreenCubit,
                                        MapScreenState>(
                                      buildWhen: (previous, current) =>
                                          previous.currentCity !=
                                          current.currentCity,
                                      builder: (context, state) {
                                        return Text(
                                          'Go Live in \n${state.currentCity}',
                                          style: TextStyles.bold(47.sp),
                                        );
                                      },
                                    ),
                                  ),
                                  Visibility(
                                      visible: !_isRecording,
                                      child: Text(
                                        'Go Live to Report the Incident. The operator\nwill join the stream as soon as you go live.',
                                        style: TextStyles.medium(18.sp),
                                      )),
                                  Visibility(
                                    visible:
                                        (remainingTime < 115 && _isRecording),
                                    child: Text(
                                      'Operator is reviewing your incident.',
                                      style: TextStyles.medium(18.sp),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Live button widget
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 40.h),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Visibility(
                                      visible: !_isRecording,
                                      child: Text(
                                        'Go Live camera duration limit is 2 minutes',
                                        style: TextStyles.medium(
                                          18.sp,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // SizedBox(
                                        //   width: 40,
                                        // ),
                                        Showcase(
                                          key: startRecordingKey,
                                          description:
                                              'You can capture and record videos from this section.',
                                          title: 'Go Live',
                                          overlayOpacity: 0.0,
                                          titleTextStyle: TextStyles.semiBold(
                                            26.sp,
                                            fontColor: AppColors.blackColor,
                                          ),
                                          descTextStyle: TextStyles.regular(
                                            18.sp,
                                            fontColor: AppColors.blackColor,
                                          ),
                                          onTargetClick: () {
                                            PrefService.setValue(
                                                PrefService.startLiveTutorial,
                                                true);
                                          },
                                          disposeOnTap: true,
                                          titleAlignment: Alignment.centerLeft,
                                          onToolTipClick: () {
                                            PrefService.setValue(
                                                PrefService.startLiveTutorial,
                                                true);
                                          },
                                          child: _isRecording
                                              ? StopAnimated(
                                                  label: "Stop Live",
                                                  remainingTime: remainingTime,
                                                  totalDuration: 120,
                                                  onTap: () {
                                                    stopTimer();
                                                    showAppDialog(
                                                        context,
                                                        CommonAlertDialogue(
                                                            dialogWidget:
                                                                EndLiveVideoDialog(
                                                          onEndTap: () async {
                                                            FirebaseEvents
                                                                .setFirebaseEvent(
                                                                    'go_live_end_btn',
                                                                    {});
                                                            NavigatorRoute
                                                                .navigateBack(
                                                                    context);
                                                            await _stopRecording(
                                                                false);
                                                          },
                                                          onCancelTap: () {
                                                            NavigatorRoute
                                                                .navigateBack(
                                                                    context);
                                                            startTimer();
                                                          },
                                                          buttonText: 'End',
                                                        )),
                                                        dismissDialog: false);
                                                  },
                                                )
                                              : CommonButton(
                                                  color: AppColors.whiteColor,
                                                  width: 200,
                                                  onPressed: _isCountdownActive
                                                      ? null
                                                      : () async {
                                                          var status =
                                                              await Permission
                                                                  .locationWhenInUse
                                                                  .status;
                                                          debugPrint(
                                                              "User current lat : ${MapUtils.position?.latitude ?? "0.0"}");
                                                          debugPrint(
                                                              "User current long : ${MapUtils.position?.longitude ?? "0.0"}");
                                                          context
                                                              .read<
                                                                  GoLiveCubit>()
                                                              .getCurrentLatLonAndTime(
                                                                  context);
                                                          var cameraStatus =
                                                              await Permission
                                                                  .camera
                                                                  .status;
                                                          if (status
                                                                  .isGranted &&
                                                              cameraStatus
                                                                  .isGranted) {
                                                            if (MapUtils.position !=
                                                                    null &&
                                                                MapUtils.position!
                                                                        .latitude !=
                                                                    0.0) {
                                                              FirebaseEvents
                                                                  .setFirebaseEvent(
                                                                      'go_live_btn',
                                                                      {});
                                                              _startCountdown();
                                                            } else {
                                                              showAppDialog(
                                                                  context,
                                                                  CommonAlertDialogue(
                                                                      dialogWidget:
                                                                          Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            40.h,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 10.w),
                                                                        child:
                                                                            Text(
                                                                          'Location permission required!',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: TextStyles.bold(
                                                                              22.sp,
                                                                              fontColor: AppColors.whiteColor,
                                                                              fontFamily: FontFamily.testTiemposHeadline),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10.h,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 25.w),
                                                                        child:
                                                                            Text(
                                                                          'For use this feature we required your current location.',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              TextStyles.bold(
                                                                            16.sp,
                                                                            fontColor:
                                                                                AppColors.whiteColor,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            50.h,
                                                                      ),
                                                                      Divider(
                                                                        color: AppColors
                                                                            .popUpTextFieldBlackColor,
                                                                      ),
                                                                      InkWell(
                                                                          child:
                                                                              SizedBox(
                                                                            height:
                                                                                40,
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                'Grand permission',
                                                                                style: TextStyles.bold(18.sp, fontColor: AppColors.redColorColor),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          onTap:
                                                                              () async {
                                                                            NavigatorRoute.navigateBack(context);
                                                                            await context.read<GoLiveCubit>().getCurrentLatLonAndTime(context);
                                                                          }),
                                                                      Divider(
                                                                        color: AppColors
                                                                            .popUpTextFieldBlackColor,
                                                                      ),
                                                                      CupertinoButton(
                                                                          child:
                                                                              Text(
                                                                            'Cancel',
                                                                            style:
                                                                                TextStyles.bold(18.sp, fontColor: AppColors.whiteColor),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            NavigatorRoute.navigateBack(context);
                                                                          }),
                                                                      SizedBox(
                                                                        height:
                                                                            10.h,
                                                                      ),
                                                                    ],
                                                                  )));
                                                            }
                                                          }
                                                        },
                                                  widget: Text(
                                                    'Go Live',
                                                    style: TextStyles.medium(
                                                        22.sp,
                                                        fontColor: AppColors
                                                            .blackColor),
                                                  )),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Colors.white,
                      ));
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
