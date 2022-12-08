import 'dart:collection';
import 'package:antizero_jumpin/models/college.dart';
import 'package:antizero_jumpin/models/company.dart';
import 'package:flutter/material.dart';

class CollegeProvider extends ChangeNotifier {
  String _selectedCollege = "";
  String _currentCollege;
  List<College> _collegies = [];
  bool loading = false;

  String get getSelectedCollege => _selectedCollege;

  String get currentCollege=> _currentCollege;

  UnmodifiableListView<College> get college =>
      UnmodifiableListView(_collegies);

  set college(List<College> collegeList)
  {
    _collegies = collegeList;
    notifyListeners();
  }

  set currentCollege(String cat) {
    _currentCollege = cat;
    notifyListeners();
  }

  set setSelectedCollege(String college) {
    _selectedCollege = college;
    notifyListeners();
  }

}
