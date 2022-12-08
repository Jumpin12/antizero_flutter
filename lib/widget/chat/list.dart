import 'package:antizero_jumpin/widget/common/no_content.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../utils/colors.dart';

class CustomList<T> extends StatelessWidget {
  final List<T> elements;
  final Function(BuildContext context, int index) itemBuilder;
  final Function() onRefresh;
  final bool loading;
  final int crossCount;
  final EdgeInsets padding;
  const CustomList(
      {Key key,
      @required this.elements,
      @required this.itemBuilder,
      @required this.crossCount,
      this.onRefresh,
      this.loading = false,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget gridView = GridView.builder(
      itemBuilder: itemBuilder,
      itemCount: elements.length,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: MediaQuery.of(context).size.height / 3,
        // childAspectRatio: 0.7,
        mainAxisSpacing: 0,
        crossAxisCount: crossCount,
        crossAxisSpacing: 0,
      ),
      padding: padding ?? EdgeInsets.all(0),
    );
    return loading
        ? Center(
            child: SizedBox(
                width: 80,
                height: 80,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballClipRotateMultiple,
                  colors: const [lightGreen],
                )),
          )
        : elements.length == 0
            ? Center(
                child: NoContentImage(
                  onRefresh: onRefresh,
                ),
              )
            : onRefresh == null
                ? gridView
                : RefreshIndicator(child: gridView, onRefresh: onRefresh);
  }
}
