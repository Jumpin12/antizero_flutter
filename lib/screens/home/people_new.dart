import 'dart:typed_data';

import 'package:antizero_jumpin/handler/home.dart';
import 'package:antizero_jumpin/handler/recommend.dart';
import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/models/sub_category.dart';
import 'package:antizero_jumpin/provider/jumpin.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/screens/home/jumpInuser_profile.dart';
import 'package:antizero_jumpin/screens/home/people.dart';
import 'package:antizero_jumpin/services/analytics.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/widget/common/no_content.dart';
import 'package:antizero_jumpin/widget/filters/filter_widget.dart';
import 'package:antizero_jumpin/widget/home/MoreInformationCard.dart';
import 'package:antizero_jumpin/widget/home/age_card.dart';
import 'package:antizero_jumpin/widget/home/age_new_card.dart';
import 'package:antizero_jumpin/widget/home/card_buttons.dart';
import 'package:antizero_jumpin/widget/home/card_buttons_new.dart';
import 'package:antizero_jumpin/widget/home/image_card.dart';
import 'package:antizero_jumpin/widget/home/image_card_new.dart';
import 'package:antizero_jumpin/widget/home/image_card_new_people.dart';
import 'package:antizero_jumpin/widget/home/interest_card.dart';
import 'package:antizero_jumpin/widget/home/jumpin_btn.dart';
import 'package:antizero_jumpin/widget/home/location_card.dart';
import 'package:antizero_jumpin/widget/home/mutual_friend.dart';
import 'package:antizero_jumpin/widget/home/people_card.dart';
import 'package:antizero_jumpin/widget/home/people_card_new.dart';
import 'package:antizero_jumpin/widget/home/username_card.dart';
import 'package:antizero_jumpin/widget/home/vibe_card.dart';
import 'package:antizero_jumpin/widget/home/widget_toImg.dart';
import 'package:antizero_jumpin/widget/home/work_card.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';

Analytics analytics = locator<Analytics>();

class PeopleNew extends StatefulWidget {
  final TextEditingController searchController;
  PeopleNew({this.searchController});

  @override
  _PeopleNewState createState() => _PeopleNewState();
}

class _PeopleNewState extends State<PeopleNew> {
  ScreenshotController screenshotController = ScreenshotController();
  ScrollController _scrollController = ScrollController();
  bool isExpanded;

  @override
  void initState() {
    super.initState();
    isExpanded = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print('people initState');
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setDefaults();
      await userProvider.getUserCityAndState();
      print('No scroll Filters Enabled ${userProvider.filtersEnabled}');
      if (userProvider.filtersEnabled)
      {
        userProvider.fetchFilteredUsers(context);
      }
      else
      {
        userProvider.fetchUsers(context);
      }
      _scrollController.addListener(() async {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.position.pixels;
        double delta = MediaQuery.of(context).size.height * 0.20;
        if ((maxScroll - currentScroll <= delta))
        {
          print('Scroll Filters Enabled ${userProvider.filtersEnabled}');
          if (userProvider.filtersEnabled)
          {
            await userProvider.fetchFilteredUsers(context);
          } else {
            await userProvider.fetchUsers(context);
          }
        }
      });
    });
    FirebaseAnalytics.instance.logScreenView(
      screenName: 'People Tab',
      screenClass: 'Home',
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  launchURLForFeedback() async {
    const url =
        'https://docs.google.com/forms/d/1dQKchHLcrFLuySKxHN_PCSlgckkL3GampptTSPjbTPY/viewform?edit_requested=true';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  double _width = 230;
  double _height = 40;

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    var size = MediaQuery.of(context).size;
    print("userProvider.usersList ${userProvider.usersList}");
    return userProvider.isFirstListLoading
        ? spinKit
        : userProvider.noUsers == true
        ? SingleChildScrollView(
      child: NoContentImage(
        text: 'No users found!',
        refreshText: 'Click here to refresh',
        onRefresh: () async {
          widget.searchController.text = "";
          userProvider.setDefaults();
          print("Refreshing");
          await userProvider.fetchUsers(context);
        },
      ),
    )
        : Screenshot(
      controller: screenshotController,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            // GestureDetector(
            //   onTap: () {
            //     isExpanded = !isExpanded;
            //     if (isExpanded) {
            //       setState(() {
            //         _width = 230;
            //         //print(this.isExpanded);
            //       });
            //     } else {
            //       setState(() {
            //         _width = 40;
            //         // print(_width);
            //       });
            //     }
            //   },
            //   child: AnimatedContainer(
            //     decoration: BoxDecoration(
            //       color: bluelite,
            //       borderRadius: BorderRadius.circular(6),
            //     ),
            //     width: _width,
            //     height: _height,
            //     child: this.isExpanded
            //         ? Row(
            //       mainAxisAlignment:
            //       MainAxisAlignment.spaceEvenly,
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: InkWell(
            //             onTap: () {
            //               launchURLForFeedback();
            //             },
            //             child: Text(
            //               'Submit your feedback',
            //               style: TextStyle(
            //                 decoration:
            //                 TextDecoration.underline,
            //                 color: Colors.blue,
            //               ),
            //             ),
            //           ),
            //         ),
            //         Icon(Icons.arrow_back)
            //       ],
            //     )
            //         : Icon(Icons.arrow_forward),
            //     duration: Duration(milliseconds: 300),
            //   ),
            // )
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: size.height - (size.height / 2.75),
                    child: (userProvider.usersList.length == 0) ||
                        ((userProvider.usersList.length == 1) && (userProvider.usersList[0].id == userProvider.currentUser.id))
                        ? NoContentImage(
                      text: 'Please Wait ...\nLoading...',
                      refreshText: 'Click here to refresh',
                      onRefresh: () async {
                        widget.searchController.text = "";
                        userProvider.setDefaults();
                          await userProvider.fetchUsers(context);
                        },
                      )
                        : ListView.builder(
                      controller: _scrollController,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: userProvider.usersList.length,
                      itemBuilder: (context, index) {
                        JumpInUser user = userProvider.usersList[index];
                        int people = user.connection.length;
                        int plans = user.plans.length;
                        // print('print user ${user.favourites}');
                        if (user.id == userProvider.currentUser.id)
                        {
                          return Container();
                        } else {
                          GlobalKey keyK;
                          Uint8List bytes;
                          return (userProvider.currentUser.connection != null)
                              && (userProvider.currentUser.connection.contains(user.id))
                              ? Container()
                              : WidgetToImage(
                            builder: (key) {
                              keyK = key;
                              return ChangeNotifierProvider<JumpInButtonProvider>(
                                create: (context) =>
                                  JumpInButtonProvider(context, user.id),
                                builder: (context, child) =>
                                  HomePeopleNewCard(
                                      favourites: user.favourites,
                                      people:people,
                                      plans:plans,
                                      scrollController: _scrollController,
                                      user: user,
                                      userId: user.id,
                                      audio: user.audio,
                                      onUserTap: () async {
                                        FocusScope.of(context)
                                            .requestFocus(
                                            new FocusNode());
                                        var jumpinButtonProv =
                                        Provider.of<
                                            JumpInButtonProvider>(
                                            context,
                                            listen:
                                            false);
                                        await Navigator.of(
                                            context)
                                            .push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                              ChangeNotifierProvider<
                                                  JumpInButtonProvider>.value(
                                                value:
                                                jumpinButtonProv,
                                                child:
                                                JumpInUserPage(
                                                  user: user,
                                                  withoutProvider:
                                                  false,
                                                ),
                                              ),
                                            ));
                                      },
                                      userName: AgeNameCard(
                                        name: user.username,
                                        dob: user.dob
                                      ),
                                      gender: user.gender,
                                      currentUserGeo: userProvider.currentUser.geoPoint != null ? userProvider.currentUser.geoPoint : null,
                                      anotherUserGeo: user.geoPoint != null ? user.geoPoint : null,
                                      centerImage: ImageCardNewPeople(
                                        photoUrl: user.photoList.last != null ? user.photoList.last  : null,
                                      ),
                                    academic: MoreInformationCard(
                                        icon:  academicIconP,
                                        label: 'Academic',
                                        planDesc: user.academicCourse,
                                        textAlign: Alignment.topLeft,
                                        iconAlign: Alignment.topLeft),
                                    work: MoreInformationCard(
                                        icon:  workIconP,
                                        label: 'Work',
                                        planDesc: user.placeOfWork,
                                        textAlign: Alignment.topLeft,
                                        iconAlign: Alignment.topLeft),
                                    education: MoreInformationCard(
                                        icon: educationIconP,
                                        label: 'Education',
                                        planDesc: user.placeOfEdu,
                                        textAlign: Alignment.topLeft,
                                        iconAlign: Alignment.topLeft),
                                    profession: MoreInformationCard(
                                        icon: workIconP,
                                        label: 'Profession',
                                        planDesc: user.profession,
                                        textAlign: Alignment.topLeft,
                                        iconAlign: Alignment.topLeft),
                                    bio: MoreInformationCard(
                                        icon: bioIconP,
                                        label: 'Bio',
                                        planDesc: user.bio,
                                        textAlign: Alignment.topLeft,
                                        iconAlign: Alignment.topLeft),
                                    injumpinfor: MoreInformationCard(
                                        icon: injumpinForIconP,
                                        label: 'I Am on Jumpin For',
                                        planDesc: user.inJumpInFor,
                                        textAlign: Alignment.topLeft,
                                        iconAlign: Alignment.topLeft),
                                      jumpInButton:
                                      JumpInButton(
                                        icon: jumpInIcon,
                                        label: 'JUMPIN',
                                        id: user.id,
                                      ),
                                      recommendButton:
                                      CardNewButton(
                                        color:
                                        Colors.grey[50],
                                        textColor:bluetextchat,
                                        onPress: () async {
                                          bytes =
                                          await capture(
                                              keyK);
                                          bool success =
                                          await takeScreenShot(
                                              bytes,
                                              context,
                                              user.id);
                                          if (success) {
                                            await recommend(
                                                context,
                                                user.username,
                                                user.id);
                                            analytics
                                                .logCustomEvent(
                                                eventName:
                                                'peopleRecommend',
                                                params: {
                                                  'recommendedBy': FirebaseAuth
                                                      .instance
                                                      .currentUser
                                                      .uid,
                                                  'userId':
                                                  user.id,
                                                });
                                          } else {
                                            showToast(
                                                'Error caught!');
                                          }
                                        },
                                        label: 'Recommend',
                                        icon: recommendLogoIcon,
                                      ),
                                    ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
                userProvider.isNextListLoading ? spinKit : Container()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
