import 'package:antizero_jumpin/models/favourite_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InterestBlock extends StatelessWidget {
  final Favourite favourite;
  final Function() onTap;

  const InterestBlock({
    Key key,
    this.favourite,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                favourite.icon,
                color: Color(0xFF71bbf8),
                size: 35,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                favourite.label,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
