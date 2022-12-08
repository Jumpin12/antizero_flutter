import 'package:antizero_jumpin/utils/colors.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';

class FancyFab extends StatefulWidget {
  final Function onPublic;
  final Function onPrivate;

  const FancyFab({Key key, this.onPublic, this.onPrivate}) : super(key: key);
  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;
  bool checkFABStatus = false;

  @override
  initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  check() {
    if (checkFABStatus == false) {
      _animationController.forward();
      checkFABStatus = true;
    } else {
      _animationController.reverse();
      checkFABStatus = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionBubble(
      // Menu items
      items: <Bubble>[
        Bubble(
          title:
              "Create a Public Plan if you want \nto allow anyone on the app to JumpIn",
          iconColor: Colors.white,
          bubbleColor: Colors.white,
          icon: null,
          titleStyle: TextStyle(fontSize: 12, color: Colors.black54),
          onPress: null,
        ),
        Bubble(
          title: " Create public plan",
          iconColor: Colors.white,
          bubbleColor: blue,
          icon: null,
          titleStyle: TextStyle(fontSize: 16, color: Colors.white),
          onPress: widget.onPublic,
        ),
        Bubble(
          title:
              "Create a Private Plan if you only want \nto add users from your connections \nto the plan",
          iconColor: Colors.white,
          bubbleColor: Colors.white,
          icon: null,
          titleStyle: TextStyle(fontSize: 12, color: Colors.black54),
          onPress: null,
        ),
        Bubble(
          title: "Create private plan",
          iconColor: Colors.white,
          bubbleColor: blue,
          icon: null,
          titleStyle: TextStyle(fontSize: 16, color: Colors.white),
          onPress: widget.onPrivate,
        ),
      ],
      animation: _animation,
      onPress: check,
      iconColor: blue,
      animatedIconData: AnimatedIcons.add_event,
      backGroundColor: checkFABStatus == true ? Colors.redAccent : blue,
    );
  }
}
