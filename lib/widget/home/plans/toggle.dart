import 'package:flutter/material.dart';

class FABToggle extends StatelessWidget {
  final Color color;
  final Function onTap;
  final String tool;
  final Widget child;
  const FABToggle({Key key, this.onTap, this.color, this.tool, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FloatingActionButton(
        heroTag: null,
        backgroundColor: color,
        onPressed: onTap,
        tooltip: tool,
        child: child,
      ),
    );
  }
}
