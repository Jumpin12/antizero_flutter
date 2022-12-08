import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/provider/ModeModel.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/screens/home/jumpInuser_profile.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/common_methods.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ConnectionCard extends StatefulWidget {
  final String id;
  const ConnectionCard({Key key, this.id}) : super(key: key);

  @override
  _ConnectionCardState createState() => _ConnectionCardState();
}

class _ConnectionCardState extends State<ConnectionCard> {
  bool loading = true;
  JumpInUser user;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  getUser() async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    user = await locator.get<UserService>().getUserById(widget.id);
    print('User ${user.id}');
    if(user!=null)
      {
        String companyName = await getCompanyNameFromMode(context);
        print('companyName $companyName ${user.placeOfWork}');
        if(companyName.length>0)
          {
            if(companyName == user.placeOfWork)
            {
              userProvider.setConnections(user);
            }
            else
            {
              userProvider.setConnections(null);
              user = null;
            }
          }
        else
          {
            userProvider.setConnections(user);
          }
      }
    if (mounted)
      setState(() {
        loading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? fadedCircle(32, 32, color: Colors.blue[100])
        : user == null
            ? Container()
            : GestureDetector(
                onTap: () {
                  Navigator.of(context).push(PageTransition(
                      child: JumpInUserPage(
                        user: user,
                        withoutProvider: true,
                      ),
                      type: PageTransitionType.fade));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // image
                    Expanded(
                      flex: 5,
                      child: CircleAvatar(
                        radius: 45,
                        backgroundColor: blue,
                        child: CircleAvatar(
                          radius: 42,
                          backgroundColor: Colors.white,
                          backgroundImage: user.photoList.last == null
                              ? AssetImage(avatarIcon)
                              : NetworkImage(user.photoList.last),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    // name
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 3, right: 3, bottom: 20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          child: Text(
                            user.name == null ? 'Jumpin user' : '${user.name}',
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.center,
                            style: bodyStyle(
                                context: context,
                                size: SizeConfig.blockSizeVertical * 3,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
  }
}
