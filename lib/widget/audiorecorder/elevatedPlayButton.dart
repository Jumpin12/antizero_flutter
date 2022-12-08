import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';

class CreateElevatedButtonPlay extends StatelessWidget {
  // IconData icon, Color iconColor, Function onPressFunc, String label
  final Function onPressFunc;
  final Color iconColor;
  final IconData icon;
  final String label;

  const CreateElevatedButtonPlay(
      {Key key, this.onPressFunc, this.iconColor, this.icon,this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(12.0),
        side: BorderSide(
          color: Colors.blue,
          width: 4.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        primary: Colors.blue,
        elevation: 9.0,
      ),
      onPressed: onPressFunc,
      icon: Icon(
        icon,
        color: iconColor,
        size: 25.0,
      ),
      label: Text('$label',textAlign:TextAlign.center,style:
      textStyle1.copyWith(
          color: Colors.white, fontSize: 13)),
    );
  }
}