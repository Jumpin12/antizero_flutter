import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/widget/common/fade_animation.dart';
import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final FocusNode focusNode;
  final List<T> items;
  final Function(T value) onChanged;
  final Widget Function(T item) itemBuilder;
  final T value;
  final String hint;
  const CustomDropdown(
      {Key key,
      this.label,
      this.focusNode,
      this.items,
      this.onChanged,
      this.value,
      this.itemBuilder,
      this.hint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 10),
            child: Text(
              '$label',
              style: textStyle6,
            ),
          ),
        FadeAnimation(
          0.2,
          DropdownButtonHideUnderline(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5.0, 10.0, 5.0),
                child: DropdownButton(
                  autofocus: true,
                  focusNode: focusNode,
                  isExpanded: true,
                  hint: Text(
                    hint,
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: sFui,
                        color: Colors.grey[400]),
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                    size: 25.0,
                  ),
                  style: TextStyle(
                      fontSize: 14.0, fontFamily: sFui, color: Colors.black54),
                  items: items.map((item) {
                    return DropdownMenuItem(
                      child: itemBuilder(item),
                      value: item,
                    );
                  }).toList(),
                  onChanged: onChanged,
                  value: value,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
