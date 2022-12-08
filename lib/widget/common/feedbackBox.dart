import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/decoration.dart';
import 'package:flutter/material.dart';

class FeedbackBox extends StatelessWidget {
  final String question;
  const FeedbackBox({this.question, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            decoration: decoration3,
            padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
            child: Text(
              question,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: white,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
            ),
            height: 100,
          )
        ],
      ),
    );
  }
}
