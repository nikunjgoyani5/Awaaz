import 'dart:developer';

import 'package:eagle_eye/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

import '../core/utils/app_prefrence.dart';

class DeepLinkingUtils {
  static void branchListenLinks(BuildContext context) {
    FlutterBranchSdk.listSession().listen((data) async {
      log('listenDynamicLinks - DeepLink Data: $data');
      if (data.containsKey('navigation')) {
        // if (data['navigation'] != "newsDetails") {
        String newPostId = data['post_id'];
        if (newPostId.isNotEmpty) {
          log('Navigating to Splash with detailsId: $newPostId');
          PrefService.setValue(PrefService.eventDetailsId, newPostId);
        }
        // }
      }
    }, onError: (error) {
      PlatformException platformException = error as PlatformException;
      log('InitSession error: ${platformException.code} - ${platformException.message}');
    });
  }

  static Future<String?> generateShortUrl(
      String newsPostId, String newsTitle, String description) async {
    BranchUniversalObject buo = BranchUniversalObject(
        canonicalIdentifier: 'awaazeye/branch',
        title: newsTitle,
        contentDescription: description,
        keywords: ['Awaazeye', 'News', 'Event'],
        contentMetadata: BranchContentMetaData()
          ..addCustomMetadata('post_id', newsPostId)
          ..addCustomMetadata('navigation', AppRoutes.newsDetails));

    BranchResponse response = await FlutterBranchSdk.getShortUrl(
        buo: buo, linkProperties: BranchLinkProperties(feature: 'Share'));
    if (response.success) {
      log('Link generated: ${response.result} ', name: 'BranchIO');
      return response.result;
    } else {
      log('Error : ${response.errorCode} - ${response.errorMessage}',
          name: 'BranchIO');
      return null;
    }
  }
}

// Reference code
/*
import 'dart:convert';
import 'dart:developer';

import 'package:bookclublm/audio_service/audio_controller.dart';
import 'package:bookclublm/models/play_list_model.dart';
import 'package:bookclublm/models/podcast_model.dart';
import 'package:bookclublm/ui/screens/main/playlist_tab/playlist_detail/playlist_detail_controller.dart';
import 'package:bookclublm/utils/app_routes.dart';
import 'package:bookclublm/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';

class DeepLinkingUtils {
  static void branchListenLinks() {
    FlutterBranchSdk.listSession().listen((data) async {
      log('listenDynamicLinks - DeepLink Data: $data');

      if (data.containsKey('navigation')) {
        if (data['navigation'] != "") {
          bool isLoggedIn =
              preferences.getBool(SharedPreference.IS_LOGGED_IN) ?? false;
          if (!isLoggedIn) {
            Get.offAllNamed(Routes.loginScreen);
            return;
          }

          String currentPage = Get.currentRoute;
          print("Current Route :->$currentPage");
          PodcastDetailData? podcastData;
          if (data['navigation'] == Routes.audioPlayingScreen) {
            try{
                podcastData = PodcastDetailData(
                podcastId: int.parse(data["podcast_id"].toString()),
                categoryId:int.parse(data["category_id"].toString()) ,
                podcastName: data["podcast_name"],
                podcastDescription: data["podcast_description"],
                podcastImage: data["podcast_image"],
                podcastFile: data["podcast_file"],
                lengthInSec:0,
                auther: data["auther"],
                createdDate: data["created_date"] == null
                    ? null
                    : DateTime.parse(data["created_date"]),
                updatedDate: data["updated_date"] == null
                    ? null
                    : DateTime.parse(data["updated_date"]),
                isLike:data["is_like"] != null? int.parse( data["is_like"].toString()):null,
              );
            }catch(e){
              print("$e");
            }


            if (currentPage == Routes.playlistDetailScreen) {
              AudioPlayerController audioPlayerController =
                  Get.find<AudioPlayerController>();
              audioPlayerController.playAudioLesson(
                  podcastDetail: podcastData!  );
            } else {
              AudioPlayerController audioPlayerController =
                  Get.put(AudioPlayerController());

              audioPlayerController.playAudioLesson(
                  podcastDetail: podcastData!);

            }
          } else if (data['navigation'] == Routes.playlistDetailScreen) {
            if (currentPage == Routes.playlistDetailScreen) {
              Get.find<PlayListDetailController>().playListData =
                  PlayListDetailData(
                playlistId: int.parse(data["playlist_id"].toString()),
                playlistName: data["playlist_name"],
              );
              Get.find<PlayListDetailController>()
                  .geMyPlayListPodcasts(int.parse(data["playlist_id"]));
              print("playlistDetailScreen Current Route :->$currentPage");
            } else {
              Get.toNamed(Routes.playlistDetailScreen,
                  arguments: PlayListDetailData(
                    playlistId: int.parse(data["playlist_id"]),
                    playlistName: data["playlist_name"],
                  ));
            }
          }
        }
      }
    }, onError: (error) {
      PlatformException platformException = error as PlatformException;
      log('InitSession error: ${platformException.code} - ${platformException.message}');
    });
  }

*/
/*  static generateLink(
      { required int playlistId, required String playlistName}) async {
    try {
      BranchResponse response = await FlutterBranchSdk.getShortUrl(
        buo: BranchUniversalObject(title: 'BookClublm',
            canonicalIdentifier: 'flutter/branch',
            canonicalUrl: 'https://BookClublm.app.link?randomized_bundle_token=1320383003280560349',
           ),
        linkProperties: BranchLinkProperties(channel: 'facebook',
            feature: 'sharing',

            stage: 'new share',
            campaign: 'campaign',
            tags: ['one', 'two', 'three'])
          ..addControlParam('\$uri_redirect_mode', '1')..addControlParam(
              'navigation', Routes.playlistDetailScreen)..addControlParam(
              "playlist_id", playlistId)..addControlParam(
              "playlist_name", playlistName),);
      log("response--_${response.result}");
      return response.result;
    } catch (e) {
      // return BranchResponse.error(
      //     errorCode: "0.0.0.0", errorMessage: e.toString());


      return e.toString();
    }
  }*/ /*


  static Future<String?> generateShortUrl(
      int playlistId, String playlistName) async {
    BranchUniversalObject buo = BranchUniversalObject(
        canonicalIdentifier: 'bookclublm/branch',
        title: 'BookClublm',
        contentDescription: 'Share $playlistName Playlist',
        keywords: ['BookClublm', 'Playlist', 'Share'],
        contentMetadata: BranchContentMetaData()
          ..addCustomMetadata('playlist_id', playlistId)
          ..addCustomMetadata('playlist_name', playlistName)
          ..addCustomMetadata('navigation', Routes.playlistDetailScreen));

    BranchResponse response = await FlutterBranchSdk.getShortUrl(
        buo: buo, linkProperties: BranchLinkProperties(feature: 'Share'));
    if (response.success) {
      log('Link generated: ${response.result} ', name: 'BranchIO');
      return response.result;
    } else {
      log('Error : ${response.errorCode} - ${response.errorMessage}',
          name: 'BranchIO');
      return null;
    }
  }

  static Future<String?> generatePodcastShortUrl(
      PodcastDetailData podcastDetail) async {
    BranchUniversalObject buo = BranchUniversalObject(
        canonicalIdentifier: 'bookclublm/branch',
        title: 'BookClublm',
        contentDescription: 'Share ${podcastDetail.podcastName} Podcast',
        keywords: ['BookClublm', 'Podcast', 'Share'],
        contentMetadata: BranchContentMetaData()
          ..addCustomMetadata("podcast_id", podcastDetail.podcastId)
          ..addCustomMetadata("category_id", podcastDetail.categoryId)
          ..addCustomMetadata("podcast_name", podcastDetail.podcastName)
          ..addCustomMetadata("podcast_description", podcastDetail.podcastDescription)
          ..addCustomMetadata("podcast_image", podcastDetail.podcastImage)
          ..addCustomMetadata("podcast_file", podcastDetail.podcastFile)
          ..addCustomMetadata("length_in_sec", podcastDetail.lengthInSec)
          ..addCustomMetadata("auther", podcastDetail.auther)
          ..addCustomMetadata("created_date", podcastDetail.createdDate.toString())
          ..addCustomMetadata("updated_date", podcastDetail.updatedDate.toString())
          ..addCustomMetadata('navigation', Routes.audioPlayingScreen));

    BranchResponse response = await FlutterBranchSdk.getShortUrl(
        buo: buo, linkProperties: BranchLinkProperties(feature: 'Share'));
    if (response.success) {
      log('Link generated: ${response.result} ', name: 'BranchIO');
      return response.result;
    } else {
      log('Error : ${response.errorCode} - ${response.errorMessage}',
          name: 'BranchIO');
      return null;
    }
  }
}
*/
