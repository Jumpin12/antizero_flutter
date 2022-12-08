import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/plan.dart';
import 'package:antizero_jumpin/provider/plan.dart';
import 'package:antizero_jumpin/screens/home/plans/current_plan.dart';
import 'package:antizero_jumpin/services/plan.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/common_methods.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PlanCard extends StatefulWidget {
  final String id;
  const PlanCard({Key key, this.id}) : super(key: key);

  @override
  _PlanCardState createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  bool loading = true;
  Plan plan;

  @override
  void initState() {
    getPlan();
    super.initState();
  }

  getPlan() async {
    plan = await locator.get<PlanService>().getPlanById(widget.id);
    // String companyName = getCompanyNameFromMode(context);
    // print('companyName $companyName ${}');
    // if(companyName.length>0)
    //   {
    //     if(companyName != plan.companyName)
    //     {
    //       plan = null;
    //     }
    //     else
    //     {
    //
    //     }
    //   }
    if (mounted)
      setState(() {
        loading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    var planProvider = Provider.of<PlanProvider>(context);

    return loading
        ? fadedCircle(32, 32, color: Colors.blue[100])
        : plan == null
            ? Container()
            : GestureDetector(
                onTap: () {
                  planProvider.currentPlan = plan;
                  Navigator.of(context).push(PageTransition(
                      child: CurrentPlanPage(
                        hostId: plan.host,
                      ),
                      type: PageTransitionType.fade));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // image
                    Expanded(
                      flex: 5,
                      child: CircleAvatar(
                        radius: 45,
                        backgroundColor: blue,
                        child: CircleAvatar(
                          radius: 42,
                          backgroundColor: Colors.white,
                          backgroundImage: plan.planImg[0] == null
                              ? AssetImage(avatarIcon)
                              : NetworkImage(plan.planImg[0]),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    // name
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 3, right: 3, bottom: 20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          child: Text(
                            plan.planName == null
                                ? 'Jumpin user'
                                : '${plan.planName}',
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.center,
                            style: bodyStyle(
                                context: context,
                                size: SizeConfig.blockSizeVertical * 3,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
  }
}
