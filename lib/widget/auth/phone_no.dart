import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:flutter/material.dart';

class PhoneNoEntry extends StatelessWidget {
  final TextEditingController phoneNoKey;
  final TextInputType keyBoardType;
  final Function(String) onSave;
  const PhoneNoEntry({
    this.phoneNoKey,
    this.onSave,
    this.keyBoardType,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: SizeConfig.bodyWidth * 0.02),
        child: TextFormField(
          onSaved: onSave,
          controller: phoneNoKey,
          keyboardType: keyBoardType,
          style: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal * 4,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(20),
              focusedBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black, width: 0.0),
              ),
              border: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black, width: 0.0),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black, width: 0.0),
              ),
              labelText: 'Enter Phone Number',
              hintText: '9876543210',
              hintStyle: TextStyle(color: Colors.black38),
              labelStyle:
                  TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
              hoverColor: ColorsJumpIn.kPrimaryColorLite),
        ),
      ),
    );
  }
}
