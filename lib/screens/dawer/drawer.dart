import 'dart:io';

import 'package:antizero_jumpin/handler/chat.dart';
import 'package:antizero_jumpin/handler/plan.dart';
import 'package:antizero_jumpin/handler/recommend.dart';
import 'package:antizero_jumpin/handler/user.dart';
import 'package:antizero_jumpin/models/friend_request.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/models/plan.dart';
import 'package:antizero_jumpin/provider/ModeModel.dart';
import 'package:antizero_jumpin/provider/auth.dart';
import 'package:antizero_jumpin/provider/navigator.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/screens/authentication/googleAuthScreen.dart';
import 'package:antizero_jumpin/screens/dashboard/dashboard.dart';
import 'package:antizero_jumpin/screens/dawer/bookmark.dart';
import 'package:antizero_jumpin/screens/dawer/location.dart';
import 'package:antizero_jumpin/screens/dawer/my_connection.dart';
import 'package:antizero_jumpin/screens/dawer/my_plan.dart';
import 'package:antizero_jumpin/screens/dawer/people_req.dart';
import 'package:antizero_jumpin/screens/dawer/plan_invite.dart';
import 'package:antizero_jumpin/screens/dawer/web_view.dart';
import 'package:antizero_jumpin/services/auth.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/locator.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:antizero_jumpin/widget/dialog.dart';
import 'package:antizero_jumpin/widget/dialog_email.dart';
import 'package:antizero_jumpin/widget/drawer/header.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int connectionLength;
  int planLength;
  int friendReqLength;
  int limit = 1500;
  int remainingUsers = 0;
  bool _isLoading = false;

  @override
  void initState() {
    getConnectionLength();
    getPlanLength();
    getPeopleRequestLength();
    super.initState();
  }

  getPeopleRequestLength() async {
    List<FriendRequest> _friendRequests = await getUserPeopleReq();
    if (_friendRequests != null) {
      friendReqLength = _friendRequests.length;
    }
    if (mounted) setState(() {});
  }

  getPlanLength() async {
    List<Plan> plans = await getAcceptedPlanForCurrentUser(context);
    if (plans != null) {
      planLength = plans.length;
    }
    if (mounted) setState(() {});
  }

  getConnectionLength() async {
    List<String> ids = getUserConnections(context);
    if (ids != null) {
      connectionLength = ids.length;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context);
    NavigationModel navigationModel = Provider.of<NavigationModel>(context);
    return Drawer(
      child: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          CustomDrawerHeader(
            img: userProvider.currentUser.photoList.last,
            name: userProvider.currentUser.name,
            mode: userProvider.currentUser.mode,
            onTap: () {
              navigationModel.changePage = 2;
              Navigator.of(context).push(PageTransition(
                  child: DashBoardScreen(), type: PageTransitionType.fade));
            },
          ),
          // location
          ListTile(
            leading: Container(
              width: SizeConfig.blockSizeHorizontal * 6,
              height: SizeConfig.blockSizeHorizontal * 6,
              child: Image.asset(locationIcon),
            ),
            title: Text(
              'Location',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: SizeConfig.blockSizeVertical * 2.55,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(PageTransition(
                  child: LocationPage(),
                  type: PageTransitionType.leftToRightWithFade));
            },
          ),

          // my connection
          ListTile(
            leading: Container(
              width: SizeConfig.blockSizeHorizontal * 6.5,
              height: SizeConfig.blockSizeHorizontal * 6.5,
              child: Image.asset(connectionIcon),
            ),
            title: Text(
              connectionLength == null
                  ? 'My Connections'
                  : 'My Connections (${connectionLength.toString()})',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: SizeConfig.blockSizeVertical * 2.55,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(PageTransition(
                  child: MyConnectionPage(),
                  type: PageTransitionType.leftToRightWithFade));
            },
          ),

          // my plan
          ListTile(
            leading: Container(
              width: SizeConfig.blockSizeHorizontal * 6,
              height: SizeConfig.blockSizeHorizontal * 6,
              child: Image.asset(planIcon),
            ),
            title: Text(
              planLength == null
                  ? 'My Plans'
                  : 'My Plans (${planLength.toString()})',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: SizeConfig.blockSizeVertical * 2.55,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(PageTransition(
                  child: MyPlanPage(),
                  type: PageTransitionType.leftToRightWithFade));
            },
          ),
          // people req
          ListTile(
            leading: Container(
              width: SizeConfig.blockSizeHorizontal * 6,
              height: SizeConfig.blockSizeHorizontal * 6,
              child: Image.asset(peopleReqIcon),
            ),
            title: Text(
              friendReqLength == null
                  ? 'People Requests Received'
                  : 'People Requests Received(${friendReqLength.toString()})',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: SizeConfig.blockSizeVertical * 2.55,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(PageTransition(
                  child: PeopleRequestPage(),
                  type: PageTransitionType.leftToRightWithFade));
            },
          ),

          // plan invite
          ListTile(
            leading: Container(
              width: SizeConfig.blockSizeHorizontal * 6,
              height: SizeConfig.blockSizeHorizontal * 6,
              child: Image.asset(planInviteIcon),
            ),
            title: Text(
              'Plan Invites Received',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: SizeConfig.blockSizeVertical * 2.55,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(PageTransition(
                  child: PlanInvitePage(),
                  type: PageTransitionType.leftToRightWithFade));
            },
          ),

          // bookmark
          ListTile(
            onTap: () {
              Navigator.of(context).push(PageTransition(
                  child: BookMarkPage(),
                  type: PageTransitionType.leftToRightWithFade));
            },
            leading: Container(
              width: SizeConfig.blockSizeHorizontal * 6,
              height: SizeConfig.blockSizeHorizontal * 6,
              child: Image.asset(bookMarkIcon),
            ),
            // leading: Icon(Icons.bookmark,
            //     color: Colors.blue, size: SizeConfig.blockSizeHorizontal * 7),
            title: Text(
              'Bookmarks',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: SizeConfig.blockSizeVertical * 2.55,
              ),
            ),
          ),

          // suggest
          ListTile(
              onTap: () async {
                await urlFileShare(context);
              },
              leading: Container(
                width: SizeConfig.blockSizeHorizontal * 5.5,
                height: SizeConfig.blockSizeHorizontal * 5.5,
                margin:
                    EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 0.5),
                child: Image.asset(suggestIcon),
              ),
              title: Text(
                'Suggest Jumpin',
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: SizeConfig.blockSizeVertical * 2.55,
                ),
              )),
          // setting
          ListTile(
            leading: Container(
              width: SizeConfig.blockSizeHorizontal * 6,
              height: SizeConfig.blockSizeHorizontal * 6,
              child: Image.asset(planIcon),
            ),
            title: Text('Give Feedback',
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: SizeConfig.blockSizeVertical * 2.55,
                )),
            onTap: () async
            {
              Uri url = Uri.parse('https://forms.gle/UoUTrnNvket6TrTU9');
              await urlShare(url);
            },
          ),
          // logout
          ListTile(
            leading: Container(
              width: SizeConfig.blockSizeHorizontal * 5.5,
              height: SizeConfig.blockSizeHorizontal * 5.5,
              margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 1),
              child: Image.asset(logoutIcon),
            ),
            title: Text(
              'Log Out',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: SizeConfig.blockSizeVertical * 2.55,
              ),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text(
                          "Are you sure you want to log out?",
                          textScaleFactor: 1,
                        ),
                        actions: [
                          ElevatedButton(
                              onPressed: () async {
                                await authProvider.signOut();
                                Navigator.of(context).push(PageTransition(
                                    child: GoogleSignInScreen(),
                                    type: PageTransitionType.fade));
                              },
                              child: Text(
                                'Yes',
                                textScaleFactor: 1,
                              )),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'No',
                                textScaleFactor: 1,
                              ))
                        ],
                      ));
            },
          ),

          // rating
          const Divider(color: Colors.black26),
          ListTile(
              leading: Container(
                width: SizeConfig.blockSizeHorizontal * 5.5,
                height: SizeConfig.blockSizeHorizontal * 5.5,
                margin:
                    EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 1),
                child: Image.asset(rateIcon),
              ),
              title: Text(
                'Rate Us',
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: SizeConfig.blockSizeVertical * 2.55,
                ),
              ),
              onTap: () {}),

          //
          ListTile(
              leading: Container(
                width: SizeConfig.blockSizeHorizontal * 5.5,
                height: SizeConfig.blockSizeHorizontal * 5.5,
                margin:
                    EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 1),
                child: Image.asset(aboutIcon),
              ),
              title: Text(
                'About Jumpin',
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: SizeConfig.blockSizeVertical * 2.55,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(PageTransition(
                    child: WebViewPage(), type: PageTransitionType.fade));
              }),
          (userProvider.currentUser.name == 'ashwini' || userProvider.currentUser.name == 'Shubham' || userProvider.currentUser.name == 'Mudit') ?
          ListTile(
              leading: Container(
                width: SizeConfig.blockSizeHorizontal * 5.5,
                height: SizeConfig.blockSizeHorizontal * 5.5,
                margin:
                EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 1),
                child: Image.asset(suggestIcon),
              ),
              title: Text(
                'Get Email',
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: SizeConfig.blockSizeVertical * 2.55,
                ),
              ),
              onTap: () async
              {
                showEmailDialog(context,limit);
              }) : Container()
        ],
      ),
    );
  }
}
