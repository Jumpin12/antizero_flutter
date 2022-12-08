import 'package:antizero_jumpin/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final decoration1 = BoxDecoration(
  gradient: LinearGradient(
    colors: [Colors.blue[900], Colors.blue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  borderRadius: BorderRadius.circular(10),
);
final decoration2 = BoxDecoration(
  border: Border.all(color: Colors.blue[900]),
  borderRadius: BorderRadius.circular(10),
);
final decoration3 = BoxDecoration(
  borderRadius: BorderRadius.only(
    topRight: Radius.circular(20),
    topLeft: Radius.circular(20),
  ),
  gradient: LinearGradient(
      colors: [Colors.blue[900], Colors.blue],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight),
);
final decoration4 = BoxDecoration(
  gradient: LinearGradient(
      colors: [Colors.blue[900], Colors.blue],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight),
);

final circleBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide(color: Colors.blue[100]));

final rectBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.blue[100]));

LinearGradient gradient2 = LinearGradient(
    colors: [shade1, shade2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight);

LinearGradient gradient3 = LinearGradient(
    colors: [shade2, shade1],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight);

LinearGradient gradient4 = LinearGradient(
colors: [
Color(0xFF3a5df8),
Color(0xFF65c5fb),
Color(0xFF74e9fd),
],
begin: Alignment.centerLeft,
end: Alignment.centerRight,
);
