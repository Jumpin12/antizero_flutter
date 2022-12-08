import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:antizero_jumpin/handler/dynamic_link.dart';
import 'package:antizero_jumpin/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

Future<Null> urlFileShare(BuildContext context) async {
  if (Platform.isAndroid) {
    var url =
        'https://firebasestorage.googleapis.com/v0/b/antizero-jumpin.appspot.com/o/logo%2Ficon1_circle.png?alt=media&token=6d50f486-a65a-46b1-849d-a2dd2e1bd692';
    var response = await get(Uri.parse(url));
    final documentDirectory = (await getExternalStorageDirectory()).path;
    File imgFile = new File('$documentDirectory/jumpin-logo.png');
    imgFile.writeAsBytesSync(response.bodyBytes);

    Share.shareFiles(['$documentDirectory/jumpin-logo.png'],
        subject: 'Share JumpIn',
        text:
            "I\'m enjoying my time at JUMPIN and want you to join the party. Use the link https://play.google.com/store/apps/details?id=in.antizero.Jumpin to download JUMPIN - the app that discovers interest-twins near you.");
  } else {
    Share.share(
      'I\'m enjoying my time at JUMPIN and want you to join the party. Use the link https://play.google.com/store/apps/details?id=in.antizero.Jumpin to download JUMPIN - the app that discovers interest-twins near you.',
      subject: 'Share JumpIn',
    );
  }
}

Future<Null> urlShare(Uri url, {mode}) async {
  if (await canLaunchUrl(url))
    await launchUrl(url,mode: LaunchMode.externalApplication);
  else
    // can't launch url, there is some error
    throw "Could not launch $url";
}

Future<bool> capturePng(String userid, GlobalKey _globalKey) async {
  RenderRepaintBoundary boundary =
      _globalKey.currentContext.findRenderObject() as RenderRepaintBoundary;
  try {
    ui.Image image = await boundary.toImage();
    if (image != null) {
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      final documentDirectory = (await getExternalStorageDirectory()).path;
      final File imgFile = File('$documentDirectory/${userid}_image.png');
      imgFile.writeAsBytesSync(pngBytes);
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future<Null> recommendPlan(
    BuildContext context, String planName, String id) async {
  // if (Platform.isAndroid) {
  //   String link = await GetIt.instance<DynamicLinkHandler>()
  //       .createDynamicLink(id, kDynamicLinkType.Plan);
  //   if (link != null) {
  //     final documentDirectory = (await getExternalStorageDirectory()).path;
  //     File imgFile = File('$documentDirectory/${id}_image.png');
  //     Share.shareFiles([imgFile.path],
  //         subject: 'Plan Recommendations',
  //         text:
  //             "There is something that tells me that this plan $planName would be incomplete without you.\nUse this link( $link ) to join the plan on JUMPIN  - the app that discovers interest twins near you. \n www.jumpin.co.in");
  //   }
  // } else {
  //   String link = await GetIt.instance<DynamicLinkHandler>()
  //       .createDynamicLink(id, kDynamicLinkType.Plan);
  //   if (link != null) {
  //     Share.share(
  //       'There is something that tells me that this plan $planName would be incomplete without you.\nUse this link( $link ) to join the plan on JUMPIN  - the app that discovers interest twins near you. \n www.jumpin.co.in',
  //       subject: 'Plan Recommendations',
  //     );
  //   }
  // }
}

Future<Null> recommend(BuildContext context, String userName, String id) async {
  // String link = await GetIt.instance<DynamicLinkHandler>()
  //     .createDynamicLink(id, kDynamicLinkType.People);
  // if (link != null) {
  //   final documentDirectory = (await getExternalStorageDirectory()).path;
  //   File imgFile = File('$documentDirectory/${id}_image.png');
  //   Share.shareFiles([imgFile.path],
  //       subject: 'People Recommendations',
  //       text:
  //           "You know that I have great taste, and I have a feeling that you and $userName will vibe very well.(Thank me later) \n Use this link( $link ) to connect on JUMPIN  - the app that discovers interest twins near you. \n www.jumpin.co.in");
  // }
}

Future<bool> takeScreenShot(
    Uint8List image, BuildContext context, String userId) async {
  try {
    // Uint8List image = await screenshotController
    //     .capture(delay: Duration(milliseconds: 10));
    final documentDirectory = (await getExternalStorageDirectory()).path;
    final File imgFile = File('$documentDirectory/${userId}_image.png');
    imgFile.writeAsBytesSync(image);
    return true;
  } catch (e) {
    print(e.toString);
    return false;
  }
}
