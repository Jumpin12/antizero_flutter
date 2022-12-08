//
// import 'dart:async';
//
// import 'package:antizero_jumpin/handler/toast.dart';
// import 'package:data_connection_checker/data_connection_checker.dart';
// import 'package:flutter/material.dart';
//
// class ConnectionChecker {
//   StreamSubscription<DataConnectionStatus> listener;
//   var InternetStatus = "Unknown";
//   var contentMessage = "Unknown";
//
//   checkConnection(BuildContext context) async {
//     listener = DataConnectionChecker().onStatusChange.listen((status) {
//       switch (status) {
//         case DataConnectionStatus.connected:
//           InternetStatus = "Connected to the Internet";
//           contentMessage = "Connected to the Internet";
//           break;
//         case DataConnectionStatus.disconnected:
//           InternetStatus =
//           "You are either disconnected from the Internet or the connection is very slow";
//           contentMessage = "Please check your internet connection";
//           buildDialog(InternetStatus, contentMessage, context);
//           break;
//       }
//     });
//     return await DataConnectionChecker().connectionStatus;
//   }
// }
