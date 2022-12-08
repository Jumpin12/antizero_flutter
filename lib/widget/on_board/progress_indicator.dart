import 'package:antizero_jumpin/handler/local.dart';
import 'package:flutter/material.dart';

class UpperProgressIndicator extends StatelessWidget {
  final String progressImage;
  const UpperProgressIndicator({
    this.progressImage,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getScreenSize(context).height * 0.05,
      child:
          SizedBox(width: 500, height: 50, child: Image.asset(progressImage)),
    );
  }
}
