import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class RequestCard extends StatefulWidget {
  final String userId;
  final String msg;
  final String msg1;
  final String planName;
  final String planImg;
  final Function onAccept;
  final Function onDeny;
  final Function onChat;
  final Function onTap;
  final bool invitedPlan;
  final bool acceptDenyCard;
  final bool deny;
  final bool deniedPlan;
  final bool public;
  final bool plan;
  final String date;

  const RequestCard({
    Key key,
    this.userId,
    this.msg,
    this.msg1,
    this.planName,
    this.planImg,
    this.onAccept,
    this.onDeny,
    this.onTap,
    this.invitedPlan = false,
    this.onChat,
    this.acceptDenyCard = false,
    this.deny = false,
    this.deniedPlan = false,
    this.public = true,
    this.plan = false,
    this.date,
  }) : super(key: key);

  @override
  _RequestCardState createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  bool loading = true;
  JumpInUser currentUser;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  getUser() async {
    JumpInUser user =
    await locator.get<UserService>().getUserById(widget.userId);
    if (user != null) {
      currentUser = user;
    }
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return fadedCircle(15, 15, color: Colors.blue[500]);
    } else {
      return InkWell(
        child: Ink(
          width: MediaQuery.of(context).size.width - 30,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: IntrinsicHeight(
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.invitedPlan == true || widget.deniedPlan == true
                      ? CircleAvatar(
                    radius: 7.w,
                    backgroundImage: widget.planImg == null
                        ? const AssetImage(avatarIcon)
                        : CachedNetworkImageProvider(widget.planImg),
                  )
                      : CircleAvatar(
                    radius: 7.w,
                    backgroundImage: currentUser.photoList.last == null
                        ? const AssetImage(avatarIcon)
                        : CachedNetworkImageProvider(
                      currentUser.photoList.last,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.deniedPlan)
                          Wrap(
                            children: [
                              RichText(
                                softWrap: true,
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                  text: 'You',
                                  style: GoogleFonts.nunitoSans(
                                    color: blue,
                                    fontSize: 12.sp,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: widget.msg ?? '',
                                      style: GoogleFonts.nunitoSans(
                                        color: Colors.black54,
                                        fontSize: 12.sp,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    TextSpan(
                                      text: currentUser.name ?? '',
                                      style: GoogleFonts.nunitoSans(
                                        color: blue,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: widget.msg1 ?? '',
                                      style: GoogleFonts.nunitoSans(
                                        color: Colors.black54,
                                        decoration: TextDecoration.none,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    // TextSpan(
                                    //   text: widget.public
                                    //       ? ' Public Plan'
                                    //       : ' Private Plan',
                                    //   style: GoogleFonts.nunitoSans(
                                    //     color:
                                    //     widget.public ? blue : Colors.red,
                                    //     decoration: TextDecoration.none,
                                    //     fontSize: 12.sp,
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        if (widget.invitedPlan == true)
                          Text(
                            widget.planName ?? '',
                            style:
                            GoogleFonts.nunitoSans(color: Colors.black54),
                          ),
                        if (widget.acceptDenyCard && widget.deniedPlan == false)
                          Wrap(
                            children: [
                              RichText(
                                softWrap: true,
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                  text: 'You',
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 12.sp,
                                    decoration: TextDecoration.underline,
                                    color: blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: widget.msg ?? '',
                                      style: GoogleFonts.nunitoSans(
                                        decoration: TextDecoration.none,
                                        color: Colors.black54,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    TextSpan(
                                      text: currentUser.name ?? '',
                                      style: GoogleFonts.nunitoSans(
                                        color: blue,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '\'s JumpIn ',
                                      style: GoogleFonts.nunitoSans(
                                        decoration: TextDecoration.none,
                                        color: Colors.black54,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'request',
                                      style: GoogleFonts.nunitoSans(
                                        decoration: TextDecoration.none,
                                        color: blue,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    // TextSpan(
                                    //   text: widget.public
                                    //       ? ' Public Plan'
                                    //       : ' Private Plan',
                                    //   style: GoogleFonts.nunitoSans(
                                    //     color:
                                    //     widget.public ? blue : Colors.red,
                                    //     decoration: TextDecoration.none,
                                    //     fontSize: 12.sp,
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        if (!widget.acceptDenyCard &&
                            widget.deniedPlan == false)
                          Wrap(
                            children: [
                              RichText(
                                softWrap: true,
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                  text: currentUser.name ?? '',
                                  style: GoogleFonts.nunitoSans(
                                    color: blue,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: widget.msg ?? '',
                                      style: GoogleFonts.nunitoSans(
                                        color: Colors.black54,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    // TextSpan(
                                    //   text: widget.public
                                    //       ? ' Public Plan'
                                    //       : ' Private Plan',
                                    //   style: GoogleFonts.nunitoSans(
                                    //     color:
                                    //     widget.public ? blue : Colors.red,
                                    //     decoration: TextDecoration.none,
                                    //     fontSize: 12.sp,
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        // if (widget.plan)
                        //   const SizedBox(
                        //     height: 10,
                        //   ),
                        // widget.onChat != null
                        //     ? Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     InkWell(
                        //       onTap: () {
                        //         HapticFeedback.mediumImpact();
                        //         widget.onChat();
                        //       },
                        //       child: Ink(
                        //         height: 25,
                        //         width: 80,
                        //         child: Center(
                        //           child: Text(
                        //             widget.deny ? 'Undo' : 'Chat now!',
                        //             style: GoogleFonts.poppins(
                        //               color: Colors.white,
                        //               fontWeight: FontWeight.bold,
                        //               fontSize: 12,
                        //             ),
                        //           ),
                        //         ),
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(5),
                        //           color: blue,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // )
                        //     : Row(
                        //   mainAxisAlignment:
                        //   MainAxisAlignment.spaceBetween,
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     if (widget.onAccept != null)
                        //       InkWell(
                        //         onTap: () {
                        //           HapticFeedback.mediumImpact();
                        //           widget.onAccept();
                        //         },
                        //         child: Ink(
                        //           height: 25,
                        //           width: 80,
                        //           child: Center(
                        //             child: Text(
                        //               'Accept',
                        //               style: GoogleFonts.nunitoSans(
                        //                 color: Colors.white,
                        //                 fontWeight: FontWeight.bold,
                        //                 fontSize: 12.sp,
                        //               ),
                        //             ),
                        //           ),
                        //           decoration: BoxDecoration(
                        //             borderRadius:
                        //             BorderRadius.circular(5),
                        //             color: skyBlue1,
                        //           ),
                        //         ),
                        //       ),
                        //     if (widget.onDeny != null)
                        //       InkWell(
                        //         onTap: () {
                        //           HapticFeedback.mediumImpact();
                        //           widget.onDeny();
                        //         },
                        //         child: Ink(
                        //           height: 25,
                        //           width: 80,
                        //           child: Center(
                        //             child: Text(
                        //               'Deny',
                        //               style: GoogleFonts.nunitoSans(
                        //                 color: Colors.white,
                        //                 fontWeight: FontWeight.bold,
                        //                 fontSize: 12.sp,
                        //               ),
                        //             ),
                        //           ),
                        //           decoration: BoxDecoration(
                        //             borderRadius:
                        //             BorderRadius.circular(5),
                        //             color: Colors.red,
                        //           ),
                        //         ),
                        //       ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.date ?? '',
                        style: GoogleFonts.nunitoSans(
                          color: Colors.black54,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      (widget.onAccept!=null) ?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                                  widget.onAccept();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              minimumSize: Size.zero, // Set this
                              padding: EdgeInsets.zero,
                              primary: Colors.blue, // <-- Button color
                              onPrimary: Colors.blue, /// and this
                            ),
                            child: Icon( Icons.done_outlined, color: white, ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              widget.onDeny();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              minimumSize: Size.zero, // Set this
                              padding: EdgeInsets.zero,
                              primary: Colors.red, // <-- Button color
                              onPrimary: Colors.red, /// and this
                            ),
                            child: Icon( Icons.clear, color: Colors.white, ),
                          ),
                        ],
                      ) :
                      widget.plan ?
                          RawMaterialButton(
                            shape: const CircleBorder(),
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              widget.onTap();
                            },
                            elevation: 0,
                            fillColor: const Color(0xFF549CFA).withOpacity(0.25),
                            child: SvgPicture.asset(
                              arrowIcon,
                              color: Theme.of(context).primaryColorDark,
                              height: widget.plan ? 4.w : 5.w,
                              width: widget.plan ? 4.w : 5.w,
                            )
                          )
                          : RawMaterialButton(
                          shape: const CircleBorder(),
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            widget.onChat();
                          },
                          elevation: 0,
                          fillColor: const Color(0xFF549CFA).withOpacity(0.25),
                          child: SvgPicture.asset(
                            messagesIcon,
                            color: Theme.of(context).primaryColorDark,
                            height: widget.plan ? 4.w : 5.w,
                            width: widget.plan ? 4.w : 5.w,
                          ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}

