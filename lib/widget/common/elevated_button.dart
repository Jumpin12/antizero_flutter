import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

enum ElevatedButtonType {
  createPlan,
  none,
}

class CustomElevatedButton extends StatelessWidget {
  final Color bgColor;
  final double curve;
  final FocusNode focus;
  final Function onTap;
  final bool loading;
  final String label;
  final double loaderSize;
  final double labelSize;
  final Color labelColor;
  final ElevatedButtonType buttonType;
  const CustomElevatedButton(
      {this.bgColor,
        this.curve,
        this.focus,
        this.onTap,
        this.loading,
        this.label,
        this.labelSize,
        this.labelColor,
        this.loaderSize,
        this.buttonType = ElevatedButtonType.none,
        Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buttonType == ElevatedButtonType.createPlan
        ? GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90.w,
        height: 7.h,
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: loading
              ? fadedCircle(loaderSize, loaderSize)
              : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(createGalleryIcon),
              SizedBox(
                width: 3.w,
              ),
              Expanded(
                child: Text(
                  label,
                  style: bodyStyle(
                    context: context,
                    size: labelSize ?? 16,
                    color: labelColor ?? Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                width: 3.w,
              ),
              SvgPicture.asset(createAttachIcon),
            ],
          ),
        ),
      ),
    )
        : ElevatedButton(
      focusNode: focus,
      style: ElevatedButton.styleFrom(
        primary: bgColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(curve)),
      ),
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: loading
            ? fadedCircle(loaderSize, loaderSize)
            : Text(
          label,
          style: bodyStyle(
              context: context, size: labelSize, color: labelColor),
        ),
      ),
    );
  }
}
