import 'package:flutter/material.dart';

class GenderDOB extends StatelessWidget {
  final String title;
  final Widget selection;
  const GenderDOB({this.title, this.selection, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 17,
      ),
      decoration: BoxDecoration(
        // shape: NeumorphicShape.convex,
        borderRadius: BorderRadius.circular(12),
        // depth: 10,
        // surfaceIntensity: 0.1,
        // lightSource: LightSource.top,
        // intensity: 0.8,
        color: Colors.grey[200],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 15,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500),
            ),
          ),
          selection,
        ],
      ),
    );
  }
}

class SelectionButton extends StatelessWidget {
  final Function onTap;
  final bool condition;
  final String img;
  const SelectionButton({this.condition, this.img, this.onTap, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Expanded(
        child: InkWell(
          onTap: onTap,
          child: condition
              ? ImageIcon(
                  AssetImage(
                    img,
                  ),
                  color: Colors.blue,
                  size: 18)
              : ImageIcon(AssetImage(img), size: 18),
        ),
      ),
    );
  }
}
