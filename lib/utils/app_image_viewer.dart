import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppImageViewer {
  static showAssetImage(
      {required String path, BoxFit? boxFit, double? height, double? width}) {
    return Image.asset(
      path,
      fit: boxFit ?? BoxFit.contain,
      height: height,
      width: width,
    );
  }

  static Widget showNetworkImage({
    required String? url,
    BoxFit? boxFit,
    double? height,
    double? width,
    Widget? placeholder,
  }) {
    final safeUrl = url ?? '';

    // Placeholder widget
    final placeholderWidget = placeholder ??
        Container(
          height: height ?? 30,
          width: width ?? 30,
          color: Colors.grey,
          child: const Icon(
            Icons.error,
            color: Colors.red,
            size: 16,
          ),
        );

    // Handle empty or invalid URLs
    if (safeUrl.isEmpty) {
      return placeholderWidget;
    }

    return kIsWeb
        ? Image.network(
            safeUrl,
            fit: boxFit ?? BoxFit.contain,
            height: height,
            width: width,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return placeholderWidget;
            },
            errorBuilder: (context, error, stackTrace) {
              return placeholderWidget;
            },
          )
        : CachedNetworkImage(
            imageUrl: safeUrl,
            fit: boxFit ?? BoxFit.contain,
            height: height,
            width: width,
            placeholder: (context, url) => placeholderWidget,
            errorWidget: (context, url, error) => placeholderWidget,
          );
  }
}
