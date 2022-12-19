import 'dart:io';
import 'package:antizero_jumpin/handler/user.dart';
import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/Message.dart';
import 'package:antizero_jumpin/models/chat_msg.dart';
import 'package:antizero_jumpin/models/friend_request.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/models/plan.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/services/chat.dart';
import 'package:antizero_jumpin/services/plan.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:antizero_jumpin/utils/common_methods.dart';
import 'package:antizero_jumpin/utils/locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<Stream<QuerySnapshot>> getChatFromCurrentPeople(BuildContext context) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentPeopleGroup != null) {
    return await locator
        .get<ChatService>()
        .getCurrentChatForPeople(context,userProvider.currentPeopleGroup);
  } else {
    return null;
  }
}

Future<bool> sendPeopleMsg(String text, BuildContext context,JumpInUser chatWithUser,
    {File imgFile}) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  // print('userProvider.currentUser.id ${userProvider.currentUser.id}');
  // print('userProvider.chatWithUser.id ${userProvider.chatWithUser.id}');
  ChatMsg chatMsg = ChatMsg();
  chatMsg.message = text;
  chatMsg.senderId = userProvider.currentUser.id;
  chatMsg.time = DateTime.now();
  chatMsg.read = false;
  if (imgFile != null) {
    String url = await locator
        .get<ChatService>()
        .uploadImage(imgFile, userProvider.currentPeopleGroup.id, 'people');
    if (url != null) {
      chatMsg.imgMsg = url;
    } else {
      return false;
    }
  } else {
    chatMsg.imgMsg = '';
  }
  userProvider.currentPeopleGroup.recentMsg.recentMsg = text;
  userProvider.currentPeopleGroup.recentMsg.sender =
      userProvider.currentUser.id;
  userProvider.currentPeopleGroup.recentMsg.time = chatMsg.time;
  userProvider.currentPeopleGroup.requestedByName = userProvider.currentUser.name;
  userProvider.currentPeopleGroup.requestedByImg = userProvider.currentUser.photoList.last;
  userProvider.currentPeopleGroup.requestedById = userProvider.currentUser.id;
  userProvider.currentPeopleGroup.senderName = chatWithUser.name;
  userProvider.currentPeopleGroup.senderImg = chatWithUser.photoList.last;
  userProvider.currentPeopleGroup.unseenMsgCount = 0;
  // mode changes
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
    userProvider.currentPeopleGroup.placeOfWork = userProvider.currentUser.placeOfWork;
  else if(collegeName!= null && collegeName.length>0)
    userProvider.currentPeopleGroup.placeOfEdu = userProvider.currentUser.placeOfEdu;
  else
    {
      userProvider.currentPeopleGroup.placeOfWork = '';
      userProvider.currentPeopleGroup.placeOfEdu = '';
    }

  if (userProvider.currentPeopleGroup.unseenMsgCount != null) {
        userProvider.currentPeopleGroup.unseenMsgCount = await locator
                .get<ChatService>()
                .fetchUnseenCount(userProvider.currentPeopleGroup.id) +
            1;
      } else {
        userProvider.currentPeopleGroup.unseenMsgCount = 0;
      }
  // print('userProvider.currentPeopleGroup.unseenMsgCount ${userProvider.currentPeopleGroup.unseenMsgCount}');
  // if(userProvider.currentPeopleGroup.unseenMsgCount != null && userProvider.currentPeopleGroup.unseenMsgCount >0)
  //   {
  //     if(userProvider.currentPeopleGroup.unseenMsgCount > 0)
  //     {
  //       userProvider.currentPeopleGroup.unseenMsgCount =  userProvider.currentPeopleGroup.unseenMsgCount + 1;
        // userProvider.currentPeopleGroup.senderMsgCount =  userProvider.currentPeopleGroup.senderMsgCount + 1;
        // userProvider.currentPeopleGroup.requestedToMsgCount = userProvider.currentPeopleGroup.requestedToMsgCount + 1;
      // }
      // else
      // {
      //   userProvider.currentPeopleGroup.unseenMsgCount = 1;
      //   userProvider.currentPeopleGroup.senderMsgCount = 1;
      // }
  //   }
  // else
  //     {
  //       userProvider.currentPeopleGroup.unseenMsgCount = 1;
  //       // userProvider.currentPeopleGroup.senderMsgCount = 1;
  //     }
  // bool val = await isUserOnline(context);
  // if (val == false) {
  //   if (userProvider.currentPeopleGroup.unseenMsgCount != null) {
  //     userProvider.currentPeopleGroup.unseenMsgCount = await locator
  //             .get<ChatService>()
  //             .fetchUnseenCount(userProvider.currentPeopleGroup.id) +
  //         1;
  //   } else {
  //     userProvider.currentPeopleGroup.unseenMsgCount = 0;
  //   }
  // } else {
  //   userProvider.currentPeopleGroup.unseenMsgCount = 0;
  // }
  bool success = await locator
      .get<ChatService>()
      .uploadMsg(chatMsg, userProvider.currentPeopleGroup);
  userProvider.currentUser.unseenTotalCount =
      userProvider.currentUser.unseenTotalCount +
      userProvider.currentPeopleGroup.unseenMsgCount;
  await updateUserUnseenTotalCount(context,userProvider.currentUser);

  if (success) {
    return true;
  } else {
    return false;
  }
}

Future<bool> updateRecent(String text, BuildContext context,JumpInUser chatWithUser,
    {File imgFile}) async {
  print('updateRecent');
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  ChatMsg chatMsg = ChatMsg();
  chatMsg.message = text;
  chatMsg.time = DateTime.now();
  chatMsg.read = false;
  userProvider.currentPeopleGroup.recentMsg.recentMsg = text;
  userProvider.currentPeopleGroup.recentMsg.sender = userProvider.currentUser.id;
  userProvider.currentPeopleGroup.recentMsg.time = chatMsg.time;
  userProvider.currentPeopleGroup.requestedByName = userProvider.currentUser.name;
  userProvider.currentPeopleGroup.requestedByImg = userProvider.currentUser.photoList.last;
  userProvider.currentPeopleGroup.senderName = chatWithUser.name;
  userProvider.currentPeopleGroup.senderImg = chatWithUser.photoList.last;
  bool success = await locator
      .get<ChatService>()
      .updateRecent(userProvider.currentPeopleGroup);
  if (success) {
    return true;
  } else {
    return false;
  }
}

// Future<bool> updateRead(BuildContext context,JumpInUser chatWithUser,
//     {File imgFile}) async {
//   print('updateRead');
//   var userProvider = Provider.of<UserProvider>(context, listen: false);
//   ChatMsg chatMsg = ChatMsg();
//   chatMsg.read = true;
//   bool success = await locator
//       .get<ChatService>()
//       .updateRead(userProvider.currentPeopleGroup);
//   if (success) {
//     return true;
//   } else {
//     return false;
//   }
// }

// Future<void> updateUserUnseenTotalCount(UserProvider userProvider) async {
//   userServ
//       .getUserById(userProvider.currentPeopleGroup.userIds
//           .where((element) => element != userProvider.currentUser.id)
//           .first)
//       .then((JumpInUser user) async {
//     user.unseenTotalCount = user.unseenTotalCount ??
//         0 +
//             await locator
//                 .get<ChatService>()
//                 .fetchUnseenCount(userProvider.currentPeopleGroup.id);
//
//     userServ.updateUnseenTotalCount(user.id, user.unseenTotalCount);
//   });
// }

Future<List<FriendRequest>> getUserPeopleReq() async {
  JumpInUser user = await locator.get<UserService>().getCurrentUser();
  if (user == null) {
    return null;
  } else {
    return await locator.get<ChatService>().getPeopleReqById(user.id);
  }
}

Future<List<FriendRequest>> getUserPeopleReqBySearch(String name) async {
  JumpInUser user = await locator.get<UserService>().getCurrentUser();
  print('getUserPeopleReqBySearch $user');
  if (user == null) {
    return null;
  } else {
    return await locator.get<ChatService>().getPeopleReqByIdSearch(user.id,name);
  }
}

Future<List<FriendRequest>> getPeopleByReqTo(BuildContext context) async {
  JumpInUser user = await locator.get<UserService>().getCurrentUser();
  if (user == null) {
    return null;
  } else {
    return await locator.get<ChatService>().getPeopleById(context,user.id);
  }
}

Future<List<FriendRequest>> getPeopleChatForUser(BuildContext context) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser == null) {
    return null;
  } else {
    return await locator
        .get<ChatService>()
        .getAcceptedChatById(userProvider.currentUser.id);
  }
}

// getting user detail from id
Future<JumpInUser> getUserFromPeople(BuildContext context, FriendRequest people) async
{
  String userId;
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser == null) {
    return null;
  } else {
    for (int i = 0; i < people.userIds.length; i++) {
      if (people.userIds[i] != userProvider.currentUser.id) {
        userId = people.userIds[i];
      }
    }
    return locator.get<UserService>().getUserById(userId);
  }
}


// Future<List<Plan>> getAcceptedPlanChat(BuildContext context) async {
//   var userProvider = Provider.of<UserProvider>(context, listen: false);
//   if (userProvider.currentUser == null) {
//     return null;
//   } else {
//     return locator
//         .get<PlanService>()
//         .getAcceptedPlanForUser(context,userProvider.currentUser.id);
//   }
// }

// Future<void> unseenReceiverMsgCountUpdate(BuildContext context,int length) async {
//   var userProvider = Provider.of<UserProvider>(context, listen: false);
//   print(userProvider.currentPeopleGroup.id);
//   if (userProvider.currentPeopleGroup.id == null) {
//     return null;
//   } else {
//     userProvider.currentPeopleGroup.requestedToMsgCount = length;
//   }
//   return locator
//       .get<ChatService>()
//       .updateUnseenMsgCount(userProvider.currentPeopleGroup);
// }

Future<void> unseenMsgCountUpdate(BuildContext context) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  // if (userProvider.currentPeopleGroup.id == null) {
  //   return null;
  // } else {
  //   userProvider.currentPeopleGroup.senderMsgCount = length;
  // }
  userProvider.currentPeopleGroup.unseenMsgCount = 0;
  print('userProvider.currentPeopleGroup ${userProvider.currentPeopleGroup.id}');
  return locator
      .get<ChatService>()
      .updateUnseenMsgCount(userProvider.currentPeopleGroup);
}

// Future<void> senderMsgCountUpdate(BuildContext context) async {
//   var userProvider = Provider.of<UserProvider>(context, listen: false);
//   if (userProvider.currentPeopleGroup.id == null) {
//     return null;
//   } else {
//     userProvider.currentPeopleGroup.senderMsgCount = userProvider.currentPeopleGroup.senderMsgCount + 1;
//     return locator
//         .get<ChatService>()
//         .updateUnseenMsgCount(userProvider.currentPeopleGroup);
//   }
// }

// Future<bool> isUserOnline(BuildContext context) async {
//   var userProvider = Provider.of<UserProvider>(context, listen: false);
//   if (userProvider.currentPeopleGroup.id == null) {
//     return false;
//   } else {
//     return locator.get<UserService>().isUserOnline(userProvider
//         .currentPeopleGroup.userIds
//         .where((element) => element != userProvider.currentUser.id)
//         .first);
//   }
// }

Stream<QuerySnapshot> fetchUserChatStream(BuildContext context) {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser.id == null) {
    return Stream.empty();
  } else {
    return locator
        .get<ChatService>()
        .fetchUserChatStream(context,userProvider.currentUser.id);
  }
}
