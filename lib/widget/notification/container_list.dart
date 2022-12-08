import 'package:flutter/material.dart';

class ContainerListView extends StatelessWidget {
  final Gradient gradient;
  final bool heading;
  final int count;
  final Function(BuildContext, int) builder;
  final String title;
  final String allText;
  final Function onAll;

  const ContainerListView(
      {Key key,
      this.gradient,
      this.allText,
      this.heading = false,
      this.title,
      this.onAll,
      this.count,
      this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: gradient,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            if (heading == true)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.brown,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0),
                  ),
                  TextButton(onPressed: onAll, child: Text(allText))
                ],
              ),
            if (heading == true)
              Divider(
                color: Colors.white.withOpacity(0.8),
                thickness: 3.0,
                height: 0,
              ),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 10),
                itemCount: count,
                itemBuilder: builder),
          ],
        ),
      ),
    );
  }
}
