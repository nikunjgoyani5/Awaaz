import 'dart:async';
import 'dart:developer';
import 'package:eagle_eye/services/connectivity_check/connectivity.dart';
import 'package:eagle_eye/services/remote_config_service/remote_config_service.dart';
import 'ads_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ADService {
  AppOpenAd? appOpenAd;
  InterstitialAd? interstitialAd;
  static NativeAd? nativeAd;
  static bool isNativeAdLoaded = false;
  static bool isNativeAdShowing = false;
  bool isOpenAdLoaded = false;
  bool isInterAdLoaded = false;
  bool isInterAdShow = false;
  bool isOpenAdShow = false;
  int adCounter = 0;

  loadInterAds(String adLbl) async {
    if (!networkConnectionServices.isNetworkConnected ||
        !adsHelper.getshowAds() ||
        isInterAdLoaded) {
      Get.log('$isInterAdLoaded Intresital Loaded');
      return;
    }
    Get.log('Intresital Loaded');
    await InterstitialAd.load(
        adUnitId: adsHelper.intrestialAdId(adLbl),
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            Get.log('$ad Loaded');
            isInterAdLoaded = true;
            interstitialAd = ad;
          },
          onAdFailedToLoad: (error) {
            log(error.message);
            isInterAdLoaded = false;
            interstitialAd = null;
          },
        ));
  }

  showInterAds(
    VoidCallback afterAd,
    String adLbl,
  ) async {
    if (networkConnectionServices.isNetworkConnected &&
        adsHelper.getshowAds() &&
        isInterAdLoaded) {
      if ((adCounter %
                  (firebaseRemoteConfigService
                          .getFirebaseAdsData()
                          .userClickCounter ??
                      3) !=
              0) ||
          firebaseRemoteConfigService.getFirebaseAdsData().homeScreenAds ==
                  false &&
              adCounter == 0) {
        Get.log('$adCounter Intresital adCount');
        afterAd();
        adCounter++;
        return;
      }
      adCounter++;

      if (adsHelper.getAdsIsEnable(adLbl)) {
        interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent: (ad) {
            isInterAdShow = true;
            afterAd();
          },
          onAdDismissedFullScreenContent: (ad) {
            isInterAdShow = false;
            isInterAdLoaded = false;
            ad.dispose();
            interstitialAd = null;
            loadInterAds(adLbl);
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            afterAd();
            isInterAdShow = false;
            isInterAdLoaded = false;
            ad.dispose();
            interstitialAd = null;
            loadInterAds(adLbl);
          },
        );
        isInterAdShow = true;
        await interstitialAd!.show();
      } else {
        afterAd();
      }
    } else {
      afterAd();
    }
  }

  loadOpenAd(String adLbl) async {
    if (!networkConnectionServices.isNetworkConnected ||
        !adsHelper.getshowAds() ||
        !adsHelper.getAdsIsEnable(adLbl) ||
        isOpenAdLoaded ||
        isInterAdShow ||
        isOpenAdShow) {
      return;
    }

    await AppOpenAd.load(
      adUnitId: adsHelper.openAppAdId(adLbl),
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          isOpenAdLoaded = true;
          appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          isOpenAdLoaded = false;
          appOpenAd = null;
        },
      ),
      // orientation: 0,
    );
  }

  showOpenAd(String adLbl) async {
    if (!networkConnectionServices.isNetworkConnected ||
        !adsHelper.getAdsIsEnable(adLbl)) {
      return;
    }

    if (networkConnectionServices.isNetworkConnected &&
        adsHelper.getshowAds() &&
        isOpenAdLoaded &&
        !isInterAdShow &&
        !isOpenAdShow) {
      // if (adsHelper.getPublisherAdmob(adLbl)) {
      if (appOpenAd != null) {
        appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent: (ad) {
            isOpenAdShow = true;
          },
          onAdDismissedFullScreenContent: (ad) {
            isOpenAdShow = false;
            isOpenAdLoaded = false;
            ad.dispose();
            appOpenAd = null;
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            isOpenAdShow = false;
            isOpenAdLoaded = false;
            ad.dispose();
            appOpenAd = null;
          },
        );
        isOpenAdShow = true;
        await appOpenAd!.show();
      }
      // } else {
      //   isOpenAdShow = true;
      // }
    }
  }

  loadSplashOpenAd(String adLbl, VoidCallback afterAd,
      {String? storedPin}) async {
    if (networkConnectionServices.isNetworkConnected) {
      AppOpenAd.load(
        adUnitId: adsHelper.openAppAdId(adLbl),
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            isOpenAdLoaded = true;
            appOpenAd = ad;
            showSplashOpenAd(afterAd, storedPin ?? '');
          },
          onAdFailedToLoad: (error) {
            isInterAdLoaded = false;
            Timer(const Duration(seconds: 1), () async {
              afterAd();
            });
            appOpenAd = null;
          },
        ),
        // orientation: 0,
      );
    } else {
      Timer(const Duration(seconds: 1), () {
        afterAd();
      });
      // afterAd();
    }
  }

  showSplashOpenAd(VoidCallback afterAd, String storedPin) async {
    if (!networkConnectionServices.isNetworkConnected ||
        !adsHelper.getshowAds()) {
      Timer(const Duration(seconds: 1), () {
        afterAd();
      });
    } else {
      appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          isOpenAdShow = true;
        },
        onAdDismissedFullScreenContent: (ad) async {
          isOpenAdShow = false;
          isOpenAdLoaded = false;
          ad.dispose();
          appOpenAd = null;
          afterAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) async {
          isOpenAdShow = false;
          isOpenAdLoaded = false;
          ad.dispose();
          appOpenAd = null;
          afterAd();
        },
      );
      await appOpenAd!.show();
    }
  }

  loadNativeAd(String adsLabel) {
    if (!networkConnectionServices.isNetworkConnected ||
        !adsHelper.getshowAds() ||
        !adsHelper.getAdsIsEnable(adsLabel)) {
      nativeAd = null;
      return;
    }
    nativeAd = NativeAd(
      factoryId: 'nativeAd',
      adUnitId: adsHelper.nativeAdId(adsLabel),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          // debugPrint('$ad NativeAd loaded.');
          isNativeAdLoaded = true;
          // nativeAd = ad as NativeAd;

          // debugPrint("Native Ad Loaded === $nativeAd");
        },
        onAdWillDismissScreen: (ad) {
          isNativeAdLoaded = false;
          isNativeAdShowing = false;

          ad.dispose();
          nativeAd = null;
          loadNativeAd(adsLabel);
        },
        onAdFailedToLoad: (ad, error) {
          isNativeAdLoaded = false;
          // debugPrint("Native Ad Failed === ${error.message.toString()}");
        },
      ),
      request: const AdRequest(),
    );
    nativeAd!.load();
  }

  Future<bool> showNativeAds(String adLabel) async {
    if (!networkConnectionServices.isNetworkConnected ||
        !adsHelper.getAdsIsEnable(adLabel)) {
      isNativeAdShowing = false;
      return false;
    }
    if (adsHelper.getshowAds()) {
      isNativeAdShowing = true;
      return true;
    } else {
      isNativeAdShowing = false;
      return false;
    }
  }

  tapCounter() {
    if (firebaseRemoteConfigService.getFirebaseAdsData().userClickCounter !=
            null &&
        adCounter <
            firebaseRemoteConfigService
                .getFirebaseAdsData()
                .userClickCounter!) {
      adCounter++;
    }
    log(adCounter.toString());
  }

  loadAndShowInterstitialAd(
      String adId, String adLbl, VoidCallback afterAd) async {
    if (!networkConnectionServices.isNetworkConnected ||
        !adsHelper.getshowAds() ||
        isInterAdLoaded) {
      Get.log('$isInterAdLoaded Intresital Loaded');
      return;
    }
    Get.log('Intresital Loaded');
    await InterstitialAd.load(
        adUnitId: adId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            Get.log('$ad Loaded');
            isInterAdLoaded = true;
            interstitialAd = ad;
            showSplashInterAds(adLbl, afterAd);
          },
          onAdFailedToLoad: (error) {
            isInterAdLoaded = false;
            interstitialAd = null;
            afterAd();
          },
        ));
  }

  showSplashInterAds(String adLbl, VoidCallback afterAd) async {
    if (adsHelper.getAdsIsEnable(adLbl)) {
      interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          isInterAdShow = true;
        },
        onAdDismissedFullScreenContent: (ad) {
          isInterAdShow = false;
          isInterAdLoaded = false;
          ad.dispose();
          interstitialAd = null;
          afterAd();
          loadInterAds('ondetail_screen');
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          afterAd();
          isInterAdShow = false;
          isInterAdLoaded = false;
          ad.dispose();
          interstitialAd = null;
          loadInterAds('ondetail_screen');
        },
      );
      isInterAdShow = true;
      await interstitialAd!.show();
    }
  }
}

ADService adService = ADService();
