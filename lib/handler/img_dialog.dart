import 'dart:ui';
import 'package:antizero_jumpin/widget/common/image_picker.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
ImageDialog({BuildContext parentContext, Function camera, Function gallery}) {
  return showDialog(
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      useSafeArea: true,
      useRootNavigator: true,
      context: parentContext,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: CustomPopup(
            takePhoto: camera,
            fromGallery: gallery,
          ),
        );
      });
}
