import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';

AppBar HomeAppBar(BuildContext context, bool leading, String title) {
  int noOfMessage = 0;
  return AppBar(
    automaticallyImplyLeading: leading,
    title: Row(
      children: [
        Image.asset('assets/images/Onboarding/logo_final.png', height: 25),
        SizedBox(
          width: 5,
        ),
        Text(title,
            style: TextStyle(
                fontFamily: sFui, fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    ),
    actions: [
      GestureDetector(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: Image.asset(
                  'assets/images/Home/chatIcon1.png',
                  height: 30,
                ),
              ),
            ),
            Positioned(
              right: 4,
              top: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(noOfMessage.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    ],
  );
}
