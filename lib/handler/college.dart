import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/provider/college.dart';
import 'package:antizero_jumpin/provider/company.dart';
import 'package:antizero_jumpin/services/college.dart';
import 'package:antizero_jumpin/services/company.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

setCollege(BuildContext context) async {
  print('setCollege');
  var _collegeList = await locator.get<CollegeService>().getCollege();
  if (_collegeList != null)
  {
    Provider.of<CollegeProvider>(context, listen: false).college = _collegeList;
  }
}



