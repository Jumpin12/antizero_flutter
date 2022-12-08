import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/models/plan.dart';
import 'package:antizero_jumpin/screens/home/plans/current_planReq.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

class MyPlanRequestCard extends StatefulWidget {
  final List<String> userIds;
  final Plan plan;
  final Function onTap;

  const MyPlanRequestCard({Key key, this.userIds, this.plan,this.onTap,}) : super(key: key);

  @override
  _MyPlanRequestCard createState() => _MyPlanRequestCard();
}

class _MyPlanRequestCard extends State<MyPlanRequestCard> {
  bool loading = true;
  List<JumpInUser> users = [];
  int moreUserLength;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  getUser() async {
    if (widget.userIds.isNotEmpty || widget.userIds != null) {
      for (int i = 0; i < widget.userIds.length; i++) {
        JumpInUser user =
        await locator.get<UserService>().getUserById(widget.userIds[i]);
        if (user != null) {
          users.add(user);
        }
      }
      if (users.isNotEmpty) moreUserLength = users.length - 1;
    }
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading == true
        ? fadedCircle(15, 15, color: Colors.blue[100])
        : users.isEmpty
        ? Container()
        : InkWell(
      child: Ink(
        padding:
        const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 8.w,
              backgroundImage: widget.plan.planImg[0] == null
                  ? const AssetImage(avatarIcon)
                  : NetworkImage(widget.plan.planImg[0]),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.plan.planName ?? '',
                    style: GoogleFonts.nunitoSans(
                      color: blue,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RichText(
                    softWrap: true,
                    textAlign: TextAlign.start,
                    text: TextSpan(
                        text: users[0].name,
                        style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 11.sp,
                        ),
                        children: [
                          TextSpan(
                            text: moreUserLength > 0
                                ? " & ${moreUserLength.toString()} more has Jumped in to your plan"
                                : ' has Jumped in to your plan',
                            style: GoogleFonts.nunitoSans(
                              color: blue,
                              fontWeight: FontWeight.normal,
                              fontSize: 11.sp,
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${DateFormat.MMM().format(widget.plan.createdAt)} ${DateFormat.d().format(widget.plan.createdAt)}, ${DateFormat.y().format(widget.plan.createdAt)}' ??
                      '',
                  style: GoogleFonts.nunitoSans(
                    color: Colors.black54,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                RawMaterialButton(
                  shape: const CircleBorder(),
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    widget.onTap();
                  },
                  elevation: 0,
                  fillColor:
                  const Color(0xFF549CFA).withOpacity(0.25),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Theme.of(context).primaryColorDark,
                    size: 5.w,
                  ),
                ),
              ],
            ),
          ],
        ),
        // title:
      ),
    );
  }
}
