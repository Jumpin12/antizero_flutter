import 'dart:io';

import 'package:antizero_jumpin/handler/dynamic_link.dart';
import 'package:antizero_jumpin/provider/ModeModel.dart';
import 'package:antizero_jumpin/provider/auth.dart';
import 'package:antizero_jumpin/provider/bookmark.dart';
import 'package:antizero_jumpin/provider/college.dart';
import 'package:antizero_jumpin/provider/company.dart';
import 'package:antizero_jumpin/provider/interest.dart';
import 'package:antizero_jumpin/provider/navigator.dart';
import 'package:antizero_jumpin/provider/phone_auth.dart';
import 'package:antizero_jumpin/provider/plan.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/screens/on_board/splashScreen.dart';
import 'package:antizero_jumpin/services/analytics.dart';
import 'package:antizero_jumpin/services/auth.dart';
import 'package:antizero_jumpin/services/bookmark.dart';
import 'package:antizero_jumpin/services/chat.dart';
import 'package:antizero_jumpin/services/college.dart';
import 'package:antizero_jumpin/services/company.dart';
import 'package:antizero_jumpin/services/interest.dart';
import 'package:antizero_jumpin/services/notification.dart';
import 'package:antizero_jumpin/services/plan.dart';
import 'package:antizero_jumpin/services/remote_config.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:antizero_jumpin/utils/routes.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

GetIt locator = GetIt.I;
final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

Future setupSingleton() async
{
  locator.registerLazySingleton<AuthService>(() => AuthService());
  locator.registerLazySingleton<UserService>(() => UserService());
  locator.registerLazySingleton<ChatService>(() => ChatService());
  locator.registerLazySingleton<InterestService>(() => InterestService());
  locator.registerLazySingleton<CompanyService>(() => CompanyService());
  locator.registerLazySingleton<CollegeService>(() => CollegeService());
  locator.registerLazySingleton<PlanService>(() => PlanService());
  locator.registerLazySingleton<BookMarkService>(() => BookMarkService());
  locator.registerLazySingleton<NotificationService>(() => NotificationService());
  // locator.registerSingleton<DynamicLinkHandler>(DynamicLinkHandler());
  locator.registerLazySingleton(() => Analytics());
  var remoteConfigService = await RemoteConfigService.getInstance();
  locator.registerSingleton(remoteConfigService);
}

///receive message when app is in background
Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  /// background messaging handler
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  print('Handling a background message ${message.messageId}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title// description
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  await Firebase.initializeApp();
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  await FirebaseAnalytics.instance.logAppOpen();
  //Called when the app is in use/is in the foreground
  await setupSingleton();

  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  //runApp(App());
  // runApp(App());
  // FacebookSdk.sdkInitialize();
  return runApp(App());
}

class App extends StatelessWidget {
  // static final facebookAppEvents = FacebookAppEvents();
  // static final facebookSDK = FacebookAppEvents();

  @override
  Widget build(BuildContext context) {
    // to display user has installed the app or no
    // facebookSDK.setAutoLogAppEventsEnabled(true);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => PhoneAuth()),
        ChangeNotifierProvider(create: (context) => InterestProvider()),
        ChangeNotifierProvider(create: (context) => CompanyProvider()),
        ChangeNotifierProvider(create: (context) => CollegeProvider()),
        ChangeNotifierProvider(create: (context) => NavigationModel()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => PlanProvider()),
        ChangeNotifierProvider(create: (context) => BookMarkProvider()),
        ChangeNotifierProvider(create: (context) => ModeProvider()),
      ],
      child: Sizer(
        builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            // initialRoute: SplashScreen.routeName,
            routes: routes,
            home: SplashScreen(),
            navigatorKey: navKey,
            theme: ThemeData(
                // visualDensity: VisualDensity.adaptivePlatformDensity,
                fontFamily: "AirbnbCereal",
                textTheme:
                TextTheme(
                  headline1: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: sFui,
                      fontSize: 25),
                  // bodyText1: TextStyle(
                  //     color: brown,
                  //     fontWeight: FontWeight.w500,
                  //     fontFamily: roboto,
                  //     fontSize: 16
                  // ),
                ),
                appBarTheme: AppBarTheme(
                    color: Colors.transparent,
                    elevation: 0,
                    // ignore: deprecated_member_use
                    brightness: Brightness.dark),
                primaryColor: Colors.blue[100]),
            title: 'JumpIn',
          );
        }
      ),
    );
  }
}
