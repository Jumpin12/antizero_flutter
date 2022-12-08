import 'package:antizero_jumpin/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

String tre = 'TrebuchetMS';
String sFui = 'SFUIText-Bold';
String sFuiSemi = 'SFUIText-Semibold';

TextStyle fonts(FontWeight fontWeight,double fontSize,Color color)
{
  return GoogleFonts.poppins(
    fontWeight: fontWeight,
    fontSize: fontSize,
    color: color,
  );
}


TextStyle headingStyle(
    {@required BuildContext context,
    @required double size,
    @required Color color}) {
  return Theme.of(context)
      .textTheme
      .headline1
      .copyWith(fontSize: size, color: color);
}

TextStyle bodyStyle(
    {@required BuildContext context,
    @required double size,
    @required Color color,
    FontWeight fontWeight}) {
  return Theme.of(context)
      .textTheme
      .bodyText1
      .copyWith(fontSize: size, color: color, fontWeight: fontWeight ?? null);
}

TextStyle textStyle1 = TextStyle(
  fontFamily: sFui,
  fontSize: 16,
  fontWeight: FontWeight.bold,
);
TextStyle textStyle2 = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 16,
  color: blue,
);
TextStyle textStyle3 = TextStyle(
  fontFamily: sFuiSemi,
  fontSize: 12,
  color: white,
  fontWeight: FontWeight.w500,
);
TextStyle textStyle4 = TextStyle(fontSize: 13, fontWeight: FontWeight.w500);

TextStyle textStyle5 = TextStyle(
    fontSize: 18, color: black.withOpacity(.7), fontWeight: FontWeight.w500);

TextStyle textStyle6 =
    TextStyle(fontSize: 18, color: white, fontWeight: FontWeight.w500);
TextStyle textStyle7 =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: white);
TextStyle textStyle8 = TextStyle(
  color: Colors.grey[700],
  fontSize: 18,
);
