import 'package:flutter/material.dart';

extension SpaceWidget on Widget {
  spaceH(double height) {
    return SizedBox(
      height: height,
    );
  }

  spaceW(double width) {
    return SizedBox(
      width: width,
    );
  }
}