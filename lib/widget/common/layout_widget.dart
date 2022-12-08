import 'package:flutter/material.dart';

class CustomLayoutWidget extends StatefulWidget {
  final Widget child;
  const CustomLayoutWidget({Key key, this.child}) : super(key: key);

  @override
  _CustomLayoutWidgetState createState() => _CustomLayoutWidgetState();
}

class _CustomLayoutWidgetState extends State<CustomLayoutWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minWidth: constraints.maxWidth, minHeight: constraints.maxHeight),
          child: widget.child,
        ),
      );
    });
  }
}
