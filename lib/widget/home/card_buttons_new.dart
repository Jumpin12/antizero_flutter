import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardNewButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final Function onPress;
  final String icon;
  final String label;
  const CardNewButton(
      {Key key,
        this.color,
        this.textColor,
        this.onPress,
        this.label,
        this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onPress,
      child: Container(
          height: size.height * 0.05,
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(color: bluetextchat),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(icon, height: size.height * 0.027),
              Padding(
                padding: EdgeInsets.only(left: size.width * 0.02),
                child: Text(label,
                    textScaleFactor: 1,
                    style: TextStyle(
                        fontFamily: sFui,
                        color: textColor,
                        fontSize: size.height * 0.018,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          )),
    );
  }
}
