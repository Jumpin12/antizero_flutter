import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/widget/on_board/cardLower.dart';
import 'package:antizero_jumpin/widget/on_board/cardUpper.dart';
import 'package:antizero_jumpin/widget/common/customContainerOnboard.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class OnBoardPage extends StatelessWidget {
  final double upper1;
  final double upper2;
  final double lower1;
  final double lower2;
  final String define1;
  final String define2;
  const OnBoardPage(
      {this.define1,
      this.define2,
      this.upper1,
      this.upper2,
      this.lower1,
      this.lower2,
      key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * 0.9,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: LayoutBuilder(
        builder: (context, size) {
          return Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: size.maxWidth,
                    height: size.maxHeight * 0.1,
                    padding:
                        EdgeInsets.symmetric(horizontal: size.maxWidth * 0.02),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: size.maxWidth * 0.04),
                          child: Icon(
                            Icons.menu_rounded,
                            size: 27,
                          ),
                        ),
                        Image.asset(
                          "assets/images/Onboarding/logo_final.png",
                          height: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('jumpin'.toUpperCase(), style: textStyle1),
                        Spacer(),

                        // color: Colors.black12,
                        Image.asset(
                          'assets/images/Home/chatIcon1.png',
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                  Container(
                      height: size.maxHeight * 0.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: size.maxWidth * 0.8,
                            height: size.maxHeight * 0.7,
                            child: Column(
                              children: [
                                Container(
                                  height: size.maxHeight * 0.1,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Spacer(),
                                          Text('@shawshank',
                                              overflow: TextOverflow.ellipsis,
                                              style: textStyle2),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: size.maxHeight * 0.005),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: size.maxHeight * 0.03,
                                                  child: Image.asset(
                                                    "assets/images/SideNav/placeholder.png",
                                                  ),
                                                ),
                                                Text("1080 kms",
                                                    style: textStyle1)
                                              ],
                                            ),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 45,
                                            height: 45,
                                            child:
                                                LiquidCircularProgressIndicator(
                                              value: 0.85,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      Colors.blue[300]),
                                              backgroundColor: Colors.white,
                                              borderColor: Colors.blue[300],
                                              borderWidth: 2.0,
                                              direction: Axis.vertical,
                                              center: Text(
                                                "85%",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Spacer(),
                                              Text(
                                                " Vibe",
                                                style: TextStyle(
                                                    fontSize: 18, color: black),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text("Meter",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: black)),
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  height: size.maxHeight * 0.5,
                                  width: size.maxWidth * 0.8,
                                  decoration: BoxDecoration(
                                      color: Colors.cyan[50].withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(10)),
                                  padding:
                                      EdgeInsets.all(size.maxHeight * 0.03),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                          top: 0,
                                          left: 0,
                                          child: CustomCardUpper(
                                            textAlignment: Alignment.topLeft,
                                            icon: Alignment.bottomLeft,
                                            title: '23 Years\nMALE',
                                            imgsrc:
                                                'assets/images/Home/male_blue.png',
                                          )),
                                      Positioned(
                                          top: 0,
                                          right: 0,
                                          child: CustomCardUpper(
                                            textAlignment: Alignment.topRight,
                                            icon: Alignment.bottomRight,
                                            title: 'AntiZero Private Limited ',
                                            imgsrc:
                                                'assets/images/Home/work.png',
                                          )),
                                      Positioned(
                                          left: 0,
                                          bottom: 0,
                                          child: CustomCardLower(
                                            textAlignment: Alignment.topLeft,
                                            icon: Alignment.topLeft,
                                            imgsrc:
                                                'assets/images/Home/mutual_friend.png',
                                            text: '6\nMutual Friends',
                                          )),
                                      Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: CustomCardLower(
                                            textAlignment:
                                                Alignment.bottomRight,
                                            icon: Alignment.topRight,
                                            imgsrc:
                                                'assets/images/Home/interest_home.png',
                                            text: 'Football\nCricket',
                                          )),
                                      Align(
                                          alignment: Alignment.center,
                                          child: Stack(
                                            children: [
                                              Align(
                                                alignment: Alignment.center,
                                                child: CircleAvatar(
                                                  radius: 60,
                                                  backgroundImage: AssetImage(
                                                      'assets/images/Home/people_background_blue_shades.png'),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.center,
                                                child: CircleAvatar(
                                                    radius: 45,
                                                    backgroundImage: AssetImage(
                                                        "assets/images/Home/profile.jpg")),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: size.maxHeight * 0.1,
                                  width: size.maxWidth * 0.8,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomContainer(
                                          title: 'JumpIn',
                                          img:
                                              "assets/images/Onboarding/logo_final.png"),
                                      CustomContainer(
                                          title: 'Recommend',
                                          img:
                                              "assets/images/Home/refer_icon.png"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  Container(
                    width: size.maxWidth,
                    height: size.maxHeight * 0.1,
                    color: Colors.grey[100],
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ImageIcon(
                              AssetImage(
                                  'assets/images/Onboarding/logo_final.png'),
                              size: 20,
                              color: Colors.blue,
                            ),
                            Text(
                              "JumpIn",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                        Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notifications,
                                size: 25, color: black.withOpacity(0.6)),
                          ],
                        ),
                        Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.face_sharp,
                                size: 25, color: black.withOpacity(0.6)),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Container(
                color: Colors.black26,
              ),
              Positioned(
                bottom: upper1,
                left: upper2,
                child: Container(
                    width: size.maxWidth * 0.6,
                    height: size.maxHeight * 0.15,
                    padding: EdgeInsets.all(size.maxHeight * 0.005),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/Home/bottom-left.png",
                          height: 50,
                        ),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.only(
                                  top: size.maxHeight * 0.05,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                alignment: Alignment.center,
                                child: Text(
                                  define2,
                                  textAlign: TextAlign.center,
                                  style: textStyle4,
                                )))
                      ],
                    )),
              ),
              Positioned(
                right: lower1,
                bottom: lower2,
                child: Container(
                    width: size.maxWidth * 0.6,
                    height: size.maxHeight * 0.15,
                    padding: EdgeInsets.all(size.maxHeight * 0.005),
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.only(
                                  bottom: size.maxHeight * 0.05,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                alignment: Alignment.center,
                                child: Text(
                                  define1,
                                  textAlign: TextAlign.center,
                                  style: textStyle4,
                                ))),
                        Image.asset(
                          "assets/images/Home/top-right.png",
                          height: 50,
                        ),
                      ],
                    )),
              )
            ],
          );
        },
      ),
    );
  }
}
