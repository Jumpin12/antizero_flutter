import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/widget/common/fade_animation.dart';
import 'package:flutter/material.dart';

class CustomTime extends StatelessWidget {
  final Function onTap;
  final String label;
  const CustomTime({Key key, this.onTap, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return FadeAnimation(
      0.2,
      GestureDetector(
        onTap: onTap,
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue.withOpacity(0.1),
            ),
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.015, horizontal: size.width * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                      fontSize: size.height * 0.02,
                      fontWeight: FontWeight.w400,
                      color: Colors.black.withOpacity(0.7)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: size.width * 0.02),
                  child: Icon(
                    Icons.calendar_today_outlined,
                    size: 20,
                    color: blue,
                  ),
                )
              ],
            )),
      ),
    );
  }
}
