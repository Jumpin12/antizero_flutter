import 'package:flutter/material.dart';

class ModeProvider extends ChangeNotifier {
  int _mode = 0;
  int get getCurrentMode => _mode;

  setCurrentMode(int val) {
    _mode = val;
    notifyListeners();
  }
}
