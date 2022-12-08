import 'package:antizero_jumpin/handler/local.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ImageCard extends StatelessWidget {
  final String photoUrl;
  const ImageCard({Key key, this.photoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: getScreenSize(context).height * 0.08,
                backgroundImage: AssetImage(blueShadeIcon),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: getScreenSize(context).height * 0.058,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2000),
                  child: CachedNetworkImage(
                    imageUrl: photoUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
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
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
