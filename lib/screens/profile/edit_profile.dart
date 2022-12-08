import 'dart:async';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:antizero_jumpin/handler/college.dart';
import 'package:antizero_jumpin/handler/company.dart';
import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/models/college.dart';
import 'package:antizero_jumpin/models/company.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/models/sub_category.dart';
import 'package:antizero_jumpin/provider/college.dart';
import 'package:antizero_jumpin/provider/company.dart';
import 'package:antizero_jumpin/provider/interest.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/resources/favourites_data.dart';
import 'package:antizero_jumpin/screens/authentication/interest.dart';
import 'package:antizero_jumpin/screens/authentication/phone_verification.dart';
import 'package:antizero_jumpin/services/auth.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/locator.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/utils/validators.dart';
import 'package:antizero_jumpin/widget/audiorecorder/elevatedPlayButton.dart';
import 'package:antizero_jumpin/widget/common/accountLinkButton.dart';
import 'package:antizero_jumpin/widget/common/custom_appbar.dart';
import 'package:antizero_jumpin/widget/common/custom_appbar_profile.dart';
import 'package:antizero_jumpin/widget/common/drop_down_college.dart';
import 'package:antizero_jumpin/widget/common/drop_down_company.dart';
import 'package:antizero_jumpin/widget/common/image_bottom.dart';
import 'package:antizero_jumpin/widget/common/profile_image.dart';
import 'package:antizero_jumpin/widget/common/text_form.dart';
import 'package:antizero_jumpin/widget/dialog_companycode.dart';
import 'package:antizero_jumpin/widget/home/plans/drop_down.dart';
import 'package:antizero_jumpin/widget/profile/interest_block.dart';
import 'package:antizero_jumpin/widget/profile/interest_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:path/path.dart' as path;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:sizer/sizer.dart';

import '../../widget/audiorecorder/elevatedButton.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController uNameController = TextEditingController();
  File imgFile;
  File imageFile;
  String imgUrl;
  FocusNode _uname,
      _name,
      _profession,
      _edu,
      _academic,
      _bio,
      _inJumpIn,
      _submit;
  JumpInUser _currentUser;
  bool updating = false;
  bool expanded = false;
  Map<String, dynamic> selections = {};
  FlutterSoundRecorder _recordingSession;
  final recordingPlayer = AssetsAudioPlayer();
  String pathToAudio;
  bool _playAudio = false;
  Company _selectedCompanyName;
  College _selectedCollegeName;
  List<Company> malcompany;
  List<SubCategory> _interestList;

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
    // await _recordingSession.startRecorder(
    //   toFile: pathToAudio,
    //   codec: Codec.pcm16WAV,
    // );
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
    handleUser();
    print('selections ${selections}');
    _uname = FocusNode();
    _name = FocusNode();
    _profession = FocusNode();
    // _work = FocusNode();
    _edu = FocusNode();
    _academic = FocusNode();
    _bio = FocusNode();
    _inJumpIn = FocusNode();
    _submit = FocusNode();
    initializer();
    getCompanyName();
    // getCollegeName();
    super.initState();
  }

  getCompanyName() async {
    await setCompany(context);
    if(_currentUser.placeOfWork!=null)
      {
        List<Company> malCompany = Provider.of<CompanyProvider>(context, listen: false).companies;
        for(int i=0;i<malCompany.length;i++)
          {
           if(malCompany[i].companyName == _currentUser.placeOfWork)
             {
               _selectedCompanyName = malCompany[i];
               break;
             }
          }
        setState(() {

        });
      }
  }

  getCollegeName() async
  {
    await setCollege(context);
    if(_currentUser.placeOfEdu!=null)
    {
      List<College> malCollege = Provider.of<CollegeProvider>(context, listen: false).college;
      for(int i=0;i<malCollege.length;i++)
      {
        if(malCollege[i].collegeName == _currentUser.placeOfEdu)
        {
          _selectedCollegeName = malCollege[i];
          break;
        }
      }
      setState(() {

      });
    }
  }

  @override
  void dispose() {
    _uname.dispose();
    _name.dispose();
    _profession.dispose();
    // _work.dispose();
    _edu.dispose();
    _academic.dispose();
    _bio.dispose();
    _inJumpIn.dispose();
    _submit.dispose();
    super.dispose();
  }

  handleUser() {
    UserProvider userProvider =
    Provider.of<UserProvider>(context, listen: false);
    if (userProvider.currentUser != null) {
      _currentUser = userProvider.currentUser;
      uNameController.text = _currentUser.username;
      imgUrl = userProvider.currentUser.photoList.last;
      if(userProvider.currentUser.favourites!=null)
      selections = userProvider.currentUser.favourites;
      _interestList = [];
      if(userProvider.currentUser.placeOfWork!=null)
      {
        _currentUser.placeOfWork = userProvider.currentUser.placeOfWork;
        print('userProvider.currentUser.company ${userProvider.currentUser.placeOfWork}');
      }
    } else {
      _currentUser = JumpInUser();
    }
  }

  selectImage(parentContext) {
    return showModalBottomSheet(
      backgroundColor: Colors.blue[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // camera
                  BuildBottomSheetItem(
                    onTap: handleTakePhoto,
                    itemIcon: FaIcon(
                      FontAwesomeIcons.cameraRetro,
                      color: Colors.lightBlueAccent,
                      size: 25,
                    ),
                    itemName: 'Camera',
                  ),
                  // gallery
                  BuildBottomSheetItem(
                    onTap: handleChooseFromGallery,
                    itemIcon: FaIcon(
                      FontAwesomeIcons.sdCard,
                      color: Colors.lightBlueAccent,
                      size: 25,
                    ),
                    itemName: 'Gallery',
                  ),
                ],
              ),
              TextButton.icon(
                  label: Text(
                    imgFile == null && imgUrl == null
                        ? 'Cancel'
                        : "Remove Image",
                    style:
                    textStyle1.copyWith(color: Colors.white, fontSize: 13),
                  ),
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    if (imgFile != null) {
                      clearImage();
                    } else if (imgUrl != null) {
                      setState(() {
                        imgUrl = null;
                      });
                    }
                    Navigator.pop(context);
                  })
            ],
          ),
        );
      },
    );
  }

  clearImage() {
    setState(() {
      imgFile = null;
      imageFile = null;
    });
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

  handleTakePhoto() async {
    Navigator.pop(context);
    PickedFile _imgFile =
    await ImagePicker().getImage(source: ImageSource.camera);
    if (_imgFile != null) {
      setState(() {
        this.imageFile = File(_imgFile.path);
      });
      await cropImage();
    }
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    PickedFile _imgFile =
    await ImagePicker().getImage(source: ImageSource.gallery);
    if (_imgFile != null) {
      setState(() {
        this.imageFile = File(_imgFile.path);
      });
      await cropImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    InterestProvider interestProv = Provider.of<InterestProvider>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Edit',
              textAlign: TextAlign.center,
              style: bodyStyle(
                context: context,
                size: 18,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        leading:
        IconButton(
            icon:
            Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 22,
            ),
            onPressed: () {
              saveAlertDialog(context);
            }),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // image
              Center(
                child: ShowUserImage(
                  imgFile: imgFile,
                  imgUrl: imgUrl,
                  onPressed: () => selectImage(context),
                ),
              ),
              SizedBox(
                height: 20,
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
                padding: const EdgeInsets.only(top: 8.0),
                child: CustomDropDownCompany(
                  label: 'Choose Company',
                  hint: 'Select Company',
                  borderColor: blue,
                  list: Provider.of<CompanyProvider>(context, listen: false).companies
                      .map((Company selected) {
                    return DropdownMenuItem<Company>(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              selected.companyName,
                              maxLines: 2,
                              softWrap: false,
                              style: bodyStyle(
                                  context: context,
                                  size: 12,
                                  color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      value: selected,
                    );
                  }).toList(),
                  onChanged: (Company newSelection)
                  {
                    TextEditingController uCodeController = TextEditingController();
                    FocusNode _ucode = new FocusNode();
                    showCompanyCodeDialog(context, _ucode, uCodeController,newSelection);
                  },
                  selectedValue: _selectedCompanyName,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: linearGrad,
                ),
                child: Column(
                  children: [
                    // user name
                    CustomFormField(
                      label: 'User Name',
                      focus: _uname,
                      hint: 'Enter your user name',
                      controller: uNameController,
                      inputType: TextInputType.name,
                      validatorFn: unameValidator,
                      onChanged: (String val) {},
                      onFiledSubmitted: (String value) {
                        _uname.unfocus();
                        FocusScope.of(context).requestFocus(_name);
                      },
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    CustomFormField(
                      label: 'Name',
                      focus: _name,
                      hint: 'Enter your name',
                      initValue: userProvider.currentUser.name,
                      inputType: TextInputType.name,
                      validatorFn: nameValidator,
                      onChanged: (String val) {
                        _currentUser.name = val;
                      },
                      onFiledSubmitted: (String value) {
                        _name.unfocus();
                        FocusScope.of(context).requestFocus(_profession);
                      },
                    ),

                    // profession
                    SizedBox(
                      height: 20,
                    ),
                    CustomFormField(
                      label: 'Profession',
                      focus: _profession,
                      hint: 'Enter your profession',
                      initValue: userProvider.currentUser.profession,
                      inputType: TextInputType.text,
                      validatorFn: professionValidator,
                      onChanged: (String val) {
                        _currentUser.profession = val;
                      },
                      onFiledSubmitted: (String value) {
                        _profession.unfocus();
                      },
                    ),
                    // place of work
                    SizedBox(
                      height: 20,
                    ),
                    // place of education
                    CustomFormField(
                      label: 'Place of Education',
                      focus: _edu,
                      hint: 'Enter your place of education',
                      initValue: userProvider.currentUser.placeOfEdu,
                      inputType: TextInputType.text,
                      validatorFn: eduValidator,
                      onChanged: (String val)
                      {
                        _currentUser.placeOfEdu = val;
                      },
                      onFiledSubmitted: (String value) {
                        _edu.unfocus();
                        FocusScope.of(context).requestFocus(_academic);
                      },
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 8.0),
                    //   child: CustomDropDownCollege(
                    //     label: 'Place of Education',
                    //     hint: 'Enter your place of education',
                    //     borderColor: blue,
                    //     list: Provider.of<CollegeProvider>(context, listen: false).college
                    //         .map((College selected) {
                    //       return DropdownMenuItem<College>(
                    //         child: Row(
                    //           children: [
                    //             Expanded(
                    //               child: Text(
                    //                 selected.collegeName,
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
                    //     onChanged: (College newSelection)
                    //     {
                    //
                    //     },
                    //     selectedValue: _selectedCollegeName,
                    //   ),
                    // ),
                    // academic course
                    SizedBox(
                      height: 20,
                    ),
                    CustomFormField(
                      label: 'Academic Course',
                      focus: _academic,
                      hint: 'Enter your academic course',
                      initValue: userProvider.currentUser.academicCourse,
                      inputType: TextInputType.text,
                      validatorFn: workValidator,
                      onChanged: (String val) {
                        _currentUser.academicCourse = val;
                      },
                      onFiledSubmitted: (String value) {
                        _academic.unfocus();
                        FocusScope.of(context).requestFocus(_bio);
                      },
                    ),

                    // bio
                    SizedBox(
                      height: 20,
                    ),
                    CustomFormField(
                      label: 'Bio',
                      maxLine: 3,
                      focus: _bio,
                      hint: 'Enter your bio',
                      initValue: userProvider.currentUser.bio,
                      inputType: TextInputType.text,
                      validatorFn: bioValidator,
                      onChanged: (String val) {
                        _currentUser.bio = val;
                      },
                      onFiledSubmitted: (String value) {
                        _bio.unfocus();
                        FocusScope.of(context).requestFocus(_inJumpIn);
                      },
                    ),

                    // in jumpIn for
                    SizedBox(
                      height: 20,
                    ),
                    CustomFormField(
                      label: 'In JumpIn for',
                      maxLine: 3,
                      focus: _inJumpIn,
                      hint: 'I\'m here for',
                      initValue: userProvider.currentUser.inJumpInFor,
                      inputType: TextInputType.text,
                      validatorFn: jumpValidator,
                      onChanged: (String val) {
                        _currentUser.inJumpInFor = val;
                      },
                      onFiledSubmitted: (String value) {
                        _inJumpIn.unfocus();
                        FocusScope.of(context).requestFocus(_submit);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Interests',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () async {
                                  _interestList =
                                  await Navigator.of(context)
                                      .push<List<SubCategory>>(
                                      PageTransition(
                                          child: InterestPage(fromFilter: false,fromProfile: true,),
                                          type: PageTransitionType.fade));
                                  if (!(_interestList.isEmpty))
                                  {
                                    userProvider.setPresetSelectedInterets(_interestList);
                                    List<String> malInterest = new List<String>();
                                    for (var i = 0; i < _interestList.length; i++) {
                                      malInterest.add(_interestList[i].id);
                                    }
                                    interestProv.setSelectedSubCategories(malInterest);
                                    _currentUser.interestList = malInterest;
                                  }
                                  setState(() {});
                                },
                                child: Text(
                                  'Select Interests',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.width * 0.018,
                        ),
                        Container(
                          height: size.height * 0.128,
                          width: MediaQuery.of(context).size.width,
                          child: _interestList.isEmpty
                              ? Center(
                            child: Text(
                              'No interests selected',
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                              ),
                            ),
                          )
                              : ListView.builder(
                              itemCount: _interestList.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                  child: InterestCard(
                                    url: _interestList[index].img,
                                    title: _interestList[index].name,
                                    size: MediaQuery.of(context).size.height * 0.04,
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Favourites',
                          style: headingStyle(
                              context: context,
                              size: 17,
                              color: Colors.black54)
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:
                      !expanded ? favData.length : expandedFavData.length,
                      addSemanticIndexes: true,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (BuildContext context, int index) =>
                          InterestBlock(
                            favourite:
                            !expanded ? favData[index] : expandedFavData[index],
                            onTap: () {
                              showTextInputDialog(
                                barrierDismissible: false,
                                title: 'Favourite ${!expanded ? favData[index]
                                    .label :
                                expandedFavData[index].label}',
                                context: context,
                                textFields: [
                                  DialogTextField(),
                                ],
                              ).then((value) {
                                if (value != null && value[0] != null && value[0] != '') {
                                  selections.addAll({
                                    '${!expanded
                                        ? favData[index].label
                                        : expandedFavData[index].label}':
                                    value,
                                  });
                                }
                                print('Selections : $selections');
                              });
                            },
                          ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              expanded = !expanded;
                            });
                          },
                          child: Text(expanded ? '- See Less' : '+ See more'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.vibrate();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PhoneNumberScreen(isFromProfile: true,),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Update Phone Number',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // submit button
              SizedBox(
                height: 20,
              ),
              CustomLogoButton(
                focus: _submit,
                logo: logoIcon,
                color: Colors.redAccent[100],
                title: 'Update',
                onTap: () async
                {
                  saveInformation();
                },
                loading: updating,
              ),
              SizedBox(
                height: 10,
              ),
              CustomLogoButton(
                focus: _submit,
                logo: null,
                color: Colors.redAccent[100],
                title: 'Delete Account',
                onTap: () async
                {
                  deleteAccount();
                },
                loading: updating,
              ),
            ],
          ),
        ),
      ),
    );
  }



  showCompanyCodeDialog(BuildContext context,FocusNode _uname,TextEditingController uCodeController,
      Company newSelection) {
    return showDialog(
      context: context,
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              height: 30.h,
              width: 80.w,
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.w),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomFormField(
                    label: 'Enter pass code for this company',
                    focus: _uname,
                    hint: 'Enter your code',
                    controller: uCodeController,
                    inputType: TextInputType.name,
                    validatorFn: null,
                    onChanged: (String val) {},
                    onFiledSubmitted: (String value) {
                      _uname.unfocus();
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async
                          {
                            if((uCodeController.text.length>0))
                            {
                              if(newSelection.passCode == uCodeController.text.toString())
                              {
                                _currentUser.placeOfWork = newSelection.companyName;
                                setState(()
                                {
                                  _selectedCompanyName = newSelection;
                                  _currentUser.placeOfWork = _selectedCompanyName.companyName;
                                });
                                showToast('Company changed');
                                Navigator.pop(context);
                              }
                              else
                              {
                                showToast('Please enter right company passcode!');
                              }
                            }
                            else
                            {
                              showToast('Please enter company passcode!');
                            }
                          },
                          child: Text(
                            'Check',
                            style: GoogleFonts.nunitoSans(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void saveInformation() async {
    var userProvider = Provider.of<UserProvider>(context,listen: false);
    _formKey.currentState.save();
    setState(() {
      updating = true;
    });
    if (uNameController.text == _currentUser.username)
    {
      JumpInUser user;
      if(File(pathToAudio).exists() == true)
      {
        File audio = File(pathToAudio);
        user = await userServ
            .updateProfile(_currentUser, imgFile: imgFile,audioFile: audio);
      }
      else
      {
        if(selections!=null)
        {
          _currentUser.favourites = selections;
        }
        user = await userServ.updateProfile(_currentUser,
            imgFile: imgFile);
      }
    }
    else {
      bool uniqueUname =
          await userServ.checkUserName(uNameController.text);

      if (uniqueUname) {
        _currentUser.username = uNameController.text;
        print('_imgFile.path ${imgFile.path}');
        JumpInUser user;
        if(pathToAudio!=null)
        {
          File audio = File(pathToAudio);
          int sizeInBytes = audio.lengthSync();
          double sizeInMb = sizeInBytes / (1024 * 1024);
          if (sizeInMb > 20){
            // This file is Longer then 10MB
            showToast('Audio file is too large.Please record it again.');
          }
          else
          {
            user = await userServ
                .updateProfile(_currentUser, imgFile: imgFile,audioFile: audio);
          }
        }
        else
        {
          user = await userServ
              .updateProfile(_currentUser, imgFile: imgFile);
        }
        if (user != null) {
          userProvider.currentUser = user;
          Navigator.pop(context);
        } else {
          showToast('Something went wrong!');
        }
      } else {
        showToast('User name is not unique!');
      }
    }
    setState(() {
      updating = false;
    });
  }

  saveAlertDialog(BuildContext context) {
      // set up the buttons
      Widget cancelButton = ElevatedButton(
        child: Text("Cancel"),
        onPressed:  () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      );
      Widget continueButton = ElevatedButton(
        child: Text("Update"),
        onPressed:  () {
          Navigator.pop(context);
          setState(()
          {
            updating = true;
          });
          saveInformation();
          Navigator.pop(context);
        },
      );
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Update!"),
        content: Text("Are you sure you want to update the information?"),
        actions:
        [
          cancelButton,
          continueButton,
        ],
      );
      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return alert;
        },
      );
    }

  void deleteAccount() async
  {
    // await authProvider.signOut();
    // 1 - deactivate true // 0 - deactivate false
    int deactivate = 1;
    await userServ.deactivateAccount(context,AuthService().currentAppUser.uid,deactivate);
    // delete existing user
    await userServ.deleteFirebaseUser();
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.currentUser.deactivate = deactivate;

  }
}

