import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';

class InterestCard extends StatelessWidget {
  final String url;
  final String title;
  final double size;
  const InterestCard({Key key, this.url, this.title, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: size != null ? size : 60,
          backgroundColor: Colors.blue[100],
          child: CircleAvatar(
            radius: size != null ? size * 0.9 : 55,
            backgroundImage: NetworkImage(url),
          ),
        ),
        Text(
          title,
          style: textStyle1.copyWith(
              fontFamily: tre,
              fontSize: size != null ? size * 0.4 : 14,
              fontWeight: FontWeight.w600,
              color: Colors.black54),
        )
      ],
    );
  }
}
