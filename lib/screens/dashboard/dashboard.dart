import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:antizero_jumpin/handler/chat.dart';
import 'package:antizero_jumpin/handler/dynamic_link.dart';
import 'package:antizero_jumpin/handler/notification.dart';
import 'package:antizero_jumpin/handler/plan.dart';
import 'package:antizero_jumpin/handler/recommend.dart';
import 'package:antizero_jumpin/models/friend_request.dart';
import 'package:antizero_jumpin/models/plan.dart';
import 'package:antizero_jumpin/provider/navigator.dart';
import 'package:antizero_jumpin/provider/plan.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/screens/chat/all_chat.dart';
import 'package:antizero_jumpin/screens/dawer/drawer.dart';
import 'package:antizero_jumpin/screens/home/chat/chat.dart';
import 'package:antizero_jumpin/screens/home/home.dart';
import 'package:antizero_jumpin/screens/home/plans/create_plan.dart';
import 'package:antizero_jumpin/screens/home/plans/current_plan.dart';
import 'package:antizero_jumpin/screens/home/plans/plan_chat.dart';
import 'package:antizero_jumpin/screens/notification/notificationScreen.dart';
import 'package:antizero_jumpin/screens/profile/profile.dart';
import 'package:antizero_jumpin/services/auth.dart';
import 'package:antizero_jumpin/services/chat.dart';
import 'package:antizero_jumpin/services/notification.dart';
import 'package:antizero_jumpin/services/plan.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/decoration.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/locator.dart';
import 'package:antizero_jumpin/widget/common/custom_appbar.dart';
import 'package:antizero_jumpin/widget/common/fade_animation.dart';
import 'package:antizero_jumpin/widget/common/search.dart';
import 'package:antizero_jumpin/widget/dialog.dart';
import 'package:antizero_jumpin/widget/drawer/bottom_nav_bar.dart';
import 'package:antizero_jumpin/widget/filters/filter_widget.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:sizer/sizer.dart';

import '../../main.dart';
import '../../models/jumpin_user.dart';
import '../../services/user.dart';
import '../../widget/dialogokcancel.dart';
import '../home/jumpInuser_profile.dart';

class DashBoardScreen extends StatefulWidget {
  static String routeName = "/dash";
  const DashBoardScreen({Key key}) : super(key: key);

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  PageController pageController;
  var currentTab = [HomePage()];
  GlobalKey<ScaffoldState> thisContext = GlobalKey<ScaffoldState>();
  bool exist = false;
  StreamController userChatsController;
  StreamController planChatsController;
  UserProvider userProvider = UserProvider();
  PlanProvider planProvider = PlanProvider();
  int count = 0;
  TextEditingController searchController;
  Icon actionIcon = new Icon(Icons.search,color: Colors.white);

  @override
  void initState() {
    // FilterProvider().getUsersByDistance();
    pageController = PageController();
    searchController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async
    {
      //Handle Notifications
      initAppServices(context, onTokenUpdate: (token) {
        NotificationService().saveFCMTokenToFirestore(
            AuthService().currentAppUser.uid,
            fetchedToken: token);
      }, onNotification: (message) async {
        print('inside notification');
        String description = message['description'];
        String planId = message['planId'];
        print(message);
        UserService userService = UserService();
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        var planProvider = Provider.of<PlanProvider>(context, listen: false);
        if (description.contains('requested by')) {
          String fromId = description.split(' ')[2];
          await userService.getUserById(fromId).then(
                (JumpInUser user) => {
                  navKey.currentState.push(
                    MaterialPageRoute(
                      builder: (_) => JumpInUserPage(
                        user: user,
                        withoutProvider: true,
                      ),
                    ),
                  ),
                },
              );
        } else if (description.contains('accepted by')) {
          String fromId = description.split(' ')[2];
          await userService.getUserById(fromId).then(
                (JumpInUser user) => {
                  navKey.currentState.push(
                    MaterialPageRoute(
                      builder: (_) => JumpInUserPage(
                        user: user,
                        withoutProvider: true,
                      ),
                    ),
                  ),
                },
              );
        } else if (description.contains('wants to')) {
          String fromId = description.split(' ')[2];
          await userService.getUserById(fromId).then(
                (JumpInUser user) => {
                  navKey.currentState.push(
                    MaterialPageRoute(
                      builder: (_) => JumpInUserPage(
                        user: user,
                        withoutProvider: true,
                      ),
                    ),
                  ),
                },
              );
        } else if (description.contains('invited to plan')) {
          String planId = description.split(' ')[3];
          debugPrint(planId);
          await planServ.getPlanById(planId).then((value) async => {
                planProvider.currentPlan = value,
                print(value.planName),
                navKey.currentState.push(
                  MaterialPageRoute(
                    builder: (_) => CurrentPlanPage(
                      hostId: value.host,
                    ),
                  ),
                ),
              });
        } else if (description.contains('accepted plan')) {
          String planId = description.split(' ')[2];
          debugPrint(planId);
          await planServ.getPlanById(planId).then((value) async => {
                planProvider.currentPlan = value,
                print(value.planName),
                navKey.currentState.push(
                  MaterialPageRoute(
                    builder: (_) => CurrentPlanPage(
                      hostId: value.host,
                    ),
                  ),
                ),
              });
        } else if (description.contains('new people message')) {
          String userId = description.split(' ')[4];

          List<FriendRequest> friendList = await ChatService().getAcceptedChatById(userId);

          if (friendList.isNotEmpty) {
            FriendRequest friend = friendList
                .where(
                    (element) => element.userIds.contains(message["recipient"]))
                .first;
            userProvider.currentPeopleGroup = friend;
            userService.getUserById(userId).then(
              (value) async {
                userProvider.chatWithUser = value;
                await navKey.currentState.push(
                  MaterialPageRoute(
                    builder: (_) => ChatPage(),
                  ),
                );
               // userServ.updateOnlineOfflineStatusUser(context, false);
              },
            );
          }
        } else if (description.contains('new plan message')) {
          print("object");
          Plan plan = await PlanService().getPlanById(planId);

          if (plan != null) {
            JumpInUser _user =
                await locator.get<UserService>().getUserById(plan.host);
            planProvider.currentPlanHost = _user;
            planProvider.currentPlan = plan;
            print("object");
            await navKey.currentState.push(
              MaterialPageRoute(
                builder: (_) => PlanChatPage(),
              ),
            );
            //setOnlineOfflineStatusOfPlanMember(context, false);
          }
        }
      });

      //Handle Dynamic Links
      _initDynamicLinks();
    });

    userChatsController = BehaviorSubject();
    planChatsController = BehaviorSubject();
    if (!userChatsController.isClosed) {
      userChatsController.sink.addStream(fetchUserChatStream(context));
    }
    if (!planChatsController.isClosed) {
      planChatsController.sink.addStream(fetchPlanChatStream(context));
    }

    Timer.periodic(Duration(minutes: 1), (timer) {
      print("count $count");
      count = count + 1;
      if(count>1)
        {
          timer.cancel();
        }
      else
        {
          // show popup from here
          showPopupDialog(context);
        }
    });
    super.initState();
  }

  // Dynamic links are used to share profile or plans on whatsapp
  _initDynamicLinks() async
  {
    // GetIt.instance<DynamicLinkHandler>().handleDynamicLink(context);
  }

  initAppServices(BuildContext context,
      {Function onTokenUpdate, Function onNotification}) async {
    NotificationHandler(
        onToken: onTokenUpdate,
        onSelectLocalNotification: (payLoad) {
          if (onNotification != null) onNotification(payLoad);
        }).configureNotificationsAndTokenUpdates(context,
          onTokenRefreshed: (value) => onTokenUpdate(value),
          onMessage: (data) {
            if (onNotification != null) onNotification(data);
          });
  }

  Future notificationHandler(BuildContext context) async {
    UserService userService = UserService();
    var userProvider = Provider.of<UserProvider>(context);
    var planProvider = Provider.of<PlanProvider>(context);
    // PlanService planService = PlanService();
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) async {
        if (message.notification.body.contains('wants to')) {
          String description = message.data['description'];
          String fromId = description.split(' ')[2];
          await userService.getUserById(fromId).then(
                (JumpInUser user) => {
                  navKey.currentState.push(
                    MaterialPageRoute(
                      builder: (_) => JumpInUserPage(
                        user: user,
                      ),
                    ),
                  ),
                },
              );
        } else if (message.notification.body.contains('invited you')) {
          String description = message.data['description'];
          String planId = description.split(' ')[3];
          print(planId);
          await planServ.getPlanById(planId).then((value) async => {
                planProvider.currentPlan = value,
                navKey.currentState.push(
                  MaterialPageRoute(
                    builder: (_) => CurrentPlanPage(
                      hostId: value.host,
                    ),
                  ),
                ),
              });
        } else if (message.notification.body.contains('new message')) {
          String description = message.data['description'];
          String userId = description.split(' ')[3];
          print(userId);
          userService.getUserById(userId).then(
                (value) async => {
                  userProvider.chatWithUser = value,
                  navKey.currentState.push(
                    MaterialPageRoute(
                      builder: (_) => ChatPage(),
                    ),
                  ),
                },
              );
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  checkNotification(
      UserProvider userProvider, PlanProvider planProvider) async {
    showNotification(context, userProvider, planProvider);
    exist = await checkUserHasNotification(context);
    // print('exist $exist');
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    planProvider = Provider.of<PlanProvider>(context, listen: false);
    checkNotification(userProvider, planProvider);
    notificationHandler(context);
    NavigationModel navigationModel = Provider.of<NavigationModel>(context);
    return WillPopScope(
      onWillPop: () async
      {
        setState(() {
          pageController.jumpToPage(0);
          navigationModel.changePage = 0;
        });
        return false;
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: primaryGradient,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          drawer: const CustomDrawer(),
          appBar: CustomAppBar(
            logo: true,
            trailing: TextButton(
              onPressed: () async {
                Uri url = Uri.parse('https://forms.gle/UoUTrnNvket6TrTU9');
                await urlShare(url);
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.transparent, // Background Color
              ),
              child: Text(
                'Give Feedback',
                style: TextStyle(fontSize: 10,color: white),
              ),
            ),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.end,
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     // IconButton(
            //     //   onPressed: () {
            //     //     showDialog(
            //     //         context: context,
            //     //         builder: (context) {
            //     //           return FilterWidget(title: "",);
            //     //         });
            //     //   },
            //     //   icon: Icon(Icons.filter_list_rounded,color: Colors.white,),
            //     // ),
            //     // IconButton(
            //     //   onPressed: ()
            //     //   {
            //     //     setState(() {
            //     //       if ( this.actionIcon.icon == Icons.search){
            //     //         this.actionIcon = new Icon(Icons.close,color: Colors.white,);
            //     //       }
            //     //       else {
            //     //         this.actionIcon = new Icon(Icons.search,color: Colors.white);
            //     //       }
            //     //     });
            //     //   },
            //     //   icon: this.actionIcon,
            //     // )
            //   ],
            // ),
            leading: IconButton(
              icon: const Icon(
                EvaIcons.menu2,color: Colors.white,
              ),
              onPressed: () {
                thisContext.currentState.openDrawer();
              },
            ),
            title: 'JUMPIN',
            backgroundColor: Colors.transparent,
            automaticImplyLeading: true,
            isFromHome: true
          ),
          key: thisContext,
          body: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7.w),
                topRight: Radius.circular(7.w),
              ),
            ),
            child: PageView(
              children: <Widget>[currentTab[navigationModel.currentIndex]],
              controller: pageController,
              onPageChanged: (index) {
                navigationModel.changePage = index;
              },
              physics: NeverScrollableScrollPhysics(),
            ),
          ),
          // bottomNavigationBar: BottomNavigationBar(
          //   currentIndex: navigationModel.currentIndex,
          //   onTap: (index) {
          //     navigationModel.changePage = index;
          //   },
          //   showUnselectedLabels: false,
          //   backgroundColor: bluelite,
          //   selectedItemColor: blue,
          //   unselectedItemColor: Colors.black54,
          //   type: BottomNavigationBarType.fixed,
          //   selectedLabelStyle:
          //       TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          //   items: [
          //     BottomNavigationBarItem(
          //         icon: ImageIcon(
          //           AssetImage('assets/images/Onboarding/logo_final.png'),
          //           size: 25,
          //         ),
          //         activeIcon: FadeAnimation(
          //             0.5,
          //             ImageIcon(
          //               AssetImage('assets/images/Onboarding/logo_final.png'),
          //               size: 25,
          //             )),
          //         label: 'JumpIn'),
          //     BottomNavigationBarItem(
          //         icon: Stack(
          //           children: [
          //             Icon(
          //               Icons.notifications,
          //               size: 25,
          //             ),
          //             if (exist)
          //               Positioned(
          //                   top: 2,
          //                   right: 0,
          //                   child: Icon(
          //                     Icons.circle,
          //                     color: Colors.green,
          //                     size: 10,
          //                   ))
          //           ],
          //         ),
          //         activeIcon: FadeAnimation(
          //           0.5,
          //           Stack(
          //             children: [
          //               Icon(
          //                 Icons.notifications,
          //                 size: 25,
          //               ),
          //               if (exist)
          //                 Positioned(
          //                     top: 2,
          //                     right: 0,
          //                     child: Icon(
          //                       Icons.circle,
          //                       color: Colors.green,
          //                       size: 10,
          //                     ))
          //             ],
          //           ),
          //         ),
          //         label: 'Notifications'),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.face_sharp, size: 25),
          //       activeIcon: FadeAnimation(
          //         0.5,
          //         Icon(Icons.face_sharp, size: 25),
          //       ),
          //       label: 'User',
          //     )
          //   ],
          // ),
          bottomNavigationBar: BottomNavBar(
            currentIndex: navigationModel.currentIndex,
            onTap: (index) {
              if (index == 0) {
                // Navigator.of(context).push(
                //   PageTransition(
                //     child: const CreatePlanPage(
                //       public: true,
                //     ),
                //     type: PageTransitionType.fade,
                //   ),
                // );
                navigationModel.changePage = 0;
              } else if (index == 1) {
                Navigator.of(context).push(
                  PageTransition(
                    child: const NotificationScreen(),
                    type: PageTransitionType.fade,
                  ),
                );
              } else if (index == 2) {
                Navigator.of(context).push(PageTransition(
                    child: AllChatPage(
                      userChatsController: userChatsController,
                      planChatsController: planChatsController,
                    ),
                    type: PageTransitionType.fade));
              } else if (index == 3) {
                Navigator.of(context).push(
                  PageTransition(
                    child: ProfilePage(),
                    type: PageTransitionType.fade,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
