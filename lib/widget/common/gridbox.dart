import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GridBox extends StatelessWidget {
  final String label;
  final String subCatImage;
  final Color color;

  const GridBox(
      {Key key,
        this.label,
        this.subCatImage,
        this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(left: 2.0,right: 2.0),
            child: Container(
              width: size.height * 0.12,
              height: size.height * 0.12,
              padding: EdgeInsets.only(top: 0, bottom: 2, left: 2, right: 2),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[350],
                  image: DecorationImage(
                    image: NetworkImage(subCatImage),
                    fit: BoxFit.cover,
                  )),
            ),
          ),
        ),
        SizedBox(height: 2),
        Container(
          width: size.height * 0.13,
          child: Align(
            alignment: Alignment.center,
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text:
                '${label.toUpperCase()}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
