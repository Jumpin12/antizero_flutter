import 'dart:ui';

import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

void showToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.SNACKBAR,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black26,
    textColor: Colors.white,
    fontSize: 15.0,
  );
}

void buildDialog(String title, String content, BuildContext context,
    {bool allow = false, Function onAllow}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: <Widget>[
                if (allow)
                  MaterialButton(
                      elevation: 5,
                      color: Colors.blue,
                      onPressed: onAllow,
                      child: Text(
                        "Continue",
                        style: bodyStyle(
                            context: context, size: 14, color: Colors.white),
                      )),
                if (!allow)
                  MaterialButton(
                      elevation: 5,
                      color: Colors.redAccent,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Close",
                        style: bodyStyle(
                            context: context, size: 14, color: Colors.white),
                      )),
              ]),
        );
      });
}

void undoRequest(BuildContext context, Function onAllow) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
              title: Text('Undo request'),
              content:
                  Text('You have denied the request, Do you want to undo?'),
              actions: <Widget>[
                MaterialButton(
                    elevation: 5,
                    color: Colors.blue,
                    onPressed: onAllow,
                    child: Text(
                      "Undo",
                      style: bodyStyle(
                          context: context, size: 14, color: Colors.white),
                    )),
                MaterialButton(
                    elevation: 5,
                    color: Colors.redAccent,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: bodyStyle(
                          context: context, size: 14, color: Colors.white),
                    )),
              ]),
        );
      });
}

void showError({BuildContext context, String errMsg}) {
  final size = MediaQuery.of(context).size;
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        width: size.width,
        padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
        child: Text(
          errMsg,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.red[800].withOpacity(0.8),
              fontWeight: FontWeight.w500,
              fontSize: size.height * 0.02),
        ),
      );
    },
  );
}

void successTick(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
        });
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Lottie.asset('assets/animations/success.json',
              repeat: false, animate: true),
        );
      });
}
