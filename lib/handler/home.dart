import 'dart:ui' as ui;
import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/contacts.dart';
import 'package:antizero_jumpin/models/friend_request.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/models/recent.dart';
import 'package:antizero_jumpin/models/sub_category.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/services/analytics.dart';
import 'package:antizero_jumpin/services/chat.dart';
import 'package:antizero_jumpin/services/interest.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:antizero_jumpin/utils/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

Analytics analytics = locator<Analytics>();

Future<double> calculateDistance(
    {double startLat, double startLong, double endLat, double endLong}) async {
  LocationPermission permission;
  permission = await Geolocator.checkPermission();
  switch (permission) {
    case LocationPermission.deniedForever:
      print("denier forever");
      return null;
      break;
    case LocationPermission.denied:
      print("denied");
      return null;
      break;
    case LocationPermission.always:
      print("always");
      var distanceInMeters =
          Geolocator.distanceBetween(startLat, startLong, endLat, endLong);
      return distanceInMeters;
      break;
    case LocationPermission.whileInUse:
      print('While in use');
      var distanceInMeters =
          Geolocator.distanceBetween(startLat, startLong, endLat, endLong);
      return distanceInMeters;
      break;
    default:
      print('Default');
      return null;
      break;
  }
}

Future<List<SubCategory>> getFirstTwoInterest(List<String> ids) async {
  List<String> intIds = [];
  for (int i = 0; i < 2; i++) {
    intIds.add(ids[i]);
  }
  return await locator.get<InterestService>().getUserInterests(intIds);
}

Future<List<UserContact>> getMutualContacts(String id, {int limit = 25}) async {
  final PermissionStatus permission = await Permission.contacts.status;
  if (permission.isGranted) {
    List<UserContact> mutualContacts =
        await locator.get<UserService>().fetchMutualContacts(id, limit: limit);
    if (mutualContacts.isNotEmpty || mutualContacts != null) {
      return mutualContacts;
    } else {
      return null;
    }
  } else {
    return null;
  }
}

// contact list in user collection
Future<List<UserContact>> getMutualContactsLength(
    JumpInUser user, BuildContext context) async {
  final PermissionStatus permission = await Permission.contacts.status;
  if (permission.isGranted) {
    List<UserContact> userContacts = [];
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.currentUser.contacts == null ||
        userProvider.currentUser.contacts.isEmpty) {
      return [];
    } else {
      if (user.contacts == null || user.contacts.isEmpty) {
        return [];
      } else {
        for (int i = 0; i < userProvider.currentUser.contacts.length; i++) {
          for (int j = 0; j < user.contacts.length; j++) {
            if (user.contacts[j].number ==
                userProvider.currentUser.contacts[i].number) {
              userContacts.add(userProvider.currentUser.contacts[i]);
            }
          }
        }
        Map<String, UserContact> mp = {};
        for (var item in userContacts) {
          mp[item.number] = item;
        }
        var filteredList = mp.values.toList();
        return filteredList;
      }
    }
  } else {
    return [];
  }
}

Future<bool> checkContactPermission() async {
  final PermissionStatus permission = await Permission.contacts.status;
  if (permission.isGranted || permission.isLimited) {
    return true;
  } else {
    return false;
  }
}

Future<List<SubCategory>> getMutualInterest(JumpInUser userWithCompare, BuildContext context) async {
  List<String> interestIds = [];
  JumpInUser currentUser = Provider.of<UserProvider>(context, listen: false).currentUser;
  List<String> comparingUserInterest = userWithCompare.interestList;
  for (int i = 0; i < currentUser.interestList.length; i++) {
    if (comparingUserInterest.contains(currentUser.interestList[i])) {
      interestIds.add(currentUser.interestList[i]);
    }
  }
  if (interestIds.isEmpty) {
    return null;
  } else {
    List<SubCategory> interestList =
        await locator.get<InterestService>().getUserInterests(interestIds);
    return interestList;
  }
}

Future<List<SubCategory>> getOtherInterest(
    JumpInUser userWithCompare, BuildContext context) async {
  List<String> interestIds = [];
  List<String> currentUserInterest =
      Provider.of<UserProvider>(context, listen: false)
          .currentUser
          .interestList;
  List<String> comparingUserInterest = userWithCompare.interestList;
  interestIds = comparingUserInterest
      .where((element) => !currentUserInterest.contains(element))
      .toList();
  if (interestIds.isEmpty) {
    return null;
  } else {
    List<SubCategory> interestList =
        await locator.get<InterestService>().getUserInterests(interestIds);
    return interestList;
  }
}

/// chat functions

Future<bool> sendRequest(String id, BuildContext context) async {
  var uid = Uuid().v4();
  JumpInUser currentUser =
      Provider.of<UserProvider>(context, listen: false).currentUser;
  List<String> userIds = [];
  userIds.add(id);
  userIds.add(currentUser.id);
  RecentMsg recentMsg = RecentMsg();
  recentMsg.recentMsg = '';
  recentMsg.sender = '';
  recentMsg.time = DateTime.now();
  FriendRequest friendRequest;
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
  if(companyName.length>0)
    friendRequest = FriendRequest(
        uid,
        currentUser.id,
        id,
        DateTime.now(),
        userIds,
        FriendRequestStatus.Requested,
        recentMsg,
        DateTime.now(),
        0,currentUser.name,currentUser.photoList.last,
        currentUser.id,currentUser.name,currentUser.photoList.last,currentUser.placeOfWork,
        '');
  else if(collegeName.length>0)
    friendRequest = FriendRequest(
        uid,
        currentUser.id,
        id,
        DateTime.now(),
        userIds,
        FriendRequestStatus.Requested,
        recentMsg,
        DateTime.now(),
        0,currentUser.name,currentUser.photoList.last,
        currentUser.id,currentUser.name,currentUser.photoList.last,'',
        currentUser.placeOfEdu);
  else
    friendRequest = FriendRequest(
        uid,
        currentUser.id,
        id,
        DateTime.now(),
        userIds,
        FriendRequestStatus.Requested,
        recentMsg,
        DateTime.now(),
        0,currentUser.name,currentUser.photoList.last,
        currentUser.id,currentUser.name,currentUser.photoList.last,'','');

  analytics.logCustomEvent(eventName: 'jumpinRequestSent', params: {
    'requestedBy': currentUser.id,
    'requestedTo': friendRequest.id,
  });
  return await locator
      .get<ChatService>()
      .sendRequest(friendRequest, currentUser);
}

/// widget share
Future capture(GlobalKey key) async {
  if (key == null) return null;

  RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
  final image = await boundary.toImage(pixelRatio: 3);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final pngBytes = byteData.buffer.asUint8List();

  return pngBytes;
}
