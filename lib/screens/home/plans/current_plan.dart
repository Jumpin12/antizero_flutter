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
import 'package:antizero_jumpin/models/plan.dart';
import 'package:antizero_jumpin/provider/plan.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/screens/home/jumpInuser_profile.dart';
import 'package:antizero_jumpin/screens/home/plans/create_plan.dart';
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

class CurrentPlanPage extends StatefulWidget {
  final String hostId;
  final bool isFromMyPlan;

  const CurrentPlanPage({@required this.hostId, Key key,this.isFromMyPlan=false}) : super(key: key);

  @override
  _CurrentPlanPageState createState() => _CurrentPlanPageState();
}

class _CurrentPlanPageState extends State<CurrentPlanPage> {
  JumpInUser hostPlan;
  List<JumpInUser> users = [];
  int male = 0;
  int female = 0;
  int other = 0;
  bool loading = true;
  bool marked = false;
  bool setMark = false;
  int acceptedMembers = 0;

  bool acceptingPlan = false;
  MemberStatus status;

  GlobalKey keyK;
  Uint8List bytes;

  @override
  void initState() {
    getHost();
    checkIfBookMarked();
    getDetails();
    super.initState();
    FirebaseAnalytics.instance.logScreenView(
      screenName: 'Current Plan Screen',
      screenClass: 'Plans',
    );
  }

  getHost() async {
    JumpInUser user =
        await locator.get<UserService>().getUserById(widget.hostId);
    if (user != null) {
      hostPlan = user;
    }
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  checkIfBookMarked() async {
    bool _marked = await isPlanBookMarked(context);
    if (_marked == true) marked = _marked;
    if (mounted)
      setState(() {
        setMark = true;
        loading = false;
      });
  }

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
            MemberStatus.Accepted)
        {
          JumpInUser user = await locator
              .get<UserService>()
              .getUserById(planProvider.currentPlan.member[i].memId);
          if (user != null) {
            users.add(user);
            if (user.gender == 'Male') {
              male = male + 1;
            } else if (user.gender == 'Female') {
              female = female + 1;
            } else {
              other = other + 1;
            }
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
        appBar:
        (widget.isFromMyPlan==true) ?
        HomeAppBar(
          title: 'JUMPIN',
          leading: true,
          trailing: true,
          isFromMyPlan: true,
          onEditPlan: onEdit
        ) :
        HomeAppBar(
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
                        // profile image
                        Container(
                          width: size.width,
                          height: size.height * 0.27,
                          child: Stack(
                            children: [
                              Container(
                                width: size.width,
                                height: size.height * 0.17,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                  colors: [Colors.blue[900], Colors.blue],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Stack(
                                  children: [
                                    Container(
                                        width: size.height * 0.18,
                                        height: size.height * 0.18,
                                        child: ImageSwiper(
                                          images:
                                              planProvider.currentPlan.planImg,
                                        )
                                    ),
                                    // Positioned(
                                    //   bottom: size.height * 0.005,
                                    //   right: 0,
                                    //   child: PlanVibeCard(
                                    //     fromProfile: true,
                                    //     plan: planProvider.currentPlan,
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Card(
                            color: blue,
                            elevation: 5,
                            shadowColor: Colors.blueGrey.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                '${planProvider.currentPlan.catName}',
                                textAlign: TextAlign.center,
                                style: textStyle1.copyWith(
                                    fontSize: 18, color: Colors.white),
                              ),
                            )),
                        SizedBox(height: 5),
                        Text(
                          '${planProvider.currentPlan.planName}',
                          textAlign: TextAlign.center,
                          style: textStyle1.copyWith(
                              fontSize: 26,
                              color: Colors.black87,
                              fontFamily: tre),
                        ),
                        SizedBox(height: 2),
                        RichText(
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          text: TextSpan(
                              text: 'Hosted by ',
                              style: bodyStyle(
                                  context: context,
                                  size: 14,
                                  color: Colors.black54),
                              children: [
                                //changes here
                                TextSpan(
                                    text: hostPlan == null
                                        ? 'JumpIn User'
                                        : hostPlan.id ==
                                                userProvider.currentUser.id
                                            ? 'YOU'
                                            : '${hostPlan.username.toUpperCase()}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: ColorsJumpIn.kPrimaryColor,
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal *
                                                3.5)),

                                // TextSpan(
                                //     text: host == null
                                //         ? 'JumpIn User'
                                //         : '${host.toUpperCase()}',
                                //     style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         color: ColorsJumpIn.kPrimaryColor,
                                //         fontSize:
                                //             SizeConfig.blockSizeHorizontal *
                                //                 3.5)),
                              ]),
                        ),

                        // spot
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.03),
                          child: LinearPercentIndicator(
                            alignment: MainAxisAlignment.center,
                            width: getScreenSize(context).width * 0.7,
                            lineHeight: SizeConfig.blockSizeVertical * 5,
                            percent: double.parse(acceptedMembers.toString()) /
                                double.parse(planProvider.currentPlan.spot),
                            center: Container(
                              child: Text(
                                  (int.parse(planProvider.currentPlan.spot) -
                                              acceptedMembers)
                                          .toString() +
                                      " Spots Left",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 3)),
                            ),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            backgroundColor: Colors.blue[200].withOpacity(0.8),
                            progressColor: Colors.blue,
                          ),
                        ),

                        // date time
                        Container(
                          width: size.width,
                          height: size.height * 0.21,
                          decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(10)),
                          margin: EdgeInsets.only(
                              top: size.height * 0.04,
                              left: size.width * 0.04,
                              right: size.width * 0.04),
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.05,
                              horizontal: size.width * 0.04),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  width: size.width * 0.2,
                                  child: Image.asset(scheduleIcon)),
                              Container(
                                width: size.width * 0.64,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          width: size.width * 0.32,
                                          child: Column(
                                            children: [
                                              Text(
                                                "Start",
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                  Jiffy(planProvider.currentPlan
                                                          .startDate)
                                                      .format("do MMM"),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.8),
                                                      fontSize:
                                                          size.height * 0.022,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ],
                                          ),
                                        ),
                                        if (planProvider.currentPlan.multi ==
                                            true)
                                          Container(
                                            width: size.width * 0.32,
                                            child: Column(
                                              children: [
                                                Text(
                                                  "End",
                                                  style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.6),
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                    Jiffy(planProvider
                                                            .currentPlan
                                                            .endDate)
                                                        .format("do MMM"),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.8),
                                                        fontSize:
                                                            size.height * 0.022,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Timings - ",
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                            Jiffy(planProvider.currentPlan.time)
                                                .format("hh:mm a"),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                                fontSize: size.height * 0.022,
                                                fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // place & gender
                        Padding(
                          padding: EdgeInsets.only(
                              left: size.width * 0.04,
                              right: size.width * 0.04,
                              top: size.height * 0.06),
                          child: Container(
                            width: size.width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: size.width * 0.458,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.02),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: size.width * 0.06,
                                        height: size.height * 0.06,
                                        child: Image.asset(locationIcon),
                                      ),
                                      Text(
                                          planProvider.currentPlan.online ==
                                                  true
                                              ? 'Online'
                                              : planProvider
                                                  .currentPlan.location,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              fontSize: size.height * 0.018,
                                              fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: size.height * 0.12,
                                  child: VerticalDivider(
                                    color: Colors.black12,
                                    thickness: size.width * 0.004,
                                    width: size.width * 0.004,
                                  ),
                                ),
                                Container(
                                  width: size.width * 0.458,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: size.width * 0.06,
                                        height: size.height * 0.06,
                                        child: Image.asset(memberIcon),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "Male",
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(male.toString(),
                                                  style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.7),
                                                      fontSize:
                                                          size.height * 0.02,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "Female",
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(female.toString(),
                                                  style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.7),
                                                      fontSize:
                                                          size.height * 0.02,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "Others",
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(other.toString(),
                                                  style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.7),
                                                      fontSize:
                                                          size.height * 0.02,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // entry fee & age limit
                        Padding(
                          padding: EdgeInsets.only(
                              left: size.width * 0.04,
                              right: size.width * 0.04,
                              top: size.height * 0.06),
                          child: Container(
                            width: size.width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: size.width * 0.458,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.02),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: size.height * 0.06,
                                        child: Image.asset(
                                          moneyIcon,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (planProvider
                                                  .currentPlan.entryFree ==
                                              true)
                                            Text(
                                              "Entry fee : ",
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          Flexible(
                                            child: Text(
                                                planProvider.currentPlan
                                                            .entryFree ==
                                                        true
                                                    ? '\u{20B9} ${planProvider.currentPlan.fees}'
                                                    : "Free Entry",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.7),
                                                    fontSize:
                                                        size.height * 0.02,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: size.width * 0.458,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: size.width * 0.06,
                                        height: size.height * 0.06,
                                        child: Image.asset(ageIcon),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (planProvider.currentPlan.age ==
                                              true)
                                            Text(
                                              "For people above : ",
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          Flexible(
                                            child: Text(
                                                planProvider.currentPlan.age ==
                                                        true
                                                    ? "${planProvider.currentPlan.ageLimit} Yrs"
                                                    : 'No Age Restriction',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.7),
                                                    fontSize:
                                                        size.height * 0.02,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // plan description
                        SizedBox(height: 20),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                'Plan description',
                                style: headingStyle(
                                    context: context,
                                    size: 20,
                                    color: Colors.black),
                              ),
                            )),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, top: 10, right: 15),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                planProvider.currentPlan.planDisc ?? '',
                                style: bodyStyle(
                                    context: context,
                                    size: 16,
                                    color: Colors.black54),
                              ),
                            ),
                          ),
                        ),

                        // user list
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Divider(),
                        ),
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
                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 100,
                      width: size.width,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(193, 206, 219, 1.0),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      child: loading
                          ? fadedCircle(32, 32, color: Colors.white)
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AcceptPlanBtn(
                                  member: planProvider.currentPlan.member,
                                  plan: planProvider.currentPlan,
                                  public: planProvider.currentPlan.public,
                                  loading: acceptingPlan,
                                  accepted: status == MemberStatus.Accepted,
                                  onTap: () async {
                                    setState(() {
                                      acceptingPlan = true;
                                    });
                                    if (status == MemberStatus.Accepted) {
                                      JumpInUser host = await locator
                                          .get<UserService>()
                                          .getUserById(
                                              planProvider.currentPlan.host);
                                      if (host != null) {
                                        planProvider.currentPlanHost = host;
                                        planProvider.currentPlan =
                                            planProvider.currentPlan;
                                        Navigator.of(context).push(
                                            PageTransition(
                                                child: PlanChatPage(),
                                                type: PageTransitionType.fade));
                                      }
                                    } else {
                                      int acceptedMemLength =
                                          getAcceptedMemberLength(
                                              planProvider.currentPlan.member);
                                      if (acceptedMemLength <
                                          int.parse(
                                              planProvider.currentPlan.spot)) {
                                        if (status == null ||
                                            status == MemberStatus.Invited) {
                                          bool success = await requestToPlan(
                                              planProvider.currentPlan,
                                              context);
                                          if (success) {
                                            successTick(context);
                                            await getDetails();
                                            await getUser(context);
                                            JumpInUser host = await locator
                                                .get<UserService>()
                                                .getUserById(planProvider
                                                    .currentPlan.host);
                                            await acceptedToPlanNotification(
                                                userProvider.currentUser.id,
                                                planProvider.currentPlan.id,
                                                planProvider
                                                    .currentPlan.planName,
                                                host);
                                          } else {
                                            showError(
                                                context: context,
                                                errMsg: 'Error caught!');
                                          }
                                        } else {
                                          print(
                                              'status is not accepted nor invited');
                                        }
                                      } else {
                                        showError(
                                            context: context,
                                            errMsg: 'Total spot filled!');
                                      }
                                    }
                                    if (mounted)
                                      setState(() {
                                        acceptingPlan = false;
                                      });
                                  },
                                ),
                                CardButton(
                                  color: Colors.grey[50],
                                  textColor: Colors.black54,
                                  onPress: () async {
                                    bytes = await capture(keyK);
                                    bool success = await takeScreenShot(bytes,
                                        context, planProvider.currentPlan.id);
                                    if (success) {
                                      await recommendPlan(
                                          context,
                                          planProvider.currentPlan.planName,
                                          planProvider.currentPlan.id);
                                      analytics.logCustomEvent(
                                          eventName: 'planRecommended',
                                          params: {
                                            'recommendedBy': FirebaseAuth
                                                .instance.currentUser.uid,
                                            'planId':
                                                planProvider.currentPlan.id,
                                          });
                                    } else {
                                      showToast('Error caught!');
                                    }
                                  },
                                  label: 'Recommend',
                                  icon: referIcon,
                                ),

                                // bookmark
                                if (setMark == true)
                                  FadeAnimation(
                                    0.2,
                                    FloatingActionButton(
                                      backgroundColor:
                                          marked ? blue : Colors.white,
                                      child: FaIcon(FontAwesomeIcons.bookmark,
                                          size: 20,
                                          color: marked ? Colors.white : blue),
                                      onPressed: () async {
                                        if (marked == true) {
                                          bool success =
                                              await removePlanFromBookMark(
                                                  context,
                                                  planProvider.currentPlan.id);
                                          if (success) {
                                            showToast('Removed from bookmark!');
                                            setState(() {
                                              marked = false;
                                            });
                                          } else {
                                            showToast('Please try again!');
                                          }
                                        } else {
                                          bool added = await addPlanToBookMark(
                                              context,
                                              planProvider.currentPlan.id);
                                          if (added) {
                                            showToast('Added to bookmark!');
                                            setState(() {
                                              marked = true;
                                            });
                                          } else {
                                            showToast('Please try again!');
                                          }
                                        }
                                      },
                                    ),
                                  )
                              ],
                            ),
                    ),
                  )
                ],
              ),
      );
    });
  }

  onEdit() {
    var planProvider = Provider.of<PlanProvider>(context,listen: false);
    Navigator.of(context).push(
        PageTransition(
            child: CreatePlanPage(
              public: true,
              isFromEdit: true,
              editPlan: planProvider.currentPlan,
              members: users
            ),
            type: PageTransitionType
                .fade));
  }
}
