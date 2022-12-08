// import 'package:antizero_jumpin/handler/chat.dart';
// import 'package:antizero_jumpin/models/friend_request.dart';
// import 'package:antizero_jumpin/models/jumpin_user.dart';
// import 'package:antizero_jumpin/provider/user.dart';
// import 'package:antizero_jumpin/screens/home/chat/chat.dart';
// import 'package:antizero_jumpin/utils/image_strings.dart';
// import 'package:antizero_jumpin/utils/loader.dart';
// import 'package:antizero_jumpin/utils/locator.dart';
// import 'package:antizero_jumpin/utils/size_config.dart';
// import 'package:antizero_jumpin/utils/textStyle.dart';
// import 'package:flutter/material.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:provider/provider.dart';
//
// class ChatBox extends StatefulWidget {
//   final FriendRequest people;
//   final Function timeFunc;
//   const ChatBox({Key key, this.people, this.timeFunc}) : super(key: key);
//
//   @override
//   _ChatBoxState createState() => _ChatBoxState();
// }
//
// class _ChatBoxState extends State<ChatBox> {
//   bool loading = true;
//   JumpInUser user;
//
//   @override
//   void initState() {
//     getUser();
//     super.initState();
//   }
//
//   getUser() async {
//     JumpInUser _user = await getUserFromPeople(context, widget.people);
//     if (_user != null) {
//       user = _user;
//     }
//     if (mounted)
//       setState(() {
//         loading = false;
//       });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var userProvider = Provider.of<UserProvider>(context);
//     return loading
//         ? fadedCircle(32, 32, color: Colors.blue[100])
//         : user == null
//             ? Container()
//             : Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       border: Border.all(color: Colors.black54),
//                       borderRadius: BorderRadius.circular(12)),
//                   child: InkWell(
//                       onTap: () async {
//                         userProvider.chatWithUser = user;
//                         userProvider.currentPeopleGroup = widget.people;
//                         await Navigator.of(context).push(PageTransition(
//                             child: ChatPage(), type: PageTransitionType.fade));
//                        // userServ.updateOnlineOfflineStatusUser(context, false);
//                       },
//                       child: Column(
//                         children: [
//                           Expanded(
//                               flex: 4,
//                               child: Align(
//                                 alignment: Alignment.center,
//                                 child: Stack(
//                                   children: [
//                                     CircleAvatar(
//                                       radius: 40,
//                                       backgroundColor: Colors.blue[100],
//                                       child: CircleAvatar(
//                                         radius: 38,
//                                         backgroundColor: Colors.white,
//                                         backgroundImage: user.photoList[0] ==
//                                                 null
//                                             ? AssetImage(avatarIcon)
//                                             : NetworkImage(user.photoList[0]),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       top: 0,
//                                       right: 0,
//                                       child: Container(
//                                         padding: EdgeInsets.all(7),
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color: Colors.blue,
//                                         ),
//                                         child: Text(
//                                           "${widget.people.recentMsg.sender != userProvider.currentUser.id ? widget.people.unseenMsgCount ?? 0 : 0}",
//                                           style: bodyStyle(
//                                               context: context,
//                                               size: 14,
//                                               color: Colors.white),
//                                         ),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               )),
//                           Expanded(
//                               flex: 2,
//                               child: Center(
//                                 child: Text(
//                                   user.name ?? '',
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: sFui,
//                                       fontSize:
//                                           SizeConfig.blockSizeHorizontal * 4.5),
//                                 ),
//                               )),
//                           Container(
//                             width: MediaQuery.of(context).size.width / 2.5,
//                             decoration: BoxDecoration(
//                                 color: Colors.blue[100],
//                                 borderRadius: BorderRadius.circular(15)),
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 widget.people.recentMsg.sender == ''
//                                     ? 'Start a new conversation'
//                                     : widget.people.recentMsg.recentMsg ?? '',
//                                 overflow: TextOverflow.ellipsis,
//                                 style: bodyStyle(
//                                     context: context,
//                                     size: 14,
//                                     fontWeight: widget
//                                                     .people.recentMsg.sender !=
//                                                 userProvider.currentUser.id &&
//                                             widget.people.unseenMsgCount !=
//                                                 null &&
//                                             widget.people.unseenMsgCount != 0
//                                         ? FontWeight.bold
//                                         : FontWeight.normal,
//                                     color: Colors.black54),
//                               ),
//                             ),
//                           ),
//                           Container(
//                             alignment: Alignment.centerRight,
//                             padding: const EdgeInsets.all(3),
//                             child: Padding(
//                               padding: const EdgeInsets.only(right: 10),
//                               child: Text(
//                                 widget.timeFunc(widget.people.recentMsg.time),
//                                 style: bodyStyle(
//                                     context: context,
//                                     size: 12,
//                                     color: Colors.black54),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           )
//                         ],
//                       )),
//                 ),
//               );
//   }
// }
