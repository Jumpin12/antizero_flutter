import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:antizero_jumpin/widget/home/app_bar.dart';

class WebViewPage extends StatefulWidget {
  @override
  WebViewPageState createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        title: 'JUMPIN',
        leading: true,
        trailing: false,
      ),
      body: WebView(
        initialUrl: 'https://jumpin.co.in',
      ),
    );
  }
}
