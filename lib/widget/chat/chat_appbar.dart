import 'package:antizero_jumpin/handler/plan.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/models/plan.dart';
import 'package:antizero_jumpin/provider/plan.dart';
import 'package:antizero_jumpin/screens/home/jumpInuser_profile.dart';
import 'package:antizero_jumpin/screens/home/plans/current_plan.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ChatAppBar extends StatefulWidget {
  final JumpInUser user;
  final bool isPlan;
  final Plan plan;

  const ChatAppBar({Key key, this.user, this.plan, this.isPlan = false})
      : super(key: key);

  @override
  _ChatAppBarState createState() => _ChatAppBarState();
}

class _ChatAppBarState extends State<ChatAppBar> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.isPlan==true)
      {
        updateMsgCountOfEachPlanMember(context);
      }
    else
      {

      }
  }

  @override
  Widget build(BuildContext context) {
    var planProvider = Provider.of<PlanProvider>(context);
    return widget.isPlan
        ? GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              planProvider.currentPlan = widget.plan;
              Navigator.of(context).push(
                PageTransition(
                  //send host name
                  child: CurrentPlanPage(
                    hostId: widget.plan.host,
                  ),
                  type: PageTransitionType.fade,
                ),
              );
            },
            child: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (!widget.isPlan) || (widget.plan.planImg == null)
                      ? CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 100 * 4.5,
                          backgroundImage: widget.user.photoList.last == null
                              ? AssetImage(avatarIcon)
                              : NetworkImage(widget.user.photoList.last),
                        )
                      : CircleAvatar(
                          backgroundImage: widget.plan.planImg == null
                              ? AssetImage(avatarIcon)
                              : NetworkImage(
                                  widget.plan.planImg[0],
                                ),
                        ),
                  SizedBox(
                    width: 15,
                  ),
                  Flexible(
                    child: Text(
                      widget.plan.planName,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
              ),
            ),
          )
        : GestureDetector(
            onTap: () async {
              HapticFeedback.mediumImpact();
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => JumpInUserPage(
                    user: widget.user,
                    withoutProvider: false,
                  ),
                ),
              );
            },
            child: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (!widget.isPlan || widget.plan.planImg == null)
                      ? CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 100 * 4.5,
                          backgroundImage: widget.user.photoList.last == null
                              ? AssetImage(avatarIcon)
                              : NetworkImage(widget.user.photoList.last),
                        )
                      : CircleAvatar(
                          backgroundImage: widget.plan.planImg == null
                              ? AssetImage(avatarIcon)
                              : NetworkImage(
                                  widget.plan.planImg[0],
                                ),
                        ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    widget.user.name,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
              ),
            ),
          );
  }
}
