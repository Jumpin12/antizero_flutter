import 'package:antizero_jumpin/handler/home.dart';
import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/handler/user.dart';
import 'package:antizero_jumpin/models/friend_request.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/provider/jumpin.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class JumpInButton extends StatefulWidget {
  final String icon;
  final String label;
  final String id;
  const JumpInButton({Key key, this.label, this.icon, this.id})
      : super(key: key);

  @override
  _JumpInButtonState createState() => _JumpInButtonState();
}

class _JumpInButtonState extends State<JumpInButton> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var jumpinButtonProv = Provider.of<JumpInButtonProvider>(context);
    return InkWell(
      onTap: jumpinButtonProv.requested
          ? null
          : () async {
              jumpinButtonProv.setRequesting(true);
              // check if denied by current user
              FriendRequest deniedReq = await checkIfDenied(context, widget.id);
              if (deniedReq != null) {
                print('Friend request denied by you!');
                undoRequest(context, () async {
                  bool done = await changeStatusToRequested(deniedReq.id);
                  if (done) {
                    showToast('success!');
                    Navigator.pop(context);
                  } else {
                    showToast('Please try after sometime!');
                  }
                });
              } else {
                bool send = await sendRequest(widget.id, context);
                if (send) {
                  jumpinButtonProv.setRequested(true);
                  JumpInUser user = await getUser(context);
                  if (user != null) {
                    successTick(context);
                  }
                }
              }
              jumpinButtonProv.setRequesting(false);
            },
      child: Container(
          height: size.height * 0.05,
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
          decoration: BoxDecoration(
              gradient: buttonGradient,
              shape: BoxShape.rectangle,
              border: Border.all(color: blueborder),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: jumpinButtonProv.loading || jumpinButtonProv.requesting
              ? fadedCircle(15, 15, color: Colors.blue[100])
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(logo, height: 20),
                    Padding(
                      padding: EdgeInsets.only(left: size.width * 0.02),
                      child: Text(widget.label,
                          textScaleFactor: 1,
                          style: TextStyle(
                              fontFamily: sFui,
                              color: Colors.white,
                              fontSize: size.height * 0.018,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                )),
    );
  }
}
