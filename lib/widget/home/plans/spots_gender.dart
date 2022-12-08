import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';

class SpotsGender extends StatelessWidget {
  final Color color;
  final Color numColor;
  final int spotNumber;
  final String spotlabel;

  const SpotsGender(
      {Key key, this.spotlabel, this.spotNumber, this.color, this.numColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: color,
          shape: BoxShape.rectangle,
          border: Border.all(color: blueborder),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: numColor,
              ),
              child: Center(
                child: Text(
                  spotNumber.toString(),
                  textScaleFactor: 1,
                  style: TextStyle(
                      fontFamily: sFuiSemi,
                      fontSize: SizeConfig.blockSizeHorizontal * 2.9,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w800),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              )),
          Align(
            alignment: Alignment.center,
            child: Text(
              spotlabel,
              textScaleFactor: 1,
              style: TextStyle(
                  fontFamily: sFuiSemi,
                  fontSize: SizeConfig.blockSizeHorizontal * 2.9,
                  color: Colors.black.withOpacity(0.9),
                  fontWeight: FontWeight.w800),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          )
        ],
      ),
    );
  }
}
