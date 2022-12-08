import 'package:antizero_jumpin/handler/home.dart';
import 'package:antizero_jumpin/models/contacts.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/widget/common/custom_appbar.dart';
import 'package:antizero_jumpin/widget/home/image_name.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class MutualContactPage extends StatefulWidget {
  final String userId;
  final JumpInUser user;
  const MutualContactPage({Key key, this.userId, this.user}) : super(key: key);

  @override
  _MutualContactPageState createState() => _MutualContactPageState();
}

class _MutualContactPageState extends State<MutualContactPage> {
  List<UserContact> mutualContact = [];
  bool loading = true;

  @override
  void initState() {
    getMutualInterestList();
    FirebaseAnalytics.instance.logScreenView(
      screenName: 'Mutual Contacts Screen',
      screenClass: 'Home',
    );
    super.initState();
  }

  getMutualInterestList() async {
    List<UserContact> contactList =
        await getMutualContactsLength(widget.user, context);
    if (contactList != null) {
      mutualContact = contactList;
    }
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        automaticImplyLeading: true,
        title: 'Mutual Friends',
      ),
      body: loading
          ? fadedCircle(32, 32, color: Colors.blue[100])
          : mutualContact.isNotEmpty
              ? Container(
                  width: size.width,
                  height: size.height,
                  child: GridView.builder(
                    itemCount: mutualContact.length,
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.01),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: size.height * 0.02,
                        mainAxisSpacing: size.width * 0.04,
                        childAspectRatio: 1 / 1.5),
                    itemBuilder: (context, index) {
                      return Container(
                        // width: size.width * 0.02,
                        // color: Colors.black12,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GetImageName(
                              label: mutualContact[index].name.toString()[0],
                            ),
                            Container(
                              // padding: EdgeInsets.only(top: size.height * 0.015),
                              alignment: Alignment.center,
                              child: Text('${mutualContact[index].name}',
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7),
                                      fontSize: size.height * 0.02,
                                      fontWeight: FontWeight.w500)),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                )
              : Container(),
    );
  }
}
