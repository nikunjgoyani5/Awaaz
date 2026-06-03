import 'dart:convert';
import 'dart:developer';

import 'package:eagle_eye/core/utils/app_functions.dart';
import 'package:eagle_eye/core/utils/app_prefrence.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../presentation/main/news_details_screen/bloc/news_details_screen_bloc_cubit.dart';
import '../routes/app_navigation.dart';
import '../routes/app_routes.dart';

final bool requireConsent = true;
String? notificationPayload;
bool isAppInForeground = true;
bool isAppInitialized = false;

class OneSignalNotificationService {
  static const String oneSignalAppId = '59df38e3-a27a-4f4c-bd65-9e19c39fbff7';
  static bool requireConsent = false;

  static Future<void> initOneSignalPlatformState() async {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.Debug.setAlertLevel(OSLogLevel.none);
    OneSignal.consentRequired(requireConsent);
    OneSignal.initialize(oneSignalAppId);
    OneSignal.Notifications.clearAll();

    if (PrefService.getBool(PrefService.isLogin)) {
      await getOneSignalDeviceToken();
    }

    // Set up notification click handlers
    OneSignal.Notifications.addClickListener((event) {
      log('Notification clicked: ${event.notification.additionalData}');
      _handleNotificationClick(event.notification.additionalData);
    });

    // Listen to app lifecycle changes
    WidgetsBinding.instance.addObserver(AppLifecycleObserver());
  }

  static void _handleNotificationClick(Map<String, dynamic>? additionalData) {
    if (additionalData == null) return;
    notificationPayload = jsonEncode(additionalData);

    // If app is in foreground, navigate directly
    if (isAppInForeground && isAppInitialized) {
      _navigateToScreen(additionalData);
    } else {}
  }

  static void _navigateToScreen(Map<String, dynamic> data) {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          final additionalData = jsonDecode(notificationPayload!);
          String eventId = additionalData['eventId'] ?? "";
          if (eventId != "") {
            final context = AppFunctions.navigatorKey.currentContext;
            if (context != null) {
              final newsDetailsCubit =
                  context.read<NewsDetailsScreenBlocCubit>();
              newsDetailsCubit.init();
              newsDetailsCubit.getPostId(eventId);
              newsDetailsCubit.getEventNewsDetailData();
              newsDetailsCubit.getInThisAreaPostList();
              NavigatorRoute.navigateTo(context, AppRoutes.newsDetails, args: {
                "isHome": false,
              });
            }
          }
          notificationPayload = null;
        } catch (e) {
          log('Error navigating to news details: $e');
        }
      });
    } catch (e) {
      log('Error navigating to screen: $e');
    }
  }

  static Future<void> getOneSignalDeviceToken() async {
    String onSignalId = await OneSignal.User.getOnesignalId() ?? '';
    PrefService.setValue(PrefService.oneSignalId, onSignalId);
    log('One === $onSignalId');
    OneSignal.User.pushSubscription.optIn();
    OneSignal.User.pushSubscription.addObserver((state) {
      String subscriptionId = OneSignal.User.pushSubscription.id ?? '';
      PrefService.setValue(PrefService.oneSignalSubscriptionId, subscriptionId);
      log("One sub id : ${OneSignal.User.pushSubscription.id}");
    });
  }

  static Future<void> requestNotificationPermission() async {
    await Permission.notification.request();
    await getOneSignalDeviceToken();
  }

  static void handlePendingNotification(pendingNotification) {
    if (pendingNotification != null && pendingNotification.isNotEmpty) {
      try {
        final additionalData = jsonDecode(pendingNotification);
        _navigateToScreen(additionalData);
      } catch (e) {
        log('Error handling pending notification: $e');
      }
    }
  }

  static void setAppInitialized(bool value) {
    isAppInitialized = value;
  }
}

class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        isAppInForeground = true;
        if (isAppInitialized) {
          OneSignalNotificationService.handlePendingNotification(
              notificationPayload);
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        isAppInForeground = false;
        break;
      default:
        break;
    }
  }
}
