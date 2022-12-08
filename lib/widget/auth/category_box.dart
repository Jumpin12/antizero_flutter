import 'package:flutter/material.dart';

class CategoryBox extends StatelessWidget {
  final double depth;
  // final LightSource lightSource;
  final Color color;
  final Color textColor;
  final BoxConstraints constraints;
  final Function onTap;
  final Function onLongPress;
  final String label;

  const CategoryBox(
      {this.depth,
      // this.lightSource,
      this.color,
      this.constraints,
      this.onTap,
      this.onLongPress,
      this.label,
      this.textColor,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(
            constraints.maxWidth * 0.03,
            constraints.maxHeight * 0.03,
            constraints.maxWidth * 0.06,
            constraints.maxHeight * 0.03),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            // boxShape: NeumorphicBoxShape.roundRect(
            //     BorderRadius.circular(12)),
            // depth: depth,
            // surfaceIntensity: 0.1,
            // lightSource: lightSource,
            // intensity: 0.9,
            color: color),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Container(
            width: constraints.maxWidth * 0.3,
            height: (constraints.maxHeight * 0.2) * 0.8,
            padding:
                EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.02),
            child: Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.018,
                    fontWeight: FontWeight.w600,
                    color: textColor),
              ),
            ),
          ),
        ));
  }
}
