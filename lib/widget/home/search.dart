import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final TextEditingController searchController;
  final Function(String) handleSearch;
  final String hint;

  const SearchBar({this.searchController, this.handleSearch, this.hint});
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  InputBorder border = OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(10),
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.blueGrey.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        cursorColor: blue,
        controller: widget.searchController,
        textInputAction: TextInputAction.search,
        style: bodyStyle(context: context, size: 18, color: Colors.black54)
            .copyWith(fontFamily: sFui),
        decoration: InputDecoration(
          border: border,
          focusedBorder: border,
          enabledBorder: border,
          errorBorder: InputBorder.none,
          disabledBorder: border,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
          isDense: false,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(bottom: 1.0),
            child: Icon(
              Icons.search,
              color: Colors.grey,
              size: 24,
            ),
          ),
          hintText: widget.hint,
          hintStyle:
              bodyStyle(context: context, size: 16, color: Colors.grey[400]),
          filled: true,
          fillColor: Color.fromRGBO(245, 247, 251, 1.0),
        ),
        onChanged: widget.handleSearch,
      ),
    );
  }
}
