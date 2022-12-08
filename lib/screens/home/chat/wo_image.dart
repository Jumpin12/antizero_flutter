import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:antizero_jumpin/handler/chat.dart';
import 'package:antizero_jumpin/handler/local.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/decoration.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/widget/chat/messages.dart';
import 'package:antizero_jumpin/widget/common/text_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_feedback/emoji_feedback.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';

class ChatWithoutImage extends StatefulWidget {
  final TextEditingController controller;
  final Function onSend;
  final Function onImage;
  final int count;
  final Function(BuildContext, int) builder;
  const ChatWithoutImage(
      {Key key,
      this.controller,
      this.onSend,
      this.onImage,
      this.count,
      this.builder})
      : super(key: key);

  @override
  _ChatWithoutImageState createState() => _ChatWithoutImageState();
}

class _ChatWithoutImageState extends State<ChatWithoutImage> {
  Stream<QuerySnapshot> chats;
  bool loading = true;
  bool showEmojiKeyboard = false;
  StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    getChats();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible == false) {
        FocusScope.of(context).requestFocus(FocusNode());
        if (showEmojiKeyboard == true)
          setState(() {
            showEmojiKeyboard = false;
          });
      }
    });
    super.initState();
  }

  getChats() async {
    var _chats = await getChatFromCurrentPeople(context);
    if (_chats != null)
    {
      chats = _chats;
    }
    loading = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return userProvider.chatWithUser == null || loading == true
        ? fadedCircle(32, 32, color: Colors.blue[100])
        : GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              if (showEmojiKeyboard == true)
                setState(() {
                  showEmojiKeyboard = false;
                });
            },
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: chats == null
                          ? Center(
                              child: Text(
                              'Hey, Start a new conversation!',
                              textAlign: TextAlign.center,
                              style: bodyStyle(
                                  context: context,
                                  size: 16,
                                  color: Colors.black54),
                            ))
                          : ChatMessages(
                              chats: chats,
                              people: true,
                            ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Container(
                          color: Colors.transparent,
                          height: getScreenSize(context).height * 0.05,
                          width: getScreenSize(context).width,
                          child: ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.count,
                              itemBuilder: widget.builder),
                        ),
                        SizedBox(height: 10),
                        LayoutBuilder(builder: (context, constraints) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                  child: CustomFormField(
                                controller: widget.controller,
                                inputType: TextInputType.multiline,
                                maxLine: 5,
                                minLine: 1,
                                border: rectBorder,
                                hint: 'Type a Message',
                                prefix: IconButton(
                                  onPressed: () {
                                    if (showEmojiKeyboard == true) {
                                      setState(() {
                                        showEmojiKeyboard = false;
                                      });
                                    } else {
                                      setState(() {
                                        showEmojiKeyboard = true;
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.emoji_emotions_outlined,
                                    size: 22,
                                    color: blue,
                                  ),
                                ),
                                suffix: IconButton(
                                  onPressed: widget.onImage,
                                  icon: Icon(
                                    Icons.image,
                                    size: 22,
                                    color: blue,
                                  ),
                                ),
                              )),
                              SizedBox(width: 5),
                              FloatingActionButton(
                                onPressed: widget.onSend,
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  alignment: Alignment.centerRight,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: buttonGradient,
                                  ),
                                  child: Center(
                                    child: Icon(Icons.send),
                                  ),
                                ),
                              )
                            ],
                          );
                        }),
                        SizedBox(height: 10)
                      ],
                    ),
                  ),
                  if (showEmojiKeyboard == true)
                    Expanded(
                      flex: 4,
                      child: EmojiPicker(
                        onEmojiSelected: (category, emoji) {
                          widget.controller.text =
                              "${widget.controller.text}${emoji.emoji}";
                          widget.controller.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: widget.controller.text.length));
                        },
                        onBackspacePressed: () {
                          widget.controller.text = widget
                              .controller.text.characters
                              .skipLast(1)
                              .string;
                          widget.controller.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: widget.controller.text.length));
                        },
                        config: Config(
                          columns: 7,
                          emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          initCategory: Category.RECENT,
                          bgColor: Color(0xFFF2F2F2),
                          indicatorColor: Colors.blue,
                          iconColor: Colors.grey,
                          iconColorSelected: Colors.blue,
                          progressIndicatorColor: Colors.blue,
                          backspaceColor: Colors.blue,
                          skinToneDialogBgColor: Colors.white,
                          skinToneIndicatorColor: Colors.grey,
                          enableSkinTones: true,
                          showRecentsTab: true,
                          recentsLimit: 28,
                          noRecents: const Text(
                            'No Recents',
                            style: TextStyle(fontSize: 20, color: Colors.black26),
                            textAlign: TextAlign.center,
                          ),
                          tabIndicatorAnimDuration: kTabScrollDuration,
                          categoryIcons: const CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL,
                        ),
                      ),
                    )
                ],
              ),
            ),
          );
  }
}
