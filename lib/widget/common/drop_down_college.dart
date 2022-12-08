import 'package:antizero_jumpin/models/college.dart';
import 'package:antizero_jumpin/models/company.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';

class CustomDropDownCollege extends StatelessWidget {
  final FocusNode focus;
  final String label;
  final String hint;
  final List<DropdownMenuItem<College>> list;
  final Function(College newSelection) onChanged;
  final College selectedValue;
  final Color borderColor;

  const CustomDropDownCollege({
    Key key,
    this.focus,
    this.label,
    this.hint,
    this.list,
    this.onChanged,
    this.selectedValue,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                text: TextSpan(
                    text: '$label',
                    style: bodyStyle(
                        context: context, size: 16, color: Colors.black)),
              ),
            ),
          ),
        DropdownButtonHideUnderline(
          child: Container(
            decoration: BoxDecoration(
                border:
                Border.all(color: borderColor ?? Colors.white, width: 1),
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
              child:
              DropdownButton<College>(
                autofocus: true,
                focusNode: focus ?? null,
                isExpanded: true,
                hint: Text(
                  hint,
                  style: textStyle8,
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                  size: 25.0,
                ),
                style: TextStyle(
                    fontSize: 17.0, fontFamily: sFui, color: Colors.black54),
                items: list,
                onChanged: onChanged,
                value: selectedValue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
