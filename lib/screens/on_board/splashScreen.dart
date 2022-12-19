import 'package:antizero_jumpin/handler/auth.dart';
import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/screens/app_update/app_update.dart';
import 'package:antizero_jumpin/services/remote_config.dart';
import 'package:antizero_jumpin/utils/applogo.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/decoration.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/widget/auth/tag_line.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = '/splash';
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final RemoteConfigService _remoteConfigService =
      locator<RemoteConfigService>();

  @override
  void initState()
  {
    setRoute();
    // askPermission();
    super.initState();
    FirebaseAnalytics.instance.logScreenView(
      screenName: 'Splash Screen',
      screenClass: 'Onboarding',
    );
  }

  setRoute() async
  {
    // await _remoteConfigService.initializeConfig();
    // await _remoteConfigService.needsUpdate
    //     ? showDialog(
    //         context: context,
    //         builder: (context) => UpdateDialog(),
    //         barrierDismissible: false,
    //       )
    //     : navigateToRoute(context);
    navigateToRoute(context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: BoxDecoration(
        gradient: gradient4,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(25),
                child: Image.asset(logoSplashIcon),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 10.h,
          child: Center(
            child: Text(
              'Discover Interest - Twins Near you',
              style: fonts(FontWeight.w600,12.sp,Colors.white)
            ),
          ),
        ),
      ),
    );
  }

  // Future<bool> askPermission() async{
  //   PermissionStatus status = await Permission.contacts.request();
  //   if(status.isDenied == true || status.isLimited == true
  //       || status.isPermanentlyDenied == true
  //   || status.isRestricted == true)
  //   {
  //     showAlertDialog(context);
  //   }
  //   else
  //   {
  //     return true;
  //   }
  // }

  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {},
    );
    Widget continueButton = TextButton(
      child: Text("Ok"),
      onPressed:  () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Give us access to your contacts!"),
      content: Text("It helps us ensure your safety by suggesting "
          "profiles with mutual contacts"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
