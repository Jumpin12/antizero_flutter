import 'package:antizero_jumpin/handler/profile.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:flutter/material.dart';

class AgeNameCard extends StatefulWidget {
  final String name;
  final DateTime dob;

  const AgeNameCard({Key key, this.name, this.dob}) : super(key: key);
  @override
  _AgeNameCardState createState() => _AgeNameCardState();
}

class _AgeNameCardState extends State<AgeNameCard> {
  int age;

  @override
  void initState() {
    age = getAgeFromDob(widget.dob);
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 5,top: 5),
        child: Center(
          child: Text('${widget.name}, ${age}',
              textScaleFactor: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorsJumpIn.kPrimaryColor,
                  fontSize: 16)),
        ),
      ),
    );
  }
}
