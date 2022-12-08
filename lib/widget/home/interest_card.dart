import 'package:antizero_jumpin/handler/local.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:flutter/material.dart';

class InterestCard extends StatelessWidget {
  final String interest;
  const InterestCard({Key key, this.interest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: 0,
        bottom: 0,
        child: Container(
          height: getScreenSize(context).height * 0.15,
          width: getScreenSize(context).width * 0.26,
          padding: EdgeInsets.all(getScreenSize(context).height * 0.015),
          decoration: BoxDecoration(
            // shape: NeumorphicShape.convex,
            borderRadius: BorderRadius.circular(12),
            // depth: -10,
            // surfaceIntensity: 0.5,
            // lightSource: LightSource.top,
            // intensity: 1,
            color: Colors.cyan[800],
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 5,
                  child: Align(
                      alignment: Alignment.topRight,
                      child: ImageIcon(
                        const AssetImage(interestIcon),
                        size: SizeConfig.blockSizeHorizontal * 8,
                        color: Colors.white.withOpacity(0.9),
                      )),
                ),
                Expanded(
                  flex: 5,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(interest,
                        textScaleFactor: 1,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: SizeConfig.blockSizeHorizontal * 2.9,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ]),
        ));
  }
}
