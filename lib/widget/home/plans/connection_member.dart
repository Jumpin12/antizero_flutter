import 'package:antizero_jumpin/handler/local.dart';
import 'package:antizero_jumpin/handler/plan.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/models/member.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:flutter/material.dart';

class ConnectionMemberCard extends StatefulWidget {
  final List<Member> memberIds;
  const ConnectionMemberCard({Key key, this.memberIds}) : super(key: key);

  @override
  _ConnectionMemberCardState createState() => _ConnectionMemberCardState();
}

class _ConnectionMemberCardState extends State<ConnectionMemberCard> {
  List<JumpInUser> users = [];
  bool loading = true;

  @override
  void initState() {
    getMutualConnection();
    super.initState();
  }

  getMutualConnection() async {
    for (int i = 0; i < widget.memberIds.length; i++) {
      if (widget.memberIds[i].status == MemberStatus.Accepted) {
        JumpInUser _user =
            await checkIfConnectedToUser(widget.memberIds[i].memId, context);
        if (_user != null) {
          users.add(_user);
        }
      }
    }
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 0,
        bottom: 0,
        child: Container(
          height: getScreenSize(context).height * 0.15,
          width: getScreenSize(context).width * 0.26,
          padding: EdgeInsets.all(getScreenSize(context).height * 0.015),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: purple,
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 8,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: ImageIcon(AssetImage(mutualIcon),
                        size: SizeConfig.blockSizeHorizontal * 9,
                        color: Colors.white.withOpacity(0.9)),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: loading
                      ? fadedCircle(15, 15, color: Colors.white)
                      : Column(
                          children: [
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                users.isNotEmpty
                                    ? '${users[0].username}+'
                                    : 'N/A',
                                textScaleFactor: 1,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 3,
                                    fontWeight: FontWeight.w800),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'are joining',
                                textScaleFactor: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 2.9,
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                ),
              ]),
        ));
  }
}
