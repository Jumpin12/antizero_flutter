import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:antizero_jumpin/handler/profile.dart';
import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/models/connection.dart';
import 'package:antizero_jumpin/models/contacts.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/models/sub_category.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/screens/on_board/splashScreen.dart';
import 'package:antizero_jumpin/services/interest.dart';
import 'package:antizero_jumpin/utils/common_methods.dart';
import 'package:antizero_jumpin/utils/locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:georange/georange.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:math' as math;

import '../main.dart';
import '../screens/dashboard/dashboard.dart';

class UserService
{
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  GeoRange georange = GeoRange();

  // update token in user collection
  Future<void> updateMode(String id, int mode) async
  {
    var doc = await userServ.userRef.doc(id).get();
    if(doc.exists){
      Map<String, dynamic> map = doc.data();
      if(map.containsKey('mode'))
      {
        // Replace field by the field you want to check.
        await userServ.userRef.doc(id).update({'mode': mode});
      }
      else
      {
        JumpInUser user = await locator.get<UserService>().getUserById(id);
        user.mode = mode;
        await userRef.doc(id).set(user.toJson()).catchError((e) {
          showToast('Error caught!');
          return null;
        });
      }
    }
  }

  // update user as deactive if user exist in user collection
  Future<void> updateDeactive(String id, int deactivate) async
  {
    var doc = await userServ.userRef.doc(id).get();
    if(doc.exists)
    {
      Map<String, dynamic> map = doc.data();
      if(map.containsKey('deactivate'))
      {
        // Replace field by the field you want to check.
        await userServ.userRef.doc(id).update({'deactivate': deactivate});
      }
      else
      {
        JumpInUser user = await locator.get<UserService>().getUserById(id);
        user.deactivate = deactivate;
        await userRef.doc(id).set(user.toJson()).catchError((e) {
          showToast('Error caught!');
          return null;
        });
      }
    }
  }

  // update token in user collection
  Future<void> saveDeviceToken(String id, String fcmToken) async {
    if (fcmToken != null) {
      String token = fcmToken;
      try {
        await userServ.userRef.doc(id).update({'token': token});
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> deleteUsers(String id) async {
    if (id != null)
    {
      try {
        await userServ.userRef.doc(id).delete();
      } catch (e) {
        print(e.toString());
      }
    }
  }

  // get current user
  Future<JumpInUser> getCurrentUser() async {
    JumpInUser user;
    String uid = '';
    try {
      User fireUser = await authServ.currentUser();
      if (fireUser != null) {
        uid = fireUser.uid;
        DocumentSnapshot snapshot = await userRef.doc(uid).get();
        if (snapshot.exists) {
          JumpInUser _user = JumpInUser.fromJson(snapshot.data());
          if (_user != null) {
            user = _user;
            return user;
          } else {
            return null;
          }
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      showToast('Something went wrong!');
      print('Error $e');
      return null;
    }
  }

  Future<bool> deleteFirebaseUser() async
  {
    print('deleteFirebaseUser');
    try {
      User fireUser = await authServ.currentUser();
      if (fireUser != null) {
        print('fireUser ${fireUser.uid}');
        // delete Users
        // delete plans where host current user
        // delete bookmarks
        // delete firebase User
        deleteUsers(fireUser.uid);
        // fireUser.delete();
      } else {
        return null;
      }
    } catch (e) {
      showToast('Something went wrong!');
      print('Error $e');
      return null;
    }
  }

  // get current user by id
  Future<JumpInUser> getUserById(String id) async {
    try {
      DocumentSnapshot snapshot = await userRef.doc(id).get();
      if (snapshot.exists) {
        JumpInUser user = JumpInUser.fromJson(snapshot.data());
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print('Error $e');
      return null;
    }
  }

  // check username
  Future<bool> checkUserName(String uName) async {
    QuerySnapshot uNameSnap = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: uName)
        .get()
        .catchError((e) {
      showToast(e.toString());
    });

    if (uNameSnap.docs.length > 0) {
      return false;
    } else {
      return true;
    }
  }

  // upload user
  Future<String> uploadUser({File img, JumpInUser user}) async {
    List<String> imgUrls = [];
    User firebaseUser = await authServ.currentUser();
    if (firebaseUser == null) {
      return null;
    } else {
      user.id = firebaseUser.uid;
      user.email = firebaseUser.email;
      // if (firebaseUser.photoURL != null) {
      //   String imgUrl = firebaseUser.photoURL;
      //   imgUrls.add(imgUrl);
      // }
      user.phoneNo = firebaseUser.phoneNumber;
      String url = await uploadImage(img, user.id);
      if (url != null) imgUrls.add(url);
      user.photoList = imgUrls;
      user.createdAt = DateTime.now();
      user.contacts = [];
      user.connection = [];
      user.plans = [];
      user.searchUname = '${user.username}_${user.id}';
      await userRef.doc(user.id).set(user.toJson()).catchError((e) {
        showToast('Error caught!');
        return null;
      });
      return user.id;
    }
  }

  // upload image
  Future<String> uploadImage(File file, String id) async {
    var uuid = Uuid().v4();
    var fileExtension = path.extension(file.path);
    var firebaseStorageRef =
        FirebaseStorage.instance.ref().child('users/$id/$uuid$fileExtension');
    await firebaseStorageRef.putFile(file).catchError((onError) {
      showToast('Error caught in saving image!');
      return null;
    });
    String url = await firebaseStorageRef.getDownloadURL();
    print('url $url');
    return url;
  }

  // upload image
  Future<String> uploadAudio(File file, String id) async {
    var uuid = Uuid().v4();
    var fileExtension = path.extension(file.path);
    var firebaseStorageRef =
    FirebaseStorage.instance.ref().child('users/$id/$uuid$fileExtension');
    await firebaseStorageRef.putFile(file).catchError((onError) {
      showToast('Error caught in saving audio!');
      return null;
    });
    String url = await firebaseStorageRef.getDownloadURL();
    print('url $url');
    return url;
  }

  // update plan
  Future<JumpInUser> updateUser(JumpInUser currentUser) async {
    try {
      await userRef.doc(currentUser.id).update(currentUser.toJson());
      return await getCurrentUser();
    } catch (e) {
      debugPrint("Error $e");
      return null;
    }
  }

  // update profile
  Future<JumpInUser> updateProfile(JumpInUser currentUser,
      {File imgFile,File audioFile}) async {
    JumpInUser _user = await getCurrentUser();
    String url,audioUrl;
    if (_user.id != null) currentUser.id = _user.id;
    if (imgFile != null) url = await uploadImage(imgFile, _user.id);
    if (audioFile != null) audioUrl = await uploadAudio(audioFile, _user.id);
    if (url != null) currentUser.photoList.add(url);
    if (audioUrl != null) currentUser.audio = audioUrl;
    print('currentUser favourites ${currentUser.favourites}');
    try {
      await userRef.doc(_user.id).update(currentUser.toJson());
      return await getCurrentUser();
    } catch (e) {
      debugPrint("Error $e");
      return null;
    }
  }

  // Future<JumpInUser> updateFavourites(Map<String, dynamic> data) async {
  //   JumpInUser user = await getCurrentUser();
  //   if (data.isNotEmpty) {
  //     user.favourites = data;
  //     try {
  //       await userRef.doc(user.id).update(user.toJson());
  //       return await getCurrentUser();
  //     } catch (e) {
  //       print(e);
  //       showToast('Please try after sometime!');
  //       return null;
  //     }
  //   }
  // }
  Future<JumpInUser> updateFavourites(Map<String, dynamic> data) async {
    JumpInUser user = await getCurrentUser();
    print('updateFavourites user.favourites ${user.favourites}');
    if (data != null) {
      user.favourites.addAll(data);
      try {
        await userRef.doc(user.id).update(user.toJson());
        return await getCurrentUser();
      } catch (e) {
        print(e);
        showToast('Please try after sometime!');
        return null;
      }
    }
  }

  // update interest
  Future<JumpInUser> updateInterest(List<String> interestIds) async {
    JumpInUser user = await getCurrentUser();
    if (user != null) {
      user.interestList = interestIds;
      try {
        await userRef.doc(user.id).update(user.toJson());
        return await getCurrentUser();
      } catch (e) {
        print(e);
        showToast('Please try after sometime!');
        return null;
      }
    } else {
      return null;
    }
  }

  // fetch all users
  Future<List<JumpInUser>> getAllUser(BuildContext context,
      {int limit, double precision, LocationType locationType}) async {
    List<JumpInUser> userList = [];
    try {
      var userSnaps;
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      //India -> 142
      //Outside India -> 76
      print('get placeOfWork ${userProvider.currentUser.placeOfWork}');
      print('userProvider.userState ${userProvider.userState}');
      print('userProvider.userCountry ${userProvider.userCountry}');
      if (userProvider.userState == null && userProvider.userCountry == null) {
        if(userProvider.currentUser.placeOfEdu!=null || userProvider.currentUser.placeOfWork!=null)
          {
            // String companyName = getCompanyNameFromMode(context);
            String companyName,collegeName;
            List malList = getCompanyOrCollegeNameFromMode(context);
            if(malList!=null && malList.length>0)
            {
              if(malList.first == 1)
              {
                companyName = malList.last;
              }
              else if(malList.first == 2)
              {
                collegeName = malList.last;
              }
              else
              {
                companyName = '';
                collegeName = '';
              }
            }
            if(companyName!= null && companyName.length>0)
              {
                userSnaps = await userRef
                    .where('placeOfWork',isEqualTo: userProvider.currentUser.placeOfWork).
                orderBy('createdAt', descending: true).limit(500).get();
              }
            else if(collegeName!= null && collegeName.length>0)
            {
              userSnaps = await userRef
                  .where('placeOfEdu',isEqualTo: userProvider.currentUser.placeOfEdu).
              orderBy('createdAt', descending: true).limit(500).get();
            }
            else
              {
                userSnaps = await userRef.
                orderBy('createdAt', descending: true).limit(500).get();
              }
          }
        else
          {
            print('No');
            userSnaps = await userRef.orderBy('createdAt', descending: true).limit(500).get();
          }
      } else {
        if (locationType == LocationType.SearchWithinState &&
            userProvider.userState != null) {
          if (userProvider.currentUser.placeOfWork != null || userProvider.currentUser.placeOfEdu !=null)
          {
            // String companyName = getCompanyNameFromMode(context);
            String companyName,collegeName;
            List malList = getCompanyOrCollegeNameFromMode(context);
            if(malList!=null && malList.length>0)
            {
              if(malList.first == 1)
              {
                companyName = malList.last;
              }
              else if(malList.first == 2)
              {
                collegeName = malList.last;
              }
              else
              {
                companyName = '';
                collegeName = '';
              }
            }
            if (companyName.length > 0)
            {
              userSnaps = await userRef
                .where('location.state', isEqualTo: userProvider.userState)
                .where('location.country', isEqualTo: userProvider.userCountry)
                .where('placeOfWork',
                isEqualTo: companyName)
                .orderBy('createdAt', descending: true)
                .limit(limit)
                .get();
            }
            else if (companyName.length > 0)
            {
              userSnaps = await userRef
                  .where('location.state', isEqualTo: userProvider.userState)
                  .where('location.country', isEqualTo: userProvider.userCountry)
                  .where('placeOfEdu', isEqualTo: collegeName)
                  .orderBy('createdAt', descending: true)
                  .limit(limit)
                  .get();
            }
            else
            {
              userSnaps = await userRef
                  .where('location.state', isEqualTo: userProvider.userState)
                  .where('location.country', isEqualTo: userProvider.userCountry)
                  .orderBy('createdAt', descending: true)
                  .limit(limit)
                  .get();
            }
          }
          else
            userSnaps = await userRef
              .where('location.state', isEqualTo: userProvider.userState)
              .where('location.country', isEqualTo: userProvider.userCountry)
              .orderBy('createdAt', descending: true)
              .limit(limit)
              .get();
        }
        if (locationType == LocationType.SearchWithinCountry &&
            userProvider.userCountry != null) {
          if(userProvider.currentUser.placeOfWork!=null || userProvider.currentUser.placeOfEdu!=null)
            {
              // String companyName = getCompanyNameFromMode(context);
              String companyName,collegeName;
              List malList = getCompanyOrCollegeNameFromMode(context);
              if(malList!=null && malList.length>0)
              {
                if(malList.first == 1)
                {
                  companyName = malList.last;
                }
                else if(malList.first == 2)
                {
                  collegeName = malList.last;
                }
                else
                {
                  companyName = '';
                  collegeName = '';
                }
              }
              if (companyName.length > 0)
              {
                userSnaps = await userRef
                    .orderBy('location.state')
                    .where('location.state', isNotEqualTo: userProvider.userState)
                    .where('location.country', isEqualTo: userProvider.userCountry)
                    .where('placeOfWork',isEqualTo: companyName)
                    .orderBy('createdAt', descending: true)
                    .limit(limit)
                    .get();
              }
              else if (collegeName.length > 0)
              {
                userSnaps = await userRef
                    .orderBy('location.state')
                    .where('location.state', isNotEqualTo: userProvider.userState)
                    .where('location.country', isEqualTo: userProvider.userCountry)
                    .where('placeOfEdu',isEqualTo: collegeName)
                    .orderBy('createdAt', descending: true)
                    .limit(limit)
                    .get();
              }
              else
                {
                  userSnaps = await userRef
                      .orderBy('location.state')
                      .where('location.state', isNotEqualTo: userProvider.userState)
                      .where('location.country', isEqualTo: userProvider.userCountry)
                      .orderBy('createdAt', descending: true)
                      .limit(limit)
                      .get();
                }
            }
          else
            userSnaps = await userRef
                .orderBy('location.state')
                .where('location.state', isNotEqualTo: userProvider.userState)
                .where('location.country', isEqualTo: userProvider.userCountry)
                .orderBy('createdAt', descending: true)
                .limit(limit)
                .get();
        }
        if (locationType == LocationType.SearchOutsideCountry &&
            userProvider.userCountry != null) {
          if(userProvider.currentUser.placeOfWork!=null || userProvider.currentUser.placeOfEdu!=null)
            {
              // String companyName = getCompanyNameFromMode(context);
              String companyName,collegeName;
              List malList = getCompanyOrCollegeNameFromMode(context);
              if(malList!=null && malList.length>0)
              {
                if(malList.first == 1)
                {
                  companyName = malList.last;
                }
                else if(malList.first == 2)
                {
                  collegeName = malList.last;
                }
                else
                {
                  companyName = '';
                  collegeName = '';
                }
              }
              if (companyName!= null && companyName.length > 0)
                {
                  userSnaps = await userRef
                      .orderBy('location.country')
                      .where('location.country', isNotEqualTo: userProvider.userCountry)
                      .where('placeOfWork',isEqualTo: userProvider.currentUser.placeOfWork)
                      .orderBy('createdAt', descending: true)
                      .limit(limit)
                      .get();
                }
              else if (collegeName!= null && collegeName.length > 0)
              {
                userSnaps = await userRef
                    .orderBy('location.country')
                    .where('location.country', isNotEqualTo: userProvider.userCountry)
                    .where('placeOfEdu',isEqualTo: userProvider.currentUser.placeOfEdu)
                    .orderBy('createdAt', descending: true)
                    .limit(limit)
                    .get();
              }
              else
                {
                  userSnaps = await userRef
                      .orderBy('location.country')
                      .where('location.country', isNotEqualTo: userProvider.userCountry)
                      .orderBy('createdAt', descending: true)
                      .limit(limit)
                      .get();
                }
            }
          else
            userSnaps = await userRef
                .orderBy('location.country')
                .where('location.country', isNotEqualTo: userProvider.userCountry)
                .orderBy('createdAt', descending: true)
                .limit(limit)
                .get();
        }
        if (locationType == LocationType.SearchAnywhere) {
          if(userProvider.currentUser.placeOfWork!=null || userProvider.currentUser.placeOfEdu!=null)
            {
            //   String companyName = getCompanyNameFromMode(context);
              String companyName,collegeName;
              List malList = getCompanyOrCollegeNameFromMode(context);
              if(malList!=null && malList.length>0)
              {
                if(malList.first == 1)
                {
                  companyName = malList.last;
                }
                else if(malList.first == 2)
                {
                  collegeName = malList.last;
                }
                else
                {
                  companyName = '';
                  collegeName = '';
                }
              }
              if (companyName!=null && companyName.length > 0)
              {
                userSnaps = await userRef
                    .where('location', isNull: true)
                    .where('placeOfWork',isEqualTo: companyName)
                    .orderBy('createdAt', descending: true)
                    .limit(limit)
                    .get();
              }
              else if (collegeName!=null && collegeName.length > 0)
              {
                userSnaps = await userRef
                    .where('location', isNull: true)
                    .where('placeOfEdu',isEqualTo: collegeName)
                    .orderBy('createdAt', descending: true)
                    .limit(limit)
                    .get();
              }
              else
              {
                userSnaps = await userRef
                    .where('location', isNull: true)
                    .where('placeOfWork',isEqualTo: userProvider.currentUser.placeOfWork)
                    .orderBy('createdAt', descending: true)
                    .limit(limit)
                    .get();
              }
            }
          else
            userSnaps = await userRef
                .where('location', isNull: true)
                .orderBy('createdAt', descending: true)
                .limit(limit)
                .get();

        }
      }
      // JumpInUser lastUser;
      // Timer.periodic(Duration(seconds: 5), (Timer t) async {
      //   lastUser = await testingFunc(lastUser);
      // });
      if (userSnaps != null) {
        userSnaps.docs.forEach((element) {
          JumpInUser user = JumpInUser.fromJson(element.data());
          userList.add(user);
          // print('User Name ${user.name}');
        });
        print('Result list ${userList.length}');
      }
      return userList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // fetch users after certain index
  Future<List<JumpInUser>> getNextUser(BuildContext context,
      {JumpInUser lastUser, int limit, LocationType locationType}) async {
    print('getNextUser $limit ${lastUser.username}');
    List<JumpInUser> userList = [];
    try {
      var userSnaps;
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      //India -> 142
      //Outside India -> 76
      // log(userProvider.userState);
      // log(userProvider.userCountry);
      log('lastUser.createdAt.toIso8601String() ${lastUser.createdAt.toIso8601String()}');
      if (userProvider.userState == null && userProvider.userCountry == null) {
        userSnaps = await userRef.orderBy('createdAt', descending: true).limit(5).get();
      } else {
        if (locationType == LocationType.SearchWithinState &&
            userProvider.userState != null) {
          if(userProvider.currentUser.placeOfWork!=null)
            {
              // String companyName = getCompanyNameFromMode(context);
              String companyName,collegeName;
              List malList = getCompanyOrCollegeNameFromMode(context);
              if(malList!=null && malList.length>0)
              {
                if(malList.first == 1)
                {
                  companyName = malList.last;
                }
                else if(malList.first == 2)
                {
                  collegeName = malList.last;
                }
                else
                {
                  companyName = '';
                  collegeName = '';
                }
              }
              if(companyName!=null && companyName.length>0)
                {
                  userSnaps = await userRef
                      .where('location.state', isEqualTo: userProvider.userState)
                      .where('location.country', isEqualTo: userProvider.userCountry)
                      .where('placeOfWork',isEqualTo: companyName)
                      .orderBy('createdAt', descending: true)
                      .startAfter([lastUser.createdAt.toIso8601String()])
                      .limit(limit)
                      .get();
                }
              else if(collegeName!=null && collegeName.length>0)
              {
                userSnaps = await userRef
                    .where('location.state', isEqualTo: userProvider.userState)
                    .where('location.country', isEqualTo: userProvider.userCountry)
                    .where('placeOfEdu',isEqualTo: collegeName)
                    .orderBy('createdAt', descending: true)
                    .startAfter([lastUser.createdAt.toIso8601String()])
                    .limit(limit)
                    .get();
              }
              else
                {
                  userSnaps = await userRef
                      .where('location.state', isEqualTo: userProvider.userState)
                      .where('location.country', isEqualTo: userProvider.userCountry)
                      .orderBy('createdAt', descending: true)
                      .startAfter([lastUser.createdAt.toIso8601String()])
                      .limit(limit)
                      .get();
                }
            }
          else
            userSnaps = await userRef
                .where('location.state', isEqualTo: userProvider.userState)
                .where('location.country', isEqualTo: userProvider.userCountry)
                .orderBy('createdAt', descending: true)
                .startAfter([lastUser.createdAt.toIso8601String()])
                .limit(limit)
                .get();
        }
        if (locationType == LocationType.SearchWithinCountry &&
            userProvider.userCountry != null) {
          if(userProvider.currentUser.placeOfWork!=null || userProvider.currentUser.placeOfEdu!=null)
            {
              // String companyName = getCompanyNameFromMode(context);
              String companyName,collegeName;
              List malList = getCompanyOrCollegeNameFromMode(context);
              if(malList!=null && malList.length>0)
              {
                if(malList.first == 1)
                {
                  companyName = malList.last;
                }
                else if(malList.first == 2)
                {
                  collegeName = malList.last;
                }
                else
                {
                  companyName = '';
                  collegeName = '';
                }
              }
              if(companyName!=null && companyName.length>0)
              {
                userSnaps = await userRef
                    .orderBy('location.state',descending: true)
                    .where('location.state', isNotEqualTo: userProvider.userState)
                    .where('location.country', isEqualTo: userProvider.userCountry)
                    .where('placeOfWork',isEqualTo: companyName)
                    .orderBy('createdAt', descending: true)
                    .startAfter([lastUser.createdAt.toIso8601String()])
                    .limit(limit)
                    .get();
              }
              else if(collegeName!=null && collegeName.length>0)
              {
                userSnaps = await userRef
                    .orderBy('location.state',descending: true)
                    .where('location.state', isNotEqualTo: userProvider.userState)
                    .where('location.country', isEqualTo: userProvider.userCountry)
                    .where('placeOfEdu',isEqualTo: collegeName)
                    .orderBy('createdAt', descending: true)
                    .startAfter([lastUser.createdAt.toIso8601String()])
                    .limit(limit)
                    .get();
              }
              else
              {
                userSnaps = await userRef
                    .orderBy('location.state',descending: true)
                    .where('location.state', isNotEqualTo: userProvider.userState)
                    .where('location.country', isEqualTo: userProvider.userCountry)
                    .orderBy('createdAt', descending: true)
                    .startAfter([lastUser.createdAt.toIso8601String()])
                    .limit(limit)
                    .get();
              }
            }
          else
            userSnaps = await userRef
                .orderBy('location.state',descending: true)
                .where('location.state', isNotEqualTo: userProvider.userState)
                .where('location.country', isEqualTo: userProvider.userCountry)
                .orderBy('createdAt', descending: true)
                .startAfter([lastUser.createdAt.toIso8601String()])
                .limit(limit)
                .get();
        }
        if (locationType == LocationType.SearchOutsideCountry &&
            userProvider.userCountry != null) {
          if(userProvider.currentUser.placeOfWork!=null || userProvider.currentUser.placeOfEdu!=null)
          {
            // String companyName = getCompanyNameFromMode(context);
            String companyName,collegeName;
            List malList = getCompanyOrCollegeNameFromMode(context);
            if(malList!=null && malList.length>0)
            {
              if(malList.first == 1)
              {
                companyName = malList.last;
              }
              else if(malList.first == 2)
              {
                collegeName = malList.last;
              }
              else
              {
                companyName = '';
                collegeName = '';
              }
            }
            if(companyName!=null && companyName.length>0)
            {
              userSnaps = await userRef
                  .orderBy('location.country', descending: true)
                  .where(
                  'location.country', isNotEqualTo: userProvider.userCountry)
                  .where(
                  'placeOfWork', isEqualTo: companyName)
                  .orderBy('createdAt', descending: true)
                  .startAfter([lastUser.createdAt.toIso8601String()])
                  .limit(limit)
                  .get();
            }
            else if(collegeName!=null && collegeName.length>0)
            {
              userSnaps = await userRef
                  .orderBy('location.country', descending: true)
                  .where(
                  'location.country', isNotEqualTo: userProvider.userCountry)
                  .where(
                  'placeOfEdu', isEqualTo: companyName)
                  .orderBy('createdAt', descending: true)
                  .startAfter([lastUser.createdAt.toIso8601String()])
                  .limit(limit)
                  .get();
            }
            else
              {
                userSnaps = await userRef
                    .orderBy('location.country', descending: true)
                    .where(
                    'location.country', isNotEqualTo: userProvider.userCountry)
                    .orderBy('createdAt', descending: true)
                    .startAfter([lastUser.createdAt.toIso8601String()])
                    .limit(limit)
                    .get();
              }
          }
          else
            userSnaps = await userRef
                .orderBy('location.country',descending: true)
                .where('location.country', isNotEqualTo: userProvider.userCountry)
                .orderBy('createdAt', descending: true)
                .startAfter([lastUser.createdAt.toIso8601String()])
                .limit(limit)
                .get();
        }
        if (locationType == LocationType.SearchAnywhere) {
          if(userProvider.currentUser.placeOfWork!=null || userProvider.currentUser.placeOfEdu!=null)
            {
              // String companyName = getCompanyNameFromMode(context);
              String companyName,collegeName;
              List malList = getCompanyOrCollegeNameFromMode(context);
              if(malList!=null && malList.length>0)
              {
                if(malList.first == 1)
                {
                  companyName = malList.last;
                }
                else if(malList.first == 2)
                {
                  collegeName = malList.last;
                }
                else
                {
                  companyName = '';
                  collegeName = '';
                }
              }
              if(companyName!=null && companyName.length>0)
              {
                userSnaps = await userRef
                    .where('location', isNull: true)
                    .where('placeOfWork',isEqualTo: companyName)
                    .orderBy('createdAt', descending: true)
                    .startAfter([lastUser.createdAt.toIso8601String()])
                    .limit(limit)
                    .get();
              }
              else if(collegeName!=null && collegeName.length>0)
              {
                userSnaps = await userRef
                    .where('location', isNull: true)
                    .where('placeOfEdu',isEqualTo: collegeName)
                    .orderBy('createdAt', descending: true)
                    .startAfter([lastUser.createdAt.toIso8601String()])
                    .limit(limit)
                    .get();
              }
              else
                {
                  userSnaps = await userRef
                      .where('location', isNull: true)
                      .orderBy('createdAt', descending: true)
                      .startAfter([lastUser.createdAt.toIso8601String()])
                      .limit(limit)
                      .get();
                }
            }
          else
            userSnaps = await userRef
                .where('location', isNull: true)
                .orderBy('createdAt', descending: true)
                .startAfter([lastUser.createdAt.toIso8601String()])
                .limit(limit)
                .get();
        }
      }
      if (userSnaps != null) {
        userSnaps.docs.forEach((element) {
          // print('username ${JumpInUser.fromJson(element.data()).username}');
          JumpInUser user = JumpInUser.fromJson(element.data());
          userList.add(user);
        });
        print('Result list ${userList.length}');
      }
      return userList;
    } catch (e) {
      print('Error : ${e.toString()}');
      return null;
    }
  }

  Future<JumpInUser> testingFunc(JumpInUser lastUser) async {
    List<JumpInUser> userList = [];
    var docSnap;
    if (lastUser == null)
      docSnap =
          await userRef.orderBy('createdAt', descending: true).limit(5).get();
    else
      docSnap = await userRef
          .orderBy('createdAt', descending: true)
          .startAfter([lastUser.createdAt.toIso8601String()])
          .limit(5)
          .get();

    for (var i = 0; i < docSnap.docs.length; i++) {
      String state;
      String country;
      JumpInUser user = JumpInUser.fromJson(docSnap.docs[i].data());
      if (docSnap.docs[i].data()["location"] == null) {
        String address;
        if (user.geoPoint != null) {
          address = await getAddressFromLatLng(
              Lat: user.geoPoint['Lat'], Long: user.geoPoint['Long']);
          if (address != null) {
            List<String> addressList = address.split(',');
            state = addressList[0].trim();
            country = addressList[1].trim();
          }
        }
        print("$state ----> $country");
        await userRef.doc(user.id).update({
          'location': user.geoPoint != null && address != null
              ? {
                  'state': state,
                  'country': country,
                }
              : null
        });
      }
      userList.add(user);
    }
    return userList.last;
  }

  Future<List<JumpInUser>> getAllUsersEmailAddress(BuildContext context,int limit) async
  {
    print('getAllUsersEmailAddress services');
    List<JumpInUser> userList = [];
    try {
      var userSnaps;
      userSnaps = await userRef.orderBy('createdAt', descending: true).limit(limit).get();
      if (userSnaps != null)
      {
        userSnaps.docs.forEach((element)
        {
          JumpInUser user = JumpInUser.fromJson(element.data());
          userList.add(user);
        });
        print('Total users ${userList.length}');
      }
      return userList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<JumpInUser>> getAllNextUsersEmailAddress(BuildContext context,int limit,JumpInUser previousUser) async
  {
    print('getAllNextUsersEmailAddress services ${previousUser.username}');
    List<JumpInUser> userList = [];
    try {
      var userSnaps;
      userSnaps = await userRef.orderBy('createdAt', descending: true).limit(limit).startAfter([previousUser.createdAt.toIso8601String()]).get();
      if (userSnaps != null)
      {
        userSnaps.docs.forEach((element)
        {
          JumpInUser user = JumpInUser.fromJson(element.data());
          userList.add(user);
        });
      }
      return userList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Search users first
  Future<List<JumpInUser>> getSearchUsersFirst({int limit, String query}) async {
    print('getSearchUsersFirst');
    List<JumpInUser> userList = [];
    try {
      var userSnaps = await userRef
          .orderBy("search_uname")
          .orderBy('createdAt', descending: true)
          .startAt([query])
          .endAt(["$query${"\uf8ff"}"])
          .limit(limit)
          .get();
      userSnaps.docs.forEach((element) {
        JumpInUser user = JumpInUser.fromJson(element.data());
        print('user ${user.username}');
        userList.add(user);
      });
      return userList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Search users next
  Future<List<JumpInUser>> getSearchUsersNext(
      {String previousUser, int limit, String query}) async {
    print('previousUser $previousUser');
    List<JumpInUser> userList = [];
    try {
      var userSnaps = await userRef
          .orderBy("search_uname")
          .orderBy('createdAt', descending: true)
          .startAt([previousUser])
          .endAt(["$query${"\uf8ff"}"])
          .limit(limit ?? 500)
          .get();
      userSnaps.docs.forEach((element) {
        JumpInUser user = JumpInUser.fromJson(element.data());
        userList.add(user);
      });
      return userList;
    } catch (e) {
      print('Error : ${e.toString()}');
      return null;
    }
  }

  // fetch all users
  Future<List<JumpInUser>> getFilteredUsersFirst(BuildContext context,
      {int limit, double precision, LocationType locationType}) async {
    List<JumpInUser> userList = [];
    try {
      var userSnaps;
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      //India -> 142
      //Outside India -> 76
      log(userProvider.userState);
      log(userProvider.userCountry);
      if (userProvider.userState == null && userProvider.userCountry == null) {
        userSnaps =
            await userRef.orderBy('createdAt', descending: true).limit(5).get();
      } else {
        if (locationType == LocationType.SearchWithinState &&
            userProvider.userState != null) {
          userSnaps = await userRef
              .where('location.state', isEqualTo: userProvider.userState)
              .where('location.country', isEqualTo: userProvider.userCountry)
              .orderBy('createdAt', descending: true)
              .limit(limit)
              .get();
        }
        if (locationType == LocationType.SearchWithinCountry &&
            userProvider.userCountry != null) {
          userSnaps = await userRef
              .orderBy('location.state')
              .where('location.state', isNotEqualTo: userProvider.userState)
              .where('location.country', isEqualTo: userProvider.userCountry)
              .orderBy('createdAt', descending: true)
              .limit(limit)
              .get();
        }
        if (locationType == LocationType.SearchOutsideCountry &&
            userProvider.userCountry != null) {
          userSnaps = await userRef
              .orderBy('location.country')
              .where('location.country', isNotEqualTo: userProvider.userCountry)
              .orderBy('createdAt', descending: true)
              .limit(limit)
              .get();
        }
        if (locationType == LocationType.SearchAnywhere) {
          userSnaps = await userRef
              .where('location', isNull: true)
              .orderBy('createdAt', descending: true)
              .limit(limit)
              .get();
        }
      }

      if (userSnaps != null) {
        userSnaps.docs.forEach((element) {
          JumpInUser user = JumpInUser.fromJson(element.data());
          userList.add(user);
        });
      }
      // JumpInUser lastUser;
      // Timer.periodic(Duration(seconds: 5), (Timer t) async {
      //   lastUser = await testingFunc(lastUser);
      // });
      return userList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Filter users first
  // Future<List<JumpInUser>> getFilteredUserFirstT(BuildContext context,
  //     {int limit}) async
  // {
  //   List<JumpInUser> userList = [];
  //   try {
  //     var userSnaps;
  //     var userProvider = Provider.of<UserProvider>(context, listen: false);
  //     var endDate = DateTime(
  //         DateTime.now().year - userProvider.ageRangeValues.start.toInt());
  //     var startDate =
  //     DateTime(DateTime.now().year - userProvider.ageRangeValues.end.toInt());
  //     String startDateF = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(startDate);
  //     String endDateF = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(endDate);
  //
  //     // String gender = userProvider.getGenderFilter == GenderFilter.Male
  //     //     ? "Male"
  //     //     : userProvider.getGenderFilter == GenderFilter.Female
  //     //     ? "Female"
  //     //     : userProvider.getGenderFilter == GenderFilter.Others
  //     //     ? "Others"
  //     //     : "None";
  //     // print(gender);
  //     // print(startDate);
  //     // print(endDate);
  //     // print(userProvider.getSelectedInterests);
  //     // print('Distance');
  //     // print(userProvider.distanceRangeValues.start);
  //     // print(userProvider.distanceRangeValues.end);
  //     // print(limit);
  //
  //     if(userProvider.getSelectedInterests.length>0)
  //       {
  //         // 	interestList Arrays gender Ascending dob Ascending createdAt Descending
  //         print("Search Gender Interest");
  //         List<String> malSubCategoryId = await locator.get<InterestService>()
  //             .getSubCategoryNameById(userProvider.getSelectedInterests);
  //         userSnaps = await userRef
  //             .where('interestList',
  //             arrayContainsAny: malSubCategoryId)
  //             .where('location.state', isEqualTo: userProvider.userState)
  //             .where('location.country', isEqualTo: userProvider.userCountry)
  //             .orderBy('dob')
  //             .where('dob',
  //               isGreaterThanOrEqualTo: startDateF,
  //               isLessThanOrEqualTo: endDateF,
  //             )
  //             .orderBy('createdAt', descending: true)
  //             .get();
  //       }
  //     // else if(gender != "None")
  //     //   {
  //     //     print('Search Gender No Interest');
  //     //     userSnaps = await userRef
  //     //         .where('gender', isEqualTo: gender)
  //     //         .orderBy('dob')
  //     //         .where('dob',
  //     //         isGreaterThanOrEqualTo: startDateF,
  //     //         isLessThanOrEqualTo: endDateF,
  //     //         )
  //     //         .orderBy('createdAt', descending: true)
  //     //         .get();
  //     //   }
  //     // else if((userProvider.distanceRangeValues.start>0) && (userProvider.distanceRangeValues.end<50))
  //     //   {
  //     //     print('Search distance');
  //     //     double lat = 0.0144927536231884;
  //     //     double lon = 0.0181818181818182;
  //     //
  //     //     double lowerLat = userProvider
  //     //         .currentUser.geoPoint['Lat'] - (lat * userProvider.distanceRangeValues.start);
  //     //     double lowerLon = userProvider
  //     //         .currentUser.geoPoint['Long'] - (lon * userProvider.distanceRangeValues.start);
  //     //
  //     //     double greaterLat = userProvider
  //     //         .currentUser.geoPoint['Lat'] + (lat * userProvider.distanceRangeValues.end);
  //     //     double greaterLon = userProvider
  //     //         .currentUser.geoPoint['Long'] + (lon * userProvider.distanceRangeValues.end);
  //     //
  //     //     GeoPoint lesserGeopoint = GeoPoint(lowerLat, lowerLon);
  //     //     GeoPoint greaterGeopoint = GeoPoint(greaterLat, greaterLon);
  //     //
  //     //     userSnaps = await userRef
  //     //         .where('geoPoint',isGreaterThan: greaterGeopoint)
  //     //         .where('geoPoint',isLessThan: lesserGeopoint)
  //     //         .get();
  //     //   }
  //     else
  //       {
  //         print('Search No Gender No Interest');
  //         userSnaps = await userRef
  //             .orderBy('dob')
  //             .where('dob',
  //               isGreaterThanOrEqualTo: startDateF,
  //               isLessThanOrEqualTo: endDateF,
  //               )
  //             .where('location.state', isEqualTo: userProvider.userState)
  //             .where('location.country', isEqualTo: userProvider.userCountry)
  //             .get();
  //       }
  //
  //     if (userSnaps != null) {
  //       userSnaps.docs.forEach((element) {
  //         JumpInUser user = JumpInUser.fromJson(element.data());
  //         userList.add(user);
  //       });
  //     }
  //     // JumpInUser lastUser;
  //     // Timer.periodic(Duration(seconds: 5), (Timer t) async {
  //     //   lastUser = await testingFunc(lastUser);
  //     // });
  //     return userList;
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  // .startAfter([previousUser.createdAt.toIso8601String()])
  // Filter users next
  Future<List<JumpInUser>> getFilteredUsersNextT(BuildContext context,
      {JumpInUser previousUser, int limit, LocationType locationType}) async {
    print('getFilteredUsersNextT previousUser $previousUser');
    List<JumpInUser> userList = [];
    try {
      var userSnaps;
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      var endDate = DateTime(
          DateTime.now().year - userProvider.ageRangeValues.start.toInt());
      var startDate = DateTime(
          DateTime.now().year - userProvider.ageRangeValues.end.toInt());
      String startDateF =
          DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(startDate);
      String endDateF = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(endDate);
      if (userProvider.userState == null && userProvider.userCountry == null) {
        if (userProvider.getSelectedInterests.length > 0) {
          List<String> malSubCategoryId = await locator
              .get<InterestService>()
              .getSubCategoryNameById(userProvider.getSelectedInterests);
          userSnaps = await userRef
              .where('interestList', arrayContainsAny: malSubCategoryId)
              .orderBy('dob', descending: false)
              .where(
                'dob',
                isGreaterThanOrEqualTo: startDateF,
                isLessThanOrEqualTo: endDateF,
              )
              .startAfter([previousUser.createdAt.toIso8601String()])
              .limit(limit)
              .get();
        } else {
          userSnaps = await userRef
              .orderBy('dob', descending: false)
              .where(
                'dob',
                isGreaterThanOrEqualTo: startDateF,
                isLessThanOrEqualTo: endDateF,
              )
              .startAfter([previousUser.createdAt.toIso8601String()])
              .limit(limit)
              .get();
        }
      } else {
        if (locationType == LocationType.SearchWithinState &&
            userProvider.userState != null) {
          if (userProvider.getSelectedInterests.length > 0)
          {
            print('Here previousUser $previousUser');
            print('userProvider.userCountry ${userProvider.userCountry}');
            print('userProvider.userState ${userProvider.userState}');
            print('dob ${startDateF} ${endDateF}');
            List<String> malSubCategoryId = await locator
                .get<InterestService>()
                .getSubCategoryNameById(userProvider.getSelectedInterests);
            userSnaps = await userRef
                .where('interestList', arrayContainsAny: malSubCategoryId)
                .where('location.country', isEqualTo: userProvider.userCountry)
                .where('location.state', isEqualTo: userProvider.userState)
                .orderBy('dob', descending: false)
                .where(
                  'dob',
                  isGreaterThanOrEqualTo: startDateF,
                  isLessThanOrEqualTo: endDateF,
                )
                .orderBy('createdAt', descending: true)
                .startAfter([previousUser.createdAt.toIso8601String()])
                .limit(limit)
                .get();
            print('Here userSnaps $userSnaps');
          } else {
            userSnaps = await userRef
                .where('location.state', isEqualTo: userProvider.userState)
                .where('location.country', isEqualTo: userProvider.userCountry)
                .orderBy('dob', descending: false)
                .where(
                  'dob',
                  isGreaterThanOrEqualTo: startDateF,
                  isLessThanOrEqualTo: endDateF,
                )
                .startAfter([previousUser.createdAt.toIso8601String()])
                .limit(limit)
                .get();
          }
        }
        if (locationType == LocationType.SearchWithinCountry &&
            userProvider.userCountry != null) {
          if (userProvider.getSelectedInterests.length > 0) {
            List<String> malSubCategoryId = await locator
                .get<InterestService>()
                .getSubCategoryNameById(userProvider.getSelectedInterests);
            userSnaps = await userRef
                .where('interestList', arrayContainsAny: malSubCategoryId)
                .orderBy('location.state')
                .where('location.state', isNotEqualTo: userProvider.userState)
                .where('location.country', isEqualTo: userProvider.userCountry)
                .orderBy('dob', descending: false)
                .where(
                  'dob',
                  isGreaterThanOrEqualTo: startDateF,
                  isLessThanOrEqualTo: endDateF,
                )
                .orderBy('createdAt', descending: true)
                .startAfter([previousUser.createdAt.toIso8601String()])
                .limit(limit)
                .get();
          } else {
            userSnaps = await userRef
                .orderBy('dob', descending: false)
                .where(
                  'dob',
                  isGreaterThanOrEqualTo: startDateF,
                  isLessThanOrEqualTo: endDateF,
                )
                .orderBy('location.state')
                .where('location.state', isNotEqualTo: userProvider.userState)
                .where('location.country', isEqualTo: userProvider.userCountry)
                .startAfter([previousUser.createdAt.toIso8601String()])
                .limit(limit)
                .get();
          }
        }
        if (locationType == LocationType.SearchOutsideCountry &&
            userProvider.userCountry != null) {
          if (userProvider.getSelectedInterests.length > 0) {
            List<String> malSubCategoryId = await locator
                .get<InterestService>()
                .getSubCategoryNameById(userProvider.getSelectedInterests);
            userSnaps = await userRef
                .where('interestList', arrayContainsAny: malSubCategoryId)
                .orderBy('location.country')
                .where('location.country',
                    isNotEqualTo: userProvider.userCountry)
                .orderBy('dob', descending: false)
                .where(
                  'dob',
                  isGreaterThanOrEqualTo: startDateF,
                  isLessThanOrEqualTo: endDateF,
                )
                .orderBy('createdAt', descending: true)
                .startAfter([previousUser.createdAt.toIso8601String()])
                .limit(limit)
                .get();
          } else {
            userSnaps = await userRef
                .orderBy('dob', descending: false)
                .where(
                  'dob',
                  isGreaterThanOrEqualTo: startDateF,
                  isLessThanOrEqualTo: endDateF,
                )
                .orderBy('location.country')
                .where('location.country',
                    isNotEqualTo: userProvider.userCountry)
                .startAfter([previousUser.createdAt.toIso8601String()])
                .limit(limit)
                .get();
          }
        }
        if (locationType == LocationType.SearchAnywhere) {
          if (userProvider.getSelectedInterests.length > 0) {
            List<String> malSubCategoryId = await locator
                .get<InterestService>()
                .getSubCategoryNameById(userProvider.getSelectedInterests);
            userSnaps = await userRef
                .where('interestList', arrayContainsAny: malSubCategoryId)
                .orderBy('dob', descending: false)
                .where(
                  'dob',
                  isGreaterThanOrEqualTo: startDateF,
                  isLessThanOrEqualTo: endDateF,
                )
                .orderBy('createdAt', descending: true)
                .startAfter([previousUser.createdAt.toIso8601String()])
                .limit(limit)
                .get();
          } else {
            userSnaps = await userRef
                .orderBy('dob', descending: false)
                .where(
                  'dob',
                  isGreaterThanOrEqualTo: startDateF,
                  isLessThanOrEqualTo: endDateF,
                )
                .startAfter([previousUser.createdAt.toIso8601String()])
                .limit(limit)
                .get();
          }
        }
      }

      if (userSnaps != null) {
        userSnaps.docs.forEach((element) {
          JumpInUser user = JumpInUser.fromJson(element.data());
          print('user ${user.name}');
          userList.add(user);
        });
      }
      return userList;
    } catch (e) {
      print('Error : ${e.toString()}');
      return null;
    }
  }

  Future<List<JumpInUser>> getFilteredUsersT(BuildContext context,
      {int limit, LocationType locationType}) async {
    print('getFilteredUsersT $locationType');
    List<JumpInUser> userList = [];
    try {
      var userSnaps;
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      print(userProvider.userState);
      print(userProvider.userCountry);
      var endDate = DateTime(
          DateTime.now().year - userProvider.ageRangeValues.start.toInt());
      var startDate = DateTime(
          DateTime.now().year - userProvider.ageRangeValues.end.toInt());
      String startDateF =
          DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(startDate);
      String endDateF = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(endDate);
      print(endDateF);
      print(startDateF);
      if (userProvider.userState == null && userProvider.userCountry == null) {
        if (userProvider.getSelectedInterests.length > 0) {
          List<String> malSubCategoryId = await locator
              .get<InterestService>()
              .getSubCategoryNameById(userProvider.getSelectedInterests);
          userSnaps = await userRef
              .where('interestList', arrayContainsAny: malSubCategoryId)
              .orderBy('dob', descending: false)
              .where(
                'dob',
                isGreaterThanOrEqualTo: startDateF,
                isLessThanOrEqualTo: endDateF,
              )
              .orderBy('createdAt', descending: true)
              .limit(limit)
              .get();
        } else {
          userSnaps = await userRef
              .orderBy('dob', descending: false)
              .where(
                'dob',
                isGreaterThanOrEqualTo: startDateF,
                isLessThanOrEqualTo: endDateF,
              )
              .limit(limit)
              .get();
        }
      } else {
        if (locationType == LocationType.SearchWithinState &&
            userProvider.userState != null) {
          print('SearchWithinState');
          if (userProvider.getSelectedInterests.length > 0)
          {
            List<String> malSubCategoryId = await locator.get<InterestService>().getSubCategoryNameById(userProvider.getSelectedInterests);
            userSnaps = await userRef
                .where('interestList', arrayContainsAny: malSubCategoryId)
                .where('location.country', isEqualTo: userProvider.userCountry)
                .where('location.state', isEqualTo: userProvider.userState)
                .where(
                  'dob',
                  isGreaterThanOrEqualTo: startDateF,
                  isLessThanOrEqualTo: endDateF,
                )
                .orderBy('createdAt', descending: true)
                .limit(limit)
                .get();
          } else {
            userSnaps = await userRef
                .where('location.state', isEqualTo: userProvider.userState)
                .where('location.country', isEqualTo: userProvider.userCountry)
                .orderBy('dob', descending: false)
                .where(
                  'dob',
                  isGreaterThanOrEqualTo: startDateF,
                  isLessThanOrEqualTo: endDateF,
                )
                .orderBy('createdAt', descending: true)
                .limit(limit)
                .get();
          }
        }
        if (locationType == LocationType.SearchWithinCountry &&
            userProvider.userCountry != null) {
          if (userProvider.getSelectedInterests.length > 0) {
            List<String> malSubCategoryId = await locator
                .get<InterestService>()
                .getSubCategoryNameById(userProvider.getSelectedInterests);
            userSnaps = await userRef
                .where('interestList', arrayContainsAny: malSubCategoryId)
                .where('location.state', isNotEqualTo: userProvider.userState)
                .where('location.country', isEqualTo: userProvider.userCountry)
                .orderBy('dob', descending: false)
                  .where(
                'dob',
                isGreaterThanOrEqualTo: startDateF,
                isLessThanOrEqualTo: endDateF,
              )
                .orderBy('createdAt', descending: true)
                .limit(limit)
                .get();
          } else {
            userSnaps = await userRef
                .orderBy('dob', descending: false)
                .where(
                  'dob',
                  isGreaterThanOrEqualTo: startDateF,
                  isLessThanOrEqualTo: endDateF,
                )
                .orderBy('location.state', descending: false)
                .where('location.state', isNotEqualTo: userProvider.userState)
                .where('location.country', isEqualTo: userProvider.userCountry)
                .limit(limit)
                .get();
          }
        }
        if (locationType == LocationType.SearchOutsideCountry &&
            userProvider.userCountry != null) {
          if (userProvider.getSelectedInterests.length > 0) {
            List<String> malSubCategoryId = await locator
                .get<InterestService>()
                .getSubCategoryNameById(userProvider.getSelectedInterests);
            userSnaps = await userRef
                .where('interestList', arrayContainsAny: malSubCategoryId)
                .orderBy('location.country', descending: false)
                .where('location.country',
                    isNotEqualTo: userProvider.userCountry)
                .orderBy('dob', descending: false)
                .where(
                  'dob',
                  isGreaterThanOrEqualTo: startDateF,
                  isLessThanOrEqualTo: endDateF,
                )
                .orderBy('createdAt', descending: true)
                .limit(limit)
                .get();
          } else {
            userSnaps = await userRef
                .orderBy('dob', descending: false)
                .where(
                  'dob',
                  isGreaterThanOrEqualTo: startDateF,
                  isLessThanOrEqualTo: endDateF,
                )
                .orderBy('location.country', descending: false)
                .where('location.country',
                    isNotEqualTo: userProvider.userCountry)
                .limit(limit)
                .get();
          }
        }
        if (locationType == LocationType.SearchAnywhere) {
          if (userProvider.getSelectedInterests.length > 0) {
            List<String> malSubCategoryId = await locator
                .get<InterestService>()
                .getSubCategoryNameById(userProvider.getSelectedInterests);
            userSnaps = await userRef
                .where('interestList', arrayContainsAny: malSubCategoryId)
                .orderBy('dob', descending: false)
                .where(
                  'dob',
                  isGreaterThanOrEqualTo: startDateF,
                  isLessThanOrEqualTo: endDateF,
                )
                .orderBy('createdAt', descending: true)
                .limit(limit)
                .get();
          } else {
            userSnaps = await userRef
                .orderBy('dob', descending: false)
                .where(
                  'dob',
                  isGreaterThanOrEqualTo: startDateF,
                  isLessThanOrEqualTo: endDateF,
                )
                .limit(limit)
                .get();
          }
        }
      }

      if (userSnaps != null) {
        userSnaps.docs.forEach((element)
        {
          JumpInUser user = JumpInUser.fromJson(element.data());
          print('Name  ${user.name}');
          userList.add(user);
        }
        );
      }
      return userList;
    } catch (e) {
      print('Error : ${e.toString()}');
      return null;
    }
  }

  // fetch user contacts
  Future<List<UserContact>> getUserContacts({int limit = 20}) async {
    JumpInUser currentUser = await getCurrentUser();
    List<UserContact> contacts = [];
    if (currentUser == null) {
      return null;
    } else {
      try {
        var snaps = await userRef
            .doc(currentUser.id)
            .collection('contacts')
            .limit(limit)
            .get();
        if (snaps.docs.length > 0)
        {
          snaps.docs.forEach((element) {
            UserContact contact = UserContact.fromJson(element.data());
            contacts.add(contact);
          });
          return contacts;
        } else {
          return null;
        }
      } catch (e) {
        print(e.toString());
        return null;
      }
    }
  }

  // update location
  Future<JumpInUser> updateLocation(Position position) async {
    var currentUser = await getCurrentUser();
    if (currentUser == null) {
      return null;
    } else {
      currentUser.geoPoint = {
        'Lat': position.latitude,
        'Long': position.longitude
      };
      String state;
      String country;
      String address;
      if (currentUser.geoPoint != null) {
        address = await getAddressFromLatLng(
            Lat: currentUser.geoPoint['Lat'],
            Long: currentUser.geoPoint['Long']);
        if (address != null) {
          List<String> addressList = address.split(',');
          state = addressList[0].trim();
          country = addressList[1].trim();
        }
      }

      print("$state ----> $country");
      if (currentUser.geoPoint != null && address != null)
        currentUser.location = {
          'state': state,
          'country': country,
        };
    }
    try {
      await userRef.doc(currentUser.id).update(currentUser.toJson());
      print('Updated successfully!');
      return await getCurrentUser();
    } catch (e) {
      print('Error in updating location : ${e.toString()}');
      return null;
    }
  }

  // update contacts
  Future<JumpInUser> updateContacts(List<UserContact> contactList) async {
    var currentUser = await getCurrentUser();
    if (currentUser == null) {
      return null;
    } else {
      try {
        JumpInUser _currentUser = currentUser;
        _currentUser.contacts = contactList;
        await userRef.doc(currentUser.id).update(_currentUser.toJson());
        // contactList.forEach((element) async {
        //   await userRef.doc(currentUser.id).collection('contacts').add(element.toJson());
        // });
        print('Updated successfully!');
        return await getCurrentUser();
      } catch (e) {
        print('Error in updating contacts : $e');
        return null;
      }
    }
  }

  // get mutual contacts
  Future<List<UserContact>> fetchMutualContacts(String id,
      {int limit = 50}) async {
    var currentUser = await getCurrentUser();
    List<UserContact> mutualContacts = [];
    try {
      var snap =
          await userRef.doc(id).collection('contacts').limit(limit).get();
      for (int i = 0; i < snap.docs.length; i++) {
        UserContact userContact = UserContact.fromJson(snap.docs[i].data());
        if (currentUser != null) {
          var mutualSnap = await userRef
              .doc(currentUser.id)
              .collection('contacts')
              .where('number', isEqualTo: userContact.number)
              .get();
          if (mutualSnap.docs.length > 0) {
            UserContact mutual =
                UserContact.fromJson(mutualSnap.docs[0].data());
            mutualContacts.add(mutual);
          }
        } else {
          return null;
        }
      }
      return mutualContacts;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // fetch user from user collection
  Future<JumpInUser> fetchUser(String id) async
  {
    try {
      var snap = await userRef.doc(id).get();
      if (snap.exists) {
        return JumpInUser.fromJson(snap.data());
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // fetch user connection
  // Future<List<String>> fetchUserConnections(String uid) async{
  //   List<String> Ids = [];
  //   try{
  //     var snaps = await userRef.doc(uid).collection('connections').get();
  //     if(snaps.docs.length > 0) {
  //       snaps.docs.forEach((element) {
  //         Connection connection = Connection.fromJson(element.data());
  //         Ids.add(connection.requestedTo);
  //       });
  //       return Ids;
  //     } else {
  //       return null;
  //     }
  //   } catch(e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  // fetch user connection by id
  Future<JumpInUser> fetchUserConnectionById(
      String currentUserID, String uid) async {
    try {
      var snaps = await userRef
          .doc(currentUserID)
          .collection('connections')
          .where('requestedTo', isEqualTo: uid)
          .get();
      if (snaps.docs.length > 0) {
        Connection connection = Connection.fromJson(snaps.docs[0].data());
        return await getUserById(connection.requestedTo);
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Update Unseen Total Count
  Future<void> updateUnseenTotalCount(String uid, int total) async {
    try {
      await userRef.doc(uid).update({'unseen_total_count': total});
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  //Fetch Unseen Total Count
  Future<int> fetchUnseenTotalCount(String uid) async {
    try {
      DocumentSnapshot docSnap = await userRef.doc(uid).get();
      if (docSnap.exists) {
        JumpInUser user = JumpInUser.fromJson(docSnap.data());
        return user.unseenTotalCount ?? 0;
      }
      return 0;
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

  //Update Online/Offline Status User
  // Future<void> updateOnlineOfflineStatusUser(
  //     BuildContext context, bool isOnline) async {
  //   final userProv = Provider.of<UserProvider>(context, listen: false);
  //   try {
  //     await userRef.doc(userProv.currentUser.id).update({'isOnline': isOnline});
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  // update unseen count for user
  // Future<bool> isUserOnline(String uid) async {
  //   print(uid);
  //   try {
  //     DocumentSnapshot snap = await userRef.doc(uid).get();
  //     if (snap.exists) {
  //       JumpInUser user = JumpInUser.fromJson(snap.data());
  //       if (user.id != null) {
  //         return user.isOnline ?? false;
  //       }
  //       return false;
  //     }
  //     return false;
  //   } catch (e) {
  //     print(e.toString());
  //     return false;
  //   }
  // }

// update token in user collection
  Future<void> deactivateAccount(BuildContext context,String id, int deactivate) async
  {
    var doc = await userServ.userRef.doc(id).get();
    if(doc.exists)
    {
      Map<String, dynamic> map = doc.data();
      if(map.containsKey('deactivate'))
      {
        // Replace field by the field you want to check.
        await userServ.userRef.doc(id).update({'deactivate': deactivate});
      }
      else
      {
        JumpInUser user = await locator.get<UserService>().getUserById(id);
        user.deactivate = deactivate;
        await userRef.doc(id).set(user.toJson()).catchError((e)
        {
          showToast('Error caught!');
          return null;
        });
      }
      Navigator.of(context).push(PageTransition(child: SplashScreen(),
          type: PageTransitionType.fade));
      // deleteFirebaseUser();
    }
  }
}
