import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:expand_widget/expand_widget.dart';

class ExtraDetail extends StatelessWidget {
  final String icon;
  final String label;
  final String text;
  const ExtraDetail({Key key, this.icon, this.label, this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null)
                Container(
                  height: size.height * 0.05,
                  padding: EdgeInsets.only(right: size.width * 0.02),
                  child: Image.asset(icon),
                ),
              Text(label,
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: size.height * 0.02,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        if (label != null)
          SizedBox(
            height: 10,
          ),
        Container(
          width: size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue[300],
                  Colors.blue[100],
                ]),
            boxShadow: [
              BoxShadow(
                  color: Colors.white.withOpacity(0.2),
                  offset: Offset(2, -4),
                  blurRadius: 5.0),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: ExpandText(
            text,
            style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontSize: 16,
                wordSpacing: 1.0,
                fontWeight: FontWeight.w600,
                fontFamily: tre),
            maxLines: 4,
            capitalArrowtext: true,
            expandOnGesture: false,
            expandedHint: 'Close',
            collapsedHint: 'Read More',
            arrowColor: blue,
            hintTextStyle: TextStyle(
                color: blue,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: tre),
            expandArrowStyle: ExpandArrowStyle.both,
            overflow: TextOverflow.fade,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
