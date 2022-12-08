import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomButton extends StatelessWidget {
  final FocusNode focusNode;
  final Function() onTap;
  final String label;
  final Color labelColor;
  final bool loading;
  final double height;
  final double length;
  final double curve;
  final Color bgColor;
  final TextStyle labelStyle;
  const CustomButton(
      {Key key,
      this.focusNode,
      this.onTap,
      this.label,
      this.labelColor,
      this.loading = false,
      this.height,
      this.length,
      this.curve,
      this.bgColor,
      this.labelStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusNode: focusNode,
      onTap: onTap,
      child: Container(
        height: height ?? 57,
        width: length ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(curve ?? 10.0),
            color: bgColor == null
                ? Colors.redAccent
                    .withOpacity(onTap == null || loading ? 0.5 : 0.9)
                : bgColor.withOpacity(onTap == null || loading ? 0.5 : 0.9)),
        alignment: Alignment.center,
        child: loading
            ? Center(
                child: SizedBox(
                    width: 32,
                    height: 32,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballScaleMultiple,
                      colors: const [Colors.white]
                    )),
              )
            : Text(
                label,
                style: labelStyle ??
                    headingStyle(
                        context: context, size: 18, color: labelColor ?? black),
              ),
      ),
    );
  }
}
