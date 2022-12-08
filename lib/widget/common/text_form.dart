import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormField extends StatefulWidget {
  final String label;
  final String richLabel;
  final int maxLine;
  final int minLine;
  final String labelText;
  final bool readOnly;
  final Color fillColor;
  final FocusNode focus;
  final String hint;
  final String initValue;
  final Widget prefix;
  final Widget suffix;
  final TextEditingController controller;
  final TextInputType inputType;
  final InputBorder border;
  final Function validatorFn;
  final Function onChanged;
  final Function onTap;
  final Function onFiledSubmitted;

  const CustomFormField(
      {Key key,
      this.label,
      this.richLabel,
      this.maxLine,
      this.minLine,
      this.labelText,
      this.readOnly,
      this.fillColor,
      this.focus,
      this.hint,
      this.initValue,
      this.prefix,
      this.suffix,
      this.controller,
      this.inputType,
      this.border,
      this.validatorFn,
      this.onChanged,
      this.onTap,
      this.onFiledSubmitted})
      : super(key: key);

  @override
  _CustomFormFieldState createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  @override
  Widget build(BuildContext context) {
    print(widget.label);
    print(widget.validatorFn);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 10),
            child: Text(
              '${widget.label}',
              style: headingStyle(
                      context: context, size: 17, color: Colors.black54)
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        if (widget.richLabel != null)
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 5, bottom: 10),
            child: RichText(
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              text: TextSpan(
                  text: widget.richLabel,
                  style: bodyStyle(
                      context: context, size: 16, color: Colors.black),
                  children: [
                    TextSpan(
                      text: " *",
                      style: bodyStyle(
                          context: context, size: 14, color: Colors.redAccent),
                    ),
                  ]),
            ),
          ),
        TextFormField(
          maxLines: widget.maxLine ?? 1,
          minLines: widget.minLine ?? 1,
          readOnly: widget.readOnly ?? false,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          focusNode: widget.focus,
          controller: widget.controller ?? null,
          initialValue: widget.initValue ?? null,
          textInputAction: TextInputAction.next,
          style: bodyStyle(context: context, size: 18, color: Colors.black87),
          keyboardType: widget.inputType,
          inputFormatters: widget.inputType == TextInputType.number ?
              <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly] : null,
          decoration: InputDecoration(
              labelText: widget.labelText ?? null,
              labelStyle: widget.labelText == null
                  ? null
                  : TextStyle(
                      color: Colors.grey,
                      fontSize: SizeConfig.blockSizeHorizontal * 4.2),
              filled: true,
              fillColor: widget.fillColor ?? Colors.white,
              hoverColor: Color(0xffd0f1fa),
              enabledBorder: widget.border ??
                  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey)),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              focusedBorder: widget.border ??
                  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.6),
                      )),
              border: widget.border ??
                  OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
              suffixIcon: widget.suffix ?? null,
              prefixIcon: widget.prefix ?? null,
              hintText: widget.hint ?? null,
              hintStyle: widget.hint != null
                  ? bodyStyle(context: context, size: 16, color: Colors.grey)
                  : null),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: widget.validatorFn ?? null,
          onChanged: widget.onChanged ?? (String value) {},
          onTap: widget.onTap ?? () {},
          onFieldSubmitted: widget.onFiledSubmitted ?? (String value) {},
        ),
      ],
    );
  }
}
