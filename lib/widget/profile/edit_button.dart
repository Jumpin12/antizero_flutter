import 'package:antizero_jumpin/utils/decoration.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EditButton extends StatelessWidget {
  final Color textColor;
  final Function onPress;
  final String label;

  const EditButton(
      {Key key,
      this.textColor,
      this.onPress,
      this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onPress,
      child: Container(
          height: size.height * 0.05,
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          decoration: BoxDecoration(
            gradient: gradient4,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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
