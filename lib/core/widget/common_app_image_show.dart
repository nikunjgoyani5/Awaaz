import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constant/app_assets.dart';

class AppImageViewer {
  static showAssetImage(
      {required String path,
      BoxFit? boxFit,
      double? height,
      double? width,
      EdgeInsets? padding}) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Image.asset(
        path,
        fit: boxFit ?? BoxFit.contain,
        height: height,
        width: width,
      ),
    );
  }

  static showFileImage(
      {required File file,
      BoxFit? boxFit,
      double? height,
      double? width,
      EdgeInsets? padding}) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Image.file(
        file,
        fit: boxFit ?? BoxFit.contain,
        height: height,
        width: width,
      ),
    );
  }

  static showNetworkImage(
      {required String url, BoxFit? boxFit, double? height, double? width}) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: boxFit ?? BoxFit.contain,
      height: height,
      width: width,
      placeholder: (context, url) {
        return showAssetImage(path: AppImageAsset.appIcon);
      },
      errorWidget: (context, url, error) {
        return showAssetImage(path: AppImageAsset.appIcon);
      },
    );
  }
}
