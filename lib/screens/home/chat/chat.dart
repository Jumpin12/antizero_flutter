import 'dart:io';
import 'dart:ui';
import 'package:antizero_jumpin/handler/user.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:antizero_jumpin/handler/chat.dart';
import 'package:antizero_jumpin/handler/notification.dart';
import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/screens/home/chat/with_image.dart';
import 'package:antizero_jumpin/screens/home/chat/wo_image.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/locator.dart';
import 'package:antizero_jumpin/utils/predefined_msg.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/widget/chat/chat_appbar.dart';
import 'package:antizero_jumpin/widget/common/image_picker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  TextEditingController msgController = TextEditingController();
  PickedFile imgFile;
  File imageFile;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool sending = false;
  bool sheetOpen = false;

  handleTakePhoto() async {
    Navigator.pop(context);
    PickedFile _imgFile =
        // ignore: deprecated_member_use
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
        // ignore: deprecated_member_use
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

  // buildDialog(parentContext) {
  //   return showDialog(
  //       barrierDismissible: true,
  //       barrierColor: Colors.black.withOpacity(0.6),
  //       useSafeArea: true,
  //       useRootNavigator: true,
  //       context: parentContext,
  //       builder: (context) {
  //         return BackdropFilter(
  //           filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
  //           child: CustomPopup(
  //             takePhoto: handleTakePhoto,
  //             fromGallery: handleChooseFromGallery,
  //           ),
  //         );
  //       });
  // }

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
    // userServ.updateOnlineOfflineStatusUser(context, true);
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    //Set Unseen Count For Future references
    unseenMsgCountUpdate(context);
    print('unseenMsgCountUpdate ${userProvider.currentPeopleGroup.unseenMsgCount}');
    // if (userProvider.currentPeopleGroup.unseenMsgCount != null)
    // {
    //
    // }
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // Update the Unseen Msg Count
    //
    // });

    FirebaseAnalytics.instance.logScreenView(
      screenName: 'People Chat Screen',
      screenClass: 'Chats',
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    print('didChangeAppLifecycleState');
  }

  @override
  void dispose() {
    msgController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    Widget attachButton(
        {String label,
        Color backgroundColor,
        IconData icon,
        Function() onTap}) {
      return GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: backgroundColor,
              radius: 30,
              child: Icon(
                icon,
                color: Colors.white,
                size: 29,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(label),
          ],
        ),
      );
    }

    Widget bottomSheet({Function() handleGallery, Function() handleCamera}) {
      return Container(
        height: 150,
        width: MediaQuery.of(context).size.width,
        child: Container(
          child: Card(
            child: SizedBox.expand(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  attachButton(
                    label: 'Document',
                    backgroundColor: Colors.indigo,
                    icon: Icons.insert_drive_file,
                  ),
                  attachButton(
                    label: 'Camera',
                    icon: Icons.camera_alt,
                    backgroundColor: Colors.pink,
                    onTap: handleCamera,
                  ),
                  attachButton(
                    label: 'Gallery',
                    backgroundColor: Colors.purple,
                    icon: Icons.insert_photo,
                    onTap: handleGallery,
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: ChatAppBar(
          user: userProvider.chatWithUser,
        ),
      ),
      body: imgFile == null
          ? ChatWithoutImage(
              controller: msgController,
              onImage: () {
                scaffoldKey.currentState.showBottomSheet(
                  (context) => bottomSheet(
                    handleGallery: handleChooseFromGallery,
                    handleCamera: handleTakePhoto,
                  ),
                  backgroundColor: Colors.transparent,
                );
                setState(() {
                  sheetOpen = true;
                });
              },
              onSend: () async {
                if (msgController.text.isNotEmpty) {
                  setState(() {
                    sending = true;
                  });
                  bool send = await sendPeopleMsg(msgController.text, context,userProvider.chatWithUser);
                  if (send == true) {
                    String msg = msgController.text;
                    msgController.clear();
                    // if (userProvider.unseenMsgCount != 0) {
                    //   userProvider.setUnseenMsgCount(0);
                    // }
                    await updateRecent(msg,context,userProvider.chatWithUser);
                    // String toUid = userProvider.currentPeopleGroup.userIds
                    //     .firstWhere((element) =>
                    //         element != userProvider.currentUser.id);
                    // await newPeopleChatNotification(
                    //     userProvider.currentUser.id, toUid);
                    await newPeopleChatNotification(msg,userProvider.currentUser,
                        userProvider.chatWithUser.id);
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
                    bool send = await sendPeopleMsg(preDefinedMsg[index], context,userProvider.chatWithUser);
                    if (send == false) {
                      showToast('Oops.... Error!');
                    } else {
                      String msg = preDefinedMsg[index];
                      if (userProvider.unseenMsgCount != 0) {
                        userProvider.setUnseenMsgCount(0);
                      }
                      await updateRecent(msg,context,userProvider.chatWithUser);
                      // String toUid = userProvider.currentPeopleGroup.userIds
                      //     .firstWhere((element) =>
                      //         element != userProvider.currentUser.id);
                      // await newPeopleChatNotification(
                      //     userProvider.currentUser.id, toUid);
                      await newPeopleChatNotification(msg,userProvider.currentUser,
                          userProvider.chatWithUser.id);
                    }
                    if (mounted) setState(() {});
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
                  bool send = await sendPeopleMsg('', context, userProvider.chatWithUser,imgFile: imageFile);
                  if (send) {
                    String msg = 'image';
                    imgFile = null;
                    imageFile = null;
                    if (userProvider.unseenMsgCount != 0) {
                      userProvider.setUnseenMsgCount(0);
                    }
                    await updateRecent(msg,context,userProvider.chatWithUser);
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
