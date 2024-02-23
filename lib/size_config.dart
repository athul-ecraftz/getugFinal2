import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    orientation = _mediaQueryData!.orientation;
  }
}

double getProportionateScreenHeight(double inputHeight) {
  if (SizeConfig.screenHeight != null) {
    double screenHeight = SizeConfig.screenHeight!;
    return (inputHeight / 812.0) * screenHeight;
  } else {
    return 0;
  }
}

double getProportionateScreenWidth(double inputWidth) {
  if (SizeConfig.screenWidth != null) {
    double screenWidth = SizeConfig.screenWidth!;
    return (inputWidth / 375.0) * screenWidth;
  } else {
    return 0;
  }
}
