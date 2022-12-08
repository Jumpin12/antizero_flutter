import 'package:antizero_jumpin/handler/chat.dart';
import 'package:antizero_jumpin/handler/notification.dart';
import 'package:antizero_jumpin/handler/plan.dart';
import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/handler/user.dart';
import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/friend_request.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/models/member.dart';
import 'package:antizero_jumpin/models/plan.dart';
import 'package:antizero_jumpin/provider/navigator.dart';
import 'package:antizero_jumpin/provider/plan.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/screens/home/chat/chat.dart';
import 'package:antizero_jumpin/screens/home/jumpInuser_profile.dart';
import 'package:antizero_jumpin/screens/home/plans/current_plan.dart';
import 'package:antizero_jumpin/services/chat.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/widget/common/custom_appbar.dart';
import 'package:antizero_jumpin/widget/common/no_content.dart';
import 'package:antizero_jumpin/widget/home/plans/myPlan_reqCard.dart';
import 'package:antizero_jumpin/widget/notification/req_card.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<FriendRequest> peopleFriendReq = [];
  List<Plan> userPlans = [];
  List<Plan> myPlans = [];
  List<Plan> invitedPlans = [];
  List<Plan> deniedPlans = [];
  List<Plan> acceptedPlans = [];
  // List<String> reqUserIds = [];
  bool loading = true;
  bool more = false;
  bool morePeople = false;
  int peopleRequests = 0;
  // bool reqToMyPlan = false;

  @override
  void initState() {
    getReq();
    super.initState();
    FirebaseAnalytics.instance.logScreenView(
      screenName: 'View Notifications Screen',
      screenClass: 'Notification',
    );
  }

  getReq() async {
    await getPeopleReq(context);
    await getUserPlan();
  }

  getUserPlan() async {
    List<Plan> _userPlans = await getAllPlanForUser(context);
    if (_userPlans != null) {
      userPlans = _userPlans;
      getHostPlanReq(_userPlans);
      getInvitedPlanReq(_userPlans);
      getDeniedPlanReq(_userPlans);
      getAcceptedPlanReq(_userPlans);
    }
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  getAcceptedPlanReq(List<Plan> plans) {
    List<Plan> _acceptedPlans = getAcceptedPlanByMe(context, plans);
    if (_acceptedPlans != null || _acceptedPlans.isNotEmpty) {
      acceptedPlans = _acceptedPlans;
    }
  }

  getDeniedPlanReq(List<Plan> plans) async {
    List<Plan> _deniedPlans = getDeniedPlanByMe(context, plans);
    if (_deniedPlans != null || _deniedPlans.isNotEmpty) {
      deniedPlans = _deniedPlans;
    }
  }

  getPeopleReq(BuildContext context) async {
    List<FriendRequest> requests = await getPeopleByReqTo(context);
    if (requests != null) {
      peopleFriendReq = requests;
    }
  }

  getHostPlanReq(List<Plan> plans) {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.currentUser != null) {
      List<Plan> _myPlans = getPlanWhereIamHost(context, plans);
      if (_myPlans != null || _myPlans.isNotEmpty) {
        myPlans = _myPlans;
        // List<String> _reqUserIds = [];
        // for(int j=0; j<_myPlans.length; j++) {
        //   for (int i = 0; i < myPlans[j].member.length; i++) {
        //     if (myPlans[j].member[i].status == MemberStatus.Accepted && myPlans[j].member[i].memId != userProvider.currentUser.id) {
        //       _reqUserIds.add(myPlans[j].member[i].memId);
        //     }
        //   }
        // }
        // if(_reqUserIds.isNotEmpty) {
        //   reqUserIds = _reqUserIds;
        //   reqToMyPlan = true;
        // }
      }
    }
  }

  getInvitedPlanReq(List<Plan> plans) {
    List<Plan> _invitedPlans = getPlanWhereIamInvited(context, plans);
    if (_invitedPlans != null || _invitedPlans.isNotEmpty) {
      invitedPlans = _invitedPlans;
      for (var element in invitedPlans) {
        print(element.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    var planProvider = Provider.of<PlanProvider>(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: primaryGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          backgroundColor: Colors.transparent,
          title: 'Notifications',
          automaticImplyLeading: true,
          labelColor: Colors.white,
          iconColor: Colors.white,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3.h),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: DefaultTabController(
          length: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 1.h),
                child: const TabBar(
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Tab(
                      text: 'People',
                    ),
                    Tab(
                      text: 'Plans',
                    ),
                    Tab(
                      text: 'My Plans',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Container(
                      child: loading
                          ? fadedCircle(32, 32, color: shade1) : peopleFriendReq.isEmpty
                          ? NoContentImage(
                        text: 'No new notification found',
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                      )
                          : ListView.builder(
                        itemBuilder: (context, index) {
                          if (peopleFriendReq[index].requestedBy ==
                              userProvider.currentUser.id &&
                              peopleFriendReq[index].status ==
                                  FriendRequestStatus.Accepted) {
                            return RequestCard(
                              date:
                              '${DateFormat.MMM().format(peopleFriendReq[index].createdAt)} ${DateFormat.d().format(peopleFriendReq[index].createdAt)}, ${DateFormat.y().format(peopleFriendReq[index].createdAt)}',
                              onTap: () async {
                                JumpInUser user = await locator
                                    .get<UserService>()
                                    .getUserById(
                                  peopleFriendReq[index].requestedTo,
                                );
                                if (user != null) {
                                  Navigator.of(context).push(
                                    PageTransition(
                                      child: JumpInUserPage(
                                        user: user,
                                        withoutProvider: true,
                                      ),
                                      type: PageTransitionType.fade,
                                    ),
                                  );
                                }
                              },
                              userId: peopleFriendReq[index].requestedTo,
                              msg: ' has accepted your JumpIn request.',
                              onChat: () async {
                                JumpInUser user = await locator
                                    .get<UserService>()
                                    .getUserById(
                                  peopleFriendReq[index].requestedTo,
                                );
                                if (user != null) {
                                  userProvider.chatWithUser = user;
                                  userProvider.currentPeopleGroup =
                                  peopleFriendReq[index];
                                  Navigator.of(context).push(
                                    PageTransition(
                                      child: const ChatPage(),
                                      type: PageTransitionType.fade,
                                    ),
                                  );
                                } else {
                                  showToast('Error in getting user');
                                }
                              },
                            );
                          } else if (peopleFriendReq[index].requestedTo ==
                              userProvider.currentUser.id &&
                              peopleFriendReq[index].status ==
                                  FriendRequestStatus.Accepted) {
                            return RequestCard(
                              date:
                              '${DateFormat.MMM().format(peopleFriendReq[index].createdAt)} ${DateFormat.d().format(peopleFriendReq[index].createdAt)}, ${DateFormat.y().format(peopleFriendReq[index].createdAt)}',
                              onTap: () async {
                                JumpInUser user = await locator
                                    .get<UserService>()
                                    .getUserById(
                                  peopleFriendReq[index].requestedBy,
                                );
                                if (user != null) {
                                  Navigator.of(context).push(
                                    PageTransition(
                                      child: JumpInUserPage(
                                        user: user,
                                        withoutProvider: true,
                                      ),
                                      type: PageTransitionType.fade,
                                    ),
                                  );
                                }
                              },
                              acceptDenyCard: true,
                              userId: peopleFriendReq[index].requestedBy,
                              msg: ' have accepted ',
                              onChat: () async {
                                JumpInUser user = await locator
                                    .get<UserService>()
                                    .getUserById(
                                  peopleFriendReq[index].requestedBy,
                                );
                                if (user != null) {
                                  userProvider.chatWithUser = user;
                                  userProvider.currentPeopleGroup =
                                  peopleFriendReq[index];
                                  Navigator.of(context).push(
                                    PageTransition(
                                      child: const ChatPage(),
                                      type: PageTransitionType.fade,
                                    ),
                                  );
                                } else {
                                  showToast('Error in getting user');
                                }
                              },
                            );
                          } else if (peopleFriendReq[index].requestedTo ==
                              userProvider.currentUser.id &&
                              peopleFriendReq[index].status ==
                                  FriendRequestStatus.Denied) {
                            return RequestCard(
                              date:
                              '${DateFormat.MMM().format(peopleFriendReq[index].createdAt)} ${DateFormat.d().format(peopleFriendReq[index].createdAt)}, ${DateFormat.y().format(peopleFriendReq[index].createdAt)}',
                              onTap: () async {
                                JumpInUser user = await locator
                                    .get<UserService>()
                                    .getUserById(
                                  peopleFriendReq[index].requestedBy,
                                );
                                if (user != null) {
                                  Navigator.of(context).push(
                                    PageTransition(
                                      child: JumpInUserPage(
                                        user: user,
                                        withoutProvider: true,
                                      ),
                                      type: PageTransitionType.fade,
                                    ),
                                  );
                                }
                              },
                              acceptDenyCard: true,
                              userId: peopleFriendReq[index].requestedBy,
                              msg: ' have denied ',
                              deny: true,
                              onChat: () async {
                                undoRequest(context, () async {
                                  bool done =
                                  await changeStatusToRequested(
                                    peopleFriendReq[index].id,
                                  );
                                  if (done) {
                                    showToast('success!');
                                    peopleFriendReq[index] =
                                        peopleFriendReq[index].copyWith(
                                          status:
                                          FriendRequestStatus.Requested,
                                        );
                                    setState(() {});
                                    Navigator.pop(context);
                                  } else {
                                    showToast(
                                      'Please try after sometime!',
                                    );
                                  }
                                });
                              },
                            );
                          } else if (peopleFriendReq[index].requestedTo ==
                              userProvider.currentUser.id &&
                              peopleFriendReq[index].status ==
                                  FriendRequestStatus.Requested) {
                            return RequestCard(
                              date:
                              '${DateFormat.MMM().format(peopleFriendReq[index].createdAt)} ${DateFormat.d().format(peopleFriendReq[index].createdAt)}, ${DateFormat.y().format(peopleFriendReq[index].createdAt)}',
                              onTap: () async {
                                JumpInUser user = await locator
                                    .get<UserService>()
                                    .getUserById(
                                  peopleFriendReq[index].requestedBy,
                                );
                                if (user != null) {
                                  Navigator.of(context).push(
                                    PageTransition(
                                      child: JumpInUserPage(
                                        user: user,
                                        withoutProvider: true,
                                      ),
                                      type: PageTransitionType.fade,
                                    ),
                                  );
                                }
                              },
                              acceptDenyCard: false,
                              userId: peopleFriendReq[index].requestedBy,
                              msg: ' wants to JumpIn with you! ',
                              onChat: null,
                              onAccept: () async {
                                bool accept = await locator
                                    .get<ChatService>()
                                    .acceptRequest(
                                  peopleFriendReq[index],
                                );
                                if (accept) {
                                  bool connected = await locator
                                      .get<ChatService>()
                                      .createConnection(
                                    peopleFriendReq[index]
                                        .requestedBy,
                                    peopleFriendReq[index]
                                        .requestedTo,
                                  );
                                  if (connected) {
                                    await acceptPeopleNotification(
                                      peopleFriendReq[index],
                                    );
                                    peopleFriendReq[index] =
                                        peopleFriendReq[index].copyWith(
                                          status:
                                          FriendRequestStatus.Accepted,
                                        );
                                    setState(
                                          () {},
                                    );
                                  }
                                }
                              },
                              onDeny: () async {
                                bool deny = await locator
                                    .get<ChatService>()
                                    .denyRequest(peopleFriendReq[index]);
                                if (deny) {
                                  peopleFriendReq[index] =
                                      peopleFriendReq[index].copyWith(
                                        status: FriendRequestStatus.Denied,
                                      );
                                  setState(() {});
                                }
                              },
                            );
                          } else {
                            return const SizedBox(
                              height: 0,
                              width: 0,
                            );
                          }
                        },
                        itemCount: peopleFriendReq.length,
                      ),
                    ),
                    Container(
                      child: loading
                          ? fadedCircle(32, 32, color: shade1)
                          : invitedPlans.isEmpty &&
                          deniedPlans.isEmpty &&
                          acceptedPlans.isEmpty
                          ? NoContentImage(
                        text: 'No new notification found',
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                      )
                          : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            ListView.builder(
                              physics:
                              const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return RequestCard(
                                  date:
                                  '${DateFormat.MMM().format(invitedPlans[index].createdAt)} ${DateFormat.d().format(invitedPlans[index].createdAt)}, ${DateFormat.y().format(invitedPlans[index].createdAt)}',
                                  onTap: () async {
                                    planProvider.currentPlan =
                                    invitedPlans[index];
                                    Navigator.of(context).push(
                                      PageTransition(
                                        child: CurrentPlanPage(
                                          hostId:
                                          invitedPlans[index].host,
                                        ),
                                        type: PageTransitionType.fade,
                                      ),
                                    );
                                  },
                                  plan: true,
                                  public: invitedPlans[index].public,
                                  userId: invitedPlans[index].host,
                                  msg: ' has invited you to JumpIn',
                                  planImg: invitedPlans[index].planImg[0],
                                  planName: invitedPlans[index].planName,
                                  invitedPlan: true,
                                  onAccept: () async {
                                    int acceptedMemLength =
                                    getAcceptedMemberLength(
                                        invitedPlans[index].member);
                                    if (acceptedMemLength <
                                        int.parse(
                                            invitedPlans[index].spot)) {
                                      bool success = await requestToPlan(
                                          invitedPlans[index], context);
                                      if (success) {
                                        getUser(context);
                                        // JumpInUser host = await locator.get<UserService>().getUserById(invitedPlans[index].host);
                                        // await acceptedToPlanNotification(userProvider.currentUser.id, invitedPlans[index].id, invitedPlans[index].planName, host);
                                        successTick(context);
                                        await acceptedMemberToPlanNotification(
                                            invitedPlans[index].host,
                                            invitedPlans[index].id,
                                            invitedPlans[index].planName,
                                            userProvider.currentUser);
                                        invitedPlans
                                            .remove(invitedPlans[index]);
                                        setState(() {});
                                      } else {
                                        showError(
                                            context: context,
                                            errMsg: 'Error caught!');
                                      }
                                    } else {
                                      showError(
                                          context: context,
                                          errMsg: 'Total spot filled!');
                                    }
                                  },
                                  onDeny: () async {
                                    bool deny = await denyingCurrentPlan(
                                        invitedPlans[index], context);
                                    if (deny == false) {
                                      showError(
                                          context: context,
                                          errMsg:
                                          'Error in denying request');
                                    } else {
                                      invitedPlans
                                          .remove(invitedPlans[index]);
                                      if (mounted) setState(() {});
                                    }
                                  },
                                );
                              },
                              itemCount: invitedPlans.length,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics:
                              const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return RequestCard(
                                  date:
                                  '${DateFormat.MMM().format(deniedPlans[index].createdAt)} ${DateFormat.d().format(deniedPlans[index].createdAt)}, ${DateFormat.y().format(deniedPlans[index].createdAt)}',
                                  plan: true,
                                  public: deniedPlans[index].public,
                                  onTap: () async {
                                    planProvider.currentPlan =
                                    deniedPlans[index];
                                    Navigator.of(context).push(
                                      PageTransition(
                                        child: CurrentPlanPage(
                                          hostId: deniedPlans[index].host,
                                        ),
                                        type: PageTransitionType.fade,
                                      ),
                                    );
                                  },
                                  msg: ' have denied ',
                                  msg1:
                                  '\'s JumpIn invite for plan ${deniedPlans[index].planName.toUpperCase()}',
                                  userId: deniedPlans[index].host,
                                  planImg: deniedPlans[index].planImg[0],
                                  planName: deniedPlans[index].planName,
                                  deny: true,
                                  deniedPlan: true,
                                  onChat: () async {
                                    undoRequest(context, () async {
                                      int acceptedMemLength =
                                      getAcceptedMemberLength(
                                          deniedPlans[index].member);
                                      if (acceptedMemLength <
                                          int.parse(
                                              deniedPlans[index].spot)) {
                                        bool success =
                                        await requestToPlan(
                                          deniedPlans[index],
                                          context,
                                        );
                                        if (success) {
                                          Navigator.pop(context);
                                          getUser(context);
                                          successTick(context);
                                          // JumpInUser host = await locator.get<UserService>().getUserById(deniedPlans[index].host);
                                          // await acceptedToPlanNotification(userProvider.currentUser.id, deniedPlans[index].id, deniedPlans[index].planName, host);
                                          await acceptedMemberToPlanNotification(
                                            deniedPlans[index].host,
                                            deniedPlans[index].id,
                                            deniedPlans[index].planName,
                                            userProvider.currentUser,
                                          );
                                          deniedPlans
                                              .remove(deniedPlans[index]);
                                          setState(() {});
                                        } else {
                                          showError(
                                            context: context,
                                            errMsg: 'Error caught!',
                                          );
                                        }
                                      } else {
                                        showError(
                                          context: context,
                                          errMsg: 'Total spot filled!',
                                        );
                                      }
                                    });
                                  },
                                );
                              },
                              itemCount: deniedPlans.length,
                            ),
                            ListView.builder(
                              physics:
                              const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return RequestCard(
                                  date:
                                  '${DateFormat.MMM().format(acceptedPlans[index].createdAt)} ${DateFormat.d().format(acceptedPlans[index].createdAt)}, ${DateFormat.y().format(acceptedPlans[index].createdAt)}',
                                  plan: true,
                                  public: acceptedPlans[index].public,
                                  onTap: () async {
                                    planProvider.currentPlan =
                                    acceptedPlans[index];
                                    Navigator.of(context).push(
                                      PageTransition(
                                        child: CurrentPlanPage(
                                          hostId:
                                          acceptedPlans[index].host,
                                        ),
                                        type: PageTransitionType.fade,
                                      ),
                                    );
                                  },
                                  msg: ' have Jumped in ',
                                  msg1:
                                  '\'s plan ${acceptedPlans[index].planName.toUpperCase()}',
                                  userId: acceptedPlans[index].host,
                                  planImg:
                                  acceptedPlans[index].planImg[0],
                                  planName: acceptedPlans[index].planName,
                                  deny: true,
                                  deniedPlan: true,
                                );
                              },
                              itemCount: acceptedPlans.length,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: loading
                          ? fadedCircle(32, 32, color: shade1)
                          : myPlans.isEmpty
                          ? NoContentImage(
                        text: 'No new notification found',
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                      )
                          : ListView.builder(
                        itemBuilder: (context, index) {
                          List<String> reqUserIds = [];
                          for (int i = 0;
                          i < myPlans[index].member.length;
                          i++) {
                            if (myPlans[index].member[i].status ==
                                MemberStatus.Accepted &&
                                myPlans[index].member[i].memId !=
                                    userProvider.currentUser.id) {
                              reqUserIds
                                  .add(myPlans[index].member[i].memId);
                            }
                          }
                          return MyPlanRequestCard(
                            onTap: () async {
                              planProvider.currentPlan = myPlans[index];
                              Navigator.of(context).push(
                                PageTransition(
                                  child: CurrentPlanPage(
                                    hostId: myPlans[index].host,
                                  ),
                                  type: PageTransitionType.fade,
                                ),
                              );
                            },
                            plan: myPlans[index],
                            userIds: reqUserIds,
                          );
                        },
                        itemCount: myPlans.length,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
