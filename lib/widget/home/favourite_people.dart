import 'package:antizero_jumpin/models/favourite_model.dart';
import 'package:antizero_jumpin/models/favourite_new_model.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class FavouriteBox extends StatelessWidget {
  final FavouriteModelNew favourite;

  const FavouriteBox({
    Key key,
    this.favourite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('favourite ${favourite.favourite}');
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: favourite.bg,
          shape: BoxShape.rectangle,
          border: Border.all(color: blueborder),
          borderRadius: BorderRadius.all(Radius.circular(10))),
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: favourite.iconbg,
                        shape: BoxShape.rectangle,
                        border: Border.all(color: white),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: ImageIcon(
                      AssetImage(favourite.icon),
                      color: Colors.white,
                      size: SizeConfig.blockSizeHorizontal * 6,
                    )
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 40,
                    child: Text(favourite.label,
                        textScaleFactor: 1,
                        style: GoogleFonts.dancingScript(
                          color: Colors.white,
                          fontSize: 10.sp
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 1,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(favourite.favourite.replaceAll('[', '').replaceAll(']', ''),
                      textScaleFactor: 1,
                      style: TextStyle(
                          fontFamily: sFui,
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
