import 'package:antizero_jumpin/handler/local.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ImageCardNewPeople extends StatelessWidget {
  final String photoUrl;
  const ImageCardNewPeople({Key key, this.photoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        child: CachedNetworkImage(
          imageUrl: photoUrl,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => SpinKitThreeBounce(
            size: getScreenSize(context).height * 0.03,
            color: Colors.white,
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
          height: 100.0,
          width: 100.0,
        ),
      ),
    );
  }
}
