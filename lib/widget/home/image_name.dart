import 'dart:math';

import 'package:antizero_jumpin/utils/colors.dart';
import 'package:flutter/material.dart';

class GetImageName extends StatelessWidget {
  final String label;
  const GetImageName({Key key, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Random random = Random();
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.height * 0.12,
      height: size.height * 0.12,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
          color: randomColor[random.nextInt(18)]),
      child: Center(
          child: Text(
        label,
        style: TextStyle(
            color: Colors.white,
            fontSize: size.height * 0.03,
            fontWeight: FontWeight.w800),
      )),
    );
  }
}
