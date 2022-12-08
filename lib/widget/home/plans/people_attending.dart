// import 'package:antizero_jumpin/handler/local.dart';
// import 'package:antizero_jumpin/handler/plan.dart';
// import 'package:antizero_jumpin/handler/user.dart';
// import 'package:antizero_jumpin/models/jumpin_user.dart';
// import 'package:antizero_jumpin/provider/plan.dart';
// import 'package:antizero_jumpin/screens/home/jumpInuser_profile.dart';
// import 'package:antizero_jumpin/utils/colors.dart';
// import 'package:antizero_jumpin/utils/image_strings.dart';
// import 'package:antizero_jumpin/utils/size_config.dart';
// import 'package:antizero_jumpin/utils/textStyle.dart';
// import 'package:antizero_jumpin/widget/common/fade_animation.dart';
// import 'package:antizero_jumpin/widget/home/plans/mutual_friends_indicator.dart';
// import 'package:flutter/material.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:provider/provider.dart';
//
// class PeopleAttendingCard extends StatelessWidget {
//
//   List<JumpInUser> users;
//
//   PeopleAttendingCard({Key key,this.users})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     print('users: $users');
//     List<String> uIds = getUserConnections(context);
//     return Column(
//       children: <Widget>[
//         if (users.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 15, vertical: 20),
//               child: Container(
//                 height: 50,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: Colors.blue[100],
//                 ),
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: users.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 15, vertical: 10),
//                       child: Card(
//                         color: Colors.white,
//                         shadowColor:
//                         Colors.blueGrey.withOpacity(0.2),
//                         elevation: 5,
//                         shape: RoundedRectangleBorder(
//                             borderRadius:
//                             BorderRadius.circular(10)),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 5, vertical: 3),
//                           child: ListTile(
//                             onTap: () async {
//                               Navigator.of(context).push(
//                                   PageTransition(
//                                       child: JumpInUserPage(
//                                         user: users[index],
//                                         withoutProvider: true,
//                                       ),
//                                       type: PageTransitionType
//                                           .fade));
//                             },
//                             dense: true,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius:
//                                 BorderRadius.circular(10)),
//                             leading: CircleAvatar(
//                               radius: 25,
//                               backgroundColor: Colors.blue[100],
//                               child: CircleAvatar(
//                                 radius: 22,
//                                 backgroundImage: users[index]
//                                     .photoList[0] ==
//                                     null
//                                     ? AssetImage(avatarIcon)
//                                     : NetworkImage(users[index]
//                                     .photoList[0]),
//                               ),
//                             ),
//                             title: Text(
//                               uIds.contains(users[index].id)
//                                   ? users[index].name
//                                   : '@ ${users[index].username}',
//                               // users[index].username ?? '',
//                               style: bodyStyle(
//                                   context: context,
//                                   size: 18,
//                                   color: Colors.black54),
//                             ),
//                             trailing: MutualFriendIndicator(
//                               user: users[index],
//                               id: users[index].id,
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             )
//       ],
//     );
//   }
// }
