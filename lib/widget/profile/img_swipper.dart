import 'package:antizero_jumpin/handler/local.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ImageSwiper extends StatelessWidget {
  final List<String> images;
  const ImageSwiper({Key key, this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Swiper(
      autoplay: false,
      pagination: SwiperControl(
          iconPrevious:
              Icon(Icons.navigate_before, color: ColorsJumpIn.kSecondaryColor)
                  .icon,
          iconNext: Icon(
            Icons.navigate_next,
            color: ColorsJumpIn.kSecondaryColor,
          ).icon),
      itemBuilder: (BuildContext context, int index) {
        return CircleAvatar(
          radius: getScreenSize(context).height * 0.058,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2000),
            child: CachedNetworkImage(
              imageUrl: images[index],
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
        );
      },
      itemCount: images.length,
      viewportFraction: 1,
      scale: 0.9,
    );
  }
}
