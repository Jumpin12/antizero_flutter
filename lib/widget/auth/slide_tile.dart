import 'package:flutter/material.dart';

class SlideTile extends StatelessWidget {
  final String path;
  const SlideTile({Key key, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height - 80,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(path),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
