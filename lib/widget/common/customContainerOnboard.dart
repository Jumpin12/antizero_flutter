import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final String img;
  final String title;
  const CustomContainer({this.img, this.title, key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // depth: 10,
        // intensity: 0.7,
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      padding: EdgeInsets.zero,
      child: Container(
          height: 38,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(img, height: 12),
              SizedBox(
                width: 2,
              ),
              Text(title,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ],
          )),
    );
  }
}
