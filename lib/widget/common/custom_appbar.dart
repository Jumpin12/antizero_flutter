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
class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
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

  CustomAppBar(
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
        this.isFromHome = false})
      : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
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
            widget.search
                ?
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.automaticImplyLeading==true && widget.isFromHome==false)
                       IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: widget.iconColor ?? Colors.yellow,
                            size: 22,
                          ),
                          onPressed: ()
                          {
                            if (widget.toNotification == true)
                            {
                              navigationModel.changePage = 1;
                              Navigator.of(context).push(PageTransition(
                                  child: const DashBoardScreen(),
                                  type: PageTransitionType.fade));
                            } else {
                              Navigator.pop(context);
                            }
                          }),
                    widget.trailing ??
                        SizedBox(
                          width: !widget.automaticImplyLeading ? 0 : 32,
                          height: !widget.automaticImplyLeading ? 0 : 32,
                        ),
                  ],
                ),
                if (widget.logo != true)
                  Center(
                    child: Padding
                      (
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Expanded(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: 'Search...',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (widget.logo == true)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Container(
                            padding: const EdgeInsets.only(right: 10),
                            child: Image.asset(logoIcon,
                                height:
                                SizeConfig.blockSizeHorizontal * 6)),
                        Text(
                          widget.title,
                          style: headingStyle(
                            context: context,
                            size: 20,
                            color: widget.labelColor,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            )
                :
            Stack(
              children: [
                (widget.trailing==null) ?
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
                            if (widget.toNotification == true) {
                              navigationModel.changePage = 1;
                              Navigator.of(context).push(PageTransition(
                                  child: const DashBoardScreen(),
                                  type: PageTransitionType.fade));
                            } else {
                              Navigator.pop(context);
                            }
                          }),
                    widget.trailing ??
                        SizedBox(
                          width: !widget.automaticImplyLeading ? 0 : 32,
                          height: !widget.automaticImplyLeading ? 0 : 32,
                        ),
                  ],
                ) :
                Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.automaticImplyLeading && widget.isFromHome==false)
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: widget.iconColor ?? Colors.yellow,
                        size: 22,
                      ),
                      onPressed: ()
                      {
                        if (widget.toNotification == true)
                        {
                          navigationModel.changePage = 1;
                          Navigator.of(context).push(PageTransition(
                              child: const DashBoardScreen(),
                              type: PageTransitionType.fade));
                        }
                        else
                        {
                          Navigator.pop(context);
                        }
                      }),
                widget.trailing ??
                    SizedBox(
                      width: !widget.automaticImplyLeading ? 0 : 32,
                      height: !widget.automaticImplyLeading ? 0 : 32,
                    ),
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
