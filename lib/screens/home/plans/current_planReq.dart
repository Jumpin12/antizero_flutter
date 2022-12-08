import 'package:antizero_jumpin/handler/plan.dart';
import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/models/plan.dart';
import 'package:antizero_jumpin/provider/navigator.dart';
import 'package:antizero_jumpin/screens/dashboard/dashboard.dart';
import 'package:antizero_jumpin/screens/home/jumpInuser_profile.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:antizero_jumpin/utils/common_methods.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/widget/common/custom_appbar.dart';
import 'package:antizero_jumpin/widget/notification/req_card.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class CurrentPlanRequestPage extends StatefulWidget {
  final List<JumpInUser> users;
  final Plan currentPlan;
  const CurrentPlanRequestPage({Key key, this.users, this.currentPlan})
      : super(key: key);

  @override
  _CurrentPlanRequestPageState createState() => _CurrentPlanRequestPageState();
}

class _CurrentPlanRequestPageState extends State<CurrentPlanRequestPage> {
  List<JumpInUser> userReq = [];

  @override
  void initState() {
    if (userReq != null) {
      userReq = widget.users;
    }
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: CustomAppBar(
          automaticImplyLeading: true,
          logo: false,
          toNotification: true,
          title: 'JUMPIN',
        ),
        body: userReq.isEmpty
            ? Container(
                child: Center(
                  child: Text(
                    'No request to accept',
                    style: bodyStyle(
                        context: context, size: 18, color: Colors.grey),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                    itemCount: userReq.length,
                    itemBuilder: (context, index) {
                      return RequestCard(
                        date: formatTime(userReq[index].createdAt),
                        onTap: () async {
                          JumpInUser user = await locator
                              .get<UserService>()
                              .getUserById(userReq[index].id);
                          if (user != null) {
                            Navigator.of(context).push(PageTransition(
                                child: JumpInUserPage(
                                  user: user,
                                  withoutProvider: true,
                                ),
                                type: PageTransitionType.fade));
                          }
                        },
                        plan: true,
                        public: widget.currentPlan.public,
                        userId: userReq[index].id,
                        msg:
                            ' has Jumped into your plan ${widget.currentPlan.planName.toUpperCase()}',
                      );
                    }),
              ),
      ),
    );
  }
}
