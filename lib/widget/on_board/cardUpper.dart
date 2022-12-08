import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';

class CustomCardUpper extends StatelessWidget {
  final String title;

  final String imgsrc;
  final Alignment icon;
  final Alignment textAlignment;
  const CustomCardUpper(
      {this.title, this.icon, this.textAlignment, this.imgsrc, key})
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 5,
            child: Align(
              alignment: textAlignment,
              child: Text(
                title,
                style: textStyle3,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Align(
                alignment: icon,
                child: ImageIcon(
                  AssetImage(imgsrc),
                  size: 35,
                  color: Colors.white,
                )),
          )
        ],
      ),
    );
  }
}
