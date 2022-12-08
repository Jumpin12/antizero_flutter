import 'package:flutter/material.dart';

class InterestSubCategory extends StatelessWidget {
  final int count;
  final Function(BuildContext, int) builder;
  const InterestSubCategory({Key key, this.builder, this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: count,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: builder);
  }
}
