import 'dart:async';
import 'dart:developer';
import 'package:app_links/app_links.dart';
import 'package:eagle_eye/core/utils/app_prefrence.dart';
import 'package:flutter/cupertino.dart';

class AppLinksDeepLink {
  AppLinksDeepLink._privateConstructor();

  static final AppLinksDeepLink _instance =
      AppLinksDeepLink._privateConstructor();

  static AppLinksDeepLink get instance => _instance;

  late AppLinks _appLinks; // ✅ Keep late, but initialize explicitly
  StreamSubscription<Uri>? _linkSubscription;

  Future<void> initialize() async {
    _appLinks = AppLinks(); // ✅ Initialize explicitly
  }

  Future<void> initDeepLinks(BuildContext context) async {
    try {
      final appLink = await _appLinks.getInitialLinkString();
      if (appLink != null) {
        var uri = Uri.parse(appLink);
        log('Redirecting from URL: $uri');
      }

      _linkSubscription = _appLinks.uriLinkStream.listen(
        (uriValue) async {
          log('Received deep link: $uriValue');
          String urlValues = uriValue.toString();
          String? detailsId = urlValues.split('/').last;
          log('detailsId :- $detailsId');
          if (detailsId.isNotEmpty) {
            log('Navigating to Splash with detailsId: $detailsId');
            PrefService.setValue(PrefService.eventDetailsId, detailsId);
          }
        },
        onError: (err) {
          log('====>>> Error: $err');
        },
        onDone: () {
          _linkSubscription?.cancel();
        },
      );
    } catch (e, stackTrace) {
      log("Deep Link Initialization Error: $e\n$stackTrace");
    }
  }
}
