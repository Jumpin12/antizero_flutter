import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class InterestCategory extends StatelessWidget {
  final Axis direction;
  final ItemScrollController scrollController;
  final int count;
  final Function(BuildContext, int) builder;
  const InterestCategory(
      {this.direction,
      this.scrollController,
      this.count,
      this.builder,
      Key key});

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      scrollDirection: direction,
      itemScrollController: scrollController,
      itemCount: count,
      physics: const BouncingScrollPhysics(),
      itemBuilder: builder,
    );
  }
}
