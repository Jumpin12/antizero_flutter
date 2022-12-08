import 'package:antizero_jumpin/provider/navigator.dart';
import 'package:antizero_jumpin/screens/dashboard/dashboard.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

// drawer header eg. location header with back button n title
class CustomAppBarProfile extends StatefulWidget with PreferredSizeWidget {
  final String title;
  final bool logo;
  final Widget trailing;
  final bool automaticImplyLeading;
  final bool toNotification;
  final bool search;
  final Color labelColor;
  final Color iconColor;
  final Color backgroundColor;
  final Widget leading;
  final bool isFromHome;
  final Function onUpdate;

  CustomAppBarProfile(
      {Key key,
        this.logo = false,
        this.title,
        this.trailing,
        this.automaticImplyLeading = false,
        this.toNotification = false,
        this.backgroundColor,
        this.labelColor = Colors.black,
        this.iconColor = Colors.black,
        this.search = false,
        this.leading,
        this.isFromHome = false,this.onUpdate})
      : super(key: key);

  @override
  _CustomAppBarProfileState createState() => _CustomAppBarProfileState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarProfileState extends State<CustomAppBarProfile> {
  @override
  Widget build(BuildContext context) {
    NavigationModel navigationModel = Provider.of<NavigationModel>(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Container(
        color: widget.backgroundColor,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child:
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (widget.automaticImplyLeading && widget.isFromHome==false)
                      IconButton(
                          icon:
                          Icon(
                            Icons.arrow_back_ios,
                            color: widget.iconColor ?? Colors.yellow,
                            size: 22,
                          ),
                          onPressed: () {
                            widget.onUpdate();
                            Navigator.pop(context);
                          }),
                  ],
                ),
                if (widget.logo != true)
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: bodyStyle(
                          context: context,
                          size: 18,
                          color: widget.labelColor ?? Colors.black87,
                        ),
                      ),
                    ),
                  ),
                if (widget.logo == true)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Stack(
                      children: [
                        if (widget.leading!=null)
                          widget.leading,
                        // Container(
                        //     padding: const EdgeInsets.only(right: 10),
                        //     child: Image.asset(logoIcon,
                        //         height:
                        //         SizeConfig.blockSizeHorizontal * 6,color: Colors.white,)),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            widget.title,
                            textAlign: TextAlign.center,
                            style: bodyStyle(
                              context: context,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
