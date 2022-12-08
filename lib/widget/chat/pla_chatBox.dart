// import 'package:antizero_jumpin/handler/plan.dart';
// import 'package:antizero_jumpin/main.dart';
// import 'package:antizero_jumpin/models/jumpin_user.dart';
// import 'package:antizero_jumpin/models/plan.dart';
// import 'package:antizero_jumpin/provider/plan.dart';
// import 'package:antizero_jumpin/provider/user.dart';
// import 'package:antizero_jumpin/screens/home/plans/plan_chat.dart';
// import 'package:antizero_jumpin/services/user.dart';
// import 'package:antizero_jumpin/utils/image_strings.dart';
// import 'package:antizero_jumpin/utils/loader.dart';
// import 'package:antizero_jumpin/utils/size_config.dart';
// import 'package:antizero_jumpin/utils/textStyle.dart';
// import 'package:flutter/material.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:provider/provider.dart';
//
// class PlanChatBox extends StatefulWidget {
//   final Plan plan;
//   final timeFunc;
//   const PlanChatBox({Key key, this.plan, this.timeFunc}) : super(key: key);
//
//   @override
//   _PlanChatBoxState createState() => _PlanChatBoxState();
// }
//
// class _PlanChatBoxState extends State<PlanChatBox> {
//   bool loading = true;
//   JumpInUser host;
//
//   @override
//   void initState() {
//     getHost();
//     super.initState();
//   }
//
//   getHost() async {
//     if (widget.plan != null) {
//       JumpInUser _user =
//           await locator.get<UserService>().getUserById(widget.plan.host);
//       if (_user != null) {
//         host = _user;
//       }
//     }
//     if (mounted)
//       setState(() {
//         loading = false;
//       });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var planProvider = Provider.of<PlanProvider>(context);
//     final userProvider = Provider.of<UserProvider>(context);
//
//     return loading == true || host == null
//         ? fadedCircle(32, 32, color: Colors.blue[100])
//         : widget.plan == null
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
//                         planProvider.currentPlanHost = host;
//                         planProvider.currentPlan = widget.plan;
//                         await Navigator.of(context).push(PageTransition(
//                             child: PlanChatPage(),
//                             type: PageTransitionType.fade));
//                         //setOnlineOfflineStatusOfPlanMember(context, false);
//                       },
//                       child: Column(
//                         children: [
//                           Expanded(
//                             flex: 4,
//                             child: Align(
//                               alignment: Alignment.center,
//                               child: Stack(
//                                 children: [
//                                   CircleAvatar(
//                                     radius: 40,
//                                     backgroundColor: Colors.blue[100],
//                                     child: CircleAvatar(
//                                       radius: 38,
//                                       backgroundColor: Colors.white,
//                                       backgroundImage:
//                                           widget.plan.planImg[0] == null
//                                               ? AssetImage(avatarIcon)
//                                               : NetworkImage(
//                                                   widget.plan.planImg[0]),
//                                     ),
//                                   ),
//                                   Positioned(
//                                     top: 0,
//                                     right: 0,
//                                     child: Container(
//                                       padding: EdgeInsets.all(7),
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: Colors.blue,
//                                       ),
//                                       child: Text(
//                                         "${widget.plan.chatActivity != null ? widget.plan.chatActivity[userProvider.currentUser.id] != null ? widget.plan.chatActivity[userProvider.currentUser.id]["unseenCount"] : 0 : 0}",
//                                         style: bodyStyle(
//                                             context: context,
//                                             size: 14,
//                                             color: Colors.white),
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                               flex: 2,
//                               child: Center(
//                                 child: Text(
//                                   widget.plan.planName ?? '',
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
//                                 widget.plan.recentMsg.sender == ''
//                                     ? 'Start a new conversation'
//                                     : widget.plan.recentMsg.recentMsg ?? '',
//                                 overflow: TextOverflow.ellipsis,
//                                 style: bodyStyle(
//                                     context: context,
//                                     size: 14,
//                                     fontWeight: widget.plan.chatActivity[
//                                                     userProvider.currentUser
//                                                         .id]["unseenCount"] !=
//                                                 null &&
//                                             widget.plan.chatActivity[
//                                                     userProvider.currentUser
//                                                         .id]["unseenCount"] !=
//                                                 0
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
//                                 widget.timeFunc(widget.plan.recentMsg.time),
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
