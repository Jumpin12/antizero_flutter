import 'package:antizero_jumpin/handler/home.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

setDistanceForFilter(Map<String, dynamic> currentUserGeo,
    Map<String, dynamic> anotherUserGeo) async {
  var dist = await calculateDistance(
      startLat: currentUserGeo['Lat'],
      startLong: currentUserGeo['Long'],
      endLat: anotherUserGeo['Lat'],
      endLong: anotherUserGeo['Long']);
  print("object $dist");
  return dist;
}

class FilterProvider extends ChangeNotifier {
  Future<JumpInUser> currentUser = getCurrentUser();
  Map<String, dynamic> currentUsergeoPoint;
  CollectionReference PeopleReference =
      FirebaseFirestore.instance.collection("users");
  getUsersByDistance() async {
    currentUsergeoPoint =
        await currentUser.then((JumpInUser value) => value.geoPoint);
    setDistanceForFilter(
        currentUsergeoPoint, {"Lat": 27.8524355, "Long": 77.4055079});
  }
}

Future<JumpInUser> getCurrentUser() async {
  return await AuthService().getUser();
}
