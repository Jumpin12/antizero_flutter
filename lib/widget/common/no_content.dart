import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';
import '../../utils/colors.dart';

// when screen is empty
class NoContentImage extends StatefulWidget {
  final double height;
  final double width;
  final String text;
  final String refreshText;
  final Function() onRefresh;

  const NoContentImage(
      {Key key,
      this.height,
      this.width,
      this.text,
      this.refreshText,
      this.onRefresh})
      : super(key: key);

  @override
  _NoContentImageState createState() => _NoContentImageState();
}

class _NoContentImageState extends State<NoContentImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/emptyF.png'),
            Text(
              widget.text ?? "No Content",
              textAlign: TextAlign.center,
              style: bodyStyle(
                  context: context,
                  size: 16,
                  color: Colors.blueGrey.withOpacity(0.6)),
            ),
            if (widget.onRefresh != null)
              TextButton(
                  child: Text(
                    widget.refreshText ?? "Refresh",
                    style: textStyle1.copyWith(color: lightGreen, fontSize: 16),
                  ),
                  onPressed: widget.onRefresh)
          ],
        ),
      ),
    );
  }
}
