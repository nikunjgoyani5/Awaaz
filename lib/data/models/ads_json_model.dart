// To parse this JSON data, do
//
//     final AdsJsonDataModel = AdsJsonDataModelFromJson(jsonString);

import 'dart:convert';

AdsJsonDataModel adsJsonDataModelFromJson(String str) =>
    AdsJsonDataModel.fromJson(json.decode(str));

String adsJsonDataModelToJson(AdsJsonDataModel data) =>
    json.encode(data.toJson());

class AdsJsonDataModel {
  bool? showAds;
  bool? homeScreenAds;
  int? userClickCounter;
  int? newsListAdsIndex;
  bool? otherAdsWithCounter;
  String? splashInterstitialId;
  Map<String, AdsScreenIntrestitials>? adsData;

  AdsJsonDataModel({
    this.showAds,
    this.homeScreenAds,
    this.otherAdsWithCounter,
    this.adsData,
    this.userClickCounter,
    this.newsListAdsIndex,
    this.splashInterstitialId,
  });

  factory AdsJsonDataModel.fromJson(Map<String, dynamic> json) =>
      AdsJsonDataModel(
        showAds: json['show_ads'],
        homeScreenAds: json['home_screen_ads'],
        userClickCounter: json['user_click_counter'],
        newsListAdsIndex: json['newsListAdsIndex'],
        otherAdsWithCounter: json['other_ads_with_counter'],
        splashInterstitialId: json['splashInterstitialId'],
        adsData: json['ads_data'] == null
            ? null
            : Map.from(json['ads_data']!).map((key, value) =>
                MapEntry<String, AdsScreenIntrestitials>(
                    key, AdsScreenIntrestitials.fromJson(value))),
      );

  Map<String, dynamic> toJson() => {
        'show_ads': showAds,
        'home_screen_ads': homeScreenAds,
        'user_click_counter': userClickCounter,
        'newsListAdsIndex': newsListAdsIndex,
        'other_ads_with_counter': otherAdsWithCounter,
        'splashInterstitialId': splashInterstitialId,
        'ads_data': Map.from(adsData!).map((key, value) =>
            MapEntry<String, AdsScreenIntrestitials>(key, value.toJson())),
      };
}

class AdsScreenIntrestitials {
  String? adsName;
  String? adsType;
  String? idAds;
  bool? enableAds;

  AdsScreenIntrestitials({
    this.adsName,
    this.adsType,
    this.idAds,
    this.enableAds,
  });

  factory AdsScreenIntrestitials.fromJson(Map<String, dynamic> json) =>
      AdsScreenIntrestitials(
        adsName: json['adsName'],
        adsType: json['adsType'],
        idAds: json['idAds'],
        enableAds: json['enableAds'],
      );

  Map<String, dynamic> toJson() => {
        'adsName': adsName,
        'adsType': adsType,
        'idAds': idAds,
        'enableAds': enableAds,
      };
}
