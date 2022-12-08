import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/widget/common/back_card.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;
  const CustomListTile({Key key, this.icon, this.title, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: skyBlue1.withOpacity(0.2),
      child: ListTile(
        tileColor: Colors.blueGrey,
        onTap: onTap,
        leading: SizedBox(
          width: 60,
          child: CustomIconCard(
            onTap: () {},
            color: skyBlue1.withOpacity(0.6),
            icon: icon,
          ),
        ),
        title: Text(
          title,
          style: bodyStyle(context: context, size: 20, color: Colors.black54),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.black54,
          size: 15,
        ),
      ),
    );
  }
}
