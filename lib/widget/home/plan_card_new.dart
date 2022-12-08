import 'package:antizero_jumpin/handler/bookmark.dart';
import 'package:antizero_jumpin/handler/local.dart';
import 'package:antizero_jumpin/handler/plan.dart';
import 'package:antizero_jumpin/handler/recommend.dart';
import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/handler/user.dart';
import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/friend_request.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/models/member.dart';
import 'package:antizero_jumpin/models/plan.dart';
import 'package:antizero_jumpin/provider/plan.dart';
import 'package:antizero_jumpin/screens/home/plans/current_plan.dart';
import 'package:antizero_jumpin/screens/home/plans/current_plan_new.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/widget/home/card_buttons.dart';
import 'package:antizero_jumpin/widget/home/image_card.dart';
import 'package:antizero_jumpin/widget/home/plans/bookmark.dart';
import 'package:antizero_jumpin/widget/home/plans/current_plan_new.dart';
import 'package:antizero_jumpin/widget/home/plans/people_attending.dart';
import 'package:antizero_jumpin/widget/home/plans/spot_card.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class HomePlanCardNew extends StatefulWidget {
  final Widget userName;
  final List<Member> members;
  final String planName;
  final String userId;
  final Widget location;
  final Widget vibe;
  final Widget upperLeft;
  final Widget upperRight;
  final Widget lowerRight;
  final Widget lowerLeft;
  final Widget centerImage;
  final Widget jumpInButton;
  final Widget recommendButton;
  final Function onUserTap;
  final bool plan;
  final bool public;
  final bool addMem;
  final Widget planDesc;
  final String hostId;
  final String catName;
  final Widget ageLimit;
  final int spotsRem;
  final double spotsPercentage;
  final String planId;
  final Plan planmodel;

  const HomePlanCardNew(
      {Key key,
        this.userName,
        this.members,
        this.planName,
        this.userId,
        this.location,
        this.vibe,
        this.upperLeft,
        this.upperRight,
        this.centerImage,
        this.lowerRight,
        this.lowerLeft,
        this.onUserTap,
        this.plan = false,
        this.public = true,
        this.addMem = false,
        this.planDesc,
        this.jumpInButton,
        this.recommendButton,
        this.hostId,
        this.catName,
        this.ageLimit,
        this.spotsRem,
        this.spotsPercentage,this.planId,this.planmodel})
      : super(key: key);

  @override
  _HomePlanCardNewState createState() => _HomePlanCardNewState();
}

class _HomePlanCardNewState extends State<HomePlanCardNew> {
  bool requested = false;
  bool ifAccepted = false;
  bool ifInvited = false;
  bool marked = false;
  List<JumpInUser> users = [];
  int numofmale = 0;
  int numoffemale = 0;
  int numofother = 0;

  @override
  void initState() {
    checkIfRequestedByThisUser();
    checkIfBookMarked(context);
    getDetails(context);
    if (widget.members != null) checkIfAcceptedPlan();
    if (widget.members != null) checkIfInvitedInPlan();
    super.initState();
  }

  getDetails(BuildContext context) async {
    if (widget.planmodel != null)
    {
      users = [];
      for (int i = 0; i < widget.planmodel.member.length; i++) {
        if (widget.planmodel.member[i].status == MemberStatus.Accepted) {
          JumpInUser user = await locator
              .get<UserService>()
              .getUserById(widget.planmodel.member[i].memId);
          if (user != null) {
            users.add(user);
            if (user.gender == 'Male') {
              numofmale = numofmale + 1;
            } else if (user.gender == 'Female') {
              numoffemale = numoffemale + 1;
            } else {
              numofother = numofother + 1;
            }
          }
        }
      }
    }
    if (mounted) setState(() {});
  }

  checkIfBookMarked(BuildContext context) async {
    marked = await isPlanBookMarked(context);
    print('marked $marked');
    setState(() {});
  }

  checkIfAcceptedPlan() {
    ifAccepted = checkIfUserHasAcceptedPlan(context, widget.members);
    setState(() {});
  }

  checkIfInvitedInPlan() {
    ifInvited = checkIfUserHasInvitedToPlan(context, widget.members);
    setState(() {});
  }

  checkIfRequestedByThisUser() async {
    if (widget.userId != null) {
      FriendRequest friendRequest =
      await checkIfRequestedByUser(context, widget.userId);
      if (friendRequest != null) {
        if (friendRequest.status == FriendRequestStatus.Requested) {
          requested = true;
        }
      }
    }
    if (mounted) setState(() {});
  }

  // ifAccepted ? Container() :
  @override
  Widget build(BuildContext context) {
    var planProvider = Provider.of<PlanProvider>(context);
    return ifAccepted
        ? Container()
        : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.82,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          border: Border.all(color: blueborder),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: blueborder.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],),
                      margin: EdgeInsets.only(right: 8, top: 8),
                      child: ListView(
                        children: <Widget>[
                          Container(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (widget.planName != null)
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.only(left: 8, top: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              widget.centerImage,
                                              Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.of(context).size.width * 0.50,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(
                                                            top: 0.0, left: 8.0),
                                                        child: Text(
                                                            widget.planName ?? 'N/A',
                                                            overflow:
                                                            TextOverflow.ellipsis,
                                                            textAlign:
                                                            TextAlign.start,
                                                            maxLines: 2,
                                                            style: bodyStyle(
                                                                context: context,
                                                                size: 20,
                                                                color: Colors.black)),
                                                      ),
                                                    ),
                                                    SizedBox(height: 2),
                                                    Container(
                                                      padding: EdgeInsets.all(8.0),
                                                      margin: EdgeInsets.all(4.0),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: Colors.blue[50],
                                                      ),
                                                      child: Text(
                                                        widget.catName,
                                                        textAlign: TextAlign.center,
                                                        style: textStyle1.copyWith(
                                                            fontSize: 12, color: Colors.blue),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                          top: 2.0, left: 4.0),
                                                      child: widget.userName,
                                                    ),
                                                  ]),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                ]),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0,top: 8.0),
                              child: widget.location,
                            ),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(child: widget.upperLeft),
                                Expanded(child: widget.upperRight),
                              ]),
                          SpotCard(
                            spotsRem: widget.spotsRem,
                            spotsPercentage: widget.spotsPercentage,
                            male: numofmale,
                            female: numoffemale,
                            others: numofother,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: widget.planDesc,
                          ),
                          widget.ageLimit,
                          GestureDetector(
                            onTap:(){
                              planProvider.currentPlan = widget.planmodel;
                              Navigator.of(context).push(PageTransition(
                              //send host name
                                child: CurrentPlanNewPage(
                                  hostId: widget.hostId,
                                ),
                                type: PageTransitionType.fade));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Center(
                                child: Text(
                                  'Click to see People attending this plan',
                                  style: TextStyle(
                                      color: Colors.black
                                          .withOpacity(0.7),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              margin: EdgeInsets.all(4.0),
                              child: widget.jumpInButton),
                          Container(
                            margin: EdgeInsets.all(4.0),
                            child: widget.recommendButton),
                          Container(
                              margin: EdgeInsets.all(4.0),
                              child: BookmarkCard(
                                  onPress: () async {
                                      if (marked == true) {
                                          bool success =
                                          await removePlanFromBookMark(
                                          context, widget.planId);
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
                                          context,widget.planId);
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
                                  marked: marked,
                                  ),
                        ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}