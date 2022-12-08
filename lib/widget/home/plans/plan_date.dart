import 'package:antizero_jumpin/handler/local.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';

class DateTimeCard extends StatelessWidget {
  final Widget icon;
  final String planDateTime;
  final String dayTime;
  final String label;
  final bool isMultiDay;
  final String planEndDate;
  final AlignmentGeometry iconAlign;
  final AlignmentGeometry textAlign;
  final Color bgcolor;

  const DateTimeCard(
      {Key key,
      this.planDateTime,
      this.icon,
      this.dayTime,
      this.label,
      this.planEndDate,
      this.isMultiDay,
      this.iconAlign,
      this.textAlign,
      this.bgcolor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.only(right: 8, top: 4, left: 8, bottom: 4),
      decoration: BoxDecoration(
          color: bgcolor,
          shape: BoxShape.rectangle,
          border: Border.all(color: blueborder),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(alignment: iconAlign, child: icon),
              ),
              if (dayTime != null)
                Align(
                  alignment: textAlign,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      dayTime,
                      textScaleFactor: 1,
                      style: TextStyle(
                          fontFamily: sFuiSemi,
                          fontSize: SizeConfig.blockSizeHorizontal * 3,
                          color: Colors.black.withOpacity(0.9),
                          fontWeight: FontWeight.w800),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
              Expanded(
                child: Align(
                  alignment: textAlign,
                  child: Text(
                    this.isMultiDay
                        ? '$planDateTime - $planEndDate'
                        : planDateTime,
                    textScaleFactor: 1,
                    style: TextStyle(
                        fontFamily: sFuiSemi,
                        fontSize: SizeConfig.blockSizeHorizontal * 2.9,
                        color: Colors.black.withOpacity(0.9),
                        fontWeight: FontWeight.w800),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
