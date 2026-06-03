import 'package:eagle_eye/core/theme/colors.dart';
import 'package:flutter/material.dart';

class ProgressLoader {
  BuildContext? context, dismissingContext;
  bool barrierDismissible = true, showLogs = false, _isShowing = false;

  final double dialogElevation = 8.0, borderRadius = 8.0;
  final Curve _insetAnimCurve = Curves.easeInOut;

  ProgressLoader(BuildContext buildContext, {required bool isDismissible}) {
    context = buildContext;
    barrierDismissible = isDismissible;
  }

  bool isShowing() {
    return _isShowing;
  }

  Future<bool> hide() async {
    try {
      if (_isShowing) {
        _isShowing = false;
        Navigator.of(dismissingContext!).pop();
        if (showLogs) debugPrint('ProgressDialog dismissed');
        return Future.value(true);
      } else {
        if (showLogs) debugPrint('ProgressDialog already dismissed');
        return Future.value(false);
      }
    } catch (err) {
      debugPrint('Seems there is an issue hiding dialog');
      debugPrint(err.toString());
      return Future.value(false);
    }
  }

  Future<bool> show() async {
    try {
      if (!_isShowing) {
        showDialog<dynamic>(
          context: context!,
          barrierDismissible: barrierDismissible,
          builder: (BuildContext context) {
            dismissingContext = context;
            return PopScope(
              canPop: barrierDismissible,
              child: Dialog(
                  insetPadding: const EdgeInsets.only(left: 50, right: 70),
                  backgroundColor: Colors.transparent,
                  insetAnimationCurve: _insetAnimCurve,
                  insetAnimationDuration: const Duration(milliseconds: 100),
                  elevation: dialogElevation,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(borderRadius))),
                  child: const LoaderBody()),
            );
          },
        );
        // Delaying the function for 200 milliseconds
        // [Default transitionDuration of DialogRoute]
        await Future.delayed(const Duration(milliseconds: 200));
        if (showLogs) debugPrint('ProgressDialog shown');
        _isShowing = true;
        return true;
      } else {
        if (showLogs) debugPrint('ProgressDialog already shown/showing');
        return false;
      }
    } catch (err) {
      _isShowing = false;
      debugPrint('Exception while showing the dialog');
      debugPrint(err.toString());
      return false;
    }
  }
}

class LoaderBody extends StatelessWidget {
  const LoaderBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: const CircularProgressIndicator(
        color: AppColors.whiteColor,
      ),
    );
  }
}
