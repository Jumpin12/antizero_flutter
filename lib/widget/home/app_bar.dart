import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/widget/common/chat_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;
  final bool leading;
  final bool trailing;
  final bool filter;
  final Function onFilter;
  final String commentCount;
  final bool isFromMyPlan;
  final Function onEditPlan;

  HomeAppBar(
      {Key key,
      this.title,
      this.commentCount,
      this.onFilter,
      this.leading = false,
      this.trailing = true,
      this.filter = false,
      this.isFromMyPlan = false,
      this.onEditPlan})
      : super(key: key);

  @override
  _HomeAppBarState createState() => _HomeAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      centerTitle: true,
      leading: widget.leading == true
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black87,
                size: 22,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              })
          : null,
      title: Row(
        children: [
          Container(
              margin: const EdgeInsets.only(right: 10),
              child: Image.asset(logoIcon,
                  height: SizeConfig.blockSizeHorizontal * 6)),
          Text(
            widget.title,
            style:
                headingStyle(context: context, size: 20, color: Colors.black),
          ),
        ],
      ),
      actions: widget.trailing == true
          ? [
              if (widget.filter == true)
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: IconButton(
                    icon: Icon(
                      Icons.sort,
                      color: Colors.black,
                      size: 22,
                    ),
                    onPressed: widget.onFilter,
                  ),
                ),
              if(widget.isFromMyPlan == false)
                ChatIcon(
                count: widget.commentCount,
                ),
              if(widget.isFromMyPlan == true)
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.black,
                      size: 22,
                    ),
                    onPressed: widget.onEditPlan,
                  ),
                ),
            ]
          : null,
    );
  }
}
