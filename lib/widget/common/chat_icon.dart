import 'dart:async';

import 'package:antizero_jumpin/handler/chat.dart';
import 'package:antizero_jumpin/handler/plan.dart';
import 'package:antizero_jumpin/models/friend_request.dart';
import 'package:antizero_jumpin/models/plan.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/screens/chat/all_chat.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class ChatIcon extends StatefulWidget {
  final String count;
  const ChatIcon({Key key, this.count}) : super(key: key);

  @override
  State<ChatIcon> createState() => _ChatIconState();
}

class _ChatIconState extends State<ChatIcon> {
  StreamController userChatsController;
  StreamController planChatsController;

  @override
  void initState() {
    userChatsController = BehaviorSubject();
    planChatsController = BehaviorSubject();
    if (!userChatsController.isClosed) {
      userChatsController.sink.addStream(fetchUserChatStream(context));
    }
    if (!planChatsController.isClosed) {
      planChatsController.sink.addStream(fetchPlanChatStream(context));
    }
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await userChatsController.stream.drain();
    await planChatsController.stream.drain();
    userChatsController.close();
    planChatsController.close();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(PageTransition(
            child: AllChatPage(
              userChatsController: userChatsController,
              planChatsController: planChatsController,
            ),
            type: PageTransitionType.fade));
      },
      child: Stack(
        children: [
          Container(
            height: SizeConfig.blockSizeHorizontal * 10,
            width: SizeConfig.blockSizeHorizontal * 10,
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.all(6),
            child: FaIcon(
              FontAwesomeIcons.solidComment,
              size: 26,
              color: Colors.black,
            ),
          ),
          StreamBuilder(
              stream: userChatsController.stream,
              builder: (context, snapshot1) {
                if (snapshot1.hasData) {
                  return StreamBuilder(
                    stream: planChatsController.stream,
                    builder: (context, snapshot2) {
                      List<FriendRequest> chatsList = [];
                      List<Plan> acceptedPlans = [];
                      final userProvider =
                          Provider.of<UserProvider>(context, listen: false);
                      if (snapshot1.hasData && snapshot2.hasData) {
                        int totalCount = 0;
                        snapshot1.data.docs.forEach((element) {
                          chatsList.add(FriendRequest.fromJson(element.data()));
                        });
                        snapshot2.data.docs.forEach((element) {
                          acceptedPlans.add(Plan.fromJson(element.data()));
                        });
                        chatsList.forEach((friend) {
                          if (friend.unseenMsgCount != null &&
                              friend.recentMsg.sender !=
                                  userProvider.currentUser.id)
                            totalCount += friend.unseenMsgCount;
                        });
                        acceptedPlans.forEach((plan) {
                          if (plan.chatActivity != null) {
                            totalCount += plan.chatActivity != null
                                ? plan.chatActivity[
                                            userProvider.currentUser.id] !=
                                        null
                                    ? plan.chatActivity[userProvider
                                        .currentUser.id]["unseenCount"]
                                    : 0
                                : 0;
                          }
                        });
                        return Positioned(
                          right: SizeConfig.blockSizeHorizontal * 1.5,
                          top: 6,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text(totalCount.toString(),
                                  style: bodyStyle(
                                      context: context,
                                      size: 13,
                                      color: Colors.white)),
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  );
                }
                return Container();
              })
        ],
      ),
    );
  }
}
