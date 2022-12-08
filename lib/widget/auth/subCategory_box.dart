import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SubCategoryBox extends StatelessWidget {
  final Function onTap;
  final BoxConstraints constraints;
  final String label;
  final String subCatImage;
  final Color color;
  final bool checkBox;

  const SubCategoryBox(
      {Key key,
      this.onTap,
      this.constraints,
      this.label,
      this.subCatImage,
      this.color,
      this.checkBox})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: onTap,
          child: Container(
            width: constraints.maxWidth / 3,
            height: constraints.maxHeight / 3,
            margin: EdgeInsets.all(constraints.maxHeight * 0.012),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2000),
                image: DecorationImage(
                    colorFilter:
                        ColorFilter.mode(Colors.black26, BlendMode.colorBurn),
                    image: subCatImage != null
                        ? CachedNetworkImageProvider(
                            subCatImage,
                          )
                        : AssetImage(
                            'assets/images/Onboarding/Interests/academic/astronomy.jpg'),
                    fit: BoxFit.cover)),
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2000),
              child: Container(
                color: color,
                width: constraints.maxWidth / 3,
                height: constraints.maxHeight / 3,
                alignment: Alignment.center,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ),
        if (checkBox)
          Align(
            alignment: Alignment.topRight,
            child: Container(
                width: 30,
                height: 30,
                margin: EdgeInsets.only(top: 10, right: 12),
                child: Image.asset("assets/images/Onboarding/checked.png")),
          ),
      ],
    );
  }
}
