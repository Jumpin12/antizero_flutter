import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';

class CreateElevatedButton extends StatelessWidget {
  // IconData icon, Color iconColor, Function onPressFunc, String label
  final Function onPressFunc;
  final Color iconColor;
  final IconData icon;
  final String label;

  const CreateElevatedButton(
      {Key key, this.onPressFunc, this.iconColor, this.icon,this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(10.0),
          side: BorderSide(
            color: Colors.blue,
            width: 4.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          primary: Colors.white,
          elevation: 9.0,
        ),
        onPressed: onPressFunc,
        icon: Icon(
          icon,
          color: iconColor,
          size: 30.0,
        ),
        label: Text('$label',style:
        textStyle1.copyWith(
            color: Colors.black, fontSize: 13)),
      );
    }
}