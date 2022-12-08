import 'package:antizero_jumpin/handler/chat.dart';
import 'package:antizero_jumpin/models/friend_request.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/screens/home/chat/chat.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/utils/locator.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ChatHeader extends StatefulWidget {
  final FriendRequest people;
  final Function timeFunc;

  const ChatHeader({Key key, this.people, this.timeFunc}) : super(key: key);

  @override
  _ChatHeaderState createState() => _ChatHeaderState();
}

class _ChatHeaderState extends State<ChatHeader> {
  bool loading = true;
  JumpInUser user;
  int count = 0;

  @override
  void initState() {
   getUser();
    super.initState();
  }

  getUser() async {
    JumpInUser _user = await getUserFromPeople(context, widget.people);
    if (_user != null) {
      user = _user;
      print('user ${user.id}');
    }
    if (mounted)
      setState(() {
        loading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? fadedCircle(32, 32, color: Colors.blue[100])
        : widget.people.requestedBy == null
            ? Container()
            : peopleview();
  }

  Widget peopleview() {
    // getUser();
    calculateCount();
    var userProvider = Provider.of<UserProvider>(context);
    return InkWell(
      onTap: () async
      {
            JumpInUser _user = await getUserFromPeople(context, widget.people);
            if (_user != null) {
                user = _user;
                // print('user ${user.id}');
            }
            userProvider.chatWithUser = user;
            // print('sending to ${user.name}');
            userProvider.currentPeopleGroup = widget.people;
            await Navigator.of(context).push(PageTransition(child: ChatPage(), type: PageTransitionType.fade));
        //userServ.updateOnlineOfflineStatusUser(context, false);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                border: Border.all(color: blueborder),
                  boxShadow: [
                    BoxShadow(
                      color: blueborder.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Ink(
                width: MediaQuery.of(context).size.width - 30,
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    widget.people.recentMsg.sender == userProvider.currentUser.id ?
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      backgroundImage: widget.people.senderImg == null
                          ? AssetImage(avatarIcon)
                          : CachedNetworkImageProvider(
                        widget.people.senderImg,
                      ),
                    ):
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      backgroundImage: widget.people.requestedByImg == null
                          ? AssetImage(avatarIcon)
                          : CachedNetworkImageProvider(
                        widget.people.requestedByImg,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: widget.people.recentMsg.sender == userProvider.currentUser.id ?
                                    Text(
                                      widget.people.senderName == null ? '' : widget.people.senderName,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: false,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: sFui,
                                        fontSize: SizeConfig.blockSizeHorizontal * 4.2,
                                      ),
                                    ) :
                                    Text(
                                      widget.people.requestedByName == null ? '' : widget.people.requestedByName,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: false,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: sFui,
                                        fontSize: SizeConfig.blockSizeHorizontal * 4.2,
                                      ),
                                    )
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      child: Text(
                                        widget.timeFunc(widget.people.recentMsg.time),
                                        maxLines: 1,
                                        textAlign: TextAlign.right,
                                        style: bodyStyle(
                                          context: context,
                                          size: 12,
                                          color: Colors.black54,
                                          fontWeight: widget.people.recentMsg.sender !=
                                              userProvider.currentUser.id && count > 0
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
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
                                          widget.people.recentMsg.sender == ''
                                              ? 'Start a new conversation'
                                              : '${widget.people.recentMsg.sender == userProvider.currentUser.id ? 'You: ' : ''}'
                                                  '${widget.people.recentMsg.recentMsg}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: bodyStyle(
                                            context: context,
                                            size: 14,
                                            fontWeight: widget.people.recentMsg.sender !=
                                                        userProvider.currentUser.id &&
                                                        count > 0
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      (widget.people.recentMsg.sender !=
                                          userProvider.currentUser.id && widget.people.unseenMsgCount!=null && widget.people.unseenMsgCount>0) ? Container(
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
                                          child: Text(widget.people.unseenMsgCount.toString(),
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void calculateCount()
  {
    print('widget.people.unseenMsgCount ${widget.people.unseenMsgCount}');
    // print('widget.people.requestedToMsgCount ${widget.people.requestedToMsgCount}');
    if(widget.people.unseenMsgCount!=null)
    {
      count = widget.people.unseenMsgCount;
      // if(widget.people.requestedToMsgCount!=null && widget.people.requestedToMsgCount>0)
      // {
      //   count = widget.people.unseenMsgCount - widget.people.requestedToMsgCount;
      // }
    }
  }
}
