import 'dart:io';
import 'dart:ui';

import 'package:antizero_jumpin/handler/auth.dart';
import 'package:antizero_jumpin/handler/company.dart';
import 'package:antizero_jumpin/handler/local.dart';
import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/models/company.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/provider/company.dart';
import 'package:antizero_jumpin/provider/interest.dart';
import 'package:antizero_jumpin/services/auth.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/utils/locator.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/utils/validators.dart';
import 'package:antizero_jumpin/widget/audiorecorder/elevatedButton.dart';
import 'package:antizero_jumpin/widget/audiorecorder/elevatedPlayButton.dart';
import 'package:antizero_jumpin/widget/auth/gender_icon.dart';
import 'package:antizero_jumpin/widget/auth/handstack_container.dart';
import 'package:antizero_jumpin/widget/common/accountLinkButton.dart';
import 'package:antizero_jumpin/widget/common/custom_appbar.dart';
import 'package:antizero_jumpin/widget/common/drop_down_company.dart';
import 'package:antizero_jumpin/widget/common/image_picker.dart';
import 'package:antizero_jumpin/widget/common/layout_widget.dart';
import 'package:antizero_jumpin/widget/common/text_form.dart';
import 'package:antizero_jumpin/widget/dialog_companycode.dart';
import 'package:antizero_jumpin/widget/on_board/progress_indicator.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import '../../main.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({Key key}) : super(key: key);

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();
  File imgFile;
  File imageFile;
  JumpInUser currentUser = JumpInUser();
  String selection;
  DateTime dateOfBirth;
  bool registering = false;
  bool loading = true;
  TextEditingController nameController;
  FlutterSoundRecorder _recordingSession;
  final recordingPlayer = AssetsAudioPlayer();
  String pathToAudio;
  bool _playAudio = false;
  // Company _selectedCompanyName;
  // List<Company> malcompany;

  void initializer() async {
    if(Platform.isAndroid)
    {
      final documentDirectory = (await getExternalStorageDirectory()).path;
      pathToAudio = documentDirectory + '/temp.wav';
    }
    else {
      Directory directory = await getTemporaryDirectory();
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        pathToAudio = directory.path + "/temp.wav";
      }
    }
    _recordingSession = FlutterSoundRecorder();
    // await _recordingSession.openAudioSession(
    //     focus: AudioFocus.requestFocusAndStopOthers,
    //     category: SessionCategory.playAndRecord,
    //     mode: SessionMode.modeDefault,
    //     device: AudioDevice.speaker);
    await _recordingSession.setSubscriptionDuration(Duration(
        milliseconds: 10));
    await initializeDateFormatting();
    await Permission.microphone.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }

  Future<void> startRecording() async {
    print('pathToAudio $pathToAudio');
    Directory directory = Directory(path.dirname(pathToAudio));
    if (!directory.existsSync()) {
      directory.createSync();
    }
    // _recordingSession.openAudioSession();
    await _recordingSession.startRecorder(
      toFile: pathToAudio,
      codec: Codec.pcm16WAV,
    );
    // StreamSubscription _recorderSubscription =
    // _recordingSession.onProgress.listen((e) {
    //   var date = DateTime.fromMillisecondsSinceEpoch(
    //       e.duration.inMilliseconds,
    //       isUtc: true);
    //   var timeText = DateFormat('mm:ss:SS', 'en_GB').format(date);
    //   setState(() {
    //     _timerText = timeText.substring(0, 8);
    //     print('_timerText $_timerText');
    //   });
    // });
    // _recorderSubscription.cancel();
    setState(() {

    });
  }

  Future<String> stopRecording() async
  {
    // _recordingSession.closeAudioSession();
    return await _recordingSession.stopRecorder();
  }

  Future<void> playFunc() async {
    recordingPlayer.open(
      Audio.file(pathToAudio),
      autoStart: true,
      showNotification: true,
    );
  }

  Future<void> stopPlayFunc() async {
    recordingPlayer.stop();
  }

  @override
  void initState() {
    nameController = new TextEditingController();
    currentAuthUser();
    initializer();
    // getCompanyName();
    super.initState();
    FirebaseAnalytics.instance.logScreenView(
      screenName: 'User Details Screens',
      screenClass: 'Authentication',
    );
  }

  // getCompanyName() async {
  //   await setCompany(context);
  // }

  currentAuthUser() async {
    var user = await locator.get<AuthService>().currentUser();
    print('user.displayName ${user.displayName}');
    if (user != null) {
      currentUser.name = user.displayName;
      currentUser.email = user.email;
      nameController.text = currentUser.name;
    }
    setState(() {
      loading = false;
    });
  }

  void showError({String errMsg}) {
    final size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: size.width,
          padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
          child: Text(
            errMsg,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.red[800].withOpacity(0.8),
                fontWeight: FontWeight.w500,
                fontSize: size.height * 0.02),
          ),
        );
      },
    );
  }

  handleTakePhoto() async {
    Navigator.pop(context);
    PickedFile _imgFile =
        // ignore: deprecated_member_use
        await ImagePicker().getImage(source: ImageSource.camera);
    if (_imgFile != null) {
      setState(() {
        this.imageFile = File(_imgFile.path);
      });
      await cropImage();
    }
  }

  Future<Null> cropImage() async {
    CroppedFile croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [AndroidUiSettings(
            toolbarTitle: 'Edit',
            hideBottomControls: false,
            toolbarColor: Colors.white,
            toolbarWidgetColor: Colors.black.withOpacity(0.8),
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        ]);
    if (croppedFile != null) {
      setState(() {
        final path = croppedFile.path;
        imageFile = File(path);
        imgFile = File(path);
      });
    }
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    PickedFile _imgFile =
        // ignore: deprecated_member_use
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (_imgFile != null) {
      setState(() {
        this.imageFile = File(_imgFile.path);
      });
      await cropImage();
    }
  }

  buildDialog(parentContext) {
    return showDialog(
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.6),
        useSafeArea: true,
        useRootNavigator: true,
        context: parentContext,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: CustomPopup(
              takePhoto: handleTakePhoto,
              fromGallery: handleChooseFromGallery,
            ),
          );
        });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime(2009),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1970),
        lastDate: DateTime(DateTime.now().year - 13));
    if (picked != null) {
      currentUser.dob = picked;
      setState(() {
        dateOfBirth = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () {
        return Future(() {
          Navigator.of(context).pop();
          return true;
        });
      },
      child: Scaffold(
        appBar: CustomAppBar(
          automaticImplyLeading: false,
          title: '',
          trailing: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                // width: width * 0.4,
                color: Colors.blue[100],
                padding: EdgeInsets.all(width * 0.02),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit,
                      size: height * 0.025,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Edit Interests",
                      style: TextStyle(fontSize: height * 0.02),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: loading
            ? fadedCircle(32, 32, color: Colors.blue[100])
            : CustomLayoutWidget(
                child: Form(
                  key: _signUpKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      HandStackContainer(
                        padding: EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            UpperProgressIndicator(
                              progressImage: progress3,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      getScreenSize(context).height * 0.021),
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () => buildDialog(context),
                                    // child: Neumorphic(
                                    //   style: NeumorphicStyle(
                                    //     shape: NeumorphicShape.convex,
                                    //     depth: 10,
                                    //     surfaceIntensity: 0.5,
                                    //     lightSource: LightSource.top,
                                    //     intensity: 0.8,
                                    //     color: Colors.blue[100],
                                    //   ),
                                    child: Container(
                                      width: getScreenSize(context).width * 0.3,
                                      height:
                                          getScreenSize(context).width * 0.3,
                                      child: imgFile == null
                                          ? Image.asset(
                                              "assets/images/Profile/avatar.png",
                                              fit: BoxFit.cover)
                                          : Image.file(imgFile,
                                              fit: BoxFit.cover),
                                    ),
                                    // ),
                                  ),
                                  Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: GestureDetector(
                                        onTap: () => buildDialog(context),
                                        // child: Neumorphic(
                                        //   style: NeumorphicStyle(
                                        //     shape: NeumorphicShape.convex,
                                        //     // boxShape: NeumorphicBoxShape.circle(),
                                        //     depth: 10,
                                        //     surfaceIntensity: 0.3,
                                        //     lightSource: LightSource.bottomRight,
                                        //     intensity: 0.8,
                                        //     color: Colors.blue[100],
                                        //   ),
                                        child: Container(
                                          width: getScreenSize(context).width *
                                              0.1,
                                          height: getScreenSize(context).width *
                                              0.1,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle),
                                          padding: EdgeInsets.all(
                                              getScreenSize(context).width *
                                                  0.02),
                                          child: FittedBox(
                                              child: Icon(Icons.camera_alt)),
                                        ),
                                        // ),
                                      ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Your voice introduction',
                        style: headingStyle(
                            context: context,
                            size: 17,
                            color: Colors.black54)
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CreateElevatedButton(
                              icon: Icons.mic,
                              iconColor: Colors.blue,
                              onPressFunc: startRecording,
                              label: 'Start \nrecording'
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          _recordingSession!=null ?
                          StreamBuilder<RecordingDisposition>(
                              stream: _recordingSession.onProgress,
                              builder: (context, snapshot){
                                final duration = snapshot.hasData ? snapshot.data.duration :
                                Duration.zero;
                                String twoDigits(int n) => n.toString().padLeft(2,"0");
                                String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
                                String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
                                return Text('$twoDigitMinutes:$twoDigitSeconds');
                              }) : Text('00:00'),
                          SizedBox(
                            width: 20,
                          ),
                          CreateElevatedButton(
                              icon: Icons.stop,
                              iconColor: Colors.blue,
                              onPressFunc: stopRecording,
                              label: 'Stop \nrecording'
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CreateElevatedButtonPlay(
                          icon: _playAudio
                              ? Icons.stop
                              : Icons.play_arrow,
                          iconColor: Colors.white,
                          onPressFunc: (){
                            setState(() {
                              _playAudio = !_playAudio;
                            });
                            if (_playAudio) playFunc();
                            if (!_playAudio) stopPlayFunc();
                          },
                          label: _playAudio ? 'Stop' : 'Play'
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: getScreenSize(context).height * 0.02,
                            left: 15,
                            right: 15),
                        child: CustomFormField(
                          controller: nameController,
                          hint: currentUser.name ?? 'Hey! So your name is',
                          labelText: 'My Name is',
                          inputType: TextInputType.name,
                          validatorFn:
                              currentUser.name != null ? null : nameValidator,
                          onChanged: (String val) {
                            currentUser.name = val;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: getScreenSize(context).height * 0.02,
                            left: 15,
                            right: 15),
                        child: CustomFormField(
                          hint:
                              'Choose something that describes you the best! eg: sassyaisha, reddevil',
                          labelText: 'Username',
                          inputType: TextInputType.name,
                          validatorFn: unameValidator,
                          onChanged: (String val) {
                            currentUser.username = val;
                          },
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 8.0,left: 15,
                      //       right: 15),
                      //   child: CustomDropDownCompany(
                      //     label: 'Choose Company',
                      //     hint: 'Select Company',
                      //     borderColor: blue,
                      //     list: Provider.of<CompanyProvider>(context, listen: false).companies
                      //         .map((Company selected) {
                      //       return DropdownMenuItem<Company>(
                      //         child: Row(
                      //           children: [
                      //             Expanded(
                      //               child: Text(
                      //                 selected.companyName,
                      //                 maxLines: 2,
                      //                 softWrap: false,
                      //                 style: bodyStyle(
                      //                     context: context,
                      //                     size: 12,
                      //                     color: Colors.black),
                      //                 overflow: TextOverflow.ellipsis,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //         value: selected,
                      //       );
                      //     }).toList(),
                      //     onChanged: (Company newSelection) {
                      //       TextEditingController uCodeController = TextEditingController();
                      //       FocusNode _ucode = new FocusNode();
                      //       showCompanyCodeDialog(context, _ucode, uCodeController,newSelection);
                      //       setState(() {
                      //         _selectedCompanyName = newSelection;
                      //         currentUser.placeOfWork = _selectedCompanyName.companyName;
                      //       });
                      //     },
                      //     selectedValue: _selectedCompanyName,
                      //   ),
                      // ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: getScreenSize(context).width * 0.08,
                            vertical: getScreenSize(context).height * 0.02),
                        decoration: BoxDecoration(
                          // shape: NeumorphicShape.convex,
                          borderRadius: BorderRadius.circular(12),
                          // depth: 10,
                          // surfaceIntensity: 0.1,
                          // lightSource: LightSource.top,
                          // intensity: 0.8,
                          color: Colors.grey[200],
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: getScreenSize(context).width * 0.05,
                          vertical: getScreenSize(context).height * 0.02,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Text(
                                'Gender',
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4.5,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GenderIcon(
                                    onTap: () {
                                      currentUser.gender = 'Female';
                                      setState(() {
                                        selection = 'Female';
                                      });
                                    },
                                    selected: selection == 'Female',
                                    genderImg: female,
                                  ),
                                  GenderIcon(
                                    onTap: () {
                                      currentUser.gender = 'Male';
                                      setState(() {
                                        selection = 'Male';
                                      });
                                    },
                                    selected: selection == 'Male',
                                    genderImg: male,
                                  ),
                                  GenderIcon(
                                    onTap: () {
                                      currentUser.gender = 'Binary';
                                      setState(() {
                                        selection = 'Binary';
                                      });
                                    },
                                    selected: selection == 'Binary',
                                    genderImg: binary,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: getScreenSize(context).width * 0.08,
                            vertical: getScreenSize(context).height * 0.02),
                        decoration: BoxDecoration(
                          // shape: NeumorphicShape.convex,
                          borderRadius: BorderRadius.circular(12),
                          // depth: 10,
                          // surfaceIntensity: 0.1,
                          // lightSource: LightSource.top,
                          // intensity: 0.8,
                          color: Colors.grey[200],
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: getScreenSize(context).width * 0.05,
                          vertical: getScreenSize(context).height * 0.02,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: Text(
                                dateOfBirth == null
                                    ? 'D.O.B.'
                                    : '${DateFormat('yMd').format(dateOfBirth)}',
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4.5,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  print('select date');
                                  _selectDate(context);

                                  // DatePicker.showDatePicker(context,
                                  //     showTitleActions: true,
                                  //     minTime: DateTime(1900, 3, 5),
                                  //     maxTime: DateTime(2020, 12, 31),
                                  //     onChanged: (date) {},
                                  //     onConfirm: (date) {
                                  //     currentUser.dob = date;
                                  //       setState(() {
                                  //         dateOfBirth = date;
                                  //       });
                                  //     });
                                },
                                child: ImageIcon(
                                  const AssetImage(calendar),
                                  color: skyBlue1,
                                  size: SizeConfig.blockSizeHorizontal * 7,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                  onTap: () {},
                                  child: Icon(
                                    Icons.beenhere_sharp,
                                    color: Colors.green,
                                    size: SizeConfig.blockSizeHorizontal * 5,
                                  )),
                              Text('Accept all',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: SizeConfig.blockSizeHorizontal *
                                          2.3)),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  ' Terms and Conditons',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[300],
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 2.3),
                                ),
                              )
                            ],
                          ),
                          CustomLogoButton(
                            onTap: () async {
                              bool uniqueUname = await userServ
                                  .checkUserName(currentUser.username);
                              if (uniqueUname)
                              {
                                if(File(pathToAudio).exists()==true)
                                  {
                                    int sizeInBytes = File(pathToAudio).lengthSync();
                                    double sizeInMb = sizeInBytes / (1024 * 1024);
                                    if (sizeInMb > 20){
                                      // This file is Longer then 10MB
                                      showToast('Audio file is too large.Please record it again.');
                                    }
                                  }
                                else if (imgFile == null) {
                                  showError(
                                      errMsg:
                                          "Please select a photo before proceeding!");
                                }
                                else if(File(pathToAudio).exists() == false)
                                {
                                  showError(
                                        errMsg:
                                        "Please record Voice introduction before proceeding!");
                                }
                                else if (currentUser.name == null ||
                                    currentUser.username == null ||
                                    currentUser.gender == null ||
                                    currentUser.dob == null) {
                                  showError(
                                      errMsg: 'Required fields are missing!');
                                } else {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  final form = _signUpKey.currentState;
                                  if (form.validate()) {
                                    form.save();
                                    setState(() {
                                      registering = true;
                                    });
                                    currentUser.interestList =
                                        Provider.of<InterestProvider>(context,
                                                listen: false)
                                            .selectedSubCategories;
                                    await setUser(
                                        context, imgFile, currentUser);
                                    setState(() {
                                      registering = false;
                                    });
                                  }
                                }
                              } else {
                                showToast('User name is not unique!');
                              }
                            },
                            title: 'Start Vibing!',
                            loading: registering,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

}
