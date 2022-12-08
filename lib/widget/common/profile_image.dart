import 'dart:io';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ShowUserImage extends StatefulWidget {
  final File imgFile;
  final String imgUrl;
  final Function onPressed;

  const ShowUserImage({Key key, this.imgFile, this.imgUrl, this.onPressed})
      : super(key: key);

  @override
  _ShowUserImageState createState() => _ShowUserImageState();
}

class _ShowUserImageState extends State<ShowUserImage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60.0,
          backgroundColor: Colors.blue[100],
          child: CircleAvatar(
            radius: 55.0,
            backgroundImage: widget.imgFile == null && widget.imgUrl == null
                ? AssetImage(avatarIcon)
                : widget.imgFile != null
                    ? FileImage(widget.imgFile)
                    : NetworkImage(widget.imgUrl),
          ),
        ),
        Positioned(
          right: 2.0,
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
            ),
            child: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.edit,
                  size: 14.0,
                  color: Colors.white,
                ),
                onPressed: widget.onPressed),
          ),
        ),
      ],
    );
  }
}
