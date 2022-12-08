import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/screens/home/jumpInuser_profile.dart';
import 'package:antizero_jumpin/screens/home/plans/current_plan.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ChatHeader extends StatelessWidget {
  final JumpInUser user;
  final bool plan;
  final String planName;
  final String planImg;
  const ChatHeader(
      {Key key, this.user, this.plan = false, this.planName, this.planImg})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.24,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue[900], Colors.blue],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight)),
      child: LayoutBuilder(builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.only(
              left: constraints.maxWidth * 0.05,
              right: constraints.maxWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        if (plan == false) {
                          Navigator.of(context).push(PageTransition(
                              child: JumpInUserPage(
                                user: user,
                                withoutProvider: true,
                              ),
                              type: PageTransitionType.fade));
                        } else {
                          Navigator.of(context).push(
                            PageTransition(
                              child: CurrentPlanPage(),
                              type: PageTransitionType.fade,
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // boxShape: NeumorphicBoxShape.circle(),
                          // depth: 10,
                          // surfaceIntensity: 0.1,
                          // shadowLightColor: Colors.blue[800],
                          // shadowDarkColor: Colors.blue[800],
                          // lightSource: LightSource.top,
                          // intensity: 1,
                        ),
                        child: plan == false || planImg == null
                            ? CircleAvatar(
                                radius: constraints.maxHeight * 0.26,
                                backgroundImage: user.photoList.last == null
                                    ? AssetImage(avatarIcon)
                                    : NetworkImage(user.photoList.last),
                              )
                            : CircleAvatar(
                                radius: constraints.maxHeight * 0.26,
                                backgroundImage: planImg == null
                                    ? AssetImage(avatarIcon)
                                    : NetworkImage(planImg),
                              ),
                      )),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: constraints.maxHeight * 0.2,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: plan == false || planName == null
                    ? Text(user.name ?? 'JumpIn user',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: constraints.maxHeight * 0.15,
                            fontWeight: FontWeight.w900))
                    : Text(planName ?? 'JumpIn user',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: constraints.maxHeight * 0.15,
                            fontWeight: FontWeight.w900)),
              ),
            ],
          ),
        );
      }),
    );
  }
}
