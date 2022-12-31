import 'package:antizero_jumpin/models/favourite_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InterestBlock extends StatefulWidget {
  final Favourite favourite;
  final Function() onTap;
  final Map<String, dynamic> selections;

  const InterestBlock({
    Key key,
    this.favourite,
    this.onTap,
    this.selections
  }) : super(key: key);

  @override
  _InterestBlockState createState() => _InterestBlockState();
}

class _InterestBlockState extends State<InterestBlock>
{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        widget.onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  widget.favourite.icon,
                  color: Color(0xFF71bbf8),
                  size: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.favourite.label,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              if(widget.selections!=null && widget.selections[widget.favourite.label]!=null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.selections[widget.favourite.label].toString().replaceAll('[', '').replaceAll(']', ''),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blueAccent
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
