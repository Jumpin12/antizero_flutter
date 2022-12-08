import 'package:flutter/material.dart';

class HandStackContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const HandStackContainer({Key key, this.child, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: padding ?? EdgeInsets.only(top: 60.0),
        child: Container(
          height: 250,
          width: size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  alignment: Alignment.topCenter,
                  colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.3), BlendMode.dstATop),
                  image: const AssetImage(
                      'assets/images/Onboarding/hands_distant.jpg'),
                  fit: BoxFit.fill)),
          child: child,
        ),
      ),
    );
  }
}
