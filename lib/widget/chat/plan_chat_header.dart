import 'package:antizero_jumpin/handler/plan.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/models/plan.dart';
import 'package:antizero_jumpin/provider/plan.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/screens/home/plans/plan_chat.dart';
import 'package:antizero_jumpin/services/plan.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class PlanChatHeader extends StatefulWidget {
  final Plan plan;
  final Function timeFunc;

  const PlanChatHeader({Key key, this.plan, this.timeFunc}) : super(key: key);

  @override
  _PlanChatHeaderState createState() => _PlanChatHeaderState();
}

class _PlanChatHeaderState extends State<PlanChatHeader> {
  bool loading = true;
  JumpInUser host;
  int count = 0;

  @override
  void initState() {
    getHost();
    // deleteChats();
    // TODO: implement initState
    super.initState();
  }

  // deleteChats() async
  // {
  //   await locator.get<PlanService>().fetchAllPlansId();
  // }

  getHost() async
  {
    if (widget.plan != null) {
      JumpInUser _user = await locator.get<UserService>().getUserById(widget.plan.host);
      if (_user != null) {
        host = _user;
      }
    }
    if (mounted)
      setState(() {
        loading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    var planProvider = Provider.of<PlanProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    print('Plan Count ${widget.plan.chatActivity[userProvider
        .currentUser
        .id]["unseenCount"].toString()}');
    return widget.plan == null
            ? Container()
            : InkWell(
                onTap: () async {
                  planProvider.currentPlanHost = host;
                  planProvider.currentPlan = widget.plan;
                  await Navigator.of(context).push(PageTransition(
                      child: PlanChatPage(), type: PageTransitionType.fade));
                  // setOnlineOfflineStatusOfPlanMember(context, false);
                },
                child: Ink(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 27,
                        backgroundColor: Colors.white,
                        backgroundImage: widget.plan.planImg[0] == null
                            ? AssetImage(avatarIcon)
                            : CachedNetworkImageProvider(
                                widget.plan.planImg[0],
                              ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Text(
                                    widget.plan.planName ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: sFui,
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 4.2,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    widget.timeFunc(widget.plan.recentMsg.time),
                                    style: bodyStyle(
                                      context: context,
                                      size: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          widget.plan.recentMsg.sender.isEmpty
                                              ? 'Start a new conversation'
                                              : widget.plan.recentMsg.recentMsg,
                                          overflow: TextOverflow.ellipsis,
                                          style: bodyStyle(
                                            context: context,
                                            size: 14,
                                            fontWeight: widget.plan.chatActivity[
                                            userProvider.currentUser.id] !=
                                                null &&
                                                widget.plan.chatActivity[userProvider
                                                    .currentUser
                                                    .id]["unseenCount"] !=
                                                    0
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                      (widget.plan.chatActivity[
                                      userProvider.currentUser.id] !=
                                          null &&
                                          widget.plan.chatActivity[userProvider
                                              .currentUser
                                              .id]["unseenCount"] !=
                                              0) ? Container(
                                        alignment: Alignment.centerRight,
                                        height:20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            border: Border.all(
                                              color: Colors.blue,
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(20))
                                        ),
                                        child: Center(
                                          child: Text(widget.plan.chatActivity[userProvider
                                              .currentUser
                                              .id]["unseenCount"].toString(),
                                              style: bodyStyle(
                                                  context: context,
                                                  size: 14,
                                                  color: Colors.white)),
                                        ),
                                      ) : Container(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
  }

}
