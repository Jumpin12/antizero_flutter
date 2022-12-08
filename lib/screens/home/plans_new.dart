import 'dart:typed_data';
import 'package:antizero_jumpin/handler/home.dart';
import 'package:antizero_jumpin/handler/notification.dart';
import 'package:antizero_jumpin/handler/plan.dart';
import 'package:antizero_jumpin/handler/recommend.dart';
import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/handler/user.dart';
import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/models/member.dart';
import 'package:antizero_jumpin/models/plan.dart';
import 'package:antizero_jumpin/provider/plan.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/screens/home/plans/current_plan.dart';
import 'package:antizero_jumpin/screens/home/plans/plan_chat.dart';
import 'package:antizero_jumpin/services/analytics.dart';
import 'package:antizero_jumpin/services/plan.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/utils/slideupcontroller.dart';
import 'package:antizero_jumpin/widget/common/no_content.dart';
import 'package:antizero_jumpin/widget/home/card_buttons.dart';
import 'package:antizero_jumpin/widget/home/card_buttons_new.dart';
import 'package:antizero_jumpin/widget/home/image_card.dart';
import 'package:antizero_jumpin/widget/home/image_card_new.dart';
import 'package:antizero_jumpin/widget/home/location_card.dart';
import 'package:antizero_jumpin/widget/home/people_card.dart';
import 'package:antizero_jumpin/widget/home/plan_card_new.dart';
import 'package:antizero_jumpin/widget/home/plans/accept_plan.dart';
import 'package:antizero_jumpin/widget/home/plans/bookmark.dart';
import 'package:antizero_jumpin/widget/home/plans/connection_member.dart';
import 'package:antizero_jumpin/widget/home/plans/current_plan_new.dart';
import 'package:antizero_jumpin/widget/home/plans/host_card.dart';
import 'package:antizero_jumpin/widget/home/plans/people_attending.dart';
import 'package:antizero_jumpin/widget/home/plans/plan_date.dart';
import 'package:antizero_jumpin/widget/home/plans/plan_desc.dart';
import 'package:antizero_jumpin/widget/home/plans/plan_vibe.dart';
import 'package:antizero_jumpin/widget/home/plans/spot_card.dart';
import 'package:antizero_jumpin/widget/home/plans/user_age.dart';
import 'package:antizero_jumpin/widget/home/widget_toImg.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

Analytics analytics = locator<Analytics>();

class PlansNew extends StatefulWidget {
  final TextEditingController searchController;
  PlansNew({this.searchController});

  @override
  _PlansNewState createState() => _PlansNewState();
}

class _PlansNewState extends State<PlansNew> with SingleTickerProviderStateMixin{
  ScrollController _scrollController = ScrollController();
  String hostId = "";

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var planProvider = Provider.of<PlanProvider>(context, listen: false);
      planProvider.setDefaults();
      await planProvider.fetchPlans(context);
      // await planProvider.checkIfListEnoughForScroll(context,planProvider);
      _scrollController.addListener(() async {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.position.pixels;
        double delta = MediaQuery.of(context).size.height * 0.20;
        if (maxScroll - currentScroll <= delta) {
          await planProvider.fetchPlans(context);
        }
      });
    });
    FirebaseAnalytics.instance.logScreenView(
      screenName: 'Plans Tab',
      screenClass: 'Home',
    );
  }

  @override
  Widget build(BuildContext context) {
    var planProvider = Provider.of<PlanProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    var size = MediaQuery.of(context).size;
    return planProvider.isFirstListLoading
        ? spinKit
        : planProvider.noPlans == true
        ? SingleChildScrollView(
      child: NoContentImage(
        text: 'No plans found!',
        refreshText: 'Click here to refresh',
        onRefresh: () async {
          widget.searchController.text = "";
          planProvider.setDefaults();
          await planProvider.fetchPlans(context);
          // await planProvider.checkIfListEnoughForScroll(context);
        },
      ),
    )
        : Row(
        children: [
        Flexible(
        child: Container(
        height: size.height - (size.height / 3) + 100,
        child: ListView.builder(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: planProvider.planList.length,
            itemBuilder: (BuildContext context, int index) {
              final Plan plan = planProvider.planList[index];
              int acceptedMemLength = getAcceptedMemberLength(plan.member);
              int totalSpot = int.parse(plan.spot);
              int spotRem = 0;
              if (totalSpot > acceptedMemLength)
                {
                  spotRem = totalSpot - acceptedMemLength;
                }
              int spotFilled = totalSpot - spotRem;
              double spotsPercentage = (spotFilled / totalSpot);
              print(spotsPercentage);
              MemberStatus status = checkStatus(plan.member, context);
              print(status);
              // planProvider.currentPlan = plan;
              GlobalKey keyK;
              Uint8List bytes;
              return WidgetToImage(builder: (key) {
                keyK = key;
                return HomePlanCardNew(
                  planmodel: plan,
                  catName: plan.catName,
                  centerImage: ImageCardNew(
                    photoUrl: plan.planImg[0],
                  ),
                  planName: plan.planName,
                  members: plan.member,
                  // userName: HostCard(
                  //   id: plan.host,
                  // ),
                  location: LocationCard(
                    distance: plan.online == true
                        ? 'Online'
                        : plan.location,
                  ),
                  // vibe: PlanVibeCard(
                  //   plan: plan,
                  //   fromProfile: false,
                  // ),
                  userId: userProvider.currentUser.id,
                  upperLeft: DateTimeCard(
                    label: 'Date',
                    textAlign: Alignment.topLeft,
                    iconAlign: Alignment.topLeft,
                    planEndDate: plan.endDate != null
                        ? Jiffy(plan.endDate).yMMMd
                        : 'N/A',
                    isMultiDay: plan.multi,
                    bgcolor: Colors.blue[50],
                    planDateTime: plan.startDate != null
                        ? Jiffy(plan.startDate).yMMMd
                        : 'N/A',
                    icon: ImageIcon(AssetImage(calendarIcon),
                      size: 20,
                      color: Colors.blue,
                    ),
                    dayTime: plan.startDate != null
                        ? Jiffy(plan.startDate).E
                        : 'N/A',
                  ),
                  upperRight: DateTimeCard(
                    label: 'Timings',
                    textAlign: Alignment.topLeft,
                    iconAlign: Alignment.topLeft,
                    bgcolor: plangreenlite,
                    isMultiDay: false,
                    planDateTime: plan.time != null
                        ? Jiffy(plan.time).jm
                        : 'N/A',
                    icon: ImageIcon(AssetImage(clockIcon),
                      size: 25,
                      color: plangreen,
                    ),
                  ),
                  spotsRem: spotRem,
                  spotsPercentage: spotsPercentage,
                  planDesc: PlanDescriptionCard(
                      icon: ImageIcon(AssetImage(documentIcon),
                        size: 30,
                        color: Colors.blue,
                      ),
                      label: 'Plan Description',
                      planDesc: plan.planDisc,
                      textAlign: Alignment.topLeft,
                      iconAlign: Alignment.topLeft),
                  ageLimit: UserAgeCard(entryFree: plan.entryFree,
                      fees: plan.fees,age: plan.age,ageLimit: plan.ageLimit),
                  jumpInButton:
                  AcceptPlanBtn(
                      member: plan.member,
                      public: plan.public,
                      plan: plan,
                      accepted: status == MemberStatus.Accepted,
                      onTap: () async {
                        planProvider.setAcceptingPlan(true);
                        if (status == MemberStatus.Accepted) {
                          analytics.logCustomEvent(
                              eventName: 'JumpinPlanFromHome',
                              params: {
                                'userId': FirebaseAuth
                                    .instance.currentUser.uid,
                                'planId': plan.id,
                              });
                          JumpInUser host = await locator
                              .get<UserService>()
                              .getUserById(plan.host);
                          if (host != null) {
                            planProvider.currentPlanHost = host;
                            planProvider.currentPlan = plan;
                            Navigator.of(context).push(
                                PageTransition(
                                    child: PlanChatPage(),
                                    type: PageTransitionType
                                        .fade));
                          }
                        } else {
                          int acceptedMemLength =
                          getAcceptedMemberLength(
                              plan.member);
                          if (acceptedMemLength <
                              int.parse(plan.spot)) {
                            if (status == null ||
                                status ==
                                    MemberStatus.Invited) {
                              bool success =
                              await requestToPlan(
                                  plan, context);
                              if (success) {
                                successTick(context);
                                setState(() {
                                  status =
                                      MemberStatus.Accepted;
                                });
                                await acceptedMemberToPlanNotification(
                                    plan.host,
                                    plan.id,
                                    plan.planName,
                                    userProvider.currentUser);
                                getUser(context);
                              } else {
                                showError(
                                    context: context,
                                    errMsg: 'Error caught!');
                              }
                            } else if (status ==
                                MemberStatus.Denied) {
                              undoRequest(context, () async {
                                bool done = await requestToPlan(
                                    plan, context);
                                if (done) {
                                  showToast('success!');
                                  Navigator.pop(context);
                                  successTick(context);
                                  await acceptedMemberToPlanNotification(
                                      plan.host,
                                      plan.id,
                                      plan.planName,
                                      userProvider.currentUser);
                                  getUser(context);
                                } else {
                                  showToast(
                                      'Please try after sometime!');
                                }
                              });
                            } else {
                              print(
                                  'status is not accepted nor invited');
                            }
                          } else {
                            showError(
                                context: context,
                                errMsg: 'Total spot filled!');
                          }
                        }
                        if (mounted)
                          planProvider.setAcceptingPlan(false);
                      },
                      loading: planProvider.acceptingPlan),
                  recommendButton: CardNewButton(
                    color: Colors.grey[50],
                    textColor: blue,
                    onPress: () async {
                      bytes = await capture(keyK);
                      bool success = await takeScreenShot(
                          bytes, context, plan.id);
                      if (success) {
                        await recommendPlan(
                            context, plan.planName, plan.id);
                      } else {
                        showToast('Error caught!');
                      }
                    },
                    label: 'Recommend',
                    icon: recommendLogoIcon,
                  ),
                  hostId: plan.host,
                  planId: plan.id,
                  onUserTap: () {
                    // FocusScope.of(context)
                    //     .requestFocus(new FocusNode());
                    // planProvider.currentPlan = plan;
                    // Navigator.of(context).push(PageTransition(
                    //   //send host name
                    //     child: CurrentPlanPage(
                    //       hostId: plan.host,
                    //     ),
                    //     type: PageTransitionType.fade));
                  },
                );
              });
            }),
    ),
    ),
    planProvider.isNextListLoading ? spinKit : Container(),
    ],
    );
  }
}
