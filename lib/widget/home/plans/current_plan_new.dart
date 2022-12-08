// import 'dart:typed_data';
//
// import 'package:antizero_jumpin/handler/bookmark.dart';
// import 'package:antizero_jumpin/handler/home.dart';
// import 'package:antizero_jumpin/handler/local.dart';
// import 'package:antizero_jumpin/handler/notification.dart';
// import 'package:antizero_jumpin/handler/plan.dart';
// import 'package:antizero_jumpin/handler/recommend.dart';
// import 'package:antizero_jumpin/handler/toast.dart';
// import 'package:antizero_jumpin/handler/user.dart';
// import 'package:antizero_jumpin/main.dart';
// import 'package:antizero_jumpin/models/jumpin_user.dart';
// import 'package:antizero_jumpin/models/member.dart';
// import 'package:antizero_jumpin/provider/plan.dart';
// import 'package:antizero_jumpin/provider/user.dart';
// import 'package:antizero_jumpin/screens/home/jumpInuser_profile.dart';
// import 'package:antizero_jumpin/screens/home/plans/plan_chat.dart';
// import 'package:antizero_jumpin/services/analytics.dart';
// import 'package:antizero_jumpin/services/user.dart';
// import 'package:antizero_jumpin/utils/colors.dart';
// import 'package:antizero_jumpin/utils/image_strings.dart';
// import 'package:antizero_jumpin/utils/loader.dart';
// import 'package:antizero_jumpin/utils/size_config.dart';
// import 'package:antizero_jumpin/utils/textStyle.dart';
// import 'package:antizero_jumpin/widget/common/fade_animation.dart';
// import 'package:antizero_jumpin/widget/home/app_bar.dart';
// import 'package:antizero_jumpin/widget/home/card_buttons.dart';
// import 'package:antizero_jumpin/widget/home/plans/accept_plan.dart';
// import 'package:antizero_jumpin/widget/home/plans/mutual_friends_indicator.dart';
// import 'package:antizero_jumpin/widget/home/widget_toImg.dart';
// import 'package:antizero_jumpin/widget/profile/img_swipper.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:jiffy/jiffy.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
// import 'package:provider/provider.dart';
//
// class CurrentPlanNewPage extends StatefulWidget {
//   final String hostId;
//   const CurrentPlanNewPage({@required this.hostId, Key key}) : super(key: key);
//
//   @override
//   _CurrentPlanNewPageState createState() => _CurrentPlanNewPageState();
// }
//
// class _CurrentPlanNewPageState extends State<CurrentPlanNewPage> {
//   JumpInUser hostPlan;
//   List<JumpInUser> users = [];
//   bool loading = true;
//   bool marked = false;
//   bool setMark = false;
//   int acceptedMembers = 0;
//
//   bool acceptingPlan = false;
//   MemberStatus status;
//
//   GlobalKey keyK;
//   Uint8List bytes;
//
//   @override
//   void initState() {
//     getHost();
//     super.initState();
//   }
//
//   getHost() async {
//     JumpInUser user =
//         await locator.get<UserService>().getUserById(widget.hostId);
//     if (user != null) {
//       hostPlan = user;
//     }
//     if (mounted) {
//       setState(() {
//         loading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print('hostId ${widget.hostId}');
//     var planProvider = Provider.of<PlanProvider>(context);
//     List<String> uIds = getUserConnections(context);
//     var size = MediaQuery.of(context).size;
//     return WidgetToImage(builder: (key) {
//       keyK = key;
//       return loading == true || planProvider.currentPlan == null
//           ? fadedCircle(32, 32, color: Colors.blue[100])
//           : SingleChildScrollView(
//             physics: BouncingScrollPhysics(),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // entry fee & age limit
//                 Padding(
//                   padding: EdgeInsets.only(
//                       left: size.width * 0.04,
//                       right: size.width * 0.04,
//                       top: size.height * 0.06),
//                   child: Container(
//                     width: size.width,
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           width: size.width * 0.458,
//                           padding: EdgeInsets.symmetric(
//                               horizontal: size.width * 0.02),
//                           child: Column(
//                             children: [
//                               Container(
//                                 height: size.height * 0.06,
//                                 child: Image.asset(
//                                   moneyIcon,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.center,
//                                 children: [
//                                   if (planProvider
//                                           .currentPlan.entryFree ==
//                                       true)
//                                     Text(
//                                       "Entry fee : ",
//                                       style: TextStyle(
//                                           color: Colors.black
//                                               .withOpacity(0.6),
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                   Flexible(
//                                     child: Text(
//                                         planProvider.currentPlan
//                                                     .entryFree ==
//                                                 true
//                                             ? '\u{20B9} ${planProvider.currentPlan.fees}'
//                                             : "Free Entry",
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                             color: Colors.black
//                                                 .withOpacity(0.7),
//                                             fontSize: size.height * 0.02,
//                                             fontWeight: FontWeight.w700)),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           width: size.width * 0.458,
//                           child: Column(
//                             children: [
//                               Container(
//                                 width: size.width * 0.06,
//                                 height: size.height * 0.06,
//                                 child: Image.asset(ageIcon),
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.center,
//                                 children: [
//                                   if (planProvider.currentPlan.age ==
//                                       true)
//                                     Text(
//                                       "For people above : ",
//                                       style: TextStyle(
//                                           color: Colors.black
//                                               .withOpacity(0.6),
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                   Flexible(
//                                     child: Text(
//                                         planProvider.currentPlan.age ==
//                                                 true
//                                             ? "${planProvider.currentPlan.ageLimit} Yrs"
//                                             : 'No Age Restriction',
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                             color: Colors.black
//                                                 .withOpacity(0.7),
//                                             fontSize: size.height * 0.02,
//                                             fontWeight: FontWeight.w700)),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // plan description
//                 SizedBox(height: 10),
//                 Align(
//                     alignment: Alignment.centerLeft,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 15),
//                       child: Text(
//                         'People attending this plan',
//                         style: headingStyle(
//                             context: context,
//                             size: 20,
//                             color: Colors.black),
//                       ),
//                     )),
//                 if (users.isNotEmpty)
//                   FadeAnimation(
//                     0.2,
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 15, vertical: 20),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           color: Colors.blue[100],
//                         ),
//                         child: ListView.builder(
//                           shrinkWrap: true,
//                           physics: NeverScrollableScrollPhysics(),
//                           itemCount: users.length,
//                           itemBuilder: (BuildContext context, int index) {
//                             return Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 15, vertical: 10),
//                               child: Card(
//                                 color: Colors.white,
//                                 shadowColor:
//                                     Colors.blueGrey.withOpacity(0.2),
//                                 elevation: 5,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(10)),
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 5, vertical: 3),
//                                   child: ListTile(
//                                     onTap: () async {
//                                       Navigator.of(context).push(
//                                           PageTransition(
//                                               child: JumpInUserPage(
//                                                 user: users[index],
//                                                 withoutProvider: true,
//                                               ),
//                                               type: PageTransitionType
//                                                   .fade));
//                                     },
//                                     dense: true,
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(10)),
//                                     leading: CircleAvatar(
//                                       radius: 25,
//                                       backgroundColor: Colors.blue[100],
//                                       child: CircleAvatar(
//                                         radius: 22,
//                                         backgroundImage: users[index]
//                                                     .photoList[0] ==
//                                                 null
//                                             ? AssetImage(avatarIcon)
//                                             : NetworkImage(users[index]
//                                                 .photoList[0]),
//                                       ),
//                                     ),
//                                     title: Text(
//                                       uIds.contains(users[index].id)
//                                           ? users[index].name
//                                           : '@ ${users[index].username}',
//
//                                       // users[index].username ?? '',
//                                       style: bodyStyle(
//                                           context: context,
//                                           size: 18,
//                                           color: Colors.black54),
//                                     ),
//                                     trailing: MutualFriendIndicator(
//                                       user: users[index],
//                                       id: users[index].id,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           );
//     });
//   }
// }
