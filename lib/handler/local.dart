import 'package:antizero_jumpin/utils/country_code.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';

Future<String> getDialCode() async {
  String dialCode;
  String locale = await Devicelocale.currentLocale;
  countryLocaleCode.keys.forEach((element) {
    if ((element as String).contains(locale.substring(3))) {
      dialCode = "+${countryLocaleCode[element]}";
      return dialCode;
    } else {
      return null;
    }
  });
  return null;
}

Size getScreenSize(BuildContext context) {
  final Size size = MediaQuery.of(context).size;
  return size;
}
