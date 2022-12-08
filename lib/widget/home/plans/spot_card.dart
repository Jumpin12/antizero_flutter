import 'package:antizero_jumpin/handler/local.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:antizero_jumpin/widget/auth/gender_icon.dart';
import 'package:antizero_jumpin/widget/home/plans/spots_gender.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SpotCard extends StatelessWidget {
  final int spotsRem;
  final double spotsPercentage;
  final int male;
  final int female;
  final int others;

  const SpotCard(
      {Key key,
      this.spotsRem,
      this.spotsPercentage,
      this.male,
      this.female,
      this.others})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getScreenSize(context).width - 20,
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.only(right: 8, top: 8, left: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.blue[50],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: ImageIcon(
                    AssetImage(spotsIcon),
                    color: Colors.blue.withOpacity(0.9),
                    size: SizeConfig.blockSizeHorizontal * 6,
                  ),
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        spotsRem.toString() + ' Spots left',
                        textScaleFactor: 1,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w800),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ]),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: new LinearPercentIndicator(
              lineHeight: 14.0,
              percent: spotsPercentage,
              linearStrokeCap: LinearStrokeCap.roundAll,
              backgroundColor: interestSubCategorySelectedColor,
              progressColor: Colors.blue,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: SpotsGender(
                spotlabel: "Male",
                spotNumber: male,
                color: Colors.blue[50],
                numColor: Colors.blue,
              )),
              Expanded(
                  child: SpotsGender(
                spotlabel: "Female",
                spotNumber: female,
                color: plangreenlite,
                numColor: plangreen,
              )),
              Expanded(
                  child: SpotsGender(
                spotlabel: "Others",
                spotNumber: others,
                color: planyellowlite,
                numColor: planyellow,
              )),
            ],
          ),
        ],
      ),
    );
  }
}
