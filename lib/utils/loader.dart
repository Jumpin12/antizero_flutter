import 'package:antizero_jumpin/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_indicator/loading_indicator.dart';

const List<Color> _kDefaultRainbowColors = const [
  Colors.teal
];


Widget ballClipRotateMultiple(double height, double width) => Center(
      child: SizedBox(
          height: height,
          width: width,
          child: LoadingIndicator(
            indicatorType: Indicator.ballClipRotateMultiple,
            colors: _kDefaultRainbowColors
          )),
    );

Widget fadedCircle(double height, double width, {Color color}) => Center(
      child: SizedBox(
          width: width ?? 32,
          height: height ?? 32,
          child: LoadingIndicator(
            indicatorType: Indicator.ballScaleMultiple,
            colors: _kDefaultRainbowColors ?? Colors.white,
          )),
    );

var spinKit = SpinKitThreeBounce(
  color: blue,
  size: 30.0,
  // duration: Duration(milliseconds: 500),
);
