import 'package:cached_network_image/cached_network_image.dart';
import 'package:eagle_eye/core/constant/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../gen/assets.gen.dart';
import 'common_app_image_show.dart';

class AppNetworkImageLoader extends StatelessWidget {
  final String url;
  final double? height;
  final double? width;
  final double? borderRadius;
  final BoxFit? boxFit;
  final SvgGenImage? placeHolderIMAGE;

  const AppNetworkImageLoader(
      {super.key,
      required this.url,
      this.height,
      this.width,
      this.placeHolderIMAGE,
      this.borderRadius,
      this.boxFit});

  bool _isValidUrl(String url) {
    if (url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isValidUrl(url)) {
      return placeHolderIMAGE != null
          ? SizedBox(
              height: height ?? 28,
              width: width ?? 28,
              child: placeHolderIMAGE!.svg(fit: boxFit ?? BoxFit.contain))
          : Container(
              height: height ?? 28,
              width: width ?? 28,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: AppImageViewer.showAssetImage(
                path: AppImageAsset.appIcon,
                boxFit: boxFit ?? BoxFit.fill,
              ),
            );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 15),
      child: CachedNetworkImage(
        height: height ?? 28,
        width: width ?? 28,
        fit: boxFit ?? BoxFit.contain,
        progressIndicatorBuilder: (context, url, progress) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[600]!,
            highlightColor: Colors.grey[200]!,
            child: Container(
              height: height ?? 28,
              width: width ?? 28,
              decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(borderRadius ?? 7.0)),
            ),
          );
        },
        errorWidget: (context, url, error) {
          return placeHolderIMAGE != null
              ? SizedBox(
                  height: height ?? 28,
                  width: width ?? 28,
                  child: placeHolderIMAGE!.svg(fit: boxFit ?? BoxFit.contain))
              : Container(
                  height: height ?? 28,
                  width: width ?? 28,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: AppImageViewer.showAssetImage(
                    path: AppImageAsset.appIcon,
                    boxFit: boxFit ?? BoxFit.fill,
                  ),
                );
        },
        imageUrl: url,
      ),
    );
  }
}
