import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';

class BuildBottomSheetItem extends StatefulWidget {
  final Function onTap;
  final Widget itemIcon;
  final String itemName;

  const BuildBottomSheetItem(
      {Key key, this.onTap, this.itemIcon, this.itemName})
      : super(key: key);

  @override
  _BuildBottomSheetItemState createState() => _BuildBottomSheetItemState();
}

class _BuildBottomSheetItemState extends State<BuildBottomSheetItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.blue[100],
              child: widget.itemIcon,
            ),
          ),
          Text(
            '${widget.itemName}',
            style: TextStyle(
                color: Colors.white,
                fontFamily: tre,
                fontSize: 14.0,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
