import 'package:antizero_jumpin/handler/local.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';

class BookmarkCard extends StatelessWidget {
  final bool marked;
  final Function onPress;

  const BookmarkCard(
      {Key key,
        this.marked,this.onPress,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return InkWell(
        onTap: onPress,
        child: Container(
          padding: EdgeInsets.all(4.0),
          child:  (marked==true) ?
            Image.asset(bookmarkPIcon, height: size.height * 0.05) :
            Image.asset(bookmarkIcon, height: size.height * 0.05),
    ),
      );
  }
}
