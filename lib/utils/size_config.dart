import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;

  static double blockSizeHorizontal;
  static double blockSizeVertical;

  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;
  static double bodyHeight;
  static double bodyWidth;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    bodyWidth = _mediaQueryData.size.width;
    bodyHeight = _mediaQueryData.size.height -
        kToolbarHeight -
        MediaQuery.of(context).padding.top;

    blockSizeHorizontal = bodyWidth / 100;
    blockSizeVertical = bodyHeight / 100;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (bodyWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (bodyHeight - _safeAreaVertical) / 100;
  }
}
