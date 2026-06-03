import 'package:eagle_eye/core/widget/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../theme/colors.dart';

class AppWebViewWidget extends StatefulWidget {
  final String appbarTitle;
  final String url;

  const AppWebViewWidget(
      {super.key, required this.appbarTitle, required this.url});

  @override
  State<AppWebViewWidget> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<AppWebViewWidget> {
  late WebViewController controller;

  bool isLoading = true;
  int progress = 0;

  @override
  void initState() {
    controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onProgress: (int progress) {
            setState(() {
              this.progress = progress;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
    // ..loadRequest(Uri.parse(
    //       "https://sites.google.com/view/olympium-live-custom-match/home"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppCommonAppBar(
        bgColor: Colors.transparent,
        title: widget.appbarTitle,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            SizedBox(
              child: LinearProgressIndicator(
                value: progress / 100,
                color: AppColors.whiteColor,
              ),
            ),
        ],
      ),
    );
  }
}
