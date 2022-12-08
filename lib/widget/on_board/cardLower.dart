import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';

class CustomCardLower extends StatelessWidget {
  final String text;
  final String imgsrc;
  final Alignment icon;
  final Alignment textAlignment;
  const CustomCardLower(
      {this.icon, this.textAlignment, this.text, this.imgsrc, key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: 90,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.cyan[800],
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Expanded(
          flex: 5,
          child: Align(
            alignment: icon,
            child: ImageIcon(AssetImage(imgsrc),
                size: 25, color: Colors.white.withOpacity(0.9)),
          ),
        ),
        Expanded(
          flex: 5,
          child: Align(
            alignment: textAlignment,
            child: Text(
              text,
              style: textStyle3,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
        )
      ]),
    );
  }
}
