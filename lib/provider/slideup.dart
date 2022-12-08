import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
class SlideUpProvider with ChangeNotifier {
  bool isShow = false;

  void updateState(bool newState) {
    isShow = newState;
    notifyListeners();
  }
}