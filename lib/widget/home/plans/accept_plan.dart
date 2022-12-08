import 'package:antizero_jumpin/models/member.dart';
import 'package:antizero_jumpin/models/plan.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AcceptPlanBtn extends StatefulWidget {
  final List<Member> member;
  final bool public;
  final Plan plan;
  final Function onTap;
  final bool loading;
  final bool accepted;
  const AcceptPlanBtn(
      {Key key,
      this.member,
      this.public,
      this.plan,
      @required this.onTap,
      this.loading = false,
      this.accepted = false})
      : super(key: key);

  @override
  _AcceptPlanBtnState createState() => _AcceptPlanBtnState();
}

class _AcceptPlanBtnState extends State<AcceptPlanBtn> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return InkWell(
      // style: NeumorphicStyle(
      //   depth: 10,
      //   intensity: 0.7,
      //   boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
      //   color: widget.accepted
      //       ? blue
      //       : Colors.grey[50],
      // ),
      // padding: EdgeInsets.zero,
      onTap: widget.onTap,
      child: Container(
          height: size.height * 0.05,
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
          decoration: BoxDecoration(
              gradient: buttonGradient,
              shape: BoxShape.rectangle,
              border: Border.all(color: blueborder),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: widget.loading
              ? fadedCircle(15, 15, color: Colors.blue[100])
              : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(logo, height: 20),
              Padding(
                padding: EdgeInsets.only(left: size.width * 0.02),
                child: Text(widget.accepted
                    ? 'Chat' : 'JUMPIN',
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
