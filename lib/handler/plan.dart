import 'dart:io';
import 'package:antizero_jumpin/handler/bookmark.dart';
import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/category.dart';
import 'package:antizero_jumpin/models/chat_msg.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/models/member.dart';
import 'package:antizero_jumpin/models/plan.dart';
import 'package:antizero_jumpin/provider/ModeModel.dart';
import 'package:antizero_jumpin/provider/plan.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/services/analytics.dart';
import 'package:antizero_jumpin/services/chat.dart';
import 'package:antizero_jumpin/services/interest.dart';
import 'package:antizero_jumpin/services/plan.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:antizero_jumpin/utils/common_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

Analytics analytics = locator<Analytics>();

// Future<bool> updatePlan(Plan plan, List<JumpInUser> members) async {
//   List<String> privateUid = [];
//   {
//     for (int i = 0; i < members.length; i++) {
//       plan.userIds.add(members[i].id);
//       if (plan.public == true) {
//         Member attendee =
//             Member(memId: members[i].id, status: MemberStatus.Invited);
//         plan.member.add(attendee);
//       } else {
//         Member attendee =
//             Member(memId: members[i].id, status: MemberStatus.Accepted);
//         plan.member.add(attendee);
//         privateUid.add(members[i].id);
//       }
//     }
//   }
//   bool success = await locator.get<PlanService>().updatePlan(plan);
//   if (success) {
//     if (plan.public == true) {
//       return true;
//     } else {
//       String id = await updatePlanInUser(plan.id, privateUid);
//       if (id != null) {
//         return true;
//       } else {
//         return false;
//       }
//     }
//   } else {
//     return false;
//   }
// }

Future<String> savePlan(
    {BuildContext context,
    Plan plan,
    List<JumpInUser> members,
    List<File> imgFile}) async {
  List<String> userIds = [];
  List<Member> attendees = [];
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser == null) {
    return null;
  } else {
    if (members != null) {
      for (int i = 0; i < members.length; i++) {
        userIds.add(members[i].id);
        if (plan.public == true) {
          Member attendee =
              Member(memId: members[i].id, status: MemberStatus.Invited,memName: members[i].name);
          attendees.add(attendee);
        } else {
          Member attendee =
              Member(memId: members[i].id, status: MemberStatus.Accepted,memName: members[i].name);
          attendees.add(attendee);
        }
      }
    }
    userIds.add(userProvider.currentUser.id);
    attendees.add(Member(
        memId: userProvider.currentUser.id, status: MemberStatus.Accepted,memName: userProvider.currentUser.name));
    plan = plan.copyWith(
      userIds: userIds,
      member: attendees,
      host: userProvider.currentUser.id,
    );

    //chatActivity
    Map chatActivity = {};
    plan.userIds.forEach((userId) {
      chatActivity.addAll({
        userId: {'unseenCount': 0, 'isOnline': false}
      });
    });
    plan.chatActivity = chatActivity;
    int mode = Provider.of<ModeProvider>(context, listen: false).getCurrentMode;
    print('modeModel ${mode}');
    if(mode==0)
    {
      plan.companyName = '';
    }
    else
    {
      plan.companyName = userProvider.currentUser.placeOfWork;
    }
    print('companyName ${plan.companyName}');
    String id = await setPlan(plan, imgFiles: imgFile);
    if (id != null) {
      if (plan.public == true) {
        return await updatePlanInUser(id, [userProvider.currentUser.id]);
      } else {
        return await updatePlanInUser(id, userIds);
      }
    } else {
      return null;
    }
  }
}

Future<String> setPlan(Plan plan, {List<File> imgFiles}) async {
  var uuid = Uuid().v4();
  List<String> urls = [];
  if (imgFiles.isNotEmpty) {
    for (int i = 0; i < imgFiles.length; i++) {
      String url =
          await locator.get<PlanService>().uploadPlanImage(imgFiles[i], uuid);
      if (url != null) {
        urls.add(url);
      }
    }
    plan = plan.copyWith(
      planImg: urls,
    );
  } else {
    Category category = await locator
        .get<InterestService>()
        .getInterestCategoryByName(plan.catName);
    if (category == null) {
      return null;
    } else {
      urls.add(category.img);
      plan = plan.copyWith(
        planImg: urls,
      );
    }
  }
  plan = plan.copyWith(
    id: uuid,
  );
  plan = plan.copyWith(searchPname: '${plan.planName.toLowerCase()}_${plan.id}');
  return await locator.get<PlanService>().createPlan(plan, uuid);
}

Future<bool> editPlan(
    {BuildContext context,
      Plan plan,
      List<JumpInUser> members,
      List<File> imgFiles}) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  print('imgFiles ${imgFiles}');
  if (userProvider.currentUser == null) {
    return null;
  } else {
    //chatActivity
    Map chatActivity = {};
    plan.userIds.forEach((userId) {
      chatActivity.addAll({
        userId: {'unseenCount': 0, 'isOnline': false}
      });
    });
    plan.chatActivity = chatActivity;
    List<String> urls = [];
    if (imgFiles.isNotEmpty) {
      for (int i = 0; i < imgFiles.length; i++) {
        if(imgFiles[i].toString().contains('https://'))
          {
            urls.add(imgFiles[i].path);
          }
        else
          {
            String url = await locator.get<PlanService>().uploadPlanImage(imgFiles[i], plan.id);
            if (url != null) {
              urls.add(url);
            }
          }
      }
      plan = plan.copyWith(
        planImg: urls,
      );
    } else {
      Category category = await locator
          .get<InterestService>()
          .getInterestCategoryByName(plan.catName);
      if (category == null) {
        return null;
      } else {
        urls.add(category.img);
        plan = plan.copyWith(
          planImg: urls,
        );
      }
    }
    plan = plan.copyWith(searchPname: '${plan.planName.toLowerCase()}_${plan.id}');
    return await locator.get<PlanService>().updatePlan(plan);
  }
}

Future<String> updatePlanInUser(String id, List<String> attendees) async {
  for (int i = 0; i < attendees.length; i++)
  {
    JumpInUser user =
        await locator.get<UserService>().getUserById(attendees[i]);
    if (user != null) {
      if (user.plans == null) {
        user.plans = [id];
      } else {
        if (!user.plans.contains(id)) {
          user.plans.add(id);
        }
      }
      JumpInUser jumpInUser = await locator.get<UserService>().updateUser(user);
      if (jumpInUser == null) {
        return null;
      }
    } else {
      return null;
    }
  }
  return id;
}

Future<JumpInUser> checkIfConnectedToUser(
    String id, BuildContext context) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser == null) {
    return null;
  } else {
    return await locator
        .get<UserService>()
        .fetchUserConnectionById(userProvider.currentUser.id, id);
  }
}

Future<bool> requestToPlan(Plan plan, BuildContext context) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser == null) {
    return false;
  } else {
    if (plan.userIds.contains(userProvider.currentUser.id) == false)
      plan.userIds.add(userProvider.currentUser.id);
    Member member;
    for (int i = 0; i < plan.member.length; i++) {
      if (plan.member[i].memId == userProvider.currentUser.id) {
        member = plan.member[i];
      }
    }
    // Member member = plan.member.firstWhere((element) => element.memId == userProvider.currentUser.id);
    if (member == null) {
      plan.member.add(Member(
          memId: userProvider.currentUser.id, status: MemberStatus.Accepted,memName: userProvider.currentUser.name));
    } else {
      plan.member.removeWhere(
          (element) => element.memId == userProvider.currentUser.id);
      plan.member.add(Member(
          memId: userProvider.currentUser.id, status: MemberStatus.Accepted,memName: userProvider.currentUser.name));
    }
    //Update Chat Activity
    Map temp = plan.chatActivity;
    if (temp == null) {
      temp = {
        userProvider.currentUser.id: {'unseenCount': 0, 'isOnline': false}
      };
    } else {
      temp.addAll({
        userProvider.currentUser.id: {'unseenCount': 0, 'isOnline': false}
      });
    }
    plan = plan.copyWith(chatActivity: temp);

    bool success = await locator.get<PlanService>().updateRequestToPlan(plan);
    if (success) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await Provider.of<PlanProvider>(context, listen: false).getHomePlan(context);
      });
      String planId =
          await updatePlanInUser(plan.id, [userProvider.currentUser.id]);
      if (planId != null) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}

Future<bool> acceptingCurrentPlan(Plan plan, BuildContext context) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser == null) {
    return false;
  } else {
    return await acceptPlanForUser(plan, userProvider.currentUser.id, userProvider.currentUser.name,context);
  }
}

Future<bool> denyingCurrentPlan(Plan plan, BuildContext context) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser == null) {
    return false;
  } else {
    return await denyPlanForUser(plan, userProvider.currentUser.id, userProvider.currentUser.name,context);
  }
}

Future<bool> acceptPlanForUser(
    Plan plan, String userId,String userName, BuildContext context) async {
  analytics.logCustomEvent(eventName: 'planAccepted', params: {
    'userId': userId,
    'planId': plan.id,
  });
  for (int i = 0; i < plan.member.length; i++) {
    if (plan.member[i].memId == userId) {
      plan.member.remove(plan.member[i]);
    }
  }
  plan.member.add(Member(memId: userId, status: MemberStatus.Accepted,memName: userName));
  bool success = await locator.get<PlanService>().updateRequestToPlan(plan);
  if (success) {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   await Provider.of<PlanProvider>(context, listen: false).refresh();
    // });
    return true;
  } else {
    return false;
  }
}

Future<bool> denyPlanForUser(
    Plan plan, String userId, String userName,BuildContext context) async {
  for (int i = 0; i < plan.member.length; i++) {
    if (plan.member[i].memId == userId) {
      plan.member.remove(plan.member[i]);
    }
  }
  plan.member.add(Member(memId: userId, status: MemberStatus.Denied, memName: userName));
  bool success = await locator.get<PlanService>().updateRequestToPlan(plan);
  if (success) {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   await Provider.of<PlanProvider>(context, listen: false).refresh();
    // });
    return true;
  } else {
    return false;
  }
}

Future<Stream<QuerySnapshot>> getCurrentPlanChat(BuildContext context) async {
  var planProvider = Provider.of<PlanProvider>(context, listen: false);
  if (planProvider.currentPlan != null) {
    return await locator
        .get<PlanService>()
        .getCurrentPlanChat(planProvider.currentPlan.id);
  } else {
    return null;
  }
}

Future<bool> sendPlanMsg(String text, BuildContext context,
    {File imgFile}) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  var planProvider = Provider.of<PlanProvider>(context, listen: false);
  if (planProvider.currentPlan == null) {
    return false;
  } else {
    ChatMsg chatMsg = ChatMsg(
        message: text,
        senderId: userProvider.currentUser.id,
        senderName: userProvider.currentUser.name,
        senderPhoto: userProvider.currentUser.photoList.last,
        time: DateTime.now());
    if (imgFile != null) {
      String url = await locator
          .get<ChatService>()
          .uploadImage(imgFile, planProvider.currentPlan.id, 'plan');
      if (url != null) {
        chatMsg.imgMsg = url;
      } else {
        return false;
      }
    } else {
      chatMsg.imgMsg = '';
    }
    planProvider.currentPlan.recentMsg.recentMsg = text;
    planProvider.currentPlan.recentMsg.sender = userProvider.currentUser.id;
    planProvider.currentPlan.recentMsg.time = chatMsg.time;
    // planProvider.currentPlan.chatActivity
    Map chatActivity = await fetchMsgCountOfEachPlanMember(context);

    if (chatActivity != null) {
      chatActivity.forEach((key, value) {
        // if (key != userProvider.currentUser.id && value["isOnline"] == false)
        if (key != userProvider.currentUser.id)
        {
          value['unseenCount'] = value['unseenCount'] + 1;
        }
        // if (key == userProvider.currentUser.id) {
        //   value['isOnline'] = true;
        // }
      });
    }

    planProvider.currentPlan.chatActivity = chatActivity;
    if(getCompanyNameFromMode(context).length>0)
      planProvider.currentPlan.placeOfWork = userProvider.currentUser.placeOfWork;
    else
      planProvider.currentPlan.placeOfWork = '';

    bool success = await locator
        .get<PlanService>()
        .uploadPlanChatMsg(chatMsg, planProvider.currentPlan);

    if (success) {
      return true;
    } else {
      return false;
    }
  }
}

List<Plan> getPlanWhereIamHost(BuildContext context, List<Plan> plans) {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser == null) {
    return null;
  } else {
    List<Plan> hostedPlans = [];
    for (int i = 0; i < plans.length; i++) {
      if (plans[i].host == userProvider.currentUser.id) {
        hostedPlans.add(plans[i]);
      }
    }
    return hostedPlans;
  }
}

List<Plan> getPlanWhereIamInvited(BuildContext context, List<Plan> plans) {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser == null) {
    return null;
  } else {
    List<Plan> invitedPlans = [];
    for (int i = 0; i < plans.length; i++) {
      for (int j = 0; j < plans[i].member.length; j++) {
        if (plans[i].member[j].memId == userProvider.currentUser.id &&
            plans[i].member[j].status == MemberStatus.Invited) {
          invitedPlans.add(plans[i]);
        }
      }
    }
    return invitedPlans;
  }
}

Future<List<Plan>> getPlanByInvite(BuildContext context) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser == null) {
    return null;
  } else {
    return locator
        .get<PlanService>()
        .getPlanByInvitation(userProvider.currentUser.id);
  }
}

Future<List<Plan>> getPlanByInviteSearch(BuildContext context,String name) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser == null) {
    return null;
  } else {
    return locator
        .get<PlanService>()
        .getPlanByInvitationSearch(userProvider.currentUser.id,name);
  }
}

List<Plan> getDeniedPlanByMe(BuildContext context, List<Plan> plans) {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser == null) {
    return null;
  } else {
    List<Plan> deniedPlans = [];
    for (int i = 0; i < plans.length; i++) {
      for (int j = 0; j < plans[i].member.length; j++) {
        if (plans[i].member[j].memId == userProvider.currentUser.id &&
            plans[i].member[j].status == MemberStatus.Denied) {
          deniedPlans.add(plans[i]);
        }
      }
    }
    return deniedPlans;
  }
}

List<Plan> getAcceptedPlanByMe(BuildContext context, List<Plan> plans) {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser == null)
  {
    return null;
  } else {
    List<Plan> acceptedPlans = [];
    for (int i = 0; i < plans.length; i++)
    {
      print('id ${plans[i].host}');
      if (plans[i].host != userProvider.currentUser.id) {
        for (int j = 0; j < plans[i].member.length; j++) {
          if (plans[i].member[j].memId == userProvider.currentUser.id &&
              plans[i].member[j].status == MemberStatus.Accepted) {
            acceptedPlans.add(plans[i]);
          }
        }
      }
    }
    return acceptedPlans;
  }
}

Future<List<Plan>> getAllPlanForUser(BuildContext context) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser == null) {
    return null;
  } else {
    return await locator
        .get<PlanService>()
        .getPlansForUser(context,userProvider.currentUser.id);
  }
}

Future<List<Plan>> getAcceptedPlanForCurrentUser(BuildContext context) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser == null) {
    return null;
  } else {
    return await locator
        .get<PlanService>()
        .getAcceptedPlanForUser(context,userProvider.currentUser.id);
  }
}

Future<List<Plan>> getAcceptedPlanForCurrentUserSearch(BuildContext context,String name) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser == null) {
    return null;
  } else {
    return await locator
        .get<PlanService>()
        .getAcceptedPlanForUserSearch(userProvider.currentUser.id,name);
  }
}

MemberStatus checkStatus(List<Member> members, BuildContext context) {
  MemberStatus memberStatus;
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  for (int i = 0; i < members.length; i++) {
    if (members[i].memId == userProvider.currentUser.id) {
      memberStatus = members[i].status;
    }
  }
  return memberStatus;
}

getHost(String hostId) async {
  JumpInUser user = await locator.get<UserService>().getUserById(hostId);
  if (user != null) {
    return user;
  }
}

int getAcceptedMemberLength(List<Member> members) {
  int count = 0;
  for (int i = 0; i < members.length; i++) {
    if (members[i].status == MemberStatus.Accepted) {
      count = count + 1;
    }
  }
  return count;
}

bool checkIfUserHasAcceptedPlan(BuildContext context, List<Member> members) {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  // print(checkIfUserHasAcceptedPlan);
  for (int i = 0; i < members.length; i++) {
    if (members[i].memId == userProvider.currentUser.id &&
        members[i].status == MemberStatus.Accepted) {
      return true;
    }
    // print(userProvider.currentUser.id);
    // print(members[i].memId);
    // print(members[i].status);
  }
  return false;
}

bool checkIfUserHasInvitedToPlan(BuildContext context, List<Member> members)
{
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  for (int i = 0; i < members.length; i++) {
    if (members[i].memId == userProvider.currentUser.id &&
        members[i].status == MemberStatus.Invited) {
      return true;
    }
  }
  return false;
}

// getCurrentPlanMembers(BuildContext context) async {
//   List<String> userList = [];
//   var planProvider = Provider.of<PlanProvider>(context, listen: false);
//   planProvider.currentPlanUsers = [];
//   if (planProvider.currentPlan != null) {
//     for (int i = 0; i < planProvider.currentPlan.member.length; i++) {
//       // JumpInUser user = await locator
//       //     .get<UserService>()
//       //     .getUserById(planProvider.currentPlan.userIds[i]);
//       if (planProvider.currentPlan.member[i] != null) userList.add(planProvider.currentPlan.member[i].memName);
//       print('user name ${planProvider.currentPlan.member[i].memName}');
//     }
//     planProvider.currentPlanUsers = userList;
//   }
// }

List<String> getCurrentPlanAcceptedMembers(List<Member> members) {
  List<String> userIds = [];
  for (int i = 0; i < members.length; i++) {
    if (members[i].status == MemberStatus.Accepted) {
      userIds.add(members[i].memId);
    }
  }
  return userIds;
}

Stream<QuerySnapshot> fetchPlanChatStream(BuildContext context) {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser.id == null) {
    return Stream.empty();
  } else {
    return locator
        .get<PlanService>()
        .fetchUserPlansChatStream(context,userProvider.currentUser.id);
  }
}

setOnlineOfflineStatusOfPlanMember(BuildContext context, bool status) {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  var planProvider = Provider.of<PlanProvider>(context, listen: false);
  if (userProvider.currentUser.id != null && planProvider.currentPlan != null) {
    locator.get<PlanService>().setOnlineOfflineStatusOfPlanMember(
        planProvider.currentPlan.id, userProvider.currentUser.id, status);
  }
}

Future<Map<dynamic, dynamic>> fetchMsgCountOfEachPlanMember(BuildContext context) async {
  var planProvider = Provider.of<PlanProvider>(context, listen: false);
  if (planProvider.currentPlan.id != null) {
    return locator
        .get<PlanService>()
        .fetchMsgCountOfEachPlanMember(planProvider.currentPlan.id);
  } else {
    return null;
  }
}

Future<void> updateMsgCountOfEachPlanMember(BuildContext context) async {
  var planProvider = Provider.of<PlanProvider>(context, listen: false);
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (planProvider.currentPlan.id != null) {
    return locator.get<PlanService>().updateMsgCountOfEachPlanMember(
        planProvider.currentPlan.id, userProvider.currentUser.id);
  } else {
    return null;
  }
}
