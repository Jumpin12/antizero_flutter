import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/widget/common/img_tile.dart';
import 'package:flutter/material.dart';

class CustomPopup extends StatefulWidget {
  final Function takePhoto;
  final Function fromGallery;
  const CustomPopup({Key key, this.takePhoto, this.fromGallery})
      : super(key: key);

  @override
  _CustomPopupState createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> {
  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            // height: isPortrait
            //     ? MediaQuery.of(context).size.height * 0.2
            //     : MediaQuery.of(context).size.height * 0.65,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Choose image',
                  style: headingStyle(
                      context: context, size: 20, color: Colors.black),
                ),
                SizedBox(height: 20),
                CustomListTile(
                  onTap: widget.takePhoto,
                  title: 'Capture with camera',
                  icon: Icons.camera_alt,
                ),
                SizedBox(height: 5),
                CustomListTile(
                  onTap: widget.fromGallery,
                  title: 'Choose from gallery',
                  icon: Icons.image,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: bodyStyle(
                          context: context, size: 18, color: Colors.red),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
