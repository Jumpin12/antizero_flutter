import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/widget/common/fade_animation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomDropDown extends StatefulWidget {
  final FocusNode focus;
  final String label;
  final String hint;
  final Widget leading;
  final List<DropdownMenuItem<String>> list;
  final Function(String newSelection) onChanged;
  final String selectedValue;
  final Color borderColor;

  const CustomDropDown({
    Key key,
    this.focus,
    this.label,
    this.hint,
    this.list,
    this.onChanged,
    this.selectedValue,
    this.borderColor,
    this.leading,
  }) : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  bool showLeading;

  @override
  void initState() {
    super.initState();
    setState(() {
      showLeading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 10),
            child: Text(
              widget.label,
              style: bodyStyle(context: context, size: 16, color: Colors.black),
            ),
          ),
        FadeAnimation(
          0.2,
          DropdownButtonHideUnderline(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: widget.borderColor ?? Colors.white, width: 1),
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: showLeading ? 3.w : 0),
                      child: showLeading
                          ? widget.leading ?? const SizedBox()
                          : const SizedBox(),
                    ),
                    Expanded(
                      child: DropdownButton(
                        autofocus: true,
                        focusNode: widget.focus,
                        isExpanded: true,
                        hint: Text(
                          widget.hint,
                          style: textStyle8,
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                          size: 25.0,
                        ),
                        style: TextStyle(
                          fontSize: 17.0,
                          fontFamily: sFui,
                          color: Colors.black54,
                        ),
                        items: widget.list,
                        onChanged: (value) {
                          widget.onChanged(value);
                          setState(() {
                            showLeading = false;
                          });
                        },
                        value: widget.selectedValue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
