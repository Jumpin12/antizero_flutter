import 'package:antizero_jumpin/handler/local.dart';
import 'package:antizero_jumpin/provider/plan.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserAgeCard extends StatelessWidget {

  final bool entryFree;
  final String fees;
  final bool age;
  final String ageLimit;

  const UserAgeCard(
      {Key key,this.entryFree,this.fees,this.age,this.ageLimit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(4.0),
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: size.width * 0.458 - 50,
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.02),
                  child: Column(
                    children: [
                      Container(
                        height: size.height * 0.06,
                        child: Image.asset(
                          moneyIcon,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          if (entryFree ==
                              true)
                            Text(
                              "Entry fee : ",
                              style: TextStyle(
                                  color: Colors.black
                                      .withOpacity(0.6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          Flexible(
                            child: Text(
                                entryFree ==
                                    true
                                    ? '\u{20B9} ${fees}'
                                    : "Free Entry",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black
                                        .withOpacity(0.7),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: size.width * 0.458,
                  child: Column(
                    children: [
                      Container(
                        width: size.width * 0.06,
                        height: size.height * 0.06,
                        child: Image.asset(ageIcon),
                      ),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          if (age ==
                              true)
                            Text(
                              "For people above : ",
                              style: TextStyle(
                                  color: Colors.black
                                      .withOpacity(0.6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          Flexible(
                            child: Text(age ==
                                    true
                                    ? "${ageLimit} Yrs"
                                    : 'No Age Restriction',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black
                                        .withOpacity(0.7),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
