import 'package:antizero_jumpin/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomIconCard extends StatelessWidget {
  final Function onTap;
  final Color color;
  final IconData icon;
  const CustomIconCard(
      {Key key, this.onTap, this.color, this.icon = Icons.arrow_back_ios})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      color: color,
      child: Center(
        child: IconButton(
            icon: Icon(
              icon,
              color: brown,
              size: 20.0,
            ),
            onPressed: onTap),
      ),
    );
  }
}
