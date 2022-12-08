// import 'dart:typed_data';
//
// import 'package:antizero_jumpin/handler/home.dart';
// import 'package:antizero_jumpin/handler/recommend.dart';
// import 'package:antizero_jumpin/handler/toast.dart';
// import 'package:antizero_jumpin/main.dart';
// import 'package:antizero_jumpin/models/jumpin_user.dart';
// import 'package:antizero_jumpin/models/sub_category.dart';
// import 'package:antizero_jumpin/provider/jumpin.dart';
// import 'package:antizero_jumpin/provider/user.dart';
// import 'package:antizero_jumpin/screens/home/jumpInuser_profile.dart';
// import 'package:antizero_jumpin/services/analytics.dart';
// import 'package:antizero_jumpin/services/user.dart';
// import 'package:antizero_jumpin/utils/colors.dart';
// import 'package:antizero_jumpin/utils/image_strings.dart';
// import 'package:antizero_jumpin/utils/loader.dart';
// import 'package:antizero_jumpin/widget/common/no_content.dart';
// import 'package:antizero_jumpin/widget/home/age_card.dart';
// import 'package:antizero_jumpin/widget/home/card_buttons.dart';
// import 'package:antizero_jumpin/widget/home/image_card.dart';
// import 'package:antizero_jumpin/widget/home/interest_card.dart';
// import 'package:antizero_jumpin/widget/home/jumpin_btn.dart';
// import 'package:antizero_jumpin/widget/home/location_card.dart';
// import 'package:antizero_jumpin/widget/home/mutual_friend.dart';
// import 'package:antizero_jumpin/widget/home/people_card.dart';
// import 'package:antizero_jumpin/widget/home/username_card.dart';
// import 'package:antizero_jumpin/widget/home/vibe_card.dart';
// import 'package:antizero_jumpin/widget/home/widget_toImg.dart';
// import 'package:antizero_jumpin/widget/home/work_card.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:provider/provider.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// Analytics analytics = locator<Analytics>();
//
// class People extends StatefulWidget {
//   final TextEditingController searchController;
//   People({this.searchController});
//
//   @override
//   _PeopleState createState() => _PeopleState();
// }
//
// class _PeopleState extends State<People> {
//   ScreenshotController screenshotController = ScreenshotController();
//   ScrollController _scrollController = ScrollController();
//   bool isExpanded;
//
//   @override
//   void initState() {
//     super.initState();
//     isExpanded = true;
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       print('people initState');
//       var userProvider = Provider.of<UserProvider>(context, listen: false);
//       userProvider.setDefaults();
//       await userProvider.getUserCityAndState();
//       if (userProvider.filtersEnabled) {
//         userProvider.fetchFilteredUsers(context);
//       } else {
//         userProvider.fetchUsers(context);
//       }
//       _scrollController.addListener(() {
//         double maxScroll = _scrollController.position.maxScrollExtent;
//         double currentScroll = _scrollController.position.pixels;
//         double delta = MediaQuery.of(context).size.height * 0.20;
//         if (maxScroll - currentScroll <= delta) {
//           print('Scroll Filters Enabled ${userProvider.filtersEnabled}');
//           if (userProvider.filtersEnabled) {
//             userProvider.fetchFilteredUsers(context);
//           } else {
//             userProvider.fetchUsers(context);
//           }
//         }
//       });
//     });
//     FirebaseAnalytics.instance.logScreenView(
//       screenName: 'People Tab',
//       screenClass: 'Home',
//     );
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   launchURLForFeedback() async {
//     const url =
//         'https://docs.google.com/forms/d/1dQKchHLcrFLuySKxHN_PCSlgckkL3GampptTSPjbTPY/viewform?edit_requested=true';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//   double _width = 230;
//   double _height = 40;
//
//   @override
//   Widget build(BuildContext context) {
//     var userProvider = Provider.of<UserProvider>(context);
//     var size = MediaQuery.of(context).size;
//     print('Filters Enabled');
//     print(userProvider.filtersEnabled);
//     print(userProvider.usersList);
//     return userProvider.isFirstListLoading
//         ? spinKit
//         : userProvider.noUsers == true
//             ? SingleChildScrollView(
//                 child: NoContentImage(
//                   text: 'No users found!',
//                   refreshText: 'Click here to refresh',
//                   onRefresh: () async {
//                     widget.searchController.text = "";
//                     userProvider.setDefaults();
//                     await userProvider.fetchUsers(context);
//                   },
//                 ),
//               )
//             : Screenshot(
//                 controller: screenshotController,
//                 child: SingleChildScrollView(
//                   physics: BouncingScrollPhysics(),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: 10,
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           isExpanded = !isExpanded;
//                           if (isExpanded) {
//                             setState(() {
//                               _width = 230;
//                               //print(this.isExpanded);
//                             });
//                           } else {
//                             setState(() {
//                               _width = 40;
//                               // print(_width);
//                             });
//                           }
//                         },
//                         child: AnimatedContainer(
//                           decoration: BoxDecoration(
//                             color: bluelite,
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           width: _width,
//                           height: _height,
//                           child: this.isExpanded
//                               ? Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: InkWell(
//                                         onTap: () {
//                                           launchURLForFeedback();
//                                         },
//                                         child: Text(
//                                           'Submit your feedback',
//                                           style: TextStyle(
//                                             decoration:
//                                                 TextDecoration.underline,
//                                             color: Colors.blue,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Icon(Icons.arrow_back)
//                                   ],
//                                 )
//                               : Icon(Icons.arrow_forward),
//                           duration: Duration(milliseconds: 300),
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Container(
//                               height: size.height - (size.height / 2.5),
//                               child: userProvider.usersList.length == 0
//                                   ? NoContentImage(
//                                       text: 'Please Wait ...\nLoading...',
//                                       refreshText: 'Click here to refresh',
//                                       onRefresh: () async {
//                                         widget.searchController.text = "";
//                                         userProvider.setDefaults();
//                                         await userProvider.fetchUsers(context);
//                                       },
//                                     )
//                                   : ListView.builder(
//                                       controller: _scrollController,
//                                       physics: BouncingScrollPhysics(),
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: userProvider.usersList.length,
//                                       itemBuilder: (context, index) {
//                                         JumpInUser user =
//                                             userProvider.usersList[index];
//                                         if (user.id ==
//                                             userProvider.currentUser.id) {
//                                           return Container();
//                                         } else {
//                                           GlobalKey keyK;
//                                           Uint8List bytes;
//                                           return userProvider.currentUser
//                                                           .connection !=
//                                                       null &&
//                                                   userProvider
//                                                       .currentUser.connection
//                                                       .contains(user.id)
//                                               ? Container()
//                                               : WidgetToImage(
//                                                   builder: (key) {
//                                                     keyK = key;
//                                                     return ChangeNotifierProvider<
//                                                         JumpInButtonProvider>(
//                                                       create: (context) =>
//                                                           JumpInButtonProvider(
//                                                               context, user.id),
//                                                       builder:
//                                                           (context, child) =>
//                                                               HomeCard(
//                                                         userId: user.id,
//                                                         onUserTap: () async {
//                                                           FocusScope.of(context)
//                                                               .requestFocus(
//                                                                   new FocusNode());
//                                                           var jumpinButtonProv =
//                                                               Provider.of<
//                                                                       JumpInButtonProvider>(
//                                                                   context,
//                                                                   listen:
//                                                                       false);
//                                                           await Navigator.of(
//                                                                   context)
//                                                               .push(
//                                                                   MaterialPageRoute(
//                                                             builder: (context) =>
//                                                                 ChangeNotifierProvider<
//                                                                     JumpInButtonProvider>.value(
//                                                               value:
//                                                                   jumpinButtonProv,
//                                                               child:
//                                                                   JumpInUserPage(
//                                                                 user: user,
//                                                                 withoutProvider:
//                                                                     false,
//                                                               ),
//                                                             ),
//                                                           ));
//                                                         },
//                                                         userName: UserCard(
//                                                           name: user.username,
//                                                         ),
//                                                         location: LocationCard(
//                                                           currentUserGeo:
//                                                               userProvider
//                                                                   .currentUser
//                                                                   .geoPoint,
//                                                           anotherUserGeo:
//                                                               user.geoPoint,
//                                                         ),
//                                                         // vibe: VibeCard(
//                                                         //   userToCompare: user,
//                                                         // ),
//                                                         upperLeft: AgeCard(
//                                                           dob: user.dob,
//                                                           gender: user.gender,
//                                                         ),
//                                                         upperRight: WorkCard(
//                                                           workOrStudy: user
//                                                                           .placeOfEdu ==
//                                                                       null &&
//                                                                   user.placeOfWork ==
//                                                                       null
//                                                               ? 'N/A'
//                                                               : user.placeOfEdu ==
//                                                                       null
//                                                                   ? user
//                                                                       .placeOfWork
//                                                                   : user
//                                                                       .placeOfEdu,
//                                                           isStudying:
//                                                               user.placeOfWork ==
//                                                                   null,
//                                                         ),
//                                                         lowerRight: FutureBuilder<
//                                                                 List<
//                                                                     SubCategory>>(
//                                                             future: getFirstTwoInterest(
//                                                                 user
//                                                                     .interestList),
//                                                             builder: (context,
//                                                                 snapshot) {
//                                                               return InterestCard(
//                                                                 interest: snapshot
//                                                                         .hasData
//                                                                     ? snapshot
//                                                                             .data[
//                                                                                 0]
//                                                                             .name +
//                                                                         '\n' +
//                                                                         snapshot
//                                                                             .data[1]
//                                                                             .name
//                                                                     : 'N/A',
//                                                               );
//                                                             }),
//                                                         lowerLeft:
//                                                             MutualFriendCard(
//                                                           id: user.id,
//                                                           user: user,
//                                                         ),
//                                                         centerImage: ImageCard(
//                                                           photoUrl:
//                                                               user.photoList.last,
//                                                         ),
//                                                         jumpInButton:
//                                                             JumpInButton(
//                                                           icon: logoIcon,
//                                                           label: 'JumpIn',
//                                                           id: user.id,
//                                                         ),
//                                                         recommendButton:
//                                                             CardButton(
//                                                           color:
//                                                               Colors.grey[50],
//                                                           textColor:
//                                                               Colors.black54,
//                                                           onPress: () async {
//                                                             bytes =
//                                                                 await capture(
//                                                                     keyK);
//                                                             bool success =
//                                                                 await takeScreenShot(
//                                                                     bytes,
//                                                                     context,
//                                                                     user.id);
//                                                             if (success) {
//                                                               await recommend(
//                                                                   context,
//                                                                   user.username,
//                                                                   user.id);
//                                                               analytics
//                                                                   .logCustomEvent(
//                                                                       eventName:
//                                                                           'peopleRecommend',
//                                                                       params: {
//                                                                     'recommendedBy': FirebaseAuth
//                                                                         .instance
//                                                                         .currentUser
//                                                                         .uid,
//                                                                     'userId':
//                                                                         user.id,
//                                                                   });
//                                                             } else {
//                                                               showToast(
//                                                                   'Error caught!');
//                                                             }
//                                                           },
//                                                           label: 'Recommend',
//                                                           icon: referIcon,
//                                                         ),
//                                                       ),
//                                                     );
//                                                   },
//                                                 );
//                                         }
//                                       },
//                                     ),
//                             ),
//                           ),
//                           userProvider.isNextListLoading ? spinKit : Container()
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//   }
// }
