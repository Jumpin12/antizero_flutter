import 'package:antizero_jumpin/handler/chat.dart';
import 'package:antizero_jumpin/handler/user.dart';
import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/provider/plan.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/widget/chat/msg_tile.dart';
import 'package:antizero_jumpin/widget/common/fade_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ChatMessages extends StatefulWidget {
  final Stream<QuerySnapshot> chats;
  final bool people;
  const ChatMessages({Key key, this.chats, @required this.people})
      : super(key: key);

  @override
  _ChatMessagesState createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  AutoScrollController _scrollController = AutoScrollController();

  @override
  void initState() {
    _scrollController = AutoScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    var planProvider = Provider.of<PlanProvider>(context);

    return StreamBuilder<QuerySnapshot>(
      stream: widget.chats,
      builder: (context, snapshot) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            if (userProvider.unseenMsgCount != 0)
              _scrollController.scrollToIndex(
                snapshot.data.docs.length - userProvider.unseenMsgCount,
                preferPosition: AutoScrollPosition.end,
                duration: Duration(milliseconds: 500),
              );
            else
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
          }
        });
        return snapshot.hasData
            ? Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.top),
                child: ListView.builder(
                    // shrinkWrap: true,
                    reverse: false,
                    controller: _scrollController,
                    itemCount: snapshot.data.docs.length,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    itemBuilder: (context, index)
                    {
                      // String user;
                      bool sendByMe = userProvider.currentUser.id ==
                          snapshot.data.docs[index]["senderId"];
                      // if (widget.people == false &&
                      //     planProvider.currentPlan.member.contains(
                      //         snapshot.data.docs[index]["senderId"])) {
                      //   user = planProvider.currentPlanUsers.firstWhere(
                      //       (element) =>
                      //           element ==
                      //               snapshot.data.docs[index][""] ??
                      //           '');
                      // }
                      if (widget.people) {
                        return AutoScrollTag(
                          key: ValueKey(index),
                          controller: _scrollController,
                          index: index,
                          child: Column(
                            children: [
                              if (userProvider.currentUser.id !=
                                      userProvider.currentPeopleGroup.recentMsg
                                          .sender &&
                                  userProvider
                                          .currentPeopleGroup.unseenMsgCount !=
                                      null &&
                                  userProvider.unseenMsgCount != 0 &&
                                  index ==
                                      snapshot.data.docs.length -
                                          userProvider.unseenMsgCount)
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              0.01),
                                  color: Colors.black12,
                                  alignment: Alignment.center,
                                  child: Text("Unseen Messages"),
                                ),
                              MessageTile(
                                  message: snapshot.data.docs[index]["message"]
                                      .toString(),
                                  sender: sendByMe
                                      ? userProvider.currentUser.name ??
                                          'JUMPIN USER'
                                      : userProvider.chatWithUser.name ??
                                          'JUMPIN USER',
                                  senderPic: sendByMe
                                      ? userProvider.currentUser.photoList.last ??
                                          ''
                                      : userProvider
                                              .chatWithUser.photoList.last ??
                                          '',
                                  time: DateTime.parse(snapshot.data.docs[index]
                                      ["time"] as String),
                                  imgMsg: snapshot.data.docs[index]["imgMsg"],
                                  sentByMe: sendByMe,
                                  isFromPeople: true),
                            ],
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            MessageTile(
                                message: snapshot.data.docs[index]["message"],
                                sender: sendByMe
                                    ? userProvider.currentUser.name ??
                                        'JUMPIN USER'
                                    : snapshot.data.docs[index]["senderName"] != null
                                        ? snapshot.data.docs[index]["senderName"] ?? 'JUMPIN USER'
                                        : 'JUMPIN USER',
                                senderPic: sendByMe
                                    ? userProvider.currentUser.photoList.last ??
                                        ''
                                    : snapshot.data.docs[index]["senderPhoto"] != null
                                        ? userProvider.currentUser.photoList.last ?? ''
                                        : '',
                                time: DateTime.parse(snapshot.data.docs[index]
                                    ["time"] as String),
                                imgMsg: snapshot.data.docs[index]["imgMsg"],
                                sentByMe: sendByMe,
                                isFromPeople: false),
                          ],
                        );
                      }
                      // return FutureBuilder<JumpInUser>(
                      //     future: getUserDetail(snapshot.data.docs[index]["senderId"]),
                      //     builder: (context, snap) {
                      //       if(snap.hasData) {
                      //         return MessageTile(
                      //           message: snapshot.data.docs[index]["message"],
                      //           sender: snap.data.name ??
                      //               'JumpIn User',
                      //           time: DateTime.parse(snapshot.data.docs[index]["time"] as String),
                      //           senderPic: snap.data.photoList[0] ?? '',
                      //           imgMsg: snapshot.data.docs[index]["imgMsg"],
                      //           sentByMe: userProvider.currentUser.id ==
                      //               snapshot.data.docs[index]["senderId"],
                      //         );
                      //       } else {
                      //         return Container();
                      //       }
                      //     }
                      // );
                    }),
              )
            : Container();
      },
    );
  }
}
