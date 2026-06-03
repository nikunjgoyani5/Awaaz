// import 'package:flutt
import 'package:eagle_eye/core/utils/skeleton_ui.dart';
import 'package:eagle_eye/services/connectivity_check/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

import 'ads_helper.dart';

class BannerAdsWidget extends StatefulWidget {
  final String adLbl;
  final String? sizes;

  const BannerAdsWidget({super.key, required this.adLbl, this.sizes});

  @override
  State<BannerAdsWidget> createState() => _BannerAdsWidgetState();
}

class _BannerAdsWidgetState extends State<BannerAdsWidget> {
  BannerAd? bannerAd;
  bool isBannerLoaded = false;
  bool isFailedBanner = false;
  bool isBannerLoad = false;

  loadAd() async {
    isBannerLoad = true;
    setState(() {});
    // final AnchoredAdaptiveBannerAdSize? size =
    //     await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
    //         Get.width.truncate());
    // if (size == null) {
    //   Get.log("Banner Ad Size Doesn't Get");
    //   return;
    // }
    bannerAd = BannerAd(
      adUnitId: adsHelper.bannerAdId(widget.adLbl),
      // adUnitId: widget.adLbl,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          isBannerLoaded = true;
          isBannerLoad = false;
          isFailedBanner = false;
          setState(() {});
        },
        onAdFailedToLoad: (ad, err) {
          isBannerLoaded = false;
          isBannerLoad = false;
          isFailedBanner = true;
          setState(() {});
        },
      ),
    )..load();
  }

  @override
  void initState() {
    if (networkConnectionServices.isNetworkConnected &&
        adsHelper.getshowAds() &&
        adsHelper.getAdsIsEnable(widget.adLbl)) {
      loadAd();
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (bannerAd != null) {
      bannerAd!.dispose();
      bannerAd = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!networkConnectionServices.isNetworkConnected ||
        !adsHelper.getshowAds() ||
        !adsHelper.getAdsIsEnable(widget.adLbl) ||
        isFailedBanner) {
      return const SizedBox.shrink();
    }
    if (isBannerLoad) {
      return Padding(
        padding: EdgeInsets.only(top: 0, bottom: 10),
        child: shimmerWidget(),
      );
    }

    if (isBannerLoaded) {
      return Padding(
        padding: EdgeInsets.only(top: 0, bottom: 0),
        child: SizedBox(
          height: bannerAd!.size.height.toDouble(),
          width: bannerAd!.size.width.toDouble(),
          child: AdWidget(ad: bannerAd!),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget shimmerWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: 40,
      width: double.infinity,
      child: Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.grey.withValues(alpha: 0.9),
          child: Row(
            children: [
              SkeletonUI(
                height: 50,
                width: 50,
              ),
              const SizedBox(
                width: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonUI(
                    height: 12,
                    width: 130,
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  SkeletonUI(
                    height: 12,
                    width: 100,
                  ),
                ],
              ),
              Spacer(),
              SkeletonUI(
                width: 80,
                height: 40,
              )
            ],
          )),
    );
  }
}
