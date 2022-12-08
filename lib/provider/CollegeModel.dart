import 'package:flutter/material.dart';

class CollegeProvider extends ChangeNotifier {
  int _college = 0;
  int get getCurrentCollege => _college;

  setCurrentCollege(int val) {
    _college = val;
    notifyListeners();
  }
}
