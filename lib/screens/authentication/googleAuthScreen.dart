import 'dart:io';
import 'package:antizero_jumpin/handler/auth.dart';
import 'package:antizero_jumpin/provider/ModeModel.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/services/auth.dart';
import 'package:antizero_jumpin/utils/applogo.dart';
import 'package:antizero_jumpin/utils/ios_style.dart';
import 'package:antizero_jumpin/utils/locator.dart';
import 'package:antizero_jumpin/widget/common/accountLinkButton.dart';
import 'package:antizero_jumpin/widget/drawer/animatedmode.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class GoogleSignInScreen extends StatefulWidget {
  static String routeName = "auth/googleSignIn";
  const GoogleSignInScreen({Key key}) : super(key: key);

  @override
  _GoogleSignInScreenState createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  bool loading = false;
  bool appleSignIn = false;
  bool _isLoading = false;

  @override
  void initState() {
    if (Platform.isIOS) {
      checkAppleAvailable();
    }
    FirebaseAnalytics.instance.logScreenView(
      screenName: 'Google Auth Screen',
      screenClass: 'Authentication',
    );
    super.initState();
  }

  checkAppleAvailable() async {
    final appleSignInAvailable = await AppleSignInAvailable.check();
    if (appleSignInAvailable.isAvailable) {
      if (mounted) {
        setState(() {
          appleSignIn = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: Stack(
        children: [
          Image.asset(
            'assets/images/OnBoard/one_hand.jpg',
            height: _size.height * .9,
            width: _size.width,
          ),
          Container(
            height: _size.height,
            width: _size.width,
            color: Colors.white54,
          ),
          Container(
            height: _size.height * .92,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60,
                ),
                AppLogo(
                  height: 50,
                  width: 40,
                ),
                Spacer(),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text('Sign Up ',
                //         style: TextStyle(
                //             fontSize: 25,
                //             color: blue,
                //             fontWeight: FontWeight.w700)),
                //     Text(
                //       'to start vibing',
                //       style: TextStyle(
                //           color: black.withOpacity(0.7),
                //           fontSize: 25,
                //           fontWeight: FontWeight.w700),
                //     ),
                //   ],
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // CustomLogoButton(
                //   loading: loading,
                //   onTap: () async {
                //     setState(() {
                //       loading = true;
                //     });
                //     doPhoneNumberLogin(context);
                //     await FirebaseAnalytics.instance.logSignUp(
                //         signUpMethod:
                //         'Mobile Number');
                //     setState(() {
                //       loading = false;
                //     });
                //   },
                //   color: Colors.lightBlueAccent,
                //   title: 'Sign in with Mobile Number',
                // ),
                SizedBox(
                  height: 10,
                ),
                CustomLogoButton(
                  loading: loading,
                  onTap: () async {
                    setState(() {
                      loading = true;
                    });
                    doGoogleLogin(context);
                    // doMicrosoftLogin(context);
                    setState(() {
                      loading = false;
                    });
                    // Navigator.pushNamed(
                    //     context, PhoneVerifationScreen.routeName);
                  },
                  title: 'Continue With Google',
                  logo: 'assets/images/OnBoard/google_logo.png',
                ),
                if (appleSignIn)
                  Padding(padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20),
                    child: AppleSignInButton(
                      cornerRadius: 12,
                      style: blackButton,
                      type: ButtonType.signIn,
                      onPressed: () {
                        doAppleLogin(context);
                      },
                    ),
                  ),
                SizedBox(
                  height: 5,
                ),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     AnimatedMode(
                //         values: ['General', 'Company'],
                //         onToggleCallback: (value) async
                //         {
                //           setState(() {
                //             _isLoading = true;
                //           });
                //           await userServ.updateMode(AuthService().currentAppUser.uid,value);
                //           var userProvider = Provider.of<UserProvider>(context, listen: false);
                //           userProvider.currentUser.mode = value;
                //           setState(()
                //           {
                //             _isLoading = false;
                //             Provider.of<ModeProvider>(context, listen: false).setCurrentMode(value);
                //             print('value $value');
                //           });
                //         },
                //         buttonColor: Colors.blueAccent,
                //         backgroundColor: Colors.black12,
                //         textColor: Colors.white,
                //         selected: widget.mode
                //     ),
                //     _isLoading ? SizedBox(
                //       child: CircularProgressIndicator(),
                //       height: 25.0,
                //       width: 25.0,
                //     ) : Container()
                //     // (widget.mode == 1) ?
                //     // Text(Provider.of<ModeProvider>(context, listen: false).getCurrentMode.toString(),
                //     //     textScaleFactor: 1,
                //     //     textAlign: TextAlign.center,
                //     //     style: TextStyle(
                //     //         fontSize: 10,
                //     //         color: Colors.black12.withOpacity(0.9),
                //     //         fontWeight: FontWeight.w500))
                //     // :
                //     // Text('Company',
                //     //     textScaleFactor: 1,
                //     //     textAlign: TextAlign.center,
                //     //     style: TextStyle(
                //     //         fontSize: 10,
                //     //         color: Colors.black.withOpacity(0.9),
                //     //         fontWeight: FontWeight.w500)),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
