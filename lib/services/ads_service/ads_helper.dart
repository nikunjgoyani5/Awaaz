import 'package:eagle_eye/services/remote_config_service/remote_config_service.dart';

class AdsHelper {
  bool getshowAds() {
    try {
      return firebaseRemoteConfigService.getFirebaseAdsData().showAds ?? false;
    } catch (e) {
      return false;
    }
  }

  String bannerAdId(String adLbl) {
    try {
      return firebaseRemoteConfigService
              .getFirebaseAdsData()
              .adsData![adLbl]!
              .idAds ??
          'ca-app-pub-3940256099942544/6300978111';
    } catch (e) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
  }

  String nativeAdId(String adLbl) {
    try {
      return firebaseRemoteConfigService
              .getFirebaseAdsData()
              .adsData![adLbl]!
              .idAds ??
          'ca-app-pub-3940256099942544/2247696110';
    } catch (e) {
      return 'ca-app-pub-3940256099942544/2247696110';
    }
  }

  String openAppAdId(String adLbl) {
    try {
      return firebaseRemoteConfigService
              .getFirebaseAdsData()
              .adsData![adLbl]!
              .idAds ??
          'ca-app-pub-3940256099942544/9257395921';
    } catch (e) {
      return 'ca-app-pub-3940256099942544/9257395921';
    }
  }

  String intrestialAdId(String adLbl) {
    try {
      return firebaseRemoteConfigService
              .getFirebaseAdsData()
              .adsData![adLbl]!
              .idAds ??
          'ca-app-pub-3940256099942544/1033173712';
    } catch (e) {
      return 'ca-app-pub-3940256099942544/1033173712';
    }
  }

  bool getAdsIsEnable(String adLbl) {
    try {
      return firebaseRemoteConfigService
              .getFirebaseAdsData()
              .adsData![adLbl]!
              .enableAds ??
          false;
    } catch (e) {
      return false;
    }
  }

  String getAdsType(String adLbl) {
    try {
      return firebaseRemoteConfigService
              .getFirebaseAdsData()
              .adsData![adLbl]!
              .adsType ??
          '';
    } catch (e) {
      return '';
    }
  }
}

AdsHelper adsHelper = AdsHelper();
