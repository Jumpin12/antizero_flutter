import 'dart:typed_data';

import 'package:antizero_jumpin/handler/bookmark.dart';
import 'package:antizero_jumpin/handler/home.dart';
import 'package:antizero_jumpin/handler/local.dart';
import 'package:antizero_jumpin/handler/notification.dart';
import 'package:antizero_jumpin/handler/plan.dart';
import 'package:antizero_jumpin/handler/recommend.dart';
import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/handler/user.dart';
import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/models/member.dart';
import 'package:antizero_jumpin/provider/plan.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/screens/home/jumpInuser_profile.dart';
import 'package:antizero_jumpin/screens/home/plans/plan_chat.dart';
import 'package:antizero_jumpin/services/analytics.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/widget/common/fade_animation.dart';
import 'package:antizero_jumpin/widget/home/app_bar.dart';
import 'package:antizero_jumpin/widget/home/card_buttons.dart';
import 'package:antizero_jumpin/widget/home/plans/accept_plan.dart';
import 'package:antizero_jumpin/widget/home/plans/mutual_friends_indicator.dart';
import 'package:antizero_jumpin/widget/home/widget_toImg.dart';
import 'package:antizero_jumpin/widget/profile/img_swipper.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

Analytics analytics = locator<Analytics>();

class CurrentPlanNewPage extends StatefulWidget {
  final String hostId;

  CurrentPlanNewPage({@required this.hostId, Key key}) : super(key: key);

  @override
  _CurrentPlanNewPageState createState() => _CurrentPlanNewPageState();
}

class _CurrentPlanNewPageState extends State<CurrentPlanNewPage> {
  // JumpInUser hostPlan;
  bool loading = true;
  // bool marked = false;
  // bool setMark = false;
  int acceptedMembers = 0;
  List<JumpInUser> users = [];
  bool acceptingPlan = false;
  MemberStatus status;

  GlobalKey keyK;
  Uint8List bytes;

  @override
  void initState() {
    // getHost();
    // checkIfBookMarked();
    getDetails();
    super.initState();
    FirebaseAnalytics.instance.logScreenView(
      screenName: 'Current Plan Screen',
      screenClass: 'Plans',
    );
  }

  // getHost() async {
  //   JumpInUser user =
  //   await locator.get<UserService>().getUserById(widget.hostId);
  //   if (user != null) {
  //     hostPlan = user;
  //   }
  //   if (mounted) {
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }

  // checkIfBookMarked() async {
  //   bool _marked = await isPlanBookMarked(context);
  //   if (_marked == true) marked = _marked;
  //   if (mounted)
  //     setState(() {
  //       setMark = true;
  //     });
  // }

  getDetails() async {
    var planProvider = Provider.of<PlanProvider>(context, listen: false);

    if (planProvider.currentPlan != null) {
      int acceptedMemLength =
      getAcceptedMemberLength(planProvider.currentPlan.member);
      acceptedMembers = acceptedMemLength;

      MemberStatus _status =
      checkStatus(planProvider.currentPlan.member, context);
      setState(() {
        status = _status;
      });

      users = [];
      for (int i = 0; i < planProvider.currentPlan.member.length; i++) {
        if (planProvider.currentPlan.member[i].status ==
            MemberStatus.Accepted) {
          JumpInUser user = await locator
              .get<UserService>()
              .getUserById(planProvider.currentPlan.member[i].memId);
          if (user != null) {
            users.add(user);
          }
        }
      }
    }
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var planProvider = Provider.of<PlanProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    List<String> uIds = getUserConnections(context);

    var size = MediaQuery.of(context).size;

    return WidgetToImage(builder: (key) {
      keyK = key;
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: HomeAppBar(
            title: 'JUMPIN',
            leading: true,
            trailing: false,
          ),
          body: loading == true || planProvider.currentPlan == null
              ? fadedCircle(32, 32, color: Colors.blue[100])
              : Stack(
              children: [
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              'People attending this plan',
                              style: headingStyle(
                                  context: context,
                                  size: 20,
                                  color: Colors.black),
                            ),
                          )),
                      if (users.isNotEmpty)
                        FadeAnimation(
                          0.2,
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.blue[100],
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: users.length,
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    child: Card(
                                      color: Colors.white,
                                      shadowColor:
                                      Colors.blueGrey.withOpacity(0.2),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 3),
                                        child: ListTile(
                                          onTap: () async {
                                            Navigator.of(context).push(
                                                PageTransition(
                                                    child: JumpInUserPage(
                                                      user: users[index],
                                                      withoutProvider: true,
                                                    ),
                                                    type: PageTransitionType
                                                        .fade));
                                          },
                                          dense: true,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10)),
                                          leading: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.blue[100],
                                            child: CircleAvatar(
                                              radius: 22,
                                              backgroundImage: users[index]
                                                  .photoList.last ==
                                                  null
                                                  ? AssetImage(avatarIcon)
                                                  : NetworkImage(users[index]
                                                  .photoList.last),
                                            ),
                                          ),
                                          title: Text(
                                            uIds.contains(users[index].id)
                                                ? users[index].name
                                                : '@ ${users[index].username}',

                                            // users[index].username ?? '',
                                            style: bodyStyle(
                                                context: context,
                                                size: 18,
                                                color: Colors.black54),
                                          ),
                                          trailing: MutualFriendIndicator(
                                            user: users[index],
                                            id: users[index].id,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              ]
          )
      );
    }
  );
}
}
