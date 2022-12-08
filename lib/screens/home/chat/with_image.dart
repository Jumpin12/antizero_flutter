import 'dart:io';

import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:flutter/material.dart';

class ChatWithImage extends StatelessWidget {
  final File imageFile;
  final Function onClear;
  final Function onCrop;
  final Function onSend;
  final bool loading;
  const ChatWithImage(
      {Key key,
      this.imageFile,
      this.onClear,
      this.onCrop,
      this.onSend,
      this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black.withOpacity(0.2),
          child: Image.file(imageFile),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 10.0),
            child: Card(
              color: Colors.black.withOpacity(0.3),
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 22.0,
                  ),
                  onPressed: onClear),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0, right: 10.0),
            child: Card(
              color: Colors.black.withOpacity(0.3),
              child: IconButton(
                  icon: Icon(
                    Icons.crop,
                    color: Colors.white,
                    size: 22.0,
                  ),
                  onPressed: onCrop),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0, right: 20.0, bottom: 30),
            child: loading
                ? fadedCircle(15, 15, color: Colors.blue[100])
                : FloatingActionButton(
                    onPressed: onSend,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.send,
                      color: blue,
                    ),
                  ),
          ),
        )
      ],
    );
  }
}
