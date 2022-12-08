import 'package:flutter/material.dart';

import 'textStyle.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    Key key,
    this.height,
    this.width,
    this.size,
  }) : super(key: key);

  final double height;
  final double size;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/Onboarding/logo_final.png',
          height: height,
          width: width,
        ),
        Text("JUMPIN",
            style: headingStyle(
                context: context, size: size ?? width, color: Colors.black))
      ],
    );
  }
}
