import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateDialog extends StatelessWidget {
  const UpdateDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String playStoreUrl =
        'https://play.google.com/store/apps/details?id=in.antizero.Jumpin';
    String appStoreUrl =
        'https://apps.apple.com/in/app/jumpin-find-interest-twins/id1592923405';

    return Platform.isIOS
        ? CupertinoAlertDialog(
            title: Text('Update Required'),
            content: Text('An update is required to continue using this app'),
            actions: [
              CupertinoButton(
                child: Text('Update Now'),
                onPressed: () async {
                  if (await canLaunch(appStoreUrl)) {
                    await launch(appStoreUrl);
                  } else {
                    throw 'Could not launch $appStoreUrl';
                  }
                },
              ),
            ],
          )
        : AlertDialog(
            title: Text('Update Required'),
            content: Text('An update is required to continue using this app'),
            actions: [
              TextButton(
                onPressed: () async {
                  if (await canLaunch(playStoreUrl)) {
                    await launch(playStoreUrl);
                  } else {
                    throw 'Could not launch $playStoreUrl';
                  }
                },
                child: Text(
                  'Update Now',
                ),
              ),
            ],
          );
  }
}
