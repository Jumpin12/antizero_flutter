import 'package:antizero_jumpin/handler/plan.dart';
import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/models/plan.dart';
import 'package:antizero_jumpin/utils/common_methods.dart';
import 'package:antizero_jumpin/utils/decoration.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/widget/common/custom_appbar.dart';
import 'package:antizero_jumpin/widget/common/no_content.dart';
import 'package:antizero_jumpin/widget/common/search.dart';
import 'package:antizero_jumpin/widget/notification/container_list.dart';
import 'package:antizero_jumpin/widget/notification/req_card.dart';
import 'package:flutter/material.dart';

class PlanInvitePage extends StatefulWidget {
  const PlanInvitePage({Key key}) : super(key: key);

  @override
  _PlanInvitePageState createState() => _PlanInvitePageState();
}

class _PlanInvitePageState extends State<PlanInvitePage> {
  List<Plan> invitedPlans = [];
  bool loading = true;
  TextEditingController searchController;

  @override
  void initState() {
    getInvitedPlanReq();
    searchController = TextEditingController();
    super.initState();
  }

  getInvitedPlanReq() async {
    List<Plan> _invitedPlans = await getPlanByInvite(context);
    if (_invitedPlans != null) {
      invitedPlans = _invitedPlans;
    }
    if (mounted)
      setState(() {
        loading = false;
      });
  }

  Future<void> searchList(String name) async
  {
    List<Plan> _invitedPlans = await getPlanByInviteSearch(context,name);
    if (_invitedPlans != null)
    {
      invitedPlans = _invitedPlans;
      print('searchList invitedPlans ${invitedPlans}');
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        automaticImplyLeading: true,
        title: 'Plan Invitation',
      ),
      body: loading
          ? fadedCircle(32, 32, color: Colors.blue[100])
          : invitedPlans.isEmpty
              ? NoContentImage(
                  text: 'No pending invitation',
                  refreshText: 'Click here to refresh',
                  onRefresh: () async {
                    setState(() {
                      loading = true;
                    });
                    await getInvitedPlanReq();
                  },
                )
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      SearchWidget(
                          searchcontroller: this.searchController,
                          onSubmitted: (String newSelection)
                          {
                            print('newSelection ${newSelection.length}');
                            if(newSelection.length>0)
                            {
                              searchList(newSelection);
                            }
                            else
                            {
                              setState(() {
                                loading = true;
                              });
                              getInvitedPlanReq();
                              setState(()
                              {

                              });
                            }
                          }
                      ),
                      // invited to plan
                      if (invitedPlans.isNotEmpty)
                        ContainerListView(
                          gradient: gradient2,
                          heading: false,
                          count: invitedPlans.length,
                          builder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: RequestCard(
                                date: formatTime(invitedPlans[index].createdAt),
                                userId: invitedPlans[index].host,
                                planImg: invitedPlans[index].planImg[0],
                                planName: invitedPlans[index].planName,
                                invitedPlan: true,
                                onAccept: () async {
                                  bool accept = await acceptingCurrentPlan(
                                      invitedPlans[index], context);
                                  if (accept) {
                                    showToast('plan accepted successfully!');
                                    invitedPlans.remove(invitedPlans[index]);
                                    if (mounted) setState(() {});
                                  } else {
                                    showError(
                                        context: context,
                                        errMsg: 'Error in accepting request');
                                  }
                                },
                                onDeny: () async {
                                  bool deny = await denyingCurrentPlan(
                                      invitedPlans[index], context);
                                  if (deny == false) {
                                    showError(
                                        context: context,
                                        errMsg: 'Error in denying request');
                                  } else {
                                    invitedPlans.remove(invitedPlans[index]);
                                    if (mounted) setState(() {});
                                  }
                                },
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
    );
  }
}
