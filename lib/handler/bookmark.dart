import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/bookmark.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/provider/bookmark.dart';
import 'package:antizero_jumpin/provider/plan.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/services/bookmark.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:antizero_jumpin/utils/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

Future<bool> isPeopleBookMarked(BuildContext context, String peopleId) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser == null) {
    return false;
  } else {
    return await locator
        .get<BookMarkService>()
        .checkIfPeopleBookMarked(userProvider.currentUser.id, peopleId);
  }
}

Future<bool> removePeopleFromBookMark(
    BuildContext context, String peopleId) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser == null) {
    return false;
  } else {
    BookMark _bookMark = await locator
        .get<BookMarkService>()
        .getUserBookMark(userProvider.currentUser.id);
    if (_bookMark == null) {
      return false;
    } else {
      BookMark bookMark = _bookMark;
      bookMark.peopleMark.removeWhere((element) => element == peopleId);
      return await locator
          .get<BookMarkService>()
          .updateBookMark(userProvider.currentUser.id, bookMark);
    }
  }
}

Future<bool> addPeopleToBookMark(BuildContext context, String peopleId) async {
  BookMark bookMark = BookMark();
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser == null) {
    return false;
  } else {
    BookMark _bookMark = await locator
        .get<BookMarkService>()
        .getUserBookMark(userProvider.currentUser.id);
    if (_bookMark == null) {
      var id = Uuid().v4();
      bookMark.id = id;
      bookMark.peopleMark = [peopleId];
      bookMark.userId = userProvider.currentUser.id;
      bookMark.planMark = [];
      return await locator.get<BookMarkService>().addBookMark(bookMark);
    } else {
      bookMark = _bookMark;
      bookMark.peopleMark.add(peopleId);
      return await locator
          .get<BookMarkService>()
          .updateBookMark(userProvider.currentUser.id, bookMark);
    }
  }
}

Future<bool> isPlanBookMarked(BuildContext context) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  var planProvider = Provider.of<PlanProvider>(context, listen: false);
  if (userProvider.currentUser == null || planProvider.currentPlan == null) {
    return false;
  } else {
    return await locator.get<BookMarkService>().checkIfPlanBookMarked(
        userProvider.currentUser.id, planProvider.currentPlan.id);
  }
}

Future<bool> removePlanFromBookMark(BuildContext context, String planId) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser == null) {
    return false;
  } else {
    BookMark _bookMark = await locator
        .get<BookMarkService>()
        .getUserBookMark(userProvider.currentUser.id);
    if (_bookMark == null) {
      return false;
    } else {
      BookMark bookMark = _bookMark;
      bookMark.planMark.removeWhere((element) => element == planId);
      return await locator
          .get<BookMarkService>()
          .updateBookMark(userProvider.currentUser.id, bookMark);
    }
  }
}

Future<bool> addPlanToBookMark(BuildContext context, String planId) async {
  print('planId $planId');
  BookMark bookMark = BookMark();
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser == null) {
    return false;
  } else {
    BookMark _bookMark = await locator
        .get<BookMarkService>()
        .getUserBookMark(userProvider.currentUser.id);
    if (_bookMark == null) {
      var id = Uuid().v4();
      bookMark.id = id;
      bookMark.peopleMark = [];
      bookMark.userId = userProvider.currentUser.id;
      bookMark.planMark = [];
      bookMark.planMark.add(planId);
      return await locator.get<BookMarkService>().addBookMark(bookMark);
    } else {
      bookMark = _bookMark;
      bookMark.planMark.add(planId);
      return await locator
          .get<BookMarkService>()
          .updateBookMark(userProvider.currentUser.id, bookMark);
    }
  }
}

Future<bool> getUserBookMark(BuildContext context) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  var bookMarkProvider = Provider.of<BookMarkProvider>(context, listen: false);
  if (userProvider.currentUser == null) {
    return false;
  } else {
    BookMark bookMark = await locator
        .get<BookMarkService>()
        .getUserBookMark(userProvider.currentUser.id);
    if (bookMark != null) {
      // company general mode setting
      bookMarkProvider.bookMark = bookMark;
      return true;
    } else {
      return false;
    }
  }
}
