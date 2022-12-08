import 'dart:convert';

import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/widget/common/fade_animation.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:linkwell/linkwell.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final DateTime time;
  final String senderPic;
  final String imgMsg;
  final bool sentByMe;
  final bool isFromPeople;

  MessageTile(
      {this.message,
      this.sender,
      this.time,
      this.senderPic,
      this.imgMsg,
      this.sentByMe,
      this.isFromPeople});

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  showImage() {
    return widget.senderPic == ''
        ? CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(avatarIcon),
          )
        : CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(widget.senderPic),
          );
  }

  enlargeImage(parentContext) {
    return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Stack(children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                image: DecorationImage(
                  image: NetworkImage(widget.imgMsg),
                )),
            // child: Image.network(widget.imgMsg, fit: BoxFit.cover,),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0, right: 10.0),
              child: Card(
                color: Colors.black.withOpacity(0.3),
                child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 22,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
            ),
          ),
        ]);
      },
    );
  }

  BuildImgMsgField() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: InkWell(
        onTap: () {
          enlargeImage(context);
        },
        child: Container(
          padding: EdgeInsets.only(
              top: 4,
              bottom: 4,
              left: widget.sentByMe ? 0 : 24,
              right: widget.sentByMe ? 24 : 0),
          alignment:
              widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: widget.sentByMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              senderNameCard(),
              SizedBox(height: 10.0),
              Column(
                crossAxisAlignment: widget.sentByMe
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 250,
                    width: 180,
                    margin: widget.sentByMe
                        ? EdgeInsets.only(left: 30)
                        : EdgeInsets.only(right: 30),
                    padding:
                        EdgeInsets.only(top: 2, bottom: 2, left: 2, right: 2),
                    decoration: BoxDecoration(
                        borderRadius: widget.sentByMe
                            ? BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10))
                            : BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                        color: widget.sentByMe ? blue : Colors.grey[350],
                        image: DecorationImage(
                          image: NetworkImage(widget.imgMsg),
                          fit: BoxFit.cover,
                        )),
                    // child: Image.network(widget.imgMsg, fit: BoxFit.cover),
                  ),
                  msgTimeCard(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isValidUrl(string) {
    // return Uri.parse(string).isAbsolute;
    return Uri.tryParse(string)?.hasAbsolutePath ?? false;
  }

  senderNameCard() {
    return Row(
      mainAxisAlignment:
          widget.sentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        widget.sentByMe ? Container() : showImage(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Align(
            alignment:
                widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(widget.sender.toUpperCase(),
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.8),
                    letterSpacing: -0.5,
                    fontFamily: sFui)),
          ),
        ),
        widget.sentByMe ? showImage() : Container(),
      ],
    );
  }

  msgTimeCard() {
    return Container(
      margin: widget.sentByMe
          ? EdgeInsets.only(left: 30)
          : EdgeInsets.only(right: 30),
      child: Text(
          '${DateFormat('jm').format(widget.time)}, ${DateFormat('d MMM').format(widget.time)}',
          textAlign: TextAlign.start,
          style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
              letterSpacing: -0.5,
              fontFamily: sFui)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.imgMsg == ''
        ? Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              padding: EdgeInsets.only(
                top: 4,
                bottom: 4,
                left: widget.sentByMe ? 0 : 24,
                right: widget.sentByMe ? 24 : 0,
              ),
              alignment: widget.sentByMe
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: widget.sentByMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  FadeAnimation(
                    0.2,
                    isValidUrl(widget.message)
                        ? GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              launch(widget.message);
                            },
                            child: Container(
                              margin: widget.sentByMe
                                  ? EdgeInsets.only(left: 30)
                                  : EdgeInsets.only(right: 30),
                              child: AnyLinkPreview(
                                placeholderWidget: Container(
                                  margin: widget.sentByMe
                                      ? EdgeInsets.only(left: 30)
                                      : EdgeInsets.only(right: 30),
                                  padding: EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                    left: 20,
                                    right: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: widget.sentByMe
                                        ? BorderRadius.only(
                                            bottomRight: Radius.circular(10),
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10))
                                        : BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                    color: widget.sentByMe
                                        ? blue
                                        : Colors.grey[100],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      (!(widget.isFromPeople))
                                          ? widget.sentByMe
                                              ? SizedBox(
                                                  height: 0,
                                                  width: 0,
                                                )
                                              : Text(
                                                  widget.sender,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                          : SizedBox(
                                              height: 0,
                                              width: 0,
                                            ),
                                      Text(
                                        widget.message,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          decoration: TextDecoration.underline,
                                          color: widget.sentByMe
                                              ? Colors.white
                                              : Colors.black,
                                          fontFamily: sFui,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                link: widget.message,
                                cache: Duration(days: 7),
                                backgroundColor:
                                    widget.sentByMe ? blue : Colors.grey[100],
                                showMultimedia: true,
                                removeElevation: false,
                                titleStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: widget.sentByMe
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                errorBody: 'No Metadata found',
                                errorTitle: 'No metadata found',
                                errorWidget: Container(
                                  margin: widget.sentByMe
                                      ? EdgeInsets.only(left: 30)
                                      : EdgeInsets.only(right: 30),
                                  padding: EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                    left: 20,
                                    right: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: widget.sentByMe
                                        ? BorderRadius.only(
                                            bottomRight: Radius.circular(10),
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10))
                                        : BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                    color: widget.sentByMe
                                        ? blue
                                        : Colors.grey[100],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      (!widget.isFromPeople)
                                          ? widget.sentByMe
                                              ? SizedBox(
                                                  height: 0,
                                                  width: 0,
                                                )
                                              : Text(
                                                  widget.sender,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                          : SizedBox(
                                              height: 0,
                                              width: 0,
                                            ),
                                      LinkWell(
                                        widget.message,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          decoration: TextDecoration.underline,
                                          color: widget.sentByMe
                                              ? Colors.blue
                                              : Colors.black,
                                          fontFamily: sFui,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                bodyMaxLines: 3,
                                bodyTextOverflow: TextOverflow.ellipsis,
                                bodyStyle: TextStyle(
                                  color: widget.sentByMe
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            margin: widget.sentByMe
                                ? EdgeInsets.only(left: 30)
                                : EdgeInsets.only(right: 30),
                            padding: EdgeInsets.only(
                                top: 10, bottom: 10, left: 20, right: 20),
                            decoration: BoxDecoration(
                              borderRadius: widget.sentByMe
                                  ? BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10))
                                  : BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                              color: widget.sentByMe ? bluebgchat : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: blueborder.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (!widget.isFromPeople)
                                    ? widget.sentByMe
                                        ? SizedBox(
                                            height: 0,
                                            width: 0,
                                          )
                                        : Text(
                                            widget.sender,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                    : SizedBox(
                                        height: 0,
                                        width: 0,
                                      ),
                                LinkWell(
                                  widget.message,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: widget.sentByMe
                                        ? bluetextchat
                                        : Colors.black,
                                    fontFamily: sFui,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Align(
                    alignment: widget.sentByMe
                        ? Alignment.bottomRight
                        : Alignment.bottomLeft,
                    child: msgTimeCard(),
                  ),
                ],
              ),
            ),
          )
        : BuildImgMsgField();
  }
}
