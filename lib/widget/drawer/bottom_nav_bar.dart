import 'package:antizero_jumpin/handler/chat.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  final Color backgroundColor;
  final Function(int value) onTap;
  final bool showUnselectedLabels;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final BottomNavigationBarType type;
  final TextStyle selectedLabelStyle;
  final bool showSelectedLabels;
  final int currentIndex;

  const BottomNavBar({
    Key key,
    this.backgroundColor,
    this.onTap,
    this.showUnselectedLabels = false,
    this.selectedItemColor = blue,
    this.unselectedItemColor = Colors.black54,
    this.type = BottomNavigationBarType.fixed,
    this.selectedLabelStyle,
    this.showSelectedLabels = false,
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    return BottomNavigationBar(
      elevation: 0,
      key: key,
      currentIndex: currentIndex,
      backgroundColor: backgroundColor ?? Colors.white,
      onTap: onTap,
      showUnselectedLabels: showUnselectedLabels,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      type: type,
      selectedLabelStyle: selectedLabelStyle ??
          GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
      showSelectedLabels: showSelectedLabels,
      items: [
        const BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/images/Onboarding/logo_final.png'),
            color: Colors.grey,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: currentIndex == 1
              ? SvgPicture.asset(bellIcon, color: blue)
              : SvgPicture.asset(bellIcon),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          // icon: SvgPicture.asset(
          //   navmessagesIcon,
          //   color: Colors.grey,
          // ),
          icon: Container(
            child: new Stack(
              children: <Widget>[
                SvgPicture.asset(
                  navmessagesIcon,
                  color: Colors.grey,
                  height: 20,
                ),
                new Positioned(
                  right: 0,
                  top: 0,
                  child: new Container(
                    padding: EdgeInsets.all(1),
                    decoration: new BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 10,
                      minHeight: 10,
                    ),
                    child: new Text(
                      '${userProvider.unseenMsgCount}',
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
          label: 'Messages',
        ),
        BottomNavigationBarItem(
          icon: currentIndex == 2
              ? SvgPicture.asset(
            userSquareIcon,
            color: blue,
          )
              : SvgPicture.asset(userSquareIcon),
          label: 'Profile',
        ),
      ],
    );
  }
}
