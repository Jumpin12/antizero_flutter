import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:flutter/material.dart';

class GenderIcon extends StatelessWidget {
  final Function onTap;
  final bool selected;
  final String genderImg;
  const GenderIcon({Key key, this.onTap, this.selected, this.genderImg})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ImageIcon(AssetImage(genderImg),
          color: selected ? Colors.blue : Colors.black54,
          size: SizeConfig.blockSizeHorizontal * 6),
    );
  }
}
