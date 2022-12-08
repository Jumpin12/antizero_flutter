import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final TextEditingController searchcontroller;
  final Function(String newSelection) onSubmitted;

  const SearchWidget({Key key,this.searchcontroller,this.onSubmitted})
      : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
@override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8.0,right: 8.0,top: 0.0,bottom: 0.0),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child:
        TextField(
          onSubmitted: (value){
            widget.onSubmitted(value);
          },
          controller: widget.searchcontroller,
          decoration: InputDecoration
            (
              labelText: "Search",
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)))
            ),
        ),
      ),
    );
  }
}
