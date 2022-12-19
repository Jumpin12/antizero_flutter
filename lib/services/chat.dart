import 'dart:io';
import 'package:antizero_jumpin/handler/chat.dart';
import 'package:antizero_jumpin/handler/notification.dart';
import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/Message.dart';
import 'package:antizero_jumpin/models/plan.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/services/analytics.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:antizero_jumpin/utils/common_methods.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/models/chat_msg.dart';
import 'package:antizero_jumpin/models/connection.dart';
import 'package:antizero_jumpin/models/friend_request.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/utils/locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

Analytics analytics = locator<Analytics>();

class ChatService {
  CollectionReference peopleRef =
      FirebaseFirestore.instance.collection('people');

  // send friend request
  Future<bool> sendRequest(
      FriendRequest friendRequest, JumpInUser currentUser) async {
    FriendRequest requested = await checkIfRequested(
        friendRequest.requestedBy, friendRequest.requestedTo);
    if (requested == null) {
      bool reqCreated = await createRequest(friendRequest);
      if (reqCreated) {
        await reqPeopleNotification(friendRequest);
      }
      return reqCreated;
    } else {
      if (requested.status == FriendRequestStatus.Accepted ||
          requested.status == FriendRequestStatus.Denied) {
        return false;
      } else {
        bool accepted = await acceptRequest(requested);
        if (accepted) {
          bool connectionCreated = await createConnection(
              requested.requestedBy, requested.requestedTo);
          if (connectionCreated) {
            await acceptPeopleNotification(requested);
          }
          return connectionCreated;
        } else {
          return false;
        }
      }
    }
  }

  // create request
  Future<bool> createRequest(FriendRequest friendRequest) async {
    try {
      await peopleRef.doc(friendRequest.id).set(friendRequest.toJson());
      return true;
    } catch (e) {
      print('Error : ${e.toString()}');
      return false;
    }
  }

  // change status to accepted
  Future<bool> acceptRequest(FriendRequest friendRequest) async {
    try {
      await peopleRef.doc(friendRequest.id).update({'status': 'Accepted'});
      analytics.logCustomEvent(eventName: 'jumpinRequestAccepted', params: {
        'requestedBy': friendRequest.requestedBy,
        'requestedTo': friendRequest.requestedTo,
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // change status to deny
  Future<bool> denyRequest(FriendRequest friendRequest) async {
    try {
      await peopleRef.doc(friendRequest.id).update({'status': 'Denied'});
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // change status to requested
  Future<bool> changeStatusToRequested(String friendRequestId) async {
    try {
      await peopleRef.doc(friendRequestId).update({'status': 'Requested'});
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // create connection in user collection
  Future<bool> createConnection(String from, String to) async {
    bool status1 = await createConnectionInUser(from, to);
    bool status2 = await createConnectionInUser(to, from);
    if (status1 == true && status2 == true) {
      showToast('Connection created!');
      return true;
    } else {
      return false;
    }
  }

  // create connection
  Future<bool> createConnectionInUser(String from, String to) async {
    JumpInUser user = await locator.get<UserService>().getUserById(from);
    if (user != null) {
      try {
        if (user.connection == null) {
          user.connection = [to];
        } else {
          user.connection.add(to);
        }
        await userServ.userRef.doc(from).update(user.toJson());
        return true;
      } catch (e) {
        print(e.toString());
        return false;
      }
    } else {
      return false;
    }
  }

  // check if already requested by either current user or next user
  Future<FriendRequest> checkIfRequested(String by, String to) async {
    FriendRequest friendRequest1 = await checkIfRequestedByCurrentUser(by, to);
    FriendRequest friendRequest2 = await checkIfRequestedByCurrentUser(to, by);
    if (friendRequest1 == null && friendRequest2 == null) {
      return null;
    } else if (friendRequest1 != null) {
      return friendRequest1;
    } else if (friendRequest2 != null) {
      return friendRequest2;
    } else {
      return null;
    }
  }

  // check if already requested by user
  Future<FriendRequest> checkIfRequestedByCurrentUser(
      String by, String to) async {
    try {
      var snap = await peopleRef
          .where('requestedBy', isEqualTo: by)
          .where('requestedTo', isEqualTo: to)
          .get();
      if (snap.docs.isNotEmpty) {
        var confirmSnap = await peopleRef.doc(snap.docs[0].id).get();
        FriendRequest friendRequest =
            FriendRequest.fromJson(confirmSnap.data());
        return friendRequest;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // check if already connected
  // Future<bool> checkIfAlreadyInConnection(String id, String connectionId) async{
  //   bool result1 = await checkConnectionForUser(id, connectionId);
  //   bool result2 = await checkConnectionForUser(connectionId, id);
  //   if(result1 == true && result2 == true) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // check if connected to user
  // Future<bool> checkConnectionForUser(String id, String reqToId) async{
  //   try {
  //     var snap = await userServ.userRef
  //         .doc(id)
  //         .collection('connections')
  //         .where('requestedTo', isEqualTo: reqToId)
  //         .get();
  //     if(snap.docs.isNotEmpty) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch(e) {
  //     print(e.toString());
  //     return false;
  //   }
  // }

  /// chat
  Future<Stream<QuerySnapshot>> getCurrentChatForPeople(BuildContext context,FriendRequest friendRequest) async {
    try {
      Stream<QuerySnapshot> chatSnaps = peopleRef
          .doc(friendRequest.id)
          .collection('chat')
          .orderBy('time', descending: false)
          .snapshots();
      if (chatSnaps != null) {
        var snaps = await  peopleRef
            .doc(friendRequest.id)
            .collection('chat').where('id', isNull: false).get();
        if (snaps.docs.length > 0) {
          unseenMsgCountUpdate(context);
        }
        return chatSnaps;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Stream<QuerySnapshot>> getLastestChat(
      FriendRequest friendRequest) async {
    try {
      Stream<QuerySnapshot> chatSnaps = peopleRef
          .doc(friendRequest.id)
          .collection('chat')
          .orderBy('time', descending: true)
          .limit(1)
          .snapshots();
      if (chatSnaps != null) {
        return chatSnaps;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // upload people chat msg
  Future<bool> uploadMsg(
    ChatMsg chatMsg,
    FriendRequest peopleReqDoc,
  ) async {
    print("Time1");
    print(DateTime.now());
    var chatId = Uuid().v1();
    chatMsg.id = chatId;
    try {
      await peopleRef
          .doc(peopleReqDoc.id)
          .collection('chat')
          .doc(chatId)
          .set(chatMsg.toJson());
      print("Time2");
      print(DateTime.now());
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // update recent msg
  Future<bool> updateRecent(FriendRequest peopleReqDoc) async {
    try {
      await peopleRef.doc(peopleReqDoc.id).update(peopleReqDoc.toJson());
      return true;
    }
    catch (e)
    {
      print(e.toString());
      return false;
    }
  }

  // update read status
  // Future<bool> updateRead(FriendRequest peopleReqDoc) async {
  //   print('updateRead');
  //   try {
  //     await peopleRef.doc(peopleReqDoc.id).collection('chat').update({'read': 'true'});
  //     return true;
  //   } catch (e) {
  //     print(e.toString());
  //     return false;
  //   }
  // }

  // upload image msg in storage
  Future<String> uploadImage(File file, String id, String folderName) async {
    var uuid = Uuid().v4();
    var fileExtension = path.extension(file.path);
    var firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('$folderName/$id/$uuid$fileExtension');
    await firebaseStorageRef.putFile(file).catchError((onError) {
      showToast('Error caught in saving image!');
      return null;
    });
    String url = await firebaseStorageRef.getDownloadURL();
    return url;
  }

  // get people request for current user
  Future<List<FriendRequest>> getPeopleReqByReqTo(String uid) async {
    List<FriendRequest> requests = [];
    try {
      var snaps = await peopleRef
          .where('requestedTo', isEqualTo: uid)
          .where('status', isEqualTo: 'Requested')
          .limit(500)
          .get();
      if (snaps.docs.length > 0) {
        for (int i = 0; i < snaps.docs.length; i++) {
          FriendRequest friendRequest =
              FriendRequest.fromJson(snaps.docs[i].data());
          if (friendRequest != null) requests.add(friendRequest);
        }
        return requests;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // get accepted people chat by userId
  Future<List<FriendRequest>> getAcceptedChatById(String uid) async {
    List<FriendRequest> peopleDocs = [];
    try {
      var snaps = await peopleRef
          .where('userIds', arrayContains: uid)
          .where('status', isEqualTo: 'Accepted')
          .orderBy('recentMsg.${'time'}', descending: true)
          .limit(500)
          .get();
      if (snaps.docs.length > 0) {
        for (int i = 0; i < snaps.docs.length; i++) {
          FriendRequest people = FriendRequest.fromJson(snaps.docs[i].data());
          if (people != null) {
            peopleDocs.add(people);
          }
        }
        return peopleDocs;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // get accepted people chat by userId
  Future<FriendRequest> getAcceptedChatId(String uid, String friendId) async {
    try {
      print(friendId);
      print(uid);
      var snaps = await peopleRef
          .where('userIds', arrayContains: "$uid||$friendId")
          .where('status', isEqualTo: 'Accepted')
          .orderBy('recentMsg.${'time'}', descending: true)
          .get();
      if (snaps.docs.length > 0) {
        print(snaps.docs.length);
        FriendRequest people;
        for (int i = 0; i < snaps.docs.length; i++) {
          people = FriendRequest.fromJson(snaps.docs[i].data());
        }
        return people;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // get people by userId
  Future<List<FriendRequest>> getPeopleReqById(String uid) async {
    List<FriendRequest> peopleDocs = [];
    try {
      var snaps = await peopleRef
          .where('requestedTo', isEqualTo: uid)
          .where('status', isEqualTo: 'Requested')
          .limit(500)
          .get();
      if (snaps.docs.length > 0) {
        for (int i = 0; i < snaps.docs.length; i++) {
          FriendRequest people = FriendRequest.fromJson(snaps.docs[i].data());
          if (people != null) {
            peopleDocs.add(people);
          }
        }
        return peopleDocs;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<FriendRequest>> getPeopleReqByIdSearch(String uid,String name) async {
    print('getPeopleReqByIdSearch $uid $name');
    List<FriendRequest> peopleDocs = [];
    try {
      var snaps = await peopleRef
          .where('requestedTo', isEqualTo: uid)
          .where('status', isEqualTo: 'Requested')
          .where('requestedByName', isEqualTo: name)
          .limit(500)
          .get();
      if (snaps.docs.length > 0) {
        for (int i = 0; i < snaps.docs.length; i++) {
          FriendRequest people = FriendRequest.fromJson(snaps.docs[i].data());
          if (people != null) {
            peopleDocs.add(people);
            print('peopleDocs ${people.id}');
          }
        }
        return peopleDocs;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // get people by userId
  Future<List<FriendRequest>> getPeopleById(BuildContext context,String uid) async {
    List<FriendRequest> peopleDocs = [];
    try {
      // String companyName = await getCompanyNameFromMode(context);
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
        var snaps = await peopleRef.where('userIds', arrayContains: uid)
            .where('companyName',isEqualTo: companyName).where('status', isEqualTo: 'Requested').limit(500).get();if (snaps.docs.length > 0) {
          for (int i = 0; i < snaps.docs.length; i++) {
            FriendRequest people = FriendRequest.fromJson(snaps.docs[i].data());
            if (people != null) {
              peopleDocs.add(people);
            }
          }
        }
        var snaps1 = await peopleRef.where('userIds', arrayContains: uid).where('companyName',isEqualTo: companyName).where('status', isEqualTo: 'Accepted').limit(500).get();if (snaps1.docs.length > 0) {
          for (int i = 0; i < snaps1.docs.length; i++) {
            FriendRequest people = FriendRequest.fromJson(snaps1.docs[i].data());
            if (people != null) {
              peopleDocs.add(people);
            }
          }
          return peopleDocs;
        } else {return null;}
      }
      else if(collegeName!= null && collegeName.length>0)
      {
        var snaps = await peopleRef.where('userIds', arrayContains: uid)
            .where('collegeName',isEqualTo: collegeName).where('status', isEqualTo: 'Requested')
            .limit(500).get();if (snaps.docs.length > 0) {
          for (int i = 0; i < snaps.docs.length; i++) {
            FriendRequest people = FriendRequest.fromJson(snaps.docs[i].data());
            if (people != null) {
              peopleDocs.add(people);
            }
          }
        }
        var snaps1 = await peopleRef.where('userIds', arrayContains: uid)
            .where('collegeName',isEqualTo: collegeName).where('status', isEqualTo: 'Accepted')
            .limit(500).get();if (snaps1.docs.length > 0) {
          for (int i = 0; i < snaps1.docs.length; i++) {
            FriendRequest people = FriendRequest.fromJson(snaps1.docs[i].data());
            if (people != null) {
              peopleDocs.add(people);
            }
          }
          return peopleDocs;
        } else {return null;}
      }
      else
      {
        var snaps = await peopleRef.where('userIds', arrayContains: uid).where('status', isEqualTo: 'Requested').limit(500).get();if (snaps.docs.length > 0) {
          for (int i = 0; i < snaps.docs.length; i++) {
            FriendRequest people = FriendRequest.fromJson(snaps.docs[i].data());
            if (people != null) {
              peopleDocs.add(people);
            }
          }
        }
        var snaps1 = await peopleRef.where('userIds', arrayContains: uid).where('status', isEqualTo: 'Accepted').limit(500).get();if (snaps1.docs.length > 0) {
          for (int i = 0; i < snaps1.docs.length; i++) {
            FriendRequest people = FriendRequest.fromJson(snaps1.docs[i].data());
            if (people != null) {
              peopleDocs.add(people);
            }
          }
          return peopleDocs;
        } else {return null;}
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // check if user exist in people
  Future<bool> checkPeopleById(String uid) async {
    try {
      var snaps =
          await peopleRef.where('userIds', arrayContains: uid).limit(500).get();
      if (snaps.docs.length > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // update unseen count for user
  Future<void> updateUnseenMsgCount(FriendRequest peopleReqDoc) async {
    try {
      await peopleRef.doc(peopleReqDoc.id).update(peopleReqDoc.toJson());
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // update unseen count for user
  // Future<void> updateSenderMsgCount(FriendRequest peopleReqDoc) async {
  //   try {
  //     await peopleRef.doc(peopleReqDoc.id).update(peopleReqDoc.toJson());
  //   } catch (e) {
  //     print(e.toString());
  //     return false;
  //   }
  // }

  // update unseen count for user
  Future<int> fetchUnseenCount(String uid) async {
    try {
      DocumentSnapshot docSnap = await peopleRef.doc(uid).get();
      if (docSnap.exists) {
        FriendRequest friendRequest = FriendRequest.fromJson(docSnap.data());
        return friendRequest.unseenMsgCount ?? 0;
      }
      return 0;
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

  ///Function to fetch User Chat Stream
  Stream<QuerySnapshot> fetchUserChatStream(BuildContext context,String userId)
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
    if((companyName!=null) && (companyName.length>0))
      {
        print('fetchUserChatStream userId $userId');
        try {
          return peopleRef
              .where('userIds', arrayContains: userId)
              .where('status', isEqualTo: 'Accepted')
              .orderBy('recentMsg.${'time'}', descending: true).snapshots();
        }
        catch (e)
        {
          print(e.toString());
          return Stream.empty();
        }
      }
    else
      {
        try {
          return peopleRef
              .where('userIds', arrayContains: userId)
              .where('status', isEqualTo: 'Accepted')
              .orderBy('recentMsg.${'time'}', descending: true).snapshots();
        }
        catch (e)
        {
          print(e.toString());
          return Stream.empty();
        } 
      }
  }
}
