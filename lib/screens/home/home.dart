import 'dart:async';

import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/handler/user.dart';
import 'package:antizero_jumpin/models/contacts.dart';
import 'package:antizero_jumpin/provider/plan.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/screens/dawer/drawer.dart';
import 'package:antizero_jumpin/screens/home/people.dart';
import 'package:antizero_jumpin/screens/home/people_new.dart';
import 'package:antizero_jumpin/screens/home/plans.dart';
import 'package:antizero_jumpin/screens/home/plans/create_plan.dart';
import 'package:antizero_jumpin/screens/home/plans_new.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // ConnectionChecker cc = ConnectionChecker();
  TextEditingController searchController;
  TabController _tabController;
  int index;
  bool planSet = false;
  StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    // cc.checkConnection(context);
    searchController = TextEditingController();
    // after layout is loaded
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      print('initState');
      setUserPermission();
    });
    _tabController = TabController(length: 2, vsync: this);

    FirebaseAnalytics.instance.logScreenView(
      screenName: 'Home Screen',
      screenClass: 'Home',
    );

    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
          if (visible == false) FocusScope.of(context).requestFocus(FocusNode());
        });

    super.initState();
  }

  @override
  void dispose() {
    // cc.listener.cancel();
    keyboardSubscription.cancel();
    searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  setUserPermission() async {
    print('setUserPermission');
    bool locationGranted = checkLocation(context);
    print(locationGranted);
    List<UserContact> contacts = getContactsList(context);
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    if (locationGranted == false && contacts == null) {
      buildDialog(
          'Location & Contacts',
          'Please allow us to access your location so that we can show you people and plans near you.\n '
          'Please allow us to access your contacts so that we can show you mutual friends with a person or mutual attending a plan.',
          context,
          allow: true, onAllow: () async {
        Navigator.pop(context);
        await getLocationAndContacts(context);
        await userProvider.getUserCityAndState();
      });
    } else if (locationGranted == true && contacts == null) {
      buildDialog(
          'Contacts', 'Please allow us to access your contacts so that we can show you mutual friends with a person or mutual attending a plan.', context,
          allow: true, onAllow: () async {
        Navigator.pop(context);
        await getLocationAndContacts(context);
        await userProvider.getUserCityAndState();
      });
    } else if (locationGranted == false && contacts != null) {
      buildDialog(
          'Location', 'Please allow us to access your location so that we can show you people and plans near you.', context,
          allow: true, onAllow: () async {
        Navigator.pop(context);
        bool locationAllow = await getLocationPermission();
        if (locationAllow) {
          await handleLocation(context);
          await userProvider.getUserCityAndState();
        }
      });
    } else {
      bool locationAllow = await getLocationPermission();
      if (locationAllow) {
        await handleLocation(context);
        await userProvider.getUserCityAndState();
      }
    }
    // userProvider.firstLoading(context);
  }

  @override
  Widget build(BuildContext context) {
    // var userProvider = Provider.of<UserProvider>(context);
    // var planProvider = Provider.of<PlanProvider>(context);

    return Stack(
            children: [
            Container(
            child: Column(
            children: [
                // tabs
                SizedBox(height: 20.0),
            Container(
            width: MediaQuery.of(context).size.width * 0.82,
            decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            border: Border.all(color: blueborder),
            borderRadius: BorderRadius.all(Radius.circular(25))),
            child: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            controller: _tabController,
            labelPadding: EdgeInsets.symmetric(horizontal: 4),
            indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(
            25.0,
            ),
            color: Colors.blue,
            ),
            labelColor: Colors.white,
            physics: NeverScrollableScrollPhysics(),
            unselectedLabelColor: Colors.blue,
            onTap: (int index) {
            setState(() {
            index = _tabController.index;
            searchController.text = "";
            });
            },
            tabs: [
            // people tab
            // plan tab
            Tab(text: 'Plan'),
            Tab(text: 'People'),
            ],
            ),
            ),
            // tab bar view
            Flexible(
            child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
            // people
            // plan
            PlansNew(
            searchController: searchController,
            ),
            PeopleNew(
            searchController: searchController,
            ),
            ],
            ),
            ),
            ],
            ),
            ),
            _tabController.index == 0 ? Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                        'Create Plan',
                        style: TextStyle(fontSize: 10),
                        textAlign: TextAlign.center
                        ),
                      ),
                      onPressed: () {
                            Navigator.of(context).push(
                            PageTransition(
                            child: CreatePlanPage(
                            public: true,
                            ),
                            type: PageTransitionType.fade,
                            ),
                            );
                        },
                      style: ElevatedButton.styleFrom(fixedSize: Size(9.h, 9.h),shape: const CircleBorder(),),
                      ),
                ),) : Container()
    ]
    );
  }
}


// _tabController.index == 0
// ? FloatingActionButton(
// onPressed: () {
// Navigator.of(context).push(
// PageTransition(
// child: CreatePlanPage(
// public: true,
// ),
// type: PageTransitionType.fade,
// ),
// );
// },
// child: Icon(
// Icons.add,
// ),
// )
// : null,
