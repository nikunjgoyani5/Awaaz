import 'dart:developer';
import 'package:eagle_eye/core/utils/skeleton_ui.dart';
import 'package:eagle_eye/services/ads_service/ads_helper.dart';
import 'package:eagle_eye/services/connectivity_check/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

class NativeAdsWidget extends StatefulWidget {
  final String adLbl;
  final String? nativeAdsType;
  final bool? isAdsLoad;

  const NativeAdsWidget(
      {super.key, required this.adLbl, this.nativeAdsType, this.isAdsLoad});

  @override
  State<NativeAdsWidget> createState() => _NativeAdsWidgetState();
}

class _NativeAdsWidgetState extends State<NativeAdsWidget>
    with AutomaticKeepAliveClientMixin {
  NativeAd? nativeAd;
  bool nativeAdIsLoaded = false;
  bool nativeAdsFailed = false;
  bool nativeAdsLoading = false;
  final double adAspectRatioMedium = (370 / 355);

  @override
  bool get wantKeepAlive => true; // Keeps state alive when off-screen

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (networkConnectionServices.isNetworkConnected &&
          adsHelper.getshowAds() &&
          adsHelper.getAdsIsEnable(widget.adLbl)) {
        loadAd();
      }
    });
  }

  @override
  void dispose() {
    if (nativeAd != null) {
      nativeAd!.dispose();
      nativeAd = null;
    }
    super.dispose();
  }

  void loadAd() async {
    if (nativeAdsLoading) return; // Prevent multiple loads
    setState(() {
      nativeAdsLoading = true;
      nativeAdIsLoaded = false;
      nativeAdsFailed = false;
    });

    nativeAd?.dispose(); // Properly dispose of the previous ad
    nativeAd = null; // Reset before loading a new one

    nativeAd = NativeAd(
      factoryId: 'nativeAd',
      nativeAdOptions: NativeAdOptions(
        mediaAspectRatio: MediaAspectRatio.portrait,
        videoOptions: VideoOptions(),
      ),
      adUnitId: adsHelper.nativeAdId(widget.adLbl),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          log('$ad NativeAd loaded.');
          setState(() {
            nativeAdIsLoaded = true;
            nativeAdsLoading = false;
          });
        },
        onAdFailedToLoad: (ad, error) {
          log('NativeAd failed to load: $error');
          setState(() {
            nativeAdIsLoaded = false;
            nativeAdsFailed = true;
            nativeAdsLoading = false;
          });
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    );

    nativeAd!.load();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (nativeAdsLoading) {
      return shimmerWidget();
    }

    if (nativeAdIsLoaded) {
      return Stack(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height *
                  adAspectRatioMedium *
                  0.26,
              width: MediaQuery.of(context).size.width),
          if (nativeAdIsLoaded && nativeAd != null)
            SizedBox(
                height: MediaQuery.of(context).size.height *
                    adAspectRatioMedium *
                    0.26,
                width: MediaQuery.of(context).size.width,
                child: AdWidget(ad: nativeAd!)),
        ],
      );
    }

    return shimmerWidget();
  }

  Widget shimmerWidget() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 150,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.grey.withValues(alpha: 0.9),
          child: Column(
            children: [
              Expanded(
                  child: Container(
                padding: EdgeInsets.symmetric(vertical: 50.h),
                child: SkeletonUI(),
              )),
              Row(
                children: [
                  SkeletonUI(
                    height: 50,
                    width: 50,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .03,
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SkeletonUI(
                        height: 10,
                        width: MediaQuery.of(context).size.width,
                      ),
                      const SizedBox(height: 10),
                      SkeletonUI(
                        height: 10,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ],
                  )),
                ],
              ),
              const SizedBox(height: 16),
              SkeletonUI(
                height: 40,
                width: MediaQuery.of(context).size.width,
              ),
            ],
          )),
    );
  }
}
