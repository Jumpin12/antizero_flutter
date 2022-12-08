import 'dart:collection';
import 'package:antizero_jumpin/models/company.dart';
import 'package:flutter/material.dart';

class CompanyProvider extends ChangeNotifier {
  String _selectedCompany = "Vedantu";
  String _currentCompany;
  List<Company> _companies = [];
  bool loading = false;

  String get getSelectedCompany => _selectedCompany;

  String get currentCompany=> _currentCompany;

  UnmodifiableListView<Company> get companies =>
      UnmodifiableListView(_companies);

  set companies(List<Company> companyList)
  {
    _companies = companyList;
    notifyListeners();
  }

  set currentCompany(String cat) {
    _currentCompany = cat;
    notifyListeners();
  }

  set setSelectedCompany(String company) {
    _selectedCompany = company;
    notifyListeners();
  }

}
