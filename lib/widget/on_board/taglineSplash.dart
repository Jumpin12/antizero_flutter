import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';

class TaglineJI extends StatelessWidget {
  const TaglineJI({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, top: 2, right: 2),
            child: Text('Discover interest-twins near you',
                style: TextStyle(
                    fontFamily: tre,
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic)),
          ),
        ],
      ),
    );
  }
}
