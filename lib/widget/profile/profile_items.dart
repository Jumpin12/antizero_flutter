import 'package:flutter/material.dart';

class ProfileItem extends StatelessWidget {
  final String leftImage;
  final String rightImage;
  final String leftText;
  final String rightText;
  final bool divider;

  const ProfileItem(
      {Key key,
      this.leftImage,
      this.rightImage,
      this.leftText,
      this.rightText,
      this.divider = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: size.width / 3.5,
          child: Column(
            children: [
              Container(
                width: size.width * 0.06,
                height: size.height * 0.06,
                child: Image.asset(leftImage),
              ),
              Text(leftText,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: size.height * 0.02,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        Container(
          height: size.height * 0.08,
          child: VerticalDivider(
            color: divider == true ? Colors.black12 : Colors.transparent,
            thickness: size.width * 0.004,
            width: size.width * 0.004,
          ),
        ),
        Container(
          width: size.width / 3.5,
          child: Column(
            children: [
              Container(
                width: size.width * 0.06,
                height: size.height * 0.06,
                child: Image.asset(rightImage),
              ),
              Text(rightText,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: size.height * 0.02,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}
