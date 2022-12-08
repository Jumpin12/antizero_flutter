import 'package:antizero_jumpin/handler/interest.dart';
import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/contacts.dart';
import 'package:antizero_jumpin/models/friend_request.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/services/chat.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:antizero_jumpin/utils/locator.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

Future<JumpInUser> getUser(BuildContext context) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  JumpInUser user = await userServ.getCurrentUser();
  if (user == null) {
    showToast('Error caught!');
    return null;
  } else {
    userProvider.currentUser = user;
    return user;
  }
}

updateInterest(BuildContext context, List<String> interestIds) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  JumpInUser user =
      await locator.get<UserService>().updateInterest(interestIds);
  if (user != null) {
    userProvider.currentUser = user;
  }
  await getUserInterest(context);
  showToast('Interest Updated Successfully!');
  Navigator.of(context).pop();
}

updateUserUnseenTotalCount(BuildContext context, JumpInUser changedUser) async {
  print('updateUserUnseenTotalCount $updateUserUnseenTotalCount');
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  JumpInUser user = await locator.get<UserService>().updateUser(changedUser);
  if (user != null) {
    userProvider.currentUser = user;
  }
}

bool checkLocation(BuildContext context) {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser.geoPoint != null) {
    return true;
  } else {
    return false;
  }
}

Future<Map<String, dynamic>> getPreSetLocation(BuildContext context) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser.geoPoint != null) {
    return userProvider.currentUser.geoPoint;
  } else {
    return null;
  }
}

List<UserContact> getContactsList(BuildContext context) {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser == null) {
    return null;
  } else {
    if (userProvider.currentUser.contacts.isEmpty ||
        userProvider.currentUser.contacts == null) {
      return null;
    } else {
      return userProvider.currentUser.contacts;
    }
  }
}

getLocationAndContacts(BuildContext context) async {
  bool locationSuccess = await getLocationPermission();
  if (locationSuccess) {
    bool success = await handleLocation(context);
    if (success) {
      bool contactSuccess = await getContactPermission();
      if (contactSuccess) await handleContacts(context);
      if (!contactSuccess) showToast('Please grant contact access in settings');
    }
  } else {
    showToast('Please grant location access in settings');
  }
}

//Check location permission
Future<bool> getLocationPermission() async {
  PermissionStatus permission = await Permission.location.status;
  if (permission != PermissionStatus.granted) {
    if (permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus status = await Permission.location.request();
      if (status != PermissionStatus.granted) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  } else {
    return true;
  }
}

//Check contact permission
Future<bool> getContactPermission() async {
  PermissionStatus permission = await Permission.contacts.status;
  if (permission != PermissionStatus.granted) {
    if (permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus status = await Permission.contacts.request();
      if (status != PermissionStatus.granted) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  } else {
    return true;
  }
}

Future<bool> handleLocation(BuildContext context) async {
  Position position = await getCurrentLocation();
  if (position != null) {
    if (position.latitude != null && position.longitude != null) {
      JumpInUser jumpInUser =
          await locator.get<UserService>().updateLocation(position);
      if (jumpInUser != null) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } else {
    return false;
  }
}

Future<Position> getCurrentLocation() async {
  Position position;
  try {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  } catch (e) {
    print('Error in permission : $e');
    showToast('Please allow location in setting!');
    return null;
  }
}

handleContacts(BuildContext context) async {
  List<UserContact> contactList = [];
  Iterable<Contact> contacts = await getContacts();
  contacts.forEach((contact) {
    List<String> phNumbers = [];
    contact.phones.forEach((number) {
      String ph = number.value.replaceAll(" ", "");
      ph = ph.replaceAll("-", "");
      if (ph.startsWith("+91")) {
        List numb = ph.split('');
        numb.removeRange(0, 3);
        ph = numb.join();
      }
      if (ph.startsWith("91")) {
        List numb = ph.split('');
        numb.removeRange(0, 2);
        ph = numb.join();
      }
      if (!phNumbers.contains(ph) &&
          (ph.startsWith("9") ||
              ph.startsWith("8") ||
              ph.startsWith("7") ||
              ph.startsWith("6"))) phNumbers.add(ph);

      phNumbers.forEach((number) {
        UserContact userContact = UserContact();
        userContact.name = contact.displayName;
        userContact.number = number;
        contactList.add(userContact);
      });
    });
  });
  JumpInUser jumpInUser =
      await locator.get<UserService>().updateContacts(contactList);
  if (jumpInUser != null)
    Provider.of<UserProvider>(context, listen: false).currentUser = jumpInUser;
}

getContacts() async {
  Iterable<Contact> contacts = await ContactsService.getContacts(
      withThumbnails: false, photoHighResolution: false);
  return contacts;
}

Future<FriendRequest> checkIfDenied(BuildContext context, String userId) async {
  String currentUserId =
      Provider.of<UserProvider>(context, listen: false).currentUser.id;
  FriendRequest friendRequest = await locator
      .get<ChatService>()
      .checkIfRequestedByCurrentUser(userId, currentUserId);
  if (friendRequest == null) {
    return null;
  } else {
    if (friendRequest.status == FriendRequestStatus.Denied) {
      return friendRequest;
    } else {
      return null;
    }
  }
}

Future<bool> changeStatusToRequested(String id) async {
  return await locator.get<ChatService>().changeStatusToRequested(id);
}

Future<FriendRequest> checkIfRequestedForConnection(
    BuildContext context, String userId) async {
  String currentUserId =
      Provider.of<UserProvider>(context, listen: false).currentUser.id;
  return await locator
      .get<ChatService>()
      .checkIfRequestedByCurrentUser(currentUserId, userId);
}

Future<FriendRequest> checkIfRequestedByUser(
    BuildContext context, String userId) async {
  String currentUserId =
      Provider.of<UserProvider>(context, listen: false).currentUser.id;
  return await locator
      .get<ChatService>()
      .checkIfRequestedByCurrentUser(userId, currentUserId);
}

Future<FriendRequest> checkRequestedStatus(
    BuildContext context, String userId) async {
  String currentUserId =
      Provider.of<UserProvider>(context, listen: false).currentUser.id;
  return await locator
      .get<ChatService>()
      .checkIfRequested(currentUserId, userId);
}

// Future<bool> checkIfAlreadyInConnection(BuildContext context, String userId) async{
//   String currentUserId = Provider.of<UserProvider>(context, listen: false).currentUser.id;
//   return await locator.get<ChatService>().checkIfAlreadyInConnection(currentUserId, userId);
// }

Future<bool> checkIfInConnection(BuildContext context, String userId) async {
  var currentUser =
      Provider.of<UserProvider>(context, listen: false).currentUser;
  if (currentUser.connection != null) {
    if (currentUser.connection.contains(userId)) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

Future<JumpInUser> getUserDetail(String id) async
{
  return await locator.get<UserService>().fetchUser(id);
}

List<String> getUserConnections(BuildContext context) {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser == null) {
    return null;
  } else {
    if (userProvider.currentUser.connection != null) {
      print('userProvider.currentUser.connection ${userProvider.currentUser.connection}');
      return userProvider.currentUser.connection;
    } else {
      return null;
    }
  }
}

// List<String> getUserSearchConnections(BuildContext context,String name) {
//   var userProvider = Provider.of<UserProvider>(context, listen: false);
//   if (userProvider.currentUser == null) {
//     return null;
//   } else {
//     if (userProvider.currentUser.connection != null) {
//       print('userProvider.currentUser.connection ${userProvider.currentUser.connection}');
//       return userProvider.currentUser.connection;
//     } else {
//       return null;
//     }
//   }
// }

Future<List<JumpInUser>> getUsers(List<String> ids) async {
  List<JumpInUser> users = [];
  for (int i = 0; i < ids.length; i++) {
    JumpInUser user = await locator.get<UserService>().fetchUser(ids[i]);
    if (user != null) {
      users.add(user);
    }
  }
  return users;
}

// Future<List<JumpInUser>> getAllUsersEmailAddress(BuildContext context,int limit) async
// {
//   List<JumpInUser> users = await locator.get<UserService>().getAllUsersEmailAddress(context,limit);
//   return users;
// }

Future<void> unseenTotalMsgCountUpdate(BuildContext context) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentPeopleGroup.id == null) {
    return null;
  } else {
    userServ.getUserById(userProvider.currentPeopleGroup.userIds
            .where((element) => element != userProvider.currentUser.id)
            .first)
        .then((JumpInUser user) async {
      if (user.unseenTotalCount != null) {
        user.unseenTotalCount = user.unseenTotalCount -
            await locator
                .get<ChatService>()
                .fetchUnseenCount(userProvider.currentPeopleGroup.id);

        userServ.updateUnseenTotalCount(user.id, user.unseenTotalCount);
      }
    });
  }
}