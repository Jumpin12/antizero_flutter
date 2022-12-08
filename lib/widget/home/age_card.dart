import 'package:antizero_jumpin/handler/local.dart';
import 'package:antizero_jumpin/handler/profile.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';

class AgeCard extends StatefulWidget {
  final DateTime dob;
  final String gender;
  const AgeCard({Key key, this.dob, this.gender}) : super(key: key);

  @override
  _AgeCardState createState() => _AgeCardState();
}

class _AgeCardState extends State<AgeCard> {
  int age;

  @override
  void initState() {
    age = getAgeFromDob(widget.dob);
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        decoration: BoxDecoration(
          // shape: NeumorphicShape.convex,
          borderRadius: BorderRadius.circular(12),
          // depth: -10,
          // surfaceIntensity: 0.5,
          // lightSource: LightSource.top,
          // intensity: 1,
          color: Colors.cyan[800],
        ),
        child: Container(
          height: getScreenSize(context).height * 0.15,
          width: getScreenSize(context).width * 0.26,
          padding: EdgeInsets.all(getScreenSize(context).height * 0.015),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        age == null ? 'N/A' : '${age.toString()} Years',
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 2.9,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.gender,
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontFamily: sFuiSemi,
                            fontSize: SizeConfig.blockSizeHorizontal * 2.9,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: ImageIcon(
                      widget.gender == 'Female'
                          ? AssetImage(femaleIcon)
                          : AssetImage(maleIcon),
                      size: SizeConfig.blockSizeHorizontal * 8,
                      color: Colors.white.withOpacity(0.9),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
