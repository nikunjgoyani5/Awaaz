import 'dart:developer';
import 'dart:io';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:dio/dio.dart';
import 'package:eagle_eye/presentation/onboard/splash_screen/bloc/splash_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../presentation/authentication/auth_screen/bloc/auth_screen_cubit.dart';
import '../../routes/app_navigation.dart';
import '../../routes/app_routes.dart';
import 'app_prefrence.dart';

const List<String> scopes = <String>[
  'https://www.googleapis.com/auth/userinfo.profile',
  'https://www.googleapis.com/auth/userinfo.email'
];

class AppFunctions {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // static Future<void> onTokenExpire() async {
  //   PrefService.clear();
  //   await AppFunctions.googleSignOut();
  //   AppFunctions.showToast('Your token has expired. Please log in again to regain access to your account securely.');
  //   navigatorKey.currentContext?.read<AuthScreenCubit>().init();
  //   AppFunctions.navigatorKey.currentContext?.read<AuthScreenCubit>().showLogInWithMobile();
  //   NavigatorRoute.navigateToRemoveUntil(AppFunctions.navigatorKey.currentContext!, AppRoutes.authScreen);
  // }

  static Future<void> onTokenExpire() async {
    PrefService.clear();
    AppFunctions.showToast('Your token has expired. Please log in again to regain access to your account securely.');
    AppFunctions.navigatorKey.currentContext?.read<SplashCubit>().deviceAuth(AppFunctions.navigatorKey.currentContext!);
  }

  static GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: scopes,
  );

  static showToast(String text, {Color? color, Color? backgroundColor}) {
    Fluttertoast.showToast(
        msg: text,
        backgroundColor: backgroundColor,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0,
        textColor: color);
  }

  static void showCustomToast({
    required BuildContext context,
    required String title,
    required String description,
    Position toastPosition = Position.top, // Default position
  }) {
    CherryToast.error(
      animationType: AnimationType.fromTop,
      displayCloseButton: false,
      enableIconAnimation: true,
      animationCurve: Curves.easeIn,
      animationDuration: Duration(microseconds: 500),
      disableToastAnimation: true,
      inheritThemeColors: true,
      autoDismiss: true,
      toastDuration: Duration(seconds: 2),
      toastPosition: toastPosition,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      action: Text(description),
      actionHandler: () {},
    ).show(context);
  }

  static Future googleSignOut() async {
    googleSignIn.disconnect();
  }

  static bool checkEmailValidation(String email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  static Future<void> sharePostText({
    required String url,
  }) async {
    Share.share(url, subject: 'News Post');
  }

  static Future<void> sharePost({
    String? imagePath,
    required String title,
    required String description,
    required String url,
  }) async {
    final truncatedText = truncateText(description);
    String appMarketingLink = url;
    final message = '$title\n$truncatedText\n\nFind out app here:\n $appMarketingLink';
    /* final message =
        'Hey, I found this interesting news.\n$title\n$truncatedText\n\nCheck more! Download the Awaz app here: $appMarketingLink';*/
    if (imagePath != null) {
      Share.shareXFiles([XFile(imagePath)], text: message, subject: 'News Post');
    } else {
      Share.share(message, subject: 'News Post');
    }
  }

  static Future<String> downloadImageToCache(String imageUrl) async {
    try {
      // Get the temporary directory
      final directory = await getTemporaryDirectory();
      final cacheDir = directory.path;

      // Extract the file name from the URL
      final fileName = Uri.parse(imageUrl).pathSegments.last;

      // Define the full file path in the cache
      final filePath = '$cacheDir/$fileName';

      // Check if the file already exists in cache
      final cachedFile = File(filePath);
      if (await cachedFile.exists()) {
        log('Image is already cached at: $filePath');
        return filePath;
      }

      // Download the image
      log('Downloading image from $imageUrl...');
      final dio = Dio();
      final response = await dio.download(imageUrl, filePath);

      if (response.statusCode == 200) {
        log('Image downloaded and cached at: $filePath');
        return filePath;
      } else {
        throw Exception('Failed to download image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Error downloading and caching image: $e');
      rethrow;
    }
  }
}

String getCatchFinalErrorMsg(Object e) {
  String errorMessage = 'Something went wrong';
  if (e is Map && e.containsKey('error') && e['error'].containsKey('message')) {
    errorMessage = e['error']['message'];
  } else if (e.toString().contains('message:')) {
    final RegExp regex = RegExp(r'message:\s(.*?),');
    final match = regex.firstMatch(e.toString());
    if (match != null) {
      errorMessage = match.group(1)!;
    }
  } else {
    errorMessage = e.toString();
  }
  debugPrint('Cache Error: $errorMessage');
  return errorMessage;
}

// Helper function to truncate text to a specified number of lines
String truncateText(String text) {
  // Split the text into words
  List<String> words = text.split(' ');

  // If the text has more than 5 words, truncate and add '...'
  if (words.length > 5) {
    return '${words.take(5).join(' ')}...';
  }

  // Otherwise, return the original text
  return text;
}

void closeKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

showAppBottomSheet(BuildContext context, Widget bottomSheet) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: bottomSheet,
      );
    },
  );
}

showAppDialog(BuildContext context, Widget dialog, {bool? dismissDialog}) {
  showDialog(
    context: context,
    barrierDismissible: dismissDialog ?? true,
    builder: (BuildContext context) {
      return PopScope(
        canPop: dismissDialog ?? false,
        onPopInvokedWithResult: (didPop, result) {},
        child: dialog,
      );
    },
  );
}
