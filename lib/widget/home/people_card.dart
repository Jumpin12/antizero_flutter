import 'package:antizero_jumpin/handler/local.dart';
import 'package:antizero_jumpin/handler/plan.dart';
import 'package:antizero_jumpin/handler/recommend.dart';
import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/handler/user.dart';
import 'package:antizero_jumpin/models/friend_request.dart';
import 'package:antizero_jumpin/models/member.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/widget/home/card_buttons.dart';
import 'package:flutter/material.dart';

class HomeCard extends StatefulWidget {
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

  const HomeCard({
    Key key,
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
    this.jumpInButton,
    this.recommendButton,
    this.onUserTap,
    this.plan = false,
    this.public = true,
    this.addMem = false,
  }) : super(key: key);

  @override
  _HomeCardState createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  bool requested = false;
  bool ifAccepted = false;
  bool ifInvited = false;

  @override
  void initState() {
    checkIfRequestedByThisUser();
    if (widget.members != null) checkIfAcceptedPlan();
    if (widget.members != null) checkIfInvitedInPlan();
    super.initState();
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
    return ifAccepted
        ? Container()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      if (widget.planName != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5, left: 5),
                            child: Container(
                              width: getScreenSize(context).width - 100,
                              child: Text(
                                widget.planName ?? 'N/A',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: bodyStyle(
                                    context: context, size: 18, color: blue),
                              ),
                            ),
                          ),
                        ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: getScreenSize(context).width - 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //username
                                widget.userName,
                                //location
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: widget.location,
                                ),
                              ],
                            ),
                            if (widget.addMem) widget.vibe
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        child: Align(
                            alignment: Alignment.topCenter,
                            child: Column(
                              children: [
                                Text("Tap To Know More",
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal *
                                                3)),
                                if (requested)
                                  Text("Requested for connection",
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                          color: blue,
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal *
                                                  3.2)),
                                if (ifInvited)
                                  Text("Invited to join ${widget.planName}",
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                          color: blue,
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal *
                                                  3.2)),
                                if (widget.plan)
                                  Text(widget.public ? 'Public' : 'Private',
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                          color: widget.public
                                              ? blue
                                              : Colors.redAccent,
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal *
                                                  3.2)),
                              ],
                            )),
                      ),
                      GestureDetector(
                        onTap: widget.onUserTap,
                        child: Container(
                          height: getScreenSize(context).height * 0.39,
                          width: getScreenSize(context).width * 0.72,
                          padding: EdgeInsets.all(
                              getScreenSize(context).height * 0.02),
                          decoration: BoxDecoration(
                              color: widget.planName == null
                                  ? Colors.cyan[50].withOpacity(0.6)
                                  : purple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10)),
                          child: Stack(
                            children: [
                              widget.upperLeft,
                              widget.upperRight,
                              widget.lowerRight,
                              widget.lowerLeft,
                              widget.centerImage,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02),
                    child: Container(
                      width: getScreenSize(context).width - 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.jumpInButton,
                          // SizedBox(width: 30),
                          widget.recommendButton
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
