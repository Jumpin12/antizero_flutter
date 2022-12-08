import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:flutter/material.dart';

class CustomLogoButton extends StatefulWidget {
  final Function onTap;
  final String title;
  final bool loading;
  final bool icon;
  final String logo;
  final Color color;
  final Color iconColor;
  final IconData iconData;
  final FocusNode focus;
  const CustomLogoButton(
      {this.logo,
        this.onTap,
        this.title,
        this.loading = false,
        this.color,
        this.focus,
        this.iconData,
        this.icon = false,
        this.iconColor,
        Key key})
      : super(key: key);

  @override
  _CustomLogoButtonState createState() => _CustomLogoButtonState();
}

class _CustomLogoButtonState extends State<CustomLogoButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      focusNode: widget.focus ?? null,
      onPressed: widget.onTap,
      child: Container(
          decoration: BoxDecoration(
            // shape: NeumorphicShape.convex,
              borderRadius: BorderRadius.circular(12),
              // depth: 8,
              // lightSource: LightSource.top,
              color: widget.color ?? bluelite),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
            child: widget.loading
                ? fadedCircle(32, 32)
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.logo != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Image(
                      image: AssetImage(widget.logo),
                      width: 25,
                      height: 25,
                    ),
                  ),
                if (widget.icon == true)
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Icon(
                      widget.iconData,
                      size: 20,
                      color: widget.iconColor,
                    ),
                  ),
                Text(
                  "${widget.title}",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.8),
                      fontSize: 20),
                )
              ],
            ),
          )),
    );
  }
}
