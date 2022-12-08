import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final Function onPress;
  final String icon;
  final String label;
  const CardButton(
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
              borderRadius: BorderRadius.circular(10), color: color),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (icon != null) Image.asset(icon, height: size.height * 0.022),
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
