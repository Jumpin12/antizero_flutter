import 'package:antizero_jumpin/handler/local.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/decoration.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MoreInformationCard extends StatelessWidget {
  final String icon;
  final String label;
  final String planDesc;
  final AlignmentGeometry iconAlign;
  final AlignmentGeometry textAlign;

  const MoreInformationCard(
      {Key key,
        this.icon,
        this.label,
        this.planDesc,
        this.iconAlign,
        this.textAlign})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getScreenSize(context).width - 20,
      margin: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.all(4),
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: bluetextchat.withOpacity(0.1),
                  shape: BoxShape.rectangle,
                  border: Border.all(color: bluetextchat.withOpacity(0.1)),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: 20,
                      width: 20,
                      child: Center(
                        child: SvgPicture.asset(icon),
                      )),
                ],
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Align(
                    alignment: textAlign,
                    child: Text(
                      label,
                      textScaleFactor: 1,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      planDesc ?? 'N/A',
                      maxLines: 2,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: bodyStyle(
                          context: context, size: 12, color: Colors.black54),
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 1,
                  child: Container(
                    color: blue.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
