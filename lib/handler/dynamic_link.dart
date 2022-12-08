// import 'dart:io';
//
// import 'package:antizero_jumpin/models/jumpin_user.dart';
// import 'package:antizero_jumpin/provider/plan.dart';
// import 'package:antizero_jumpin/screens/home/jumpInuser_profile.dart';
// import 'package:antizero_jumpin/screens/home/plans/current_plan.dart';
// import 'package:antizero_jumpin/utils/enums.dart';
// import 'package:antizero_jumpin/utils/locator.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../main.dart';
//
// class DynamicLinkHandler {
//   handleDynamicLink(BuildContext context) async {
//     PendingDynamicLinkData data;
//     if (Platform.isIOS) {
//       await Future.delayed(Duration(seconds: 2), () async {
//         data = await FirebaseDynamicLinks.instance.getInitialLink();
//       });
//     } else {
//       data = await FirebaseDynamicLinks.instance.getInitialLink();
//     }
//
//     _handleDeepLink(data, context);
//
//     FirebaseDynamicLinks.instance.onLink(
//         onSuccess: (PendingDynamicLinkData dynamicLink) async {
//       final Uri deepLink = dynamicLink?.link;
//       if (deepLink != null) {
//         _handleDeepLink(dynamicLink, context);
//       }
//     }, onError: (OnLinkErrorException e) async {
//       print('onLinkError');
//       print(e.message);
//     });
//   }
//
//   _handleDeepLink(PendingDynamicLinkData data, BuildContext context) async {
//     final Uri deepLink = data?.link;
//     print('deep link is $deepLink');
//     if (deepLink != null) {
//       onDeepLink(context, deepLink);
//     }
//   }
//
//   onDeepLink(BuildContext context, Uri deepLink) async {
//     print(deepLink);
//     String id;
//
//     if (deepLink.toString().contains("userId")) {
//       id = deepLink.toString().split("userId=")[1];
//       await userServ.getUserById(id).then(
//             (JumpInUser user) => {
//               navKey.currentState.push(
//                 MaterialPageRoute(
//                   builder: (_) => JumpInUserPage(
//                     user: user,
//                     withoutProvider: true,
//                   ),
//                 ),
//               ),
//             },
//           );
//     }
//
//     if (deepLink.toString().contains("planId")) {
//       id = deepLink.toString().split("planId=")[1];
//       var planProvider = Provider.of<PlanProvider>(context, listen: false);
//       await planServ.getPlanById(id).then((value) async => {
//             planProvider.currentPlan = value,
//             print(value.planName),
//             navKey.currentState.push(
//               MaterialPageRoute(
//                 builder: (_) => CurrentPlanPage(
//                   hostId: value.host,
//                 ),
//               ),
//             ),
//           });
//     }
//   }
//
//   Future<String> createDynamicLink(String id, var type) async {
//     try {
//       var parameters = DynamicLinkParameters(
//         uriPrefix: 'https://antizero.page.link',
//         link: Uri.parse(
//             'https://azjumpin.com/share?${type == kDynamicLinkType.People ? "userId" : "planId"}=$id'),
//         androidParameters: AndroidParameters(
//           packageName: "in.antizero.Jumpin",
//         ),
//         iosParameters: IosParameters(
//           bundleId: 'in.antizero.Jumpin',
//           appStoreId: '1592923405',
//         ),
//       );
//       final ShortDynamicLink shortDynamicLink =
//           await parameters.buildShortLink();
//       final Uri shortUrl = shortDynamicLink.shortUrl;
//
//       return shortUrl.toString();
//     } catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }
// }
