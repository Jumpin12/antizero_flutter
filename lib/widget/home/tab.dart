import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  final bool active;
  final String label;
  const CustomTab({Key key, this.active, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return active
        ? Tab(
              text: label,
          )
        : Tab(
              text: label,
          );
  }
}
