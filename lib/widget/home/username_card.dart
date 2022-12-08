import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String name;
  const UserCard({Key key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.35,
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(name,
            textScaleFactor: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorsJumpIn.kPrimaryColor,
                fontSize: SizeConfig.blockSizeHorizontal * 3.7)),
      ),
    );
  }
}
