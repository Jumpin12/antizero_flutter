// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
//
// class WebScreen extends StatefulWidget {
//   final String url;
//   final String type;
//   WebScreen(this.url, this.type);
//   @override
//   _WebScreenState createState() => _WebScreenState();
// }
//
// class _WebScreenState extends State<WebScreen> {
//   final GlobalKey webViewKey = GlobalKey();
//
//   InAppWebViewController webViewController;
//   InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
//       crossPlatform: InAppWebViewOptions(
//         useShouldOverrideUrlLoading: true,
//         mediaPlaybackRequiresUserGesture: false,
//       ),
//       android: AndroidInAppWebViewOptions(
//         useHybridComposition: true,
//       ),
//       ios: IOSInAppWebViewOptions(
//         allowsInlineMediaPlayback: true,
//       ));
//
//   PullToRefreshController pullToRefreshController;
//   String url = "";
//   double progress = 0;
//   final urlController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//
//     pullToRefreshController = PullToRefreshController(
//       options: PullToRefreshOptions(
//         color: Colors.blue,
//       ),
//       onRefresh: () async {
//         if (Platform.isAndroid) {
//           webViewController?.reload();
//         } else if (Platform.isIOS) {
//           webViewController?.loadUrl(
//               urlRequest: URLRequest(url: await webViewController?.getUrl()));
//         }
//       },
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//             leading: BackButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//             title: Text(widget.type)),
//         body: SafeArea(
//             child: Column(children: <Widget>[
//           Expanded(
//             child: Stack(
//               children: [
//                 InAppWebView(
//                   key: webViewKey,
//                   initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
//                   initialOptions: options,
//                   pullToRefreshController: pullToRefreshController,
//                   onWebViewCreated: (controller) {
//                     webViewController = controller;
//                   },
//                   onLoadStart: (controller, url) {
//                     setState(() {
//                       this.url = url.toString();
//                       urlController.text = this.url;
//                     });
//                   },
//                   androidOnPermissionRequest:
//                       (controller, origin, resources) async {
//                     return PermissionRequestResponse(
//                         resources: resources,
//                         action: PermissionRequestResponseAction.GRANT);
//                   },
//                   onLoadStop: (controller, url) async {
//                     pullToRefreshController.endRefreshing();
//                     setState(() {
//                       this.url = url.toString();
//                       urlController.text = this.url;
//                     });
//                   },
//                   onLoadError: (controller, url, code, message) {
//                     pullToRefreshController.endRefreshing();
//                   },
//                   onProgressChanged: (controller, progress) {
//                     if (progress == 100) {
//                       pullToRefreshController.endRefreshing();
//                     }
//                     setState(() {
//                       this.progress = progress / 100;
//                       urlController.text = this.url;
//                     });
//                   },
//                   onUpdateVisitedHistory: (controller, url, androidIsReload) {
//                     setState(() {
//                       this.url = url.toString();
//                       urlController.text = this.url;
//                     });
//                   },
//                   onConsoleMessage: (controller, consoleMessage) {
//                     print(consoleMessage);
//                   },
//                 ),
//                 progress < 1.0
//                     ? LinearProgressIndicator(value: progress)
//                     : Container(),
//               ],
//             ),
//           ),
//         ])));
//   }
// }
