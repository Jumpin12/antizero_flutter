import 'dart:io';

import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/handler/user.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/models/on_board.dart';
import 'package:antizero_jumpin/screens/dashboard/dashboard.dart';
import 'package:antizero_jumpin/widget/auth/slide_tile.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class OnBoardPage extends StatefulWidget {
  const OnBoardPage({Key key}) : super(key: key);

  @override
  _OnBoardPageState createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  List<SliderModel> mySlides = <SliderModel>[];
  int slideIndex = 0;
  PageController controller;

  @override
  void initState() {
    super.initState();
    mySlides = getSlides();
    setState(() {});
    controller = new PageController();
    FirebaseAnalytics.instance.logScreenView(
      screenName: 'Onboarding Screen',
      screenClass: 'Onboarding',
    );
  }

  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 30.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.blue[100] : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.black26, Colors.black12])),
        child: Scaffold(
          backgroundColor: Colors.white70,
          body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                child: PageView(
                  physics: ScrollPhysics(),
                  controller: controller,
                  onPageChanged: (index) {
                    setState(() {
                      slideIndex = index;
                    });
                  },
                  children: <Widget>[
                    SlideTile(
                      path: mySlides[0].getImageAssetPath(),
                    ),
                    SlideTile(
                      path: mySlides[1].getImageAssetPath(),
                    ),
                    SlideTile(
                      path: mySlides[2].getImageAssetPath(),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
                  color: Colors.black26,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: [
                            for (int i = 0; i < 3; i++)
                              i == slideIndex
                                  ? _buildPageIndicator(true)
                                  : _buildPageIndicator(false),
                          ],
                        ),
                      ),
                      slideIndex != 2
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: InkWell(
                                onTap: () {
                                  controller.animateToPage(slideIndex + 1,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.linear);
                                },
                                child: Container(
                                  height: Platform.isIOS ? 55 : 50,
                                  width: 140,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                      color: Colors.blue[100]),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Next",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                            fontSize: 16,
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: InkWell(
                                onTap: () async {
                                  JumpInUser user = await getUser(context);
                                  if (user != null) {
                                    Navigator.of(context).push(PageTransition(
                                        child: DashBoardScreen(),
                                        type: PageTransitionType.fade));
                                  } else {
                                    showToast('Error in getting user');
                                  }
                                },
                                child: Container(
                                  height: Platform.isIOS ? 55 : 50,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                      color: Colors.blue[100]),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Get Started",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                            fontSize: 16,
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
