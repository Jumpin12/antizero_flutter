import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final Function accept;
  final Function onSubmit;
  final Color color;
  const SubmitButton({this.accept, this.onSubmit, this.color, key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            GestureDetector(
                onTap: accept,
                child: Icon(
                  Icons.beenhere_sharp,
                  color: color,
                  size: 15,
                )),
            Text('Accept all',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 8)),
            GestureDetector(
              onTap: () {},
              child: Text(
                ' Terms and Conditons',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.blue[300],
                    fontSize: 8),
              ),
            )
          ],
        ),
        GestureDetector(
          onTap: onSubmit,
          child: Container(
            decoration: BoxDecoration(
              // shape: NeumorphicShape.convex,
              borderRadius: BorderRadius.circular(12),
              // depth: 10,
              // surfaceIntensity: 0.1,
              // lightSource: LightSource.top,
              // intensity: 0.8,
              color: Colors.blue[100],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Start Vibing!',
                style: TextStyle(fontFamily: 'TrebuchetMS', fontSize: 15),
              ),
            ),
          ),
        )
      ],
    );
  }
}
