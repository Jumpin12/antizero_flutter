import 'dart:io';

import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/chat_msg.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/models/member.dart';
import 'package:antizero_jumpin/models/plan.dart';
import 'package:antizero_jumpin/provider/ModeModel.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/services/analytics.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:antizero_jumpin/utils/common_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

Analytics analytics = locator<Analytics>();

class PlanService {
  CollectionReference planRef = FirebaseFirestore.instance.collection('plan');

  // update plan
  Future<bool> updatePlan(Plan plan) async {
    try {
      print('updatePlan ${plan.member}');
      await planRef.doc(plan.id).update(plan.toJson());
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // upload plan
  Future<String> createPlan(Plan plan, String id) async {
    analytics.logCustomEvent(eventName: 'planCreated', params: {
      'userId': id,
      'planId': plan.id,
    });
    try {
      if (plan.startDate.isBefore(plan.endDate)) {
        await planRef.doc(id).set(plan.toJson(), SetOptions(merge: true));
        return id;
      } else {
        return 'Start date cannot be after end date';
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // upload plan image
  Future<String> uploadPlanImage(File file, String id) async {
    var uuid = Uuid().v4();
    var fileExtension = path.extension(file.path);
    var firebaseStorageRef =
        FirebaseStorage.instance.ref().child('plans/$id/$uuid$fileExtension');
    await firebaseStorageRef.putFile(file).catchError((onError) {
      showToast('Error caught in saving image!');
      return null;
    });
    String url = await firebaseStorageRef.getDownloadURL();
    return url;
  }

  Future<bool> fetchAllPlansId() async
  {
    try {
      await planRef.get().then((querySnap) {
        querySnap.docs.forEach((doc) {
          Plan plan = Plan.fromJson(doc.data());
          print(plan.id);

        });
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // fetch user invited plans
  Future<List<Plan>> fetchCurrentUserHomePlan(BuildContext context) async {
    print('fetchCurrentUserHomePlan');
    List<Plan> plans = [];
    JumpInUser currentUser = await locator.get<UserService>().getCurrentUser();
    if (currentUser == null) {
      return null;
    } else {
      List<Plan> publicPlans = await getPublicPlan(context);
      if (publicPlans != null) {
        for (int i = 0; i < publicPlans.length; i++) {
          plans.add(publicPlans[i]);
        }
      }
      return plans;
    }
  }

  // fetch user plans
  Future<List<Plan>> fetchCurrentUserPlan(BuildContext context) async {
    List<Plan> plans = [];
    JumpInUser currentUser = await locator.get<UserService>().getCurrentUser();
    if (currentUser == null) {
      return null;
    } else {
      List<Plan> privatePlans = await getUserPrivatePlan(currentUser.id);
      if (privatePlans != null) {
        for (int i = 0; i < privatePlans.length; i++) {
          plans.add(privatePlans[i]);
        }
      }
      List<Plan> publicPlans = await getPublicPlan(context);
      if (publicPlans != null) {
        for (int i = 0; i < publicPlans.length; i++) {
          plans.add(publicPlans[i]);
        }
      }
      return plans;
    }
  }

  // get user private plan
  Future<List<Plan>> getUserPrivatePlan(String id) async {
    List<Plan> privatePlans = [];
    try {
      var snap = await planRef
          .where('public', isEqualTo: false)
          .where('userIds', arrayContains: id)
          .limit(500)
          .orderBy('createdAt', descending: true)
          .get();
      if (snap.docs.length > 0) {
        for (int i = 0; i < snap.docs.length; i++) {
          Plan plan = Plan.fromJson(snap.docs[i].data());
          privatePlans.add(plan);
        }
        return privatePlans;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // get user public plan
  Future<List<Plan>> getPublicPlan(BuildContext context,{int limit}) async {
    print('getPublicPlan');
    List<Plan> publicPlans = [];

    try {
      JumpInUser currentUser = await locator.get<UserService>().getCurrentUser();
      var snap;
      print('currentUser.placeOfWork ${currentUser.placeOfWork}');
      if(currentUser.placeOfWork!=null)
        {
          String companyName = await getCompanyNameFromMode(context);
          if(companyName.length>0)
            snap = await planRef.where('companyName',isEqualTo: currentUser.placeOfWork)
              .orderBy('createdAt', descending: true)
              .limit(5).get();
          else
            snap = await planRef.orderBy('createdAt', descending: true)
                .limit(5).get();
        }
      else
        {
          snap = await planRef.orderBy('createdAt', descending: true)
              .limit(5).get();
        }
      // snap = await planRef.orderBy('createdAt', descending: true)
      //     .limit(5).get();

      if (snap.docs.length > 0) {
        for (int i = 0; i < snap.docs.length; i++) {
          Plan plan = Plan.fromJson(snap.docs[i].data());
          publicPlans.add(plan);
        }
        return publicPlans;
      } else {
        return null;
      }
    } catch (e) {
      print('Error : ${e.toString()}');
      return null;
    }
  }

  // get next public plan
  Future<List<Plan>> getNextPlan(BuildContext context,{String date, int limit}) async {
    List<Plan> publicPlans = [];
    try {
      JumpInUser currentUser = await locator.get<UserService>().getCurrentUser();
      var snap;
      if(currentUser.placeOfWork!=null)
        {
          String companyName = await getCompanyNameFromMode(context);
          if(companyName.length>0)
            snap = await planRef
              .where('companyName',isEqualTo: currentUser.placeOfWork)
              .orderBy('createdAt', descending: true)
              .startAfter([date])
              .limit(limit ?? 500)
              .get();
          else
            snap = await planRef
                .orderBy('createdAt', descending: true)
                .startAfter([date])
                .limit(limit ?? 500)
                .get();
        }
      else
        {
          snap = await planRef
              .orderBy('createdAt', descending: true)
              .startAfter([date])
              .limit(limit ?? 500)
              .get();
        }
      if (snap.docs.length > 0) {
        for (int i = 0; i < snap.docs.length; i++) {
          Plan plan = Plan.fromJson(snap.docs[i].data());
          publicPlans.add(plan);
        }
        return publicPlans;
      } else {
        return null;
      }
    } catch (e) {
      print('Error : ${e.toString()}');
      return null;
    }
  }

  // search user public plan
  Future<List<Plan>> getSearchPlansFirst({int limit, String query}) async {
    List<Plan> publicPlans = [];
    try {
      var snap = await planRef
          .where('public', isEqualTo: true)
          .orderBy("search_pname")
          .startAt([query])
          .endAt(["$query${"\uf8ff"}"])
          .limit(limit)
          .get();
      if (snap.docs.length > 0) {
        for (int i = 0; i < snap.docs.length; i++) {
          Plan plan = Plan.fromJson(snap.docs[i].data());
          publicPlans.add(plan);
        }
        return publicPlans;
      } else {
        return null;
      }
    } catch (e) {
      print('Error : ${e.toString()}');
      return null;
    }
  }

  // search next public plan
  Future<List<Plan>> getSearchPlansNext(
      {String previousUser, int limit, String query}) async {
    List<Plan> publicPlans = [];
    try {
      var snap = await planRef
          .where('public', isEqualTo: true)
          .orderBy("username")
          .startAt([previousUser])
          .endAt(["$query${"\uf8ff"}"])
          .limit(limit ?? 500)
          .get();
      if (snap.docs.length > 0) {
        for (int i = 0; i < snap.docs.length; i++) {
          Plan plan = Plan.fromJson(snap.docs[i].data());
          print(plan.planName);
          publicPlans.add(plan);
        }
        return publicPlans;
      } else {
        return null;
      }
    } catch (e) {
      print('Error : ${e.toString()}');
      return null;
    }
  }

  // add user request to plan
  Future<bool> updateRequestToPlan(Plan plan) async {
    try {
      await planRef.doc(plan.id).update(plan.toJson());
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // get plan by host id
  Future<List<Plan>> getPlanByHostId(String uid) async {
    List<Plan> myPlans = [];
    try {
      var snaps = await planRef.where('host', isEqualTo: uid).limit(500).get();
      if (snaps.docs.length > 0) {
        for (int i = 0; i < snaps.docs.length; i++) {
          Plan plan = Plan.fromJson(snaps.docs[i].data());
          if (plan != null) {
            myPlans.add(plan);
          }
        }
        return myPlans;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // get plan by id
  Future<Plan> getPlanById(String id) async {
    try {
      var snap = await planRef.doc(id).get();
      if (snap.exists) {
        Plan plan = Plan.fromJson(snap.data());
        return plan;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // get plan by user invitation
  Future<List<Plan>> getPlanByInvitation(String uid) async {
    List<Plan> invitedPlans = [];
    try {
      var snaps =
          await planRef.where('userIds', arrayContains: uid).limit(500).get();
      if (snaps.docs.length > 0) {
        for (int i = 0; i < snaps.docs.length; i++) {
          Plan plan = Plan.fromJson(snaps.docs[i].data());
          if (plan != null) {
            for (int j = 0; j < plan.member.length; j++) {
              if (plan.member[j].memId == uid &&
                  plan.member[j].status == MemberStatus.Invited) {
                invitedPlans.add(plan);
              }
            }
          }
        }
        return invitedPlans;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<Plan>> getPlanByInvitationSearch(String uid,String name) async {
    List<Plan> invitedPlans = [];
    try {
      var snaps =
      await planRef.where('userIds', arrayContains: uid)
          .where('planName',isEqualTo: name)
          .limit(500).get();
      if (snaps.docs.length > 0) {
        for (int i = 0; i < snaps.docs.length; i++) {
          Plan plan = Plan.fromJson(snaps.docs[i].data());
          if (plan != null) {
            for (int j = 0; j < plan.member.length; j++) {
              if (plan.member[j].memId == uid &&
                  plan.member[j].status == MemberStatus.Invited) {
                invitedPlans.add(plan);
              }
            }
          }
        }
        return invitedPlans;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // get denied plans by me
  Future<List<Plan>> getPlanDeniedByMe(String uid) async {
    List<Plan> deniedPlans = [];
    try {
      var snaps =
          await planRef.where('userIds', arrayContains: uid).limit(500).get();
      if (snaps.docs.length > 0) {
        for (int i = 0; i < snaps.docs.length; i++) {
          Plan plan = Plan.fromJson(snaps.docs[i].data());
          if (plan != null) {
            for (int j = 0; j < plan.member.length; j++) {
              if (plan.member[j].memId == uid &&
                  plan.member[j].status == MemberStatus.Denied) {
                deniedPlans.add(plan);
              }
            }
          }
        }
        return deniedPlans;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // fetch plan for user where status is accepted
  Future<List<Plan>> getAcceptedPlanForUser(BuildContext context,String uid) async {
    print('userProvider.currentUser.id ${uid}');
    List<Plan> acceptedPlans = [];
    try {
      String companyName = await getCompanyNameFromMode(context);
      var snaps;
      if(companyName.length>0)
        {
          snaps = await planRef
              .where('userIds', arrayContains: uid)
              .where('companyName', isEqualTo: companyName)
              .orderBy('recentMsg.${'time'}', descending: true)
              .limit(5)
              .get();
        }
      else
        {
          snaps = await planRef
              .where('userIds', arrayContains: uid)
              .orderBy('recentMsg.${'time'}', descending: true)
              .limit(5)
              .get(); 
        }
      if (snaps.docs.length > 0) {
        for (int i = 0; i < snaps.docs.length; i++) {
          Plan plan = Plan.fromJson(snaps.docs[i].data());
          if (plan != null) {
            for (int i = 0; i < plan.member.length; i++) {
              if (plan.member[i].memId == uid &&
                  plan.member[i].status == MemberStatus.Accepted) {
                acceptedPlans.add(plan);
              }
            }
          }
        }
        return acceptedPlans;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<Plan>> getAcceptedPlanForUserSearch(String uid,String name) async {
    List<Plan> acceptedPlans = [];
    try {
      var snaps = await planRef
          .where('userIds', arrayContains: uid)
          .where('planName', isEqualTo: name)
          .orderBy('recentMsg.${'time'}', descending: true)
          .limit(5)
          .get();
      if (snaps.docs.length > 0) {
        for (int i = 0; i < snaps.docs.length; i++) {
          Plan plan = Plan.fromJson(snaps.docs[i].data());
          if (plan != null) {
            for (int i = 0; i < plan.member.length; i++) {
              if (plan.member[i].memId == uid &&
                  plan.member[i].status == MemberStatus.Accepted) {
                acceptedPlans.add(plan);
              }
            }
          }
        }
        return acceptedPlans;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<Plan>> getMyPlans(String uid) async {
    List<Plan> acceptedPlans = [];
    try {
      var snaps = await planRef
          .where('userIds', arrayContains: uid)
          .orderBy('recentMsg.${'time'}', descending: true)
          .limit(5)
          .get();
      if (snaps.docs.length > 0) {
        for (int i = 0; i < snaps.docs.length; i++) {
          Plan plan = Plan.fromJson(snaps.docs[i].data());
          if (plan != null) {
            for (int i = 0; i < plan.member.length; i++) {
              if (plan.member[i].memId == uid &&
                  plan.member[i].status == MemberStatus.Accepted) {
                acceptedPlans.add(plan);
              }
            }
          }
        }
        return acceptedPlans;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // fetch all plan for user
  Future<List<Plan>> getPlansForUser(BuildContext context,String uid) async {
    List<Plan> userPlans = [];
    try {
      String companyName = await getCompanyNameFromMode(context);
      var snaps;
      if(companyName.length>0)
        {
          JumpInUser currentUser = await locator.get<UserService>().getCurrentUser();
          snaps = await planRef
              .where('userIds', arrayContains: uid)
              .where('companyName',isEqualTo: currentUser.placeOfWork)
              .orderBy('createdAt', descending: true)
              .limit(500)
              .get();
        }
      else
        {
          snaps = await planRef
              .where('userIds', arrayContains: uid)
              .orderBy('createdAt', descending: true)
              .limit(500)
              .get();
        }
      if (snaps.docs.length > 0) {
        for (int i = 0; i < snaps.docs.length; i++) {
          Plan plan = Plan.fromJson(snaps.docs[i].data());
          if (plan != null) {
            userPlans.add(plan);
          }
        }
        return userPlans;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /// chat
  Future<Stream<QuerySnapshot>> getCurrentPlanChat(String planId) async {
    try {
      Stream<QuerySnapshot> chatSnaps = planRef
          .doc(planId)
          .collection('chat')
          .orderBy('time', descending: false)
          .snapshots();
      if (chatSnaps != null)
      {
        JumpInUser currentUser = await locator.get<UserService>().getCurrentUser();
        if(currentUser!=null)
          updateMsgCountOfEachPlanMember(planId,currentUser.id);
        return chatSnaps;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // upload plan chat msg
  Future<bool> uploadPlanChatMsg(ChatMsg chatMsg, Plan plan) async {
    var chatId = Uuid().v1();
    chatMsg.id = chatId;
    try {
      await planRef
          .doc(plan.id)
          .collection('chat')
          .doc(chatId)
          .set(chatMsg.toJson());
      bool updated = await updateRecent(plan);
      if (updated) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // update recent msg
  Future<bool> updateRecent(Plan plan) async {
    try {
      await planRef.doc(plan.id).update(plan.toJson());
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  ///Function to save search name of plan
  void saveSearchPlanName(String id) {
    try {
      planRef.doc(id).get().then((snap) {
        Plan plan = Plan.fromJson(snap.data());
        planRef.doc(plan.id).set(
            {'search_pname': '${plan.planName.toLowerCase()}_${plan.id}'},
            SetOptions(merge: true));
        print(plan.planName);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  ///Function to fetch User Chat Stream
  Stream<QuerySnapshot> fetchUserPlansChatStream(BuildContext context,String userId){
    try {
      // planRef.get().then((querySnap) {
      //   querySnap.docs.forEach((doc) {
      //     Plan plan = Plan.fromJson(doc.data());
      //     Map<dynamic, dynamic> chatActivity = {};
      //     plan.userIds.forEach((userId) {
      //       chatActivity.addAll({
      //         userId: {'unseenCount': 0, 'isOnline': false}
      //       });
      //     });
      //     log(chatActivity.toString());
      //     planRef.doc(plan.id).update({'chat_activity': chatActivity});
      //   });
      // });
      String companyName = getCompanyNameFromMode(context);
      if(companyName.length>0)
      {
        return planRef
            .where('userIds', arrayContains: userId)
            .where('companyName',isEqualTo: companyName)
            .orderBy('recentMsg.${'time'}', descending: true)
            .snapshots();
      }
      else
      {
        return planRef
            .where('userIds', arrayContains: userId)
            .orderBy('recentMsg.${'time'}', descending: true)
            .snapshots();
      }
    } catch (e) {
      print(e.toString());
      return Stream.empty();
    }
  }

  ///Function to fetch each msg count user in plan
  Future<Map<dynamic, dynamic>> fetchMsgCountOfEachPlanMember(
      String planId) async {
    try {
      DocumentSnapshot docSnap = await planRef.doc(planId).get();
      if (docSnap.exists)
      {
        Plan plan = Plan.fromJson(docSnap.data());
        return plan.chatActivity;
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  ///Function to fetch each msg count user in plan
  Future<void> updateMsgCountOfEachPlanMember(String planId, String userId) async
  {
    try {
      planRef.doc(planId).update(
        {'chat_activity.$userId.unseenCount': 0},
      );
    } catch (e) {
      print(e.toString());
    }
  }

  ///Function to fetch each msg count user in plan
  Future<void> setOnlineOfflineStatusOfPlanMember(
      String planId, String userId, bool status) async {
    try {
      planRef.doc(planId).update(
        {'chat_activity.$userId.isOnline': status},
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
