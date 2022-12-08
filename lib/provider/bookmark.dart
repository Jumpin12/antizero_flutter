import 'package:antizero_jumpin/models/bookmark.dart';
import 'package:flutter/material.dart';

class BookMarkProvider with ChangeNotifier {
  BookMark _bookMark;

  BookMark get bookMark => _bookMark;

  set bookMark(BookMark currentBookMark) {
    _bookMark = currentBookMark;
    notifyListeners();
  }
}
