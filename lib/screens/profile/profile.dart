import 'package:antizero_jumpin/handler/interest.dart';
import 'package:antizero_jumpin/handler/local.dart';
import 'package:antizero_jumpin/handler/profile.dart';
import 'package:antizero_jumpin/handler/user.dart';
import 'package:antizero_jumpin/models/favourite_new_model.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/provider/filter.dart';
import 'package:antizero_jumpin/provider/interest.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/screens/profile/edit_interest.dart';
import 'package:antizero_jumpin/screens/profile/edit_profile.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/widget/common/custom_appbar.dart';
import 'package:antizero_jumpin/widget/home/card_buttons_new.dart';
import 'package:antizero_jumpin/widget/home/favourite_people.dart';
import 'package:antizero_jumpin/widget/home/plans/spots_gender.dart';
import 'package:antizero_jumpin/widget/profile/edit_button.dart';
import 'package:antizero_jumpin/widget/profile/extra_details.dart';
import 'package:antizero_jumpin/widget/profile/img_swipper.dart';
import 'package:antizero_jumpin/widget/profile/img_swipper_profile.dart';
import 'package:antizero_jumpin/widget/profile/interest_card.dart';
import 'package:antizero_jumpin/widget/profile/profile_items.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int age;
  String address;
  List<FavouriteModelNew> favouriteList = [];
  FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  bool _mPlayerIsInited = false;

  @override
  void initState() {
    getInterest();
    getAgeAndAddress();
    // _mPlayer.openAudioSession().then((value) {
    //   setState(() {
    //     _mPlayerIsInited = true;
    //   });
    // });
    super.initState();
    FirebaseAnalytics.instance
        .logScreenView(screenClass: 'Profile', screenName: 'View Profile');
  }

  setFavourites() async
  {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    JumpInUser user = await getCurrentUser();
    // print('profile user ${user.favourites}');
    if(userProvider.currentUser.favourites != null)
      favouriteList = setFav(context,user.favourites);
    // print('favouriteList ${favouriteList}');
    if(mounted)
    setState(() {

    });
  }

  getInterest() async {
    await getUserInterest(context);
    if(mounted)
      {
        setState(() {

        });
      }
    // if (mounted) await getAgeAndAddress();
  }

  getAgeAndAddress() async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.currentUser.geoPoint != null) {
      String add = await getAddressFromLatLng(
          Lat: userProvider.currentUser.geoPoint['Lat'],
          Long: userProvider.currentUser.geoPoint['Long']);
      if (add != null) address = add;
    }
    if (userProvider.currentUser.dob != null)
      age = getAgeFromDob(userProvider.currentUser.dob);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    stopPlayer();
    // Be careful : you must `close` the audio session when you have finished with it.
    // _mPlayer.closeAudioSession();
    _mPlayer = null;

    super.dispose();
  }

  void play() async {
    var userProvider = Provider.of<UserProvider>(context,listen: false);
    // _mPlayer.openAudioSession().then((value) {
    //   setState(() {
    //     _mPlayerIsInited = true;
    //   });
    // });
    await _mPlayer.startPlayer(
        fromURI: userProvider.currentUser.audio,
        codec: Codec.pcm16WAV,
        whenFinished: () {
          setState(() {});
        });
    setState(() {});
  }

  Future<void> stopPlayer() async {
    if (_mPlayer != null) {
      await _mPlayer.stopPlayer();
    }
  }

  getPlaybackFn() {
    if (!_mPlayerIsInited) {
      return null;
    }
    return _mPlayer.isStopped
        ? play
        : () {
      stopPlayer().then((value) => setState(() {}));
    };
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    var interestProvider = Provider.of<InterestProvider>(context);
    var size = MediaQuery.of(context).size;
    setFavourites();
    getInterest();
    return Container(
        decoration: const BoxDecoration(
        gradient: primaryGradient,
    ),
    child: Scaffold(
    backgroundColor: Colors.white,
    extendBodyBehindAppBar: true,
    appBar: CustomAppBar(
    backgroundColor: Colors.transparent,
    title: '',
    automaticImplyLeading: true,
    labelColor: Colors.white,
    iconColor: Colors.white,
    ),
    body: userProvider.currentUser == null
        ? fadedCircle(80, 80, color: Colors.blue[100])
        : Stack(
          children: [
            Container(
                height: size.height * 0.3,
                child: CachedNetworkImage(
                  imageUrl: userProvider.currentUser.photoList.last,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => SpinKitThreeBounce(
                    size: getScreenSize(context).height * 0.03,
                    color: Colors.white,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )),
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    Container(
                      height: size.height * 0.27,
                      color: Colors.transparent,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.h, vertical: 3.h),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      width: size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${userProvider.currentUser.name}',
                                    textAlign: TextAlign.left,
                                    style: fonts(FontWeight.bold,20.sp,Colors.black),
                                  ),
                                  (age!=null) ? Text(
                                    '${age} years old',
                                    textAlign: TextAlign.left,
                                    style: fonts(FontWeight.normal,12.sp,blue),
                                  ) : Container(),
                                ],
                              ),
                              EditButton(
                              textColor:white,
                              onPress: () async {
                                Navigator.of(context).push(
                                    PageTransition(
                                        child: EditProfilePage(),
                                        type: PageTransitionType
                                            .fade));
                              },
                              label: 'Edit',
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: SpotsGender(
                                    spotlabel: "Connections",
                                    spotNumber: (userProvider.currentUser.connection != null) ?
                                    userProvider.currentUser.connection.length>0 ?
                                    userProvider.currentUser.connection.length : 0 : 0,
                                    color: Colors.blue[50],
                                    numColor: Colors.blue,
                                  )),
                              Expanded(
                                  child: SpotsGender(
                                    spotlabel: "Plans",
                                    spotNumber: userProvider.currentUser.plans != null ?
                                    userProvider.currentUser.plans.length>0 ?
                                        userProvider.currentUser.plans.length : 0 : 0,
                                    color: plangreenlite,
                                    numColor: plangreen,
                                  )),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              title('About Me'),
                              (userProvider.currentUser.audio!=null) ?
                              Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: getPlaybackFn(),
                                      //color: Colors.white,
                                      //disabledColor: Colors.grey,
                                      child: Text(_mPlayer.isPlaying ? 'Stop' : 'Play'),
                                    )
                                  ]): Container(),
                            ],
                          ),
                          SizedBox(height: 5),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            margin: EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              border: Border.all(color: blueborder),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: blueborder.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        width: size.height * 0.02,
                                        height: size.height * 0.02,
                                        alignment: Alignment.topLeft,
                                        child: Image.asset(documentIcon,color: black,)),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        userProvider.currentUser.placeOfWork == null
                                            ? 'No company mentioned'
                                            : userProvider.currentUser.placeOfWork ?? 'Syncing..',
                                        textAlign: TextAlign.center,
                                        style: textStyle1.copyWith(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                        width: size.height * 0.02,
                                        height: size.height * 0.02,
                                        alignment: Alignment.topLeft,
                                        child: Image.asset(locationNIcon,color: black,)),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        userProvider.currentUser.geoPoint == null
                                            ? 'N/A'
                                            : address ?? 'Syncing..',
                                        textAlign: TextAlign.center,
                                        style: textStyle1.copyWith(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                        width: size.height * 0.02,
                                        height: size.height * 0.02,
                                        alignment: Alignment.topLeft,
                                        child: Image.asset(locationNIcon,color: black,)),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        userProvider.currentUser.placeOfEdu ??
                                            'N/A' ?? 'Syncing..',
                                        textAlign: TextAlign.center,
                                        style: textStyle1.copyWith(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          title('Profession'),
                          SizedBox(height: 2,),
                          subtitle(userProvider.currentUser.profession ?? 'N/A'),
                          title('Academic'),
                          SizedBox(height: 2,),
                          subtitle(userProvider.currentUser.academicCourse ?? 'N/A'),
                          SizedBox(height: 2,),
                          title('Bio'),
                          SizedBox(height: 2,),
                          subtitle(userProvider.currentUser.bio ?? 'N/A'),
                          SizedBox(height: 2,),
                          title('I Am on Jumpin For'),
                          SizedBox(height: 2,),
                          subtitle(userProvider.currentUser.inJumpInFor ??
                              'N/A'),
                          SizedBox(height: 5,),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  title('Favourites'),
                                  (favouriteList != null) ? titlenum(favouriteList.length.toString()) :
                                  titlenum('0'),
                                ],
                              ),
                              SizedBox(height: 5,),
                              (favouriteList == null)
                                  ? Center(child: Text('No favourites selected'))
                                  : Container(
                                padding: const EdgeInsets.only(
                                    top: 8.0, left: 8.0,right: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: blueborder),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: blueborder.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: Offset(0, 3), // changes position of shadow
                                    ),
                                  ],),
                                alignment: Alignment.topCenter,
                                child: MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: favouriteList.length,
                                    addSemanticIndexes: true,
                                    shrinkWrap: true,
                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                    itemBuilder: (BuildContext context, int index) =>
                                        FavouriteBox(favourite: favouriteList[index]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  title('My Interests'),
                                  titlenum(userProvider
                                      .currentUser
                                      .interestList
                                      .length
                                      .toString()),
                                ],
                              ),
                              SizedBox(height: 5,),
                              if(userProvider.currentUser.interestList.length>0)
                              Container(
                                height: size.height / 4,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: blueborder),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: blueborder.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: Offset(0, 3), // changes position of shadow
                                    ),
                                  ],),
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                    interestProvider.userInterest.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: InterestCard(
                                          url: interestProvider
                                              .userInterest[index].img,
                                          title: interestProvider
                                              .userInterest[index].name,
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                          SizedBox(height: 2,),
                        ],
                      ),
                    ),
                  ]
                ),
              ),
            ),
          ],
        )
    )
    );
  }

  Widget title(String title) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 0.0, left: 8.0,right: 8.0),
      child: Text(
          title,
          overflow:
          TextOverflow.ellipsis,
          textAlign:
          TextAlign.start,
          maxLines: 4,
          style: bodyStyle(
              context: context,
              size: 16,
              color: Colors.black)),
    );
  }

  Widget subtitle(String subtitle) {
    return Container(
      height: 5.h,
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
            color: Colors.blue[50],
            shape: BoxShape.rectangle,
            border: Border.all(color: blueborder),
            borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.only(
            top: 0.0, left: 8.0),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            subtitle,
            textScaleFactor: 1,
            style: TextStyle(
                fontFamily: sFuiSemi,
                fontSize: SizeConfig.blockSizeHorizontal * 2.9,
                color: Colors.black.withOpacity(0.9),
                fontWeight: FontWeight.w800),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.left,
          ),
        ),
      )
    );
  }
}

titlenum(String length) {
  return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue,
      ),
      child: Center(
        child: Text(
          length ?? '0',
          textScaleFactor: 1,
          style: TextStyle(
              fontFamily: sFuiSemi,
              fontSize: SizeConfig.blockSizeHorizontal * 2.9,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w800),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ));
}
