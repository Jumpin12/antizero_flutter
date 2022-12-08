import 'package:antizero_jumpin/handler/home.dart';
import 'package:antizero_jumpin/handler/interest.dart';
import 'package:antizero_jumpin/handler/local.dart';
import 'package:antizero_jumpin/handler/plan.dart';
import 'package:antizero_jumpin/handler/recommend.dart';
import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/handler/user.dart';
import 'package:antizero_jumpin/models/favourite_model.dart';
import 'package:antizero_jumpin/models/favourite_new_model.dart';
import 'package:antizero_jumpin/models/friend_request.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/models/member.dart';
import 'package:antizero_jumpin/models/sub_category.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/widget/common/favouritebox.dart';
import 'package:antizero_jumpin/widget/common/gridbox.dart';
import 'package:antizero_jumpin/widget/home/card_buttons.dart';
import 'package:antizero_jumpin/widget/home/favourite_people.dart';
import 'package:antizero_jumpin/widget/profile/interest_block.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HomePeopleNewCard extends StatefulWidget {

  final Widget centerImage;
  final Widget userName;
  final List<Member> members;
  final String planName;
  final String userId;
  final Widget vibe;
  final Widget upperRight;
  final Widget lowerLeft;
  final Widget jumpInButton;
  final Widget recommendButton;
  final Function onUserTap;
  final bool plan;
  final bool public;
  final bool addMem;
  final String gender;
  final Map<String, dynamic> currentUserGeo;
  final Map<String, dynamic> anotherUserGeo;
  final String distance;
  final JumpInUser user;
  final ScrollController scrollController;
  final int people;
  final int plans;
  final Map<String,dynamic> favourites;
  final Widget academic,work,education,profession,bio,injumpinfor;
  final String audio;

  const HomePeopleNewCard({
    Key key,
    this.people,
    this.plans,
    this.centerImage,
    this.userName,
    this.members,
    this.planName,
    this.userId,
    this.vibe,
    this.upperRight,
    this.lowerLeft,
    this.jumpInButton,
    this.recommendButton,
    this.onUserTap,
    this.plan = false,
    this.public = true,
    this.addMem = false,
    this.gender,
    this.currentUserGeo,
    this.anotherUserGeo,
    this.distance,
    this.user,
    this.scrollController,
    this.favourites,this.academic,this.work,this.education,this.profession,this.bio,this.injumpinfor,this.audio
  }) : super(key: key);

  @override
  _HomePeopleNewCardState createState() => _HomePeopleNewCardState();
}

class _HomePeopleNewCardState extends State<HomePeopleNewCard> {
  List<SubCategory> mutualInterest = [];
  List<FavouriteModelNew> favouriteList = [];
  bool calcDistance = false;
  String distance;
  String title = '';
  FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  bool _mPlayerIsInited = false;

  @override
  void initState() {
    super.initState();
    if(widget.favourites!=null) favouriteList = setFav(context,widget.favourites);
    if (widget.distance == null) setDistance();
    getInterest();
    if(widget.audio!=null) {
      // _mPlayer.openAudioSession().then((value) {
      //   setState(() {
      //     _mPlayerIsInited = true;
      //   });
      // });
    }
  }

  getInterest() async {
    if (mounted) await getMutualInterestList();
  }

  getMutualInterestList() async {
    List<SubCategory> _mutualInterests = await getMutualInterest(widget.user, context);
    if (_mutualInterests != null)
    {
      mutualInterest = _mutualInterests;
      title = 'Mutual Interest';
    }
    else
    {
      _mutualInterests = await getOtherInterest(widget.user, context);
      if(_mutualInterests != null)
        {
          mutualInterest = _mutualInterests;
          title =  'Interests';
        }
    }
    if (mounted) setState(() {});
  }

  setDistance() async {
    if (widget.currentUserGeo != null && widget.anotherUserGeo != null) {
      double dist = await calculateDistance(
          startLat: widget.currentUserGeo['Lat'],
          startLong: widget.currentUserGeo['Long'],
          endLat: widget.anotherUserGeo['Lat'],
          endLong: widget.anotherUserGeo['Long']);
      if (dist != null) distance = '${(dist / 1000).toStringAsFixed(2)} Km';
      calcDistance = true;
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    stopPlayer();
    // Be careful : you must `close` the audio session when you have finished with it.
    // _mPlayer.closeAudioSession();
    _mPlayer = null;

    super.dispose();
  }

  // -------  Here is the code to playback a remote file -----------------------

  void play() async {
    // _mPlayer.openAudioSession().then((value) {
    //   setState(() {
    //     _mPlayerIsInited = true;
    //   });
    // });
    await _mPlayer.startPlayer(
        fromURI: widget.audio,
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

  // --------------------- UI -------------------

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
    var size = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.82,
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
                      margin: EdgeInsets.only(left:8,right: 8, top: 8),
                      child: ListView(
                        children: <Widget>[
                          Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.only(left: 8, top: 8,right: 8,bottom: 8),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Padding(padding: const EdgeInsets.all(4.0),
                                                  child: SizedBox(
                                                    width: 80,
                                                    child: Text(
                                                        widget.plans.toString(),
                                                        textAlign:
                                                        TextAlign.center,
                                                        style: bodyStyle(
                                                            context: context,
                                                            size: 12,
                                                            color: blue,
                                                            fontWeight: FontWeight.bold)),
                                                  ),
                                                ),
                                                Padding(padding: const EdgeInsets.all(4.0),
                                                  child: SizedBox(
                                                    width: 80,
                                                    child: Text('Plans',
                                                        textAlign:
                                                        TextAlign.center,
                                                        style: bodyStyle(
                                                            context: context,
                                                            size: 12,
                                                            color: Colors.black)),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.only(left: 8, top: 8,right: 8,bottom: 8),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Padding(padding: const EdgeInsets.all(4.0),
                                                  child: SizedBox(
                                                    width: 80,
                                                    child: Text(
                                                        widget.people.toString(),
                                                        textAlign:
                                                        TextAlign.center,
                                                        style: bodyStyle(
                                                            context: context,
                                                            size: 12,
                                                            color: blue,
                                                            fontWeight: FontWeight.bold)),
                                                  ),
                                                ),
                                                Padding(padding: const EdgeInsets.all(4.0),
                                                  child: SizedBox(
                                                    width: 80,
                                                    child: Text(
                                                        'People',
                                                        textAlign:
                                                        TextAlign.center,
                                                        style: bodyStyle(
                                                            context: context,
                                                            size: 12,
                                                            color: Colors.black)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(top: 8,bottom: 8),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              widget.centerImage,
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(left: 8, top: 8,right: 8,bottom: 8),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Align(
                                                alignment: Alignment.center,
                                                child: ImageIcon(
                                                  AssetImage(locationNIcon),
                                                  color: Colors.blue.withOpacity(0.9),
                                                  size: SizeConfig.blockSizeHorizontal * 6,
                                                ),
                                              ),
                                              Padding(padding: const EdgeInsets.all(4.0),
                                                child: SizedBox(
                                                  width: 80,
                                                  child: Text(
                                                      widget.distance != null ? widget.distance : distance ?? "N/A",
                                                      textAlign:
                                                      TextAlign.center,
                                                      style: bodyStyle(
                                                          context: context,
                                                          size: 12,
                                                          color: Colors.black)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(left: 8, top: 8,right: 8,bottom: 8),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Align(
                                                alignment: Alignment.center,
                                                child:
                                                widget.gender=='Female' ?
                                                Icon(Icons.female_outlined, color: Colors.blue.withOpacity(0.9), size: SizeConfig.blockSizeHorizontal * 6) :
                                                Icon(Icons.male_outlined, color: Colors.blue.withOpacity(0.9), size: SizeConfig.blockSizeHorizontal * 6),
                                              ),
                                              Padding(padding: const EdgeInsets.all(4.0),
                                                child: SizedBox(
                                                  width: 80,
                                                  child: Text(
                                                      widget.gender ?? 'N/A',
                                                      textAlign:
                                                      TextAlign.center,
                                                      style: bodyStyle(
                                                          context: context,
                                                          size: 12,
                                                          color: Colors.black)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              widget.userName,
                              SizedBox(width: 20),
                              (widget.audio!=null) ?
                              Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: getPlaybackFn(),
                                      //color: Colors.white,
                                      //disabledColor: Colors.grey,
                                      child: Text(_mPlayer.isPlaying ? 'Stop' : 'Play'),
                                    )
                                  ]) : Container(),
                            ],
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0,top: 8.0),
                              child: Text(title,
                                  textScaleFactor: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ColorsJumpIn.kPrimaryColor,
                                      fontSize: SizeConfig.blockSizeHorizontal * 3.7)),
                            ),
                          ),
                          mutualInterest == null
                              ? Center(child: Text('No $title')) :
                          Container(
                            height: 18.h,
                            margin: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                border: Border.all(color: blueborder),
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0,top: 8.0,bottom: 8.0),
                              child: Container(
                                child: ListView.builder(
                                          physics: ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: mutualInterest.length,
                                          itemBuilder: (context, index) {
                                            return GridBox(
                                              color: Colors.transparent,
                                              subCatImage: mutualInterest[index].img,
                                              label: mutualInterest[index].name,
                                            );
                                          }
                                          ),
                              ),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0,top: 8.0),
                              child: RichText(
                                text: TextSpan(
                                  text:
                                  '${widget.user.username.toUpperCase()}\'S',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: ' WALL OF FAVOURITES',
                                      style: GoogleFonts.dancingScript(
                                        color: Theme.of(context).primaryColorDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          widget.favourites == null
                              ? Center(child: Text('No favourites selected'))
                              : Container(
                            margin: EdgeInsets.all(8.0),
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
                                  FavouriteBox(
                                      favourite: favouriteList[index]
                                  ),
                          ),
                              ),
                          widget.academic,
                          widget.work,
                          widget.education,
                          widget.profession,
                          widget.bio,
                          widget.injumpinfor
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              margin: EdgeInsets.all(4.0),
                              child: widget.jumpInButton),
                          Container(
                              margin: EdgeInsets.all(4.0),
                              child: widget.recommendButton),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
