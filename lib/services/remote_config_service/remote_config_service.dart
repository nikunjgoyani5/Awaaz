import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:eagle_eye/data/models/ads_json_model.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
import 'package:eagle_eye/services/remote_config_service/remote_config_label.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseRemoteConfigService {
  static final FirebaseRemoteConfigService _instance =
      FirebaseRemoteConfigService._internal();
  factory FirebaseRemoteConfigService() => _instance;
  FirebaseRemoteConfigService._internal();

  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  String? tutorialVideoId;
  bool? isShowTutorialPlayBtn;
  String? adsData;

  Future<void> initializeConfig() async {
    FirebaseEvents.setFirebaseEvent('remoteConfig_requested', {});
    log('Remote Config Requested');

    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 5),
        minimumFetchInterval: const Duration(seconds: 0),
      ));
      await remoteConfig.setDefaults({
        "test_ads_json":
            "{\"show_ads\":true,\"home_screen_ads\":true,\"other_ads_with_counter\":true,\"user_click_counter\":1,\"newsListAdsIndex\":3,\"splashInterstitialId\":\"ca-app-pub-3940256099942544/1033173712\",\"ads_data\":{\"splash_open_app\":{\"adsName\":\"splash_open_app\",\"adsType\":\"openapp\",\"idAds\":\"ca-app-pub-3940256099942544/9257395921\",\"enableAds\":true},\"background_open_app\":{\"adsName\":\"background_open_app\",\"adsType\":\"openapp\",\"idAds\":\"ca-app-pub-3940256099942544/9257395921\",\"enableAds\":true},\"news_screen_native\":{\"adsName\":\"news_screen_native\",\"adsType\":\"native\",\"idAds\":\"ca-app-pub-3940256099942544/2247696110\",\"enableAds\":true},\"news_details_screen_banner\":{\"adsName\":\"news_details_screen_banner\",\"adsType\":\"banner\",\"idAds\":\"ca-app-pub-3940256099942544/9214589741\",\"enableAds\":true}}}",
        "tutorial_video_id": "Hu6rI-RVsuo",
        "is_show_tutorial_play_btn": "true",
        "is_new_onboard":"false"
      });
      await remoteConfig.fetchAndActivate();

      bool fetchSuccess = await remoteConfig.activate();
      if (fetchSuccess) {
        await remoteConfig.fetch();
      }

      if (remoteConfig.lastFetchStatus == RemoteConfigFetchStatus.success) {
        FirebaseEvents.setFirebaseEvent('remoteConfig_fetched_success', {});
        log('✅ Remote Config Request Success');
        _loadRemoteValues();
      } else {
        FirebaseEvents.setFirebaseEvent('remoteConfig_fetch_failed', {});
        log('❌ Remote Config Fetch Failed: ${remoteConfig.lastFetchStatus}');
        _loadRemoteValues();
      }
    } on SocketException {
      FirebaseEvents.setFirebaseEvent('remoteConfig_noInternet', {});
      log('No Internet Connection');
    } on TimeoutException {
      FirebaseEvents.setFirebaseEvent('remoteConfig_timeout', {});
      log('Remote Config Timeout');
    } on FirebaseException catch (e) {
      FirebaseEvents.setFirebaseEvent('remoteConfig_request_failed', {});
      log('Remote Config Request Failed: FirebaseException: $e');
    } catch (e) {
      FirebaseEvents.setFirebaseEvent('remoteConfig_request_failed', {});
      log('Remote Config Request Failed: $e');
    }
  }

  void _loadRemoteValues() {
    try {
      tutorialVideoId =
          remoteConfig.getString(RemoteConfigLabel.tutorialVideoId);
      isShowTutorialPlayBtn =
          remoteConfig.getBool(RemoteConfigLabel.isShowTutorialPlayBtn);
      adsData = remoteConfig.getString(RemoteConfigLabel.testAdsJson);

      log('tutorialVideoId is here :- $tutorialVideoId');
    } catch (e) {
      FirebaseEvents.setFirebaseEvent('remoteConfig_load_error', {});
      log('Error while loading remote config values: $e');
    }
  }

  AdsJsonDataModel getFirebaseAdsData() {
    try {
      return adsJsonDataModelFromJson(adsData!);
    } catch (e) {
      return AdsJsonDataModel();
    }
  }
}

FirebaseRemoteConfigService firebaseRemoteConfigService =
    FirebaseRemoteConfigService();
