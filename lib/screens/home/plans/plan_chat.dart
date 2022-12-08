import 'dart:io';
import 'dart:ui';

import 'package:antizero_jumpin/handler/notification.dart';
import 'package:antizero_jumpin/handler/plan.dart';
import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/models/plan.dart';
import 'package:antizero_jumpin/provider/plan.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/screens/home/chat/with_image.dart';
import 'package:antizero_jumpin/screens/home/plans/chat_woImage.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/predefined_msg.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/widget/common/image_picker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PlanChatPage extends StatefulWidget {
  const PlanChatPage({Key key}) : super(key: key);

  @override
  _PlanChatPageState createState() => _PlanChatPageState();
}

class _PlanChatPageState extends State<PlanChatPage> {
  TextEditingController msgController = TextEditingController();
  PickedFile imgFile;
  File imageFile;
  bool sending = false;

  handleTakePhoto() async {
    Navigator.pop(context);
    PickedFile _imgFile =
        await ImagePicker().getImage(source: ImageSource.camera);
    if (_imgFile != null) {
      setState(() {
        this.imgFile = _imgFile;
        imageFile = File(_imgFile.path);
      });
    }
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    PickedFile _imgFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (_imgFile != null) {
      setState(() {
        this.imgFile = _imgFile;
        imageFile = File(_imgFile.path);
      });
    }
  }

  clearImage() {
    setState(() {
      imageFile = null;
      imgFile = null;
    });
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
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);

    //Set User Online
    // setOnlineOfflineStatusOfPlanMember(context, true);

    //Update Unseen Count of Current User
    //  updateMsgCountOfEachPlanMember(context);
    FirebaseAnalytics.instance.logScreenView(
      screenName: 'Plan Chat Screen',
      screenClass: 'Plans',
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('AppLifecycleState ${state.name}');
    if (state == AppLifecycleState.resumed) {
      //Set User Online
      // setOnlineOfflineStatusOfPlanMember(context, true);

      //Update Unseen Count of Current User
       updateMsgCountOfEachPlanMember(context);
    } else {
      //Set User Offline
      // setOnlineOfflineStatusOfPlanMember(context, false);
    }
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var planProvider = Provider.of<PlanProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: imgFile == null
          ? PlanChatWithoutImage(
              controller: msgController,
              onImage: () {
                buildDialog(context);
              },
              onSend: () async {
                if (msgController.text.isNotEmpty) {
                  setState(() {
                    sending = true;
                  });
                  bool send = await sendPlanMsg(msgController.text, context);
                  if (send) {
                    String textMsg = msgController.text.toString();
                    msgController.clear();
                    List<String> userIds = getCurrentPlanAcceptedMembers(
                        planProvider.currentPlan.member);
                    List<String> otherUsers = userIds
                        .where(
                            (element) => element != userProvider.currentUser.id)
                        .toList();
                    for (int i = 0; i < otherUsers.length; i++) {
                      await newPlanChatNotification(
                          textMsg,
                          userProvider.currentUser.id,
                          otherUsers[i],
                          planProvider.currentPlan.planName,
                          planProvider.currentPlan.id);
                    }
                  } else {
                    showToast('Oops.... Error!');
                  }
                  setState(() {
                    sending = false;
                  });
                }
              },
              count: preDefinedMsg.length,
              builder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    bool send =
                        await sendPlanMsg(preDefinedMsg[index], context);
                    if (send == false) {
                      showToast('Oops.... Error!');
                    } else {
                      List<String> userIds = getCurrentPlanAcceptedMembers(
                          planProvider.currentPlan.member);
                      List<String> otherUsers = userIds
                          .where((element) =>
                              element != userProvider.currentUser.id)
                          .toList();
                      for (int i = 0; i < otherUsers.length; i++) {
                        await newPlanChatNotification(
                            preDefinedMsg[index],
                            userProvider.currentUser.id,
                            otherUsers[i],
                            planProvider.currentPlan.planName,
                            planProvider.currentPlan.id);
                      }
                    }
                    setState(() {});
                  },
                  child: Container(
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: blue)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 3),
                      child: Center(
                        child: Text(
                          preDefinedMsg[index],
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: bodyStyle(
                              context: context,
                              size: 13,
                              color: Colors.black54),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : ChatWithImage(
              imageFile: imageFile,
              onClear: () {
                clearImage();
              },
              onCrop: () async {
                await cropImage();
              },
              onSend: () async {
                if (imageFile != null) {
                  setState(() {
                    sending = true;
                  });
                  bool send =
                      await sendPlanMsg('', context, imgFile: imageFile);
                  if (send) {
                    imgFile = null;
                    imageFile = null;
                  } else {
                    showToast('Oops.... Error!');
                  }
                }
                setState(() {});
              },
              loading: sending,
            ),
    );
  }
}
