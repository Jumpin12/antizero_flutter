import 'package:antizero_jumpin/handler/home.dart';
import 'package:antizero_jumpin/handler/local.dart';
import 'package:antizero_jumpin/models/contacts.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class MutualFriendCard extends StatefulWidget {
  final String id;
  final JumpInUser user;
  const MutualFriendCard({Key key, this.id, this.user}) : super(key: key);

  @override
  _MutualFriendCardState createState() => _MutualFriendCardState();
}

class _MutualFriendCardState extends State<MutualFriendCard> {
  bool loading = true;
  int length = 0;

  @override
  void initState() {
    getMutualContactLength();
    super.initState();
  }

  getMutualContactLength() async {
    // List<UserContact> mutualContacts =  await getMutualContacts(widget.id, limit: 10);
    List<UserContact> mutualContacts =
        await getMutualContactsLength(widget.user, context);
    if (mutualContacts.length > 0) {
      length = mutualContacts.length;
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
      bottom: 0,
      left: 0,
      child: Container(
        height: getScreenSize(context).height * 0.15,
        width: getScreenSize(context).width * 0.26,
        padding: EdgeInsets.all(getScreenSize(context).height * 0.015),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.cyan[800],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Expanded(
            flex: 5,
            child: Align(
              alignment: Alignment.topLeft,
              child: ImageIcon(AssetImage(mutualIcon),
                  size: SizeConfig.blockSizeHorizontal * 9,
                  color: Colors.white.withOpacity(0.9)),
            ),
          ),
          Expanded(
            flex: 5,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: loading
                  ? SizedBox(
                      width: 15,
                      height: 15,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballScaleMultiple,
                        colors: const [Colors.white],
                      ))
                  : Text(
                      length > 10
                          ? '10+\nMutual Friends'
                          : '${length.toString()}\nMutual Friends',
                      textScaleFactor: 1,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: SizeConfig.blockSizeHorizontal * 2.9,
                          fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
            ),
          )
        ]),
      ),
    );
  }
}
