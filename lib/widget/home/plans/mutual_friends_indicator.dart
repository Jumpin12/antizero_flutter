import 'package:antizero_jumpin/handler/home.dart';
import 'package:antizero_jumpin/models/contacts.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';

class MutualFriendIndicator extends StatefulWidget {
  final String id;
  final JumpInUser user;
  const MutualFriendIndicator({Key key, this.id, this.user}) : super(key: key);

  //const MutualFriendIndicator({Key? key}) : super(key: key);

  @override
  State<MutualFriendIndicator> createState() => _MutualFriendIndicatorState();
}

class _MutualFriendIndicatorState extends State<MutualFriendIndicator> {
  int length = 0;
  @override
  void initState() {
    getMutualContactLength();
    super.initState();
  }

//fetching mutual user count
  getMutualContactLength() async {
    // List<UserContact> mutualContacts =  await getMutualContacts(widget.id, limit: 10);
    List<UserContact> mutualContacts =
        await getMutualContactsLength(widget.user, context);
    if (mutualContacts.length > 0) {
      length = mutualContacts.length;
    }
    // if (mounted) {
    //   setState(() {
    //     loading = false;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    //depending on count the Text appears
    return length > 0
        ? Text(
            'Mutual-Friend',
            style:
                bodyStyle(context: context, size: 12, color: Colors.lightGreen),
          )
        : Text('');
  }
}
