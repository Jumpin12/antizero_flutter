import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';

class PageThird extends StatelessWidget {
  const PageThird({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: _size.height * .9,
          width: _size.width,
          child: Image.asset('assets/images/OnBoard/page3.jpg'),
        ),
        Container(
          height: _size.height * .9,
          width: _size.width,
          color: Colors.black26,
        ),
        Positioned(
          top: _size.height * 0.45,
          left: _size.width * 0.3,
          child: Container(
              width: _size.width * 0.6,
              height: _size.height * 0.15,
              padding: EdgeInsets.all(_size.height * 0.005),
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/Home/bottom-left.png",
                    height: 50,
                  ),
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(
                            top: _size.height * 0.05,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          alignment: Alignment.center,
                          child: Text(
                            "Enter location to see distance from potential connections",
                            textAlign: TextAlign.center,
                            style: textStyle4,
                          ))),
                ],
              )),
        ),
        Positioned(
          right: 0,
          top: _size.height * 0.18,
          child: Container(
              width: _size.width * 0.6,
              height: _size.height * 0.15,
              padding: EdgeInsets.all(_size.height * 0.005),
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/Home/right.png",
                    height: 50,
                  ),
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(
                            bottom: _size.height * 0.05,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          alignment: Alignment.center,
                          child: Text(
                            "Link social media to identify more mutual friends",
                            textAlign: TextAlign.center,
                            style: textStyle4,
                          ))),
                ],
              )),
        )
      ],
    );
  }
}
