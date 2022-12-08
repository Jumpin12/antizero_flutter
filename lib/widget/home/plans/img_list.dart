import 'dart:io';

import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomImageCard extends StatelessWidget {
  final File imgFile;
  final Function onDelete;
  const CustomImageCard({Key key, this.imgFile, this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('imgFile.toString() ${imgFile.toString()}');
    return Stack(
      children: [
        imgFile.toString().contains('https://') ?
        CircleAvatar(
          radius: 55.0,
          backgroundImage:
          NetworkImage(imgFile.path),
          backgroundColor: Colors.black,
        ) :
        CircleAvatar(
          backgroundColor: Colors.black,
          radius: 55,
          backgroundImage: FileImage(imgFile),
        )
        ,
        Align(
          alignment: Alignment.topLeft,
          child: CircleAvatar(
            backgroundColor: Colors.redAccent,
            radius: 18,
            child: Center(
                child: IconButton(
              onPressed: onDelete,
              icon: Icon(
                Icons.clear,
                size: 20,
                color: Colors.white,
              ),
            )),
          ),
        )
      ],
    );
  }
}
