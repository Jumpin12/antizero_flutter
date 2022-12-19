import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/provider/ModeModel.dart';
import 'package:antizero_jumpin/provider/auth.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/screens/authentication/googleAuthScreen.dart';
import 'package:antizero_jumpin/screens/dashboard/dashboard.dart';
import 'package:antizero_jumpin/screens/on_board/splashScreen.dart';
import 'package:antizero_jumpin/services/auth.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/locator.dart';
import 'package:antizero_jumpin/widget/drawer/animatedmode.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class CustomDrawerHeader extends StatefulWidget {
  final String img;
  final String name;
  final Function onTap;
  final int mode;

  const CustomDrawerHeader({Key key, this.img, this.name, this.onTap, this.mode}) : super(key: key);

  @override
  _CustomDrawerHeaderState createState() => _CustomDrawerHeaderState();
}

class _CustomDrawerHeaderState extends State<CustomDrawerHeader>
{
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var authProvider = Provider.of<AuthProvider>(context);
    return
      SafeArea(
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
            height: size.height * 0.35,
            // color: Colors.black12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  children: [
                    Container(
                      width: size.height * 0.14,
                      height: size.height * 0.14,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2000),
                          gradient: LinearGradient(
                              colors: [Colors.blue[200], Colors.blue[400]],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight)),
                    ),
                    Positioned(
                      left: size.height * 0.01,
                      top: size.height * 0.01,
                      child: Container(
                        width: size.height * 0.12,
                        height: size.height * 0.12,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2000),
                            image: DecorationImage(
                                image: widget.img == null ? AssetImage(avatarIcon) : NetworkImage(widget.img),
                                fit: BoxFit.cover)),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Hello! ",
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontSize: size.height * 0.03,
                            color: Colors.black.withOpacity(0.7))),
                    Text(widget.name ?? 'JUMPIN USER',
                        textScaleFactor: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: size.height * 0.035,
                            color: Colors.black.withOpacity(0.9),
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedMode(
                      values: ['General', 'Company/\nCollege'],
                      onToggleCallback: (value) async
                      {
                        setState(() {
                          _isLoading = true;
                        });
                        // await authProvider.signOut();
                        await userServ.updateMode(AuthService().currentAppUser.uid,value);
                        var userProvider = Provider.of<UserProvider>(context, listen: false);
                        userProvider.currentUser.mode = value;
                        setState(()
                        {
                          _isLoading = false;
                          Provider.of<ModeProvider>(context, listen: false).setCurrentMode(value);
                          print('value $value');
                        });
                        Navigator.of(context).push(PageTransition(
                            child: SplashScreen(),
                            type: PageTransitionType.fade));
                      },
                      buttonColor: Colors.blueAccent,
                      backgroundColor: Colors.black12,
                      textColor: Colors.white,
                      selected: widget.mode
                    ),
                    _isLoading ?
                    SizedBox(
                      child: CircularProgressIndicator(),
                      height: 25.0,
                      width: 25.0,
                      ) : Container(),
                    // (widget.mode == 1) ?
                    // Text(Provider.of<ModeProvider>(context, listen: false).getCurrentMode.toString(),
                    //     textScaleFactor: 1,
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(
                    //         fontSize: 10,
                    //         color: Colors.black12.withOpacity(0.9),
                    //         fontWeight: FontWeight.w500))
                    //     :
                    // Text('Company',
                    //     textScaleFactor: 1,
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(
                    //         fontSize: 10,
                    //         color: Colors.black.withOpacity(0.9),
                    //         fontWeight: FontWeight.w500)),
                  ],
                ),
                const Divider(color: Colors.black26),
              ],
            )),
      ),
    );
  }
}
