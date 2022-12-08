import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/widget/common/fade_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HostCard extends StatefulWidget {
  final String id;
  const HostCard({Key key, this.id}) : super(key: key);

  @override
  _HostCardState createState() => _HostCardState();
}

class _HostCardState extends State<HostCard> {
  JumpInUser jumpInUser;
  bool loading = true;

  @override
  void initState() {
    getHost();
    super.initState();
  }

  getHost() async {
    JumpInUser user = await locator.get<UserService>().getUserById(widget.id);
    if (user != null) {
      jumpInUser = user;
      print('jumpInUser ${jumpInUser.name}');
    }
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    final size = MediaQuery.of(context).size;
    return loading
        ? fadedCircle(15, 15, color: Colors.blue[100])
        : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.white,
                  backgroundImage: jumpInUser.photoList.last == null
                      ? AssetImage(avatarIcon)
                      : NetworkImage(jumpInUser.photoList.last),
                ),
                SizedBox(width: 4),
                Container(
                  width: size.width * 0.25,
                  child: RichText(
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    textScaleFactor: 1,
                    text: TextSpan(
                        text: 'Hosted by ',
                        style: bodyStyle(
                            context: context, size: 13, color: Colors.black54),
                        children: [
                          TextSpan(
                              text: jumpInUser.id == userProvider.currentUser.id
                                  ? 'YOU'
                                  : '${jumpInUser.username.toUpperCase()}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorsJumpIn.kPrimaryColor,
                                  fontSize:
                                      SizeConfig.blockSizeHorizontal * 3.4)),
                        ]),
                  ),
                ),
              ],
          );
  }
}
