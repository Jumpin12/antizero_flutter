import 'package:flutter/material.dart';

class EmptyCategoryContainer extends StatelessWidget {
  final BoxConstraints constraints;
  const EmptyCategoryContainer({Key key, this.constraints}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: constraints.maxWidth,
      height: constraints.maxHeight * 0.63,
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
        child: Column(
          children: [
            Icon(Icons.assistant, color: Colors.black.withOpacity(0.7)),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03),
              child: Text(
                "Select an interest and then sub-interests",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16, color: Colors.black.withOpacity(0.7)),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(
            //       top: MediaQuery.of(context).size.height * 0.015),
            //   child: Text(
            //     "(Long press an interest to remove selection)",
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //         fontSize: 14,
            //         color: Colors.black45),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
