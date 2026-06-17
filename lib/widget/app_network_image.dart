
import 'package:flutter/material.dart';

import '../../../gen/assets.gen.dart';
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

  @override
  Widget build(BuildContext context) {
    return

      ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 10),
        child: Image.network(
            url,
            height: height ?? 28,
            width :  width ?? 28,
            fit: BoxFit
                .cover,

            errorBuilder: (context, error, stackTrace) {
              return
                Center(
                  child: Assets.image.aawazLogo.svg(
                    height: height ?? 28,
                    width :  width ?? 28,
                    fit: BoxFit
                        .contain,
                  ),
                );
            }
        ),
      );



    //   ClipRRect(
    //   borderRadius: BorderRadius.circular(borderRadius ?? 15),
    //   child: CachedNetworkImage(
    //     imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
    //     height: height ?? 28,
    //     width: width ?? 28,
    //     fit: boxFit ?? BoxFit.cover,
    //     placeholder: (context, url) {
    //       return placeHolderIMAGE != null
    //           ? SizedBox(
    //               height: height ?? 28,
    //               width: width ?? 28,
    //               child: placeHolderIMAGE!.svg(fit: boxFit ?? BoxFit.cover))
    //           : Container(
    //               height: height ?? 28,
    //               width: width ?? 28,
    //               decoration: const BoxDecoration(shape: BoxShape.circle),
    //               child: AppImageViewer.showAssetImage(
    //                 path: Assets.image.noDataSelected.path,
    //                 height: height ?? 28,
    //                 width: width ?? 28,
    //                 boxFit: boxFit ?? BoxFit.cover,
    //               ),
    //             );
    //     },
    //     errorWidget: (context, url, error) {
    //       return placeHolderIMAGE != null
    //           ? SizedBox(
    //               height: height ?? 28,
    //               width: width ?? 28,
    //               child: placeHolderIMAGE!.svg(fit: boxFit ?? BoxFit.cover))
    //           : Container(
    //               height: height ?? 28,
    //               width: width ?? 28,
    //               decoration: const BoxDecoration(shape: BoxShape.circle),
    //               child: AppImageViewer.showAssetImage(
    //                 path: Assets.image.noDataSelected.path,
    //                 height: height ?? 28,
    //                 width: width ?? 28,
    //                 boxFit: boxFit ?? BoxFit.cover,
    //               ),
    //             );
    //     },
    //     imageUrl: url,
    //   ),
    // );
  }
}
