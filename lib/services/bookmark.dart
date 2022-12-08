import 'package:antizero_jumpin/models/bookmark.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookMarkService {
  CollectionReference bookRef =
      FirebaseFirestore.instance.collection('bookmark');

  // check if people already bookmarked
  Future<bool> checkIfPeopleBookMarked(String id, String peopleId) async {
    try {
      var snaps = await bookRef.where('userId', isEqualTo: id).get();
      if (snaps.docs.length > 0) {
        BookMark bookMark = BookMark.fromJson(snaps.docs.first.data());
        if (bookMark.peopleMark.contains(peopleId)) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print('Error : ${e.toString()}');
      return false;
    }
  }

  // check if plan already bookmarked
  Future<bool> checkIfPlanBookMarked(String id, String planId) async {
    try {
      var snaps = await bookRef.where('userId', isEqualTo: id).get();
      if (snaps.docs.length > 0) {
        BookMark bookMark = BookMark.fromJson(snaps.docs[0].data());
        if (bookMark.planMark.contains(planId)) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // get user bookmark document
  Future<BookMark> getUserBookMark(String id) async {
    try {
      var snaps = await bookRef.where('userId', isEqualTo: id).get();
      if (snaps.docs != null) {
        if (snaps.docs.length > 0) {
          BookMark bookMark = BookMark.fromJson(snaps.docs[0].data());
          return bookMark;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print('Error caught in getting bookmark : ${e.toString()}');
      return null;
    }
  }

  // update bookmark
  Future<bool> updateBookMark(String uid, BookMark bookMark) async {
    try {
      await bookRef.doc(bookMark.id).update(bookMark.toJson());
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // add bookmark
  Future<bool> addBookMark(BookMark bookMark) async {
    try {
      await bookRef
          .doc(bookMark.id)
          .set(bookMark.toJson(), SetOptions(merge: true));
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
