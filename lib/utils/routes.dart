import 'package:antizero_jumpin/screens/authentication/googleAuthScreen.dart';
import 'package:antizero_jumpin/screens/dashboard/dashboard.dart';
import 'package:antizero_jumpin/screens/on_board/splashScreen.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  GoogleSignInScreen.routeName: (context) => GoogleSignInScreen(),
  DashBoardScreen.routeName: (context) => DashBoardScreen(),
};
