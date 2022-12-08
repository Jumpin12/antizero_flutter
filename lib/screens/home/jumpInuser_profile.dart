import 'dart:typed_data';

import 'package:antizero_jumpin/handler/bookmark.dart';
import 'package:antizero_jumpin/handler/home.dart';
import 'package:antizero_jumpin/handler/profile.dart';
import 'package:antizero_jumpin/handler/recommend.dart';
import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/handler/user.dart';
import 'package:antizero_jumpin/models/bookmark.dart';
import 'package:antizero_jumpin/models/contacts.dart';
import 'package:antizero_jumpin/models/friend_request.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/models/sub_category.dart';
import 'package:antizero_jumpin/provider/jumpin.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/screens/home/chat/chat.dart';
import 'package:antizero_jumpin/screens/home/mutual_contacts.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/widget/common/fade_animation.dart';
import 'package:antizero_jumpin/widget/home/app_bar.dart';
import 'package:antizero_jumpin/widget/home/card_buttons.dart';
import 'package:antizero_jumpin/widget/home/image_name.dart';
import 'package:antizero_jumpin/widget/home/jumpin_btn.dart';
import 'package:antizero_jumpin/widget/home/widget_toImg.dart';
import 'package:antizero_jumpin/widget/profile/extra_details.dart';
import 'package:antizero_jumpin/widget/profile/img_swipper.dart';
import 'package:antizero_jumpin/widget/profile/interest_block.dart';
import 'package:antizero_jumpin/widget/profile/interest_card.dart';
import 'package:antizero_jumpin/widget/profile/profile_items.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_settings/open_settings.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class JumpInUserPage extends StatefulWidget {
  final JumpInUser user;
  final bool withoutProvider;
  const JumpInUserPage({Key key, this.user, this.withoutProvider = false})
      : super(key: key);

  @override
  _JumpInUserPageState createState() => _JumpInUserPageState();
}

class _JumpInUserPageState extends State<JumpInUserPage> {
  int age;
  String address;
  List<SubCategory> mutualInterest = [];
  List<SubCategory> otherInterest = [];
  bool contactGranted = false;
  bool loading = true;
  bool statusLoading = true;
  List<UserContact> mutualContact = [];

  FriendRequest friendRequest;
  BookMark bookMark;
  bool marked = false;
  bool setMark = false;

  GlobalKey keyK;
  Uint8List bytes;

  @override
  void initState() {
    // print(widget.user.id);
    checkIfBookMarked();
    checkIfConnected();
    getInterest();
    super.initState();
    FirebaseAnalytics.instance.logScreenView(
      screenName: 'Jumpin Profile Screen',
      screenClass: 'Home',
    );
  }

  checkIfBookMarked() async {
    bool _marked = await isPeopleBookMarked(context, widget.user.id);
    if (_marked == true) marked = _marked;
    if (mounted)
      setState(() {
        setMark = true;
      });
  }

  checkIfConnected() async {
    FriendRequest _friendRequest =
        await checkRequestedStatus(context, widget.user.id);
    if (_friendRequest != null &&
        _friendRequest.status == FriendRequestStatus.Accepted) {
      friendRequest = _friendRequest;
    }
    setState(() {
      statusLoading = false;
    });
  }

  getInterest() async {
    if (mounted) await getMutualInterestList();
    if (mounted) await getOtherInterestList();
    await getMutualContacts();
    await getAgeAddress();
  }

  getMutualInterestList() async {
    List<SubCategory> _mutualInterests =
        await getMutualInterest(widget.user, context);
    if (_mutualInterests != null) {
      mutualInterest = _mutualInterests;
    }
  }

  getOtherInterestList() async {
    List<SubCategory> _otherInterests =
        await getOtherInterest(widget.user, context);
    if (_otherInterests != null) {
      otherInterest = _otherInterests;
    }
  }

  getAgeAddress() async {
    if (widget.user.dob != null) age = getAgeFromDob(widget.user.dob);
    if (widget.user.geoPoint != null) {
      String add = await getAddressFromLatLng(
          Lat: widget.user.geoPoint['Lat'], Long: widget.user.geoPoint['Long']);
      if (add != null) address = add;
    }
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  getMutualContacts() async {
    bool status = await checkContactPermission();
    contactGranted = status;
    await calcMutualContacts();
  }

  calcMutualContacts() async {
    List<UserContact> contactList =
        await getMutualContactsLength(widget.user, context);

    if (contactList != null) {
      mutualContact = contactList;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var userProvider = Provider.of<UserProvider>(context);

    return WidgetToImage(
      builder: (key) {
        keyK = key;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: HomeAppBar(
            title: 'JUMPIN',
            leading: true,
            trailing: false,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // profile image
                    Container(
                      width: size.width,
                      height: size.height * 0.27,
                      child: Stack(
                        children: [
                          Container(
                            width: size.width,
                            height: size.height * 0.17,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                              colors: [Colors.blue[900], Colors.blue],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )),
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: Stack(
                                children: [
                                  Container(
                                      width: size.height * 0.18,
                                      height: size.height * 0.18,
                                      child: ImageSwiper(
                                        images: widget.user.photoList,
                                      )),
                                  // Positioned(
                                  //   bottom: size.height * 0.005,
                                  //   right: 0,
                                  //   child: VibeCard(
                                  //     fromProfile: true,
                                  //     userToCompare: widget.user,
                                  //   ),
                                  // )
                                ],
                              )),
                          Positioned(
                            bottom: size.height * 0.03,
                            left: (size.width * 0.2) / 8,
                            child: Column(
                              children: [
                                Text("Connections",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: size.height * 0.02,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                    widget.user.connection != null
                                        ? widget.user.connection.length
                                            .toString()
                                        : '0',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: size.height * 0.025,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: size.height * 0.03,
                            left: size.width - size.width * 0.2,
                            child: Column(
                              children: [
                                Text("Plans",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: size.height * 0.02,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                    widget.user.plans != null
                                        ? widget.user.plans.length.toString()
                                        : '0',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: size.height * 0.025,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    // name
                    Text(
                      '@${widget.user.username}',
                      textAlign: TextAlign.center,
                      style: textStyle1.copyWith(
                          fontSize: 24, color: Colors.black54),
                    ),
                    if (friendRequest != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          '${widget.user.name}',
                          textAlign: TextAlign.center,
                          style: textStyle1.copyWith(
                              fontSize: 26,
                              color: Colors.black87,
                              fontFamily: tre),
                        ),
                      ),
                    SizedBox(height: 2),
                    Text(
                      widget.user.profession ?? 'JumpIn User',
                      textAlign: TextAlign.center,
                      style: textStyle1.copyWith(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400),
                    ),
                    ProfileItem(
                      leftImage: widget.user.geoPoint == null
                          ? noLocationIcon
                          : locationIcon,
                      leftText: widget.user.geoPoint == null
                          ? 'N/A'
                          : address ?? 'Syncing..',
                      rightImage: ageIcon,
                      rightText: age == null ? 'N/A' : age.toString(),
                      divider: true,
                    ),

                    // work & education
                    SizedBox(height: 10),
                    ProfileItem(
                      leftImage: professionIcon,
                      leftText: widget.user.placeOfWork ?? 'N/A',
                      rightImage: collegeIcon,
                      rightText: widget.user.placeOfEdu ?? 'N/A',
                      divider: false,
                    ),

                    // academic
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: ExtraDetail(
                        icon: academicIcon,
                        label: 'Academic',
                        text: widget.user.academicCourse ?? 'N/A',
                      ),
                    ),

                    // bio
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: ExtraDetail(
                        label: 'Bio',
                        text: widget.user.bio ?? 'N/A',
                      ),
                    ),

                    // in jumpIn for
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: ExtraDetail(
                        label: 'I am on JumpIn for ',
                        text: widget.user.inJumpInFor ?? 'N/A',
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    if (loading) fadedCircle(32, 32, color: Colors.blue[100]),
                    // mutual interest
                    SizedBox(height: 20),
                    if (loading == false)
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                  text: "Mutual Interest - ",
                                  style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: tre,
                                      color: Colors.black.withOpacity(0.8)),
                                  children: [
                                    TextSpan(
                                      text: mutualInterest.length.toString() ??
                                          '',
                                      style: TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: tre,
                                          color: Colors.red),
                                    ),
                                  ]),
                            ),
                          )),
                    if (mutualInterest.isEmpty && loading == false)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "No mutual interest found",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: size.height * 0.018,
                              color: Colors.black38,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    if (mutualInterest.length > 0 && loading == false)
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Container(
                          height: size.height / 6,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: mutualInterest.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: InterestCard(
                                    url: mutualInterest[index].img,
                                    title: mutualInterest[index].name,
                                  ),
                                );
                              }),
                        ),
                      ),

                    // Interests
                    if (mutualInterest.isEmpty) SizedBox(height: 20),
                    if (otherInterest.length > 0 && loading == false)
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                  text: "Other Interest - ",
                                  style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: tre,
                                      color: Colors.black.withOpacity(0.8)),
                                  children: [
                                    TextSpan(
                                      text:
                                          otherInterest.length.toString() ?? '',
                                      style: TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: tre,
                                          color: Colors.red),
                                    ),
                                  ]),
                            ),
                          )),
                    if (otherInterest.length > 0 && loading == false)
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Container(
                          height: size.height / 6,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: otherInterest.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: InterestCard(
                                    url: otherInterest[index].img,
                                    title: otherInterest[index].name,
                                  ),
                                );
                              }),
                        ),
                      ),
                    // mutual contacts
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            'Favourites',
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: size.height * 0.02,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    widget.user.favourites == null
                        ? Text('No favourites selected')
                        : GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.user.favourites.length,
                            addSemanticIndexes: true,
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemBuilder: (BuildContext context, int index) =>
                                InterestBlock(
                              favourite: widget.user.favourites[index],
                            ),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                            "You and @${widget.user.username} both know",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontSize: size.height * 0.02,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (contactGranted == false && loading == false)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Text(
                              "Want to know more about the person? \nEnable contacts in settings to see mutual friends",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: size.height * 0.018,
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w500),
                            ),
                            TextButton(
                                onPressed: () async {
                                  bool status = await checkContactPermission();
                                  if (status) {
                                    contactGranted = true;
                                    await handleContacts(context);
                                    await calcMutualContacts();
                                  } else {
                                    OpenSettings.openMainSetting();
                                    // PhotoManager.openSetting();
                                  }
                                },
                                child: Text('Grant access')),
                          ],
                        ),
                      ),
                    if (contactGranted == true && mutualContact.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: size.width * 0.8,
                              height: size.height * 0.15,
                              padding: EdgeInsets.only(
                                  top: (size.height * 0.15) / 5),
                              child: Stack(
                                children: mutualContact.map((e) {
                                  return Positioned(
                                      left: mutualContact.indexOf(e) *
                                          (size.width * 0.17),
                                      child: GetImageName(
                                        label: e.name.toString()[0],
                                      ));
                                }).toList(),
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                                top: (size.height * 0.15) / 5,
                                right: size.width * 0.02),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(PageTransition(
                                    child: MutualContactPage(
                                      userId: widget.user.id,
                                      user: widget.user,
                                    ),
                                    type: PageTransitionType.fade));
                              },
                              child: Container(
                                width: size.width * 0.1,
                                height: size.width * 0.2,
                                // color: Colors.black26,
                                padding: EdgeInsets.all(size.width * 0.02),
                                child: FittedBox(
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: size.height * 0.025,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    if (contactGranted == true && mutualContact.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "No mutual friend found",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: size.height * 0.018,
                              color: Colors.black38,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 100,
                  width: size.width,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey.shade100,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: statusLoading
                      ? fadedCircle(32, 32, color: Colors.white)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            if (friendRequest == null)
                              if (widget.withoutProvider)
                                ChangeNotifierProvider<JumpInButtonProvider>(
                                  create: (context) => JumpInButtonProvider(
                                      context, widget.user.id),
                                  child: JumpInButton(
                                    label: 'JUMPIN',
                                    id: widget.user.id,
                                    icon: logoIcon,
                                  ),
                                )
                              else
                                JumpInButton(
                                  label: 'JUMPIN',
                                  id: widget.user.id,
                                  icon: logoIcon,
                                ),
                            if (friendRequest != null)
                              CardButton(
                                icon: logoIcon,
                                color: Colors.grey[50],
                                textColor: Colors.black54,
                                onPress: () {
                                  userProvider.chatWithUser = widget.user;
                                  userProvider.currentPeopleGroup =
                                      friendRequest;
                                  Navigator.of(context).push(PageTransition(
                                      child: ChatPage(),
                                      type: PageTransitionType.fade));
                                },
                                label: 'Chat',
                              ),
                            CardButton(
                              color: Colors.grey[50],
                              textColor: Colors.black54,
                              onPress: () async {
                                bytes = await capture(keyK);
                                bool success = await takeScreenShot(
                                    bytes, context, widget.user.id);
                                if (success) {
                                  await recommend(context, widget.user.username,
                                      widget.user.id);
                                } else {
                                  showToast('Error caught!');
                                }
                              },
                              label: 'Recommend',
                              icon: referIcon,
                            ),
                            // bookmark
                            if (setMark == true)
                              FadeAnimation(
                                0.2,
                                FloatingActionButton(
                                  backgroundColor: marked ? blue : Colors.white,
                                  child: FaIcon(FontAwesomeIcons.bookmark,
                                      size: 20,
                                      color: marked ? Colors.white : blue),
                                  onPressed: () async {
                                    if (marked == true) {
                                      bool success =
                                          await removePeopleFromBookMark(
                                              context, widget.user.id);
                                      if (success) {
                                        bool bMSet =
                                            await getUserBookMark(context);
                                        showToast('Removed from bookmark!');
                                        setState(() {
                                          marked = false;
                                        });
                                      } else {
                                        showToast('Please try again!');
                                      }
                                    } else {
                                      bool added = await addPeopleToBookMark(
                                          context, widget.user.id);
                                      if (added) {
                                        bool bMSet =
                                            await getUserBookMark(context);
                                        showToast('Added to bookmark!');
                                        setState(() {
                                          marked = true;
                                        });
                                      } else {
                                        showToast('Please try again!');
                                      }
                                    }
                                  },
                                ),
                              )
                          ],
                        ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
