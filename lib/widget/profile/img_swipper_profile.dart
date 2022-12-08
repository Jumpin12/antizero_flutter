import 'package:antizero_jumpin/handler/local.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ImageSwiperProfile extends StatelessWidget {
  final List<String> images;
  const ImageSwiperProfile({Key key, this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Swiper(
      autoplay: false,
      pagination: new SwiperPagination(
        alignment: Alignment.center,
        builder: new DotSwiperPaginationBuilder(
            color: Colors.grey, activeColor: Color(0xff38547C)),
      ),
      itemBuilder: (BuildContext context, int index) {
        return CachedNetworkImage(
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
        );
      },
      itemCount: images.length,
      viewportFraction: 1,
      scale: 0.9,
    );
  }
}
