import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/provider/company.dart';
import 'package:antizero_jumpin/services/company.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

setCompany(BuildContext context) async {
  print('setCompany');
  var _companyList = await locator.get<CompanyService>().getCompany();
  if (_companyList != null) {
    Provider.of<CompanyProvider>(context, listen: false).companies = _companyList;
  }
}



