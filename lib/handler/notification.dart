import 'dart:convert';

import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/friend_request.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/models/msg_body.dart';
import 'package:antizero_jumpin/models/notification.dart';
import 'package:antizero_jumpin/provider/plan.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/screens/home/chat/chat.dart';
import 'package:antizero_jumpin/screens/home/jumpInuser_profile.dart';
import 'package:antizero_jumpin/screens/home/plans/current_plan.dart';
import 'package:antizero_jumpin/services/analytics.dart';
import 'package:antizero_jumpin/services/notification.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/locator.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

Analytics analytics = locator<Analytics>();

class NotificationHandler {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  NotificationHandler({Function onToken, Function onSelectLocalNotification}) {
    this._flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initNotifications(onToken, onSelectNotification: onSelectLocalNotification);
  }

  //Local Notifications
  void initLocalNotificationsPlugin(Function onSelectNotification) async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) {
      Map<String, dynamic> json = jsonDecode(payload);
      return onSelectNotification(json);
    });
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  //Firebase Messaging
  initNotifications(Function onToken, {Function onSelectNotification}) async {
    print('initNotifications');
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    initLocalNotificationsPlugin(onSelectNotification);
    messaging.getToken().then((token) {
      print('token is $token');
      if (onToken != null) onToken(token);
    });
  }

  configureNotificationsAndTokenUpdates(BuildContext context,
      {Function(String) onTokenRefreshed, Function onMessage}) async
  {
    Stream onTokenRefresh = messaging.onTokenRefresh;
    onTokenRefresh.listen((newToken) {
      print('token is $newToken');
      if (onTokenRefreshed != null) onTokenRefreshed(newToken);
    });
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      if (onMessage != null)
        onMessage(handlePlatformAwareNotification(initialMessage.data));
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      FlutterAppBadger.removeBadge();
      if (onMessage != null) {
        analytics.logCustomEvent(eventName: 'NotificationOnTap', params: {
          'from': message.senderId,
          'to': FirebaseAuth.instance.currentUser.uid,
        });
        onMessage(handlePlatformAwareNotification(message.data));
      }
    });

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final String body = message.notification.body;
      SnackBar snackBar = SnackBar(
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.fixed,
        backgroundColor: shade1,
        action: SnackBarAction(
          label: 'Open',
          onPressed: () async {
            ScaffoldMessenger.of(context).clearSnackBars();
            onMessage(handlePlatformAwareNotification(message.data));
          },
        ),
        content: Text(
          '$body',
          style: bodyStyle(context: context, size: 14, color: Colors.black),
        ),
        elevation: 10.0,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'jumpin',
                'jumpin',
                icon: android?.smallIcon,
                // other properties...
              ),
            ));
      }
    });
  }

  dynamic handlePlatformAwareNotification(message) => message;
}

// create people requested notification
reqPeopleNotification(FriendRequest friendRequest) async {
  var id = Uuid().v4();
  JumpInUser user =
      await locator.get<UserService>().getUserById(friendRequest.requestedBy);
  MsgBody msgBody = MsgBody.named(
    title: 'People',
    type: MsgBodyType.PeopleRequested,
    userId: friendRequest.requestedTo,
    msg: user == null
        ? 'wants to JumpIn with you!'
        : '${user.name} wants to JumpIn with you!',
    planId: '',
    isUnRead: true,
  );
  UserNotification notification = UserNotification.named(
      id: id,
      title: 'People',
      type: NotificationType.People,
      description: 'requested by ${friendRequest.requestedBy}',
      createdAt: DateTime.now(),
      msgBody: msgBody,
      isUnRead: true);

  await locator.get<NotificationService>().sendNotificationToFirestore(
      notification: notification, userId: friendRequest.requestedTo);
}

// create people accepted notification
acceptPeopleNotification(FriendRequest friendRequest) async {
  var id = Uuid().v4();
  JumpInUser user =
      await locator.get<UserService>().getUserById(friendRequest.requestedTo);
  MsgBody msgBody = MsgBody.named(
    title: 'People',
    type: MsgBodyType.PeopleAccepted,
    msg: user == null
        ? 'accepted your JumpIn request!'
        : '${user.name} accepted your JumpIn request!',
    userId: friendRequest.requestedTo,
    planId: '',
    isUnRead: true,
  );
  UserNotification notification = UserNotification.named(
      id: id,
      title: 'People',
      type: NotificationType.People,
      description: 'accepted by ${friendRequest.requestedTo}',
      createdAt: DateTime.now(),
      msgBody: msgBody,
      isUnRead: true);

  await locator.get<NotificationService>().sendNotificationToFirestore(
      notification: notification, userId: friendRequest.requestedBy);
}

showNotification(BuildContext context, UserProvider userProvider,
    PlanProvider planProvider) async {
  notServ.fcm.getInitialMessage().then((RemoteMessage message) {
    if (message != null) {
      print(message.data);
    }
  });

  /// Create a [AndroidNotificationChannel] for heads up notifications
  AndroidNotificationChannel channel;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  channel = AndroidNotificationChannel('jumpin',
      'jumpin',
      importance: Importance.high,showBadge: true);

  FirebaseMessaging.onBackgroundMessage(
    (message) => FlutterLocalNotificationsPlugin()
        .show(
          message.hashCode,
          message.notification.title,
          message.notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'jumpinnotification',
              'jumpinnotification',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        )
        .then(
          (value) => FlutterAppBadger.updateBadgeCount(1),
        ),
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      .createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance
      .setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    UserService userService = UserService();
    RemoteNotification notification = message.notification;
    AndroidNotification android = message.notification.android;

    if (notification != null && android != null) {
      final String recipientId = message.data['recipient'];
      final String title = message.notification.title;
      final String body = message.notification.body;
      print('body $body');
      showToast('body $body');
      if (recipientId == userProvider.currentUser.id) {
        SnackBar snackBar = SnackBar(
          duration: Duration(seconds: 5),
          behavior: SnackBarBehavior.fixed,
          backgroundColor: shade1,
          action: SnackBarAction(
            label: 'Open',
            onPressed: () async {
              if (message.notification.body.contains('requested by')) {
                String description = message.data['description'];
                String fromId = description.split(' ')[2];
                analytics.logCustomEvent(
                  eventName: 'InAppNotificationTap',
                  params: {
                    'from': fromId,
                    'to': FirebaseAuth.instance.currentUser.uid,
                  },
                );
                await userService.getUserById(fromId).then(
                      (JumpInUser user) => {
                        navKey.currentState.push(
                          MaterialPageRoute(
                            builder: (_) => JumpInUserPage(
                              user: user,
                              withoutProvider: true,
                            ),
                          ),
                        ),
                      },
                    );
              } else if (message.notification.body.contains('accepted by')) {
                String description = message.data['description'];
                String fromId = description.split(' ')[2];
                await userService.getUserById(fromId).then(
                      (JumpInUser user) => {
                        navKey.currentState.push(
                          MaterialPageRoute(
                            builder: (_) => JumpInUserPage(
                              user: user,
                              withoutProvider: true,
                            ),
                          ),
                        ),
                      },
                    );
              } else if (message.notification.body.contains('wants to')) {
                String description = message.data['description'];
                String fromId = description.split(' ')[2];
                await userService.getUserById(fromId).then(
                      (JumpInUser user) => {
                        navKey.currentState.push(
                          MaterialPageRoute(
                            builder: (_) => JumpInUserPage(
                              user: user,
                              withoutProvider: true,
                            ),
                          ),
                        ),
                      },
                    );
              } else if (message.notification.body.contains('invited you')) {
                String description = message.data['description'];
                String planId = description.split(' ')[3];
                analytics.logCustomEvent(
                  eventName: 'InAppNotificationTap',
                  params: {
                    'plan': planId,
                    'to': FirebaseAuth.instance.currentUser.uid,
                  },
                );
                debugPrint(planId);
                await planServ.getPlanById(planId).then((value) async => {
                      planProvider.currentPlan = value,
                      print(value.planName),
                      navKey.currentState.push(
                        MaterialPageRoute(
                          builder: (_) => CurrentPlanPage(
                            hostId: value.host,
                          ),
                        ),
                      ),
                    });
              } else if (message.notification.body.contains('new message')) {
                String description = message.data['description'];
                String userId = description.split(' ')[3];
                analytics.logCustomEvent(
                  eventName: 'InAppNotificationTap',
                  params: {
                    'from': userId,
                    'to': FirebaseAuth.instance.currentUser.uid,
                  },
                );
                print(userId);
                userService.getUserById(userId).then(
                      (value) async => {
                        userProvider.chatWithUser = value,
                        navKey.currentState.push(
                          MaterialPageRoute(
                            builder: (_) => ChatPage(),
                          ),
                        ),
                      },
                    );
              }
            },
          ),
          content: Text(
            '$body',
            style: bodyStyle(context: context, size: 14, color: Colors.black),
          ),
          elevation: 10.0,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // showToast(body);
      } else {
        print("Notification NOT shown");
      }
    }
  });
}

// send notification to user for added to plan
addedToPrivatePlanNotification(String userId, String planId, String planName, JumpInUser host) async {
  var id = Uuid().v4();
  MsgBody msgBody = MsgBody.named(
    title: 'Plan',
    type: MsgBodyType.PlanAccepted,
    msg: host == null
        ? 'You have been added to plan $planName!'
        : 'You have been added to ${host.name}\'s plan $planName!',
    userId: host.id,
    planId: planId,
    isUnRead: true,
  );
  UserNotification notification = UserNotification.named(
      id: id,
      title: 'Plan',
      type: NotificationType.Plan,
      description: 'added to plan $planId',
      createdAt: DateTime.now(),
      msgBody: msgBody,
      isUnRead: true);

  await locator
      .get<NotificationService>()
      .sendNotificationToFirestore(notification: notification, userId: userId);
}

// send notification to user for invited to plan
invitedToPublicPlanNotification(
    String userId, String planId, String planName, JumpInUser host) async {
  var id = Uuid().v4();
  MsgBody msgBody = MsgBody.named(
    title: 'Plan',
    type: MsgBodyType.PlanInvited,
    msg: host == null
        ? 'You have been invited to plan $planName!'
        : '${host.name} has invited you to JumpIn to plan $planName!',
    userId: host.id,
    planId: planId,
    isUnRead: true,
  );
  UserNotification notification = UserNotification.named(
      id: id,
      title: 'Plan',
      type: NotificationType.Plan,
      description: 'invited to plan $planId',
      createdAt: DateTime.now(),
      msgBody: msgBody,
      isUnRead: true);

  await locator
      .get<NotificationService>()
      .sendNotificationToFirestore(notification: notification, userId: userId);
}

// send notification to user for added to plan
acceptedToPlanNotification(
    String userId, String planId, String planName, JumpInUser host) async {
  var id = Uuid().v4();
  MsgBody msgBody = MsgBody.named(
    title: 'Plan',
    type: MsgBodyType.PlanAccepted,
    msg: host == null
        ? 'You have accepted plan $planName!'
        : 'You have accepted ${host.name}\'s plan $planName!',
    userId: host.id,
    planId: planId,
    isUnRead: true,
  );
  UserNotification notification = UserNotification.named(
      id: id,
      title: 'Plan',
      type: NotificationType.Plan,
      description: 'accepted plan $planId',
      createdAt: DateTime.now(),
      msgBody: msgBody,
      isUnRead: true);

  await locator
      .get<NotificationService>()
      .sendNotificationToFirestore(notification: notification, userId: userId);
}

// send notification to host for added member in plan
acceptedMemberToPlanNotification(
    String hostId, String planId, String planName, JumpInUser user) async {
  var id = Uuid().v4();
  MsgBody msgBody = MsgBody.named(
    title: 'Plan',
    type: MsgBodyType.PlanAccepted,
    msg: user == null
        ? 'Someone Jumped into your plan $planName!'
        : '${user.name} Jumped into your plan $planName!',
    userId: user.id,
    planId: planId,
    isUnRead: true,
  );
  UserNotification notification = UserNotification.named(
      id: id,
      title: 'Plan',
      type: NotificationType.Plan,
      description: 'accepted plan $planId',
      createdAt: DateTime.now(),
      msgBody: msgBody,
      isUnRead: true);

  await locator
      .get<NotificationService>()
      .sendNotificationToFirestore(notification: notification, userId: hostId);
}

Future<bool> checkUserHasNotification(BuildContext context) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  if (userProvider.currentUser == null) {
    return false;
  } else {
    return await locator
        .get<NotificationService>()
        .getNotificationsFromFirestore(userProvider.currentUser.id);
  }
}

// create new people chat msg notification
newPeopleChatNotification(String textMsg,JumpInUser user, String toUid) async {
  var id = Uuid().v4();
  // JumpInUser user = await locator.get<UserService>().getUserById(fromUid);
  String fromUid = user.id;
  MsgBody msgBody = MsgBody.named(
    title: '${user.name}',
    type: MsgBodyType.NewPeopleChat,
    msg: user == null
        ? '$textMsg'
        : '$textMsg',
    userId: toUid,
    planId: '',
    isUnRead: true,
  );
  UserNotification notification = UserNotification.named(
      id: id,
      title: 'People',
      type: NotificationType.People,
      description: 'new people message by $fromUid',
      createdAt: DateTime.now(),
      msgBody: msgBody,
      isUnRead: true);

  await locator
      .get<NotificationService>()
      .sendNotificationToFirestore(notification: notification, userId: toUid);
}

// create new plan chat msg notification
newPlanChatNotification(String textMsg,String fromUid, String toUid,
    String planName, String planId) async
{
  var id = Uuid().v4();
  JumpInUser user = await locator.get<UserService>().getUserById(fromUid);
  MsgBody msgBody = MsgBody.named(
    title: '${user.name} in "$planName"',
    type: MsgBodyType.NewPlanChat,
    msg: user == null
        ? '$textMsg'
        : '$textMsg',
    userId: toUid,
    planId: planId,
    isUnRead: true,
  );
  UserNotification notification = UserNotification.named(
      id: id,
      title: 'Plan',
      type: NotificationType.Plan,
      description: 'new plan message by $fromUid',
      createdAt: DateTime.now(),
      msgBody: msgBody,
      isUnRead: true);

  await locator
      .get<NotificationService>()
      .sendNotificationToFirestore(notification: notification, userId: toUid);
}

sendPrivatePlanAcceptNot(BuildContext context, List<JumpInUser> users,
    String planId, bool public, String planName) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  for (int i = 0; i < users.length; i++) {
    if (!public)
      await addedToPrivatePlanNotification(
          users[i].id, planId, planName, userProvider.currentUser);
    if (public)
      await invitedToPublicPlanNotification(
          users[i].id, planId, planName, userProvider.currentUser);
  }
}
